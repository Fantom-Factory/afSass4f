using concurrent

internal class ScssWatcher {
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
		scssDirs	:= (File[]) Env.cur.findAllFiles(`etc/scss/`).map |dir->File| { dir.normalize }
		outDir		:= `../web-static/css/`
		globals		:= File[,]
		options		:= SassOptions() {
			it.outputStyle	= SassOutputStyle.compressed
			it.inputStyle	= SassInputStyle.SCSS
		}

		i := args.findIndex { it == "outDir" }
		if (i != null)
			outDir = args[i+1].toUri
		
		// compile top level scss files only - otherwise it gets tricky knowing where to save them to!
		scssDirs.each |scssDir| {
			scssDir.listFiles.each |file| {
				if (file.ext == "scss" && !file.name.startsWith("_"))
					scssFiles.getOrAdd(scssDir) { File[,] }.add(file)
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
			scssFiles.each |scssFil, scssDir| {
				// don't compile everything - just SCSS files in the containing project
				if (updatedFiles.any { it.toStr.startsWith(scssDir.toStr) }) {
					scssFil.each |scssFile| {
						cssOut	:= scssFile.parent.plus(outDir)
				        result  := sassCompiler.compileFile(scssFile, cssOut, options)
						result.autoprefix
				        result.saveCss(cssOut)
					}
				}
			}
		}.run
	}
}
