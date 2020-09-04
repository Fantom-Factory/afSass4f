using concurrent::Actor

@NoDoc	// Advanced use only
class DirWatcher {
	private Log			log				:= typeof.pod.log
	private FileMap 	fileMap			:= FileMap(null)
			Bool		keepWatching	:= true
			Duration	sleepDir		:= 0.75sec
			File[]		baseDirs
			|File[]|	onChangeFn
	
	new makeIt(|This| f) { f(this) }
	
	new make(File[] baseDirs, |File[]| onChangeFn) {
		this.baseDirs	= baseDirs
		this.onChangeFn	= onChangeFn
	}
	
	Void run() {
		baseDirs.each |baseDir| {
			log.info("Watching `${baseDir.normalize.osPath}` for changes...")
			
			baseDir.walk |file| {
				if (file.isDir) return
				fileMap[file] = false
			}
		}

		while (keepWatching) {
			allUpdatedFiles := File[,]

			baseDirs.each |baseDir| {
				// by walking each time, we pick up new files
				baseDir.walk |file| {
					if (file.isDir) return
					fileMap.getOrAddOrUpdate(file) |->Bool| { true }
				}
	
				updatedFiles := fileMap.val.findAll { it == true }.keys
				
				if (updatedFiles.size > 0) {
					allUpdatedFiles.addAll(updatedFiles)

					if (updatedFiles.size == 1)
						log.info("File updated: ${updatedFiles.first.uri.relTo(baseDir.uri)}")
					else {
						str := "Files updated:\n"
						str += updatedFiles.join("\n") { it.uri.relTo(baseDir.uri).toStr }
						log.info(str)
					}
	
					// reset cache
					updatedFiles.each {
						if (it.exists)
							fileMap[it] = false
						else
							fileMap.remove(it)
					}
				}
			}

			if (allUpdatedFiles.size > 0)
				try	onChangeFn(allUpdatedFiles)
				catch (Err err)	log.err("ERROR", err)

			Actor.sleep(sleepDir)
		}
	}
}
