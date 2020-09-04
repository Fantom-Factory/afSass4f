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
	        log.info("Compiling `${sassIn.normalize.osPath}` to `${cssOut.normalize.osPath}`")
	        result  := SassCompiler().compileFile(sassIn, cssOut, options)
			if (autoprefix)	result.autoprefix
	        result.saveCss(cssOut)
			if (sourceMap)
				result.saveCss(options.sourceMap.outputPath ?: (cssOut.isDir ? cssOut : cssOut.parent))
		}.run
	}
	
	** Used by StackHub web modules - compiles all SCSS files found in the work dirs.
	static Void main(Str[] args) {
		scssFiles	:= File[,]
		scssDirs	:= Env.cur.findAllFiles(`etc/scss/`)
		cssOut		:= `etc/web/`.toFile.normalize
		options		:= SassOptions() {
			it.outputStyle	= SassOutputStyle.compressed
			it.inputStyle	= SassInputStyle.SCSS
		}

		i := args.findIndex { it == "cssOut" }
		if (i != null)
			cssOut = args[i+1].toUri.toFile.normalize
		
		scssDirs.each |scssDir| {
			scssDir.walk |file| {
				if (file.ext == "scss" && !file.name.startsWith("_"))
					scssFiles.add(file)
			}
		}

		DirWatcher(scssDirs) |updatedFiles| {
			scssFiles.each |scssFile| {
		        log.info("Compiling `${scssFile.normalize.osPath}` to `${cssOut.normalize.osPath}`")
		        result  := SassCompiler().compileFile(scssFile, cssOut, options)
				result.autoprefix
		        result.saveCss(cssOut)
			}
		}.run
	}
}
