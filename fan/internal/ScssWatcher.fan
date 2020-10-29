using concurrent

internal class ScssWatcher {
	private static const Log	log				:= ScssWatcher#.pod.log
	private SassCompiler		sassCompiler	:= SassCompiler()

	SassOptions	options
	Bool		sourceMap
	Bool		autoprefix
	File		sassIn
	File		cssOut
	File		baseDir
	
	new make(|This| f) { f(this) }
	
	Void run() {
		DirWatcher([baseDir]) |recompile| {
	        result  := SassCompiler().compileFile(sassIn, cssOut, options)
			if (autoprefix)	result.autoprefix
	        result.saveCss(cssOut)
			if (sourceMap)
				result.saveCss(options.sourceMap.outputPath ?: (cssOut.isDir ? cssOut : cssOut.parent))
		}.run
	}
	
	** Used by StackHub web modules - compiles all SCSS files found in the work dirs.
	static Void main(Str[] args) {
		ScssInstall().go

		scssFiles	:= File:File[][:]
		watchDirs	:= File:File[][:]
		scssDirs	:= (File[]) Env.cur.findAllFiles(`etc/scss/`).map |dir->File| { dir.normalize }
		outDir		:= `../web-static/css/`
		globals		:= File[,]
		options		:= SassOptions() {
			it.outputStyle	= SassOutputStyle.compressed
			it.inputStyle	= SassInputStyle.SCSS
		}

		if (`etc/scss/`.toFile.exists)
			scssDirs.add(`etc/scss/`.toFile.normalize)

		i := args.findIndex { it == "outDir" }
		if (i != null)
			outDir = args[i+1].toUri
		
		// compile top level scss files only - otherwise it gets tricky knowing where to save them to!
		scssDirs.unique.each |scssDir| {
			scssDir.listFiles.each |file| {
				if (file.ext == "scss" && !file.name.startsWith("_")) {
					scssFiles.getOrAdd(scssDir) { File[,] }.add(file)
					
					// let top-level SCSS files watch dirs: e.g.
					// watch: ../../../StackHub-WebPortal-Lics/etc/scss/
					dirs := File[,]
					file.readAllLines.each {
						if (it.startsWith("// watch:")) {
							dir := file + it["// watch:".size..-1].trim.toUri
							dirs.add(dir)
						}
					}
					if (dirs.size > 0)
						watchDirs[file] = dirs
				}
			}

			// support for inter-project global SCSS files via:
			// @import "/global/variables";
			globalDir := scssDir.plus(`global/`)
			if (globalDir.exists) {
				globalDir.listFiles.each |file| {
					if (file.ext == "scss" && file.name.startsWith("_"))
						globals.add(file)
				}
			}
		}
		
		watchedFiles := (File[]) scssFiles.vals.flatten.unique
		if (watchedFiles.isEmpty) {
			log.warn("WARN: Could not find any SCSS files in: " + scssDirs.join(", ") { it.toStr + "etc/scss/" })
			return
		}
		
		log.info("Watching the following SCSS files:\n - " + watchedFiles.join("\n - ") { it.osPath } + "\n")
		
		sassCompiler := SassCompiler {
			it.preProcessingFn = |Str scss, File file -> Str| {
				globals.each |global| {
					path := global.uri.relTo(file.uri)
					name := path + path.basename[1..-1].toUri
					scss = scss.replace("@import \"/global/${global.basename[1..-1]}\";", "@import \"${name}\";")
				}
				return scss
			}
		}

		DirWatcher(scssDirs) |updatedFiles| {
			updateEverything := globals.containsAny(updatedFiles)
			
			scssFiles.each |scssFil, scssDir| {
				echo("[$scssDir] -> $scssFil")
			}
			
			updated := File[,]
			scssFiles.each |scssFil, scssDir| {
				// don't compile everything - just SCSS files in the containing project
				if (updateEverything || updatedFiles.any { it.toStr.startsWith(scssDir.toStr) }) {
					scssFil.each |scssFile| {
						cssOut	:= scssFile.parent.plus(outDir)
				        result  := sassCompiler.compileFile(scssFile, cssOut, options)
						result.autoprefix
				        result.saveCss(cssOut)
						updated.add(scssFile)
					}
				}
			}
			
			watchDirs.each |watchDirs2, scssFile| {
				watchUpdated := watchDirs2.any |watchDir| {
					updatedFiles.any { it.toStr.startsWith(watchDir.toStr) }			
				}
				if (watchUpdated && !updated.contains(scssFile)) {
					cssOut	:= scssFile.parent.plus(outDir)
			        result  := sassCompiler.compileFile(scssFile, cssOut, options)
					result.autoprefix
			        result.saveCss(cssOut)
					updated.add(scssFile)
				}
			}
			
		}.run
	}
}
