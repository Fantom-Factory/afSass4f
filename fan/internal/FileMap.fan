
** Altered from afConcurrent to be non-const.
internal class FileMap {
	private File:Obj?			cache
	private File:FileModState 	fileData

	** The duration between individual file checks.
	** Use to avoid excessive reads of the file system.
	** Set to 'null' to check the file *every* time.
	const Duration?		timeout

	** The default value to use for `get` when a key isn't mapped.
	const Obj? 			def	:= null

	** Creates a 'SynchronizedMap' with the given 'ActorPool' and 'timeout'.
	new make(Duration? timeout := 30sec, |This|? f := null) {
		this.timeout 	= timeout
		f?.call(this)
		this.cache	 	= File:Obj?[:]
		this.fileData	= File:FileModState[:]
	}
	
	** Gets the backing map.
	[File:Obj?] val {
		get { cache }
		
		// private until I sync the file keys with the 'fileData' map 
		private set { cache = it }
	}

	** Sets the key / value pair, ensuring no data is lost during multi-threaded race conditions.
	** 
	** Nothing is added should the file not exist.
	@Operator
	Void set(File key, Obj? item) {
		setFile(key, |->Obj?| { item })
	}

	** Remove all key/value pairs from the map. Return this.
	This clear() {
		cache.clear
		fileData.clear
		return this
	}
	
	** Remove the key/value pair identified by the specified key
	** from the map and return the value. 
	** If the key was not mapped then return 'null'.
	Obj? remove(File key) {
		val := cache.remove(key)
		fileData.remove(key)
		return val 
	}

	** Returns the value associated with the given key. 
	** If the key is not mapped then it is added from the value function.
	** 
	** If the file does not exist, the 'valFunc' is executed but nothing is added to the cache. 
	**  
	** Note that 'valFunc' should be immutable and, if used, is executed in a different thread to the calling thread.
	Obj? getOrAdd(File key, |File->Obj?| valFunc) {
		if (containsKey(key))
			return get(key)
		
		return setFile(key, valFunc)
	}
	
	** Returns the value associated with the given file. 
	** If it doesn't exist, **or the file has been modified** since the last call to 'getOrAddOrUpdate()', 
	** then it is added from the given value function. 
	** 
	** Set 'timeout' in the ctor to avoid hitting the file system on every call to this method.
	** 
	** If the file does not exist, the 'valFunc' is executed but nothing is added to the cache.
	**  
	** Note that 'valFunc' should be immutable and, if used, is executed in a different thread to the calling thread.
	Obj? getOrAddOrUpdate(File key, |File->Obj?| valFunc) {
		fileMod := (FileModState?) fileData[key]
		
		if (fileMod?.isTimedOut(timeout) ?: true) {

			if (fileMod?.isModified(key) ?: true)
				return setFile(key, valFunc)

			if (!key.exists)
				return setFile(key, valFunc)				

			// just update the last checked
			fileData.set(key, FileModState(key.modified))
		}

		return cache[key]
	}

	** Returns 'true' if a subsequent call to 'getOrAddOrUpdate()' would result in the 'valFunc' 
	** being executed. 
	** This method does not modify any state.
	Bool isModified(File key) {
		fileMod := (FileModState?) fileData[key]
		if (fileMod == null)
			return true
		if (!fileMod.isTimedOut(timeout))
			return false
		return fileMod.isModified(key)
	}
	
	private Obj? setFile(File iKey, |File->Obj?| iFunc) {
		val  := iFunc.call(iKey)
		
		// only cache when the file exists
		if (iKey.exists) {
			cache.set(iKey, val)
			fileData.set(iKey, FileModState(iKey.modified))
		
		} else if (cache.containsKey(iKey)) {
			cache.remove(iKey)
			fileData.remove(iKey)
		}

		return val
	}
	
	// ---- Common Map Methods --------------------------------------------------------------------

	** Returns 'true' if the map contains the given file
	Bool containsKey(File key) {
		val.containsKey(key)
	}
	
	** Call the specified function for every key/value in the map.
	Void each(|Obj? item, File key| c) {
		val.each(c)
	}

	** Returns the value associated with the given key. 
	** If key is not mapped, then return the value of the 'def' parameter.  
	** If 'def' is omitted it defaults to 'null'.
	@Operator
	Obj? get(File key, Obj? def := this.def) {
		val.get(key, def)
	}

	** Return 'true' if size() == 0
	Bool isEmpty() {
		val.isEmpty
	}

	** Returns a list of all the mapped keys.
	File[] keys() {
		val.keys
	}

	** Get a read-write, mutable Map instance with the same contents.
	[File:Obj?] rw() {
		val.rw
	}

	** Get the number of key/value pairs in the map.
	Int size() {
		val.size
	}
	
	** Returns a list of all the mapped values.
	Obj?[] vals() {
		val.vals
	}

	@NoDoc
	override Str toStr() {
		"SynchronizedFileMap - size=${size}"
	}
}

internal const class FileModState {
	const DateTime	lastChecked
	const DateTime	lastModified	// pod files have last modified info too!
	
	new make(DateTime lastModified) {
		this.lastChecked	= DateTime.now
		this.lastModified	= lastModified
	}	
	
	Bool isTimedOut(Duration? timeout) {
		timeout == null
			? true
			: (DateTime.now - lastChecked) > timeout
	}
	
	** Returns 'false' when the file doesn't exist
	Bool isModified(File file) {
		file.modified > lastModified
	}
}
