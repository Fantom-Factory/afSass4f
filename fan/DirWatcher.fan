using concurrent

internal class DirWatcher {
	private Log				log				:= typeof.pod.log
	private SassCompiler	sassCompiler	:= SassCompiler()
	private FileMap 		fileMap			:= FileMap(null)

	SassOptions	options
	Bool		sourceMap
	Bool		autoprefix
	File		sassIn
	File		cssOut
	File		baseDir
	
	new make(|This| f) { f(this) }
	
	Void run() {
		log.info("Watching `${baseDir.normalize.osPath}` for changes...")
		
		clearMap(baseDir)

		while (true) {
			baseDir.walk |file| {
				if (file.isDir) return
				fileMap.getOrAddOrUpdate(file) |->Bool| { true }
			}

			recompile := fileMap.val.findAll { it == true }
			
			if (recompile.size > 0) {
				if (recompile.size == 1)
					log.info("File updated: ${recompile.keys.first.uri.relTo(baseDir.uri)}")
				else {
					str := "Files updated:\n"
					str += recompile.keys.join("\n") { it.uri.relTo(baseDir.uri).toStr }
					log.info(str)
				}
				
				try {
			        log.info("Compiling `${sassIn.normalize.osPath}` to `${cssOut.normalize.osPath}`")
			        result  := SassCompiler().compileFile(sassIn, cssOut, options)
					if (autoprefix)	result.autoprefix
			        result.saveCss(cssOut)
					if (sourceMap)
						result.saveCss(options.sourceMap.outputPath ?: (cssOut.isDir ? cssOut : cssOut.parent))

				} catch (Err err)
					err.trace
				
				clearMap(baseDir)
			}

			Actor.sleep(0.5sec)
		}
	}

	private Void clearMap(File baseDir) {
		baseDir.walk |file| {
			if (file.isDir) return
			fileMap[file] = false
		}		
	}
}
