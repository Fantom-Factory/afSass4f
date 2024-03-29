using util

** Runs Sass4f from the command line.
**
**   C:\> fan afSass4j [-x] [-m] [-w] <sassIn> <cssOut>
**
** Where 'sassIn' and 'cssOut' are files. OS dependent and / or URI notation may be used. Example:
**
**   C:\> fan afSass4j -x C:\projects\website.scss C:\projects\website.css
**
**   C:\> fan afSass4j -x file:/C:/projects/website.scss file:/C:/projects/website.css
**
** '-x' compresses the CSS output, '-m' generates a source map, and '-w' continuously watches for file updates.
class Main : AbstractMain {

	@Opt { aliases=["s"]; help="Setup; extract libsass library files to %FAN_HOME%/bin/" }
	private Bool setup

	@Opt { aliases=["x"]; help="Compresses the generated CSS" }
	private Bool compress

	@Opt { aliases=["m"]; help="Generates a CSS source map" }
	private Bool sourceMap

	@Opt { aliases=["w"]; help="Continuously watches all files in the SCSS directory (and sub-directories) and re-compiles if any are updated" }
	private Bool watch

	@NoDoc
	@Opt { aliases=["a"]; help="A really, really, shitty impl of Autoprefixer" }
	private Bool autoprefix

	@Arg { help="The .sass / .scss input file" }
	private File? sassIn

	@Arg { help="The .css output file" }
	private File? cssOut

	@NoDoc
	override Int run() {
		// first things first, make sure libSass is installed!
		if (setup)
			ScssInstall().go

		options := SassOptions()
		options.outputStyle	= compress ? SassOutputStyle.compressed : SassOutputStyle.nested
		if (sassIn.ext == "sass" || sassIn.ext == "scss")
			options.inputStyle	= SassInputStyle(sassIn.ext.upper)

		if (watch) {
			ScssWatcher {
				it.sassIn		= this.sassIn
				it.cssOut		= this.cssOut
				it.baseDir		= this.sassIn.parent
				it.options		= options
				it.sourceMap	= this.sourceMap
				it.autoprefix	= this.autoprefix
			}.run

			// DirWatcher never stops running
			return 0
		}

		log.info("Compiling `${sassIn.normalize.osPath}` to `${cssOut.normalize.osPath}`")
		result	:= SassCompiler().compileFile(sassIn, cssOut, options)

		if (autoprefix)
			result.autoprefix

		result.saveCss(cssOut)

		if (sourceMap)
			result.saveCss(options.sourceMap.outputPath ?: (cssOut.isDir ? cssOut : cssOut.parent))

		log.info("Done.")
		return 0
	}
}
