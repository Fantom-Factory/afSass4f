using util

** Runs Sass4f from the command line.
** 
**   C:\> fan afSass4j [-x] [-m] <sassIn> <cssOut>
** 
** Where 'sassIn' and 'cssOut' are files. OS dependent and / or URI notation may be used. Example:
** 
**   C:\> fan afSass4j -x C:\projects\website.scss C:\projects\website.css
** 
**   C:\> fan afSass4j -x file:/C:/projects/website.scss file:/C:/projects/website.css
** 
** '-x' compresses the CSS output and '-m' generates a source map.
class Main : AbstractMain {

	@Opt { aliases=["x"]; help="Compresses the generated CSS" }
	private Bool compress

	@Opt { aliases=["m"]; help="Generates a CSS source map" }
	private Bool sourceMap

	@Arg { help="The .sass / .scss input file" }
	private File? sassIn

	@Arg { help="The .css output file" }
	private File? cssOut

	@NoDoc
	override Int run() {
		copyLibFile()

		log := typeof.pod.log
		log.info("Sass4j ${typeof.pod.version} with LibSass ${SassCompiler().version}")
		
		options := SassOptions()
		options.outputStyle	= compress ? SassOutputStyle.compressed : SassOutputStyle.nested
		if (sassIn.ext == "sass" || sassIn.ext == "scss")
			options.inputStyle	= SassInputStyle(sassIn.ext.upper)

		log.info("Compiling `${sassIn.normalize.osPath}` to `${cssOut.normalize.osPath}`")
		result	:= SassCompiler().compileFile(sassIn, options)
		result.saveCss(cssOut)

		if (sourceMap)
			result.saveCss(options.sourceMap.outputPath ?: (cssOut.isDir ? cssOut : cssOut.parent))

		log.info("Done.")
		return 0
	}
	
	private Void copyLibFile() {
		libFile := Main#.pod.files.find { it.uri.pathStr.startsWith("/res/${Env.cur.platform}/") && it.basename == "sass" }
		if (libFile == null)
			log.warn("Platform '${Env.cur.platform}' is not supported")
		else {
			dstFile := Env.cur.homeDir + `bin/${libFile.name}`
			if (dstFile.exists.not) {
				log.info("First time usage:")
				log.info("Copying ${libFile.name} to `${dstFile.parent.normalize.osPath}`\n")
				libFile.copyTo(dstFile)
			}
		}		
	}
}
