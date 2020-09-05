using [java] io.bit3.jsass::CompilationException
using [java] io.bit3.jsass::Compiler
using [java] java.io::File as JFile
using [java] fanx.interop::Interop

** The wrapper around JSass that wraps LibSass.
class SassCompiler {
	private static const Log	log		:= SassCompiler#.pod.log

	** Compiles the given Sass / Scss file to a CSS string.
	** 
	** To compile a file:
	** 
	**   syntax: fantom
	**   css := SassCompiler().compileFile(`myScss.scss`).css
	** 
	SassResult compileFile(File inputFile, File? outputFile := null, SassOptions? options := null) {
		if (inputFile.exists.not)
			throw ArgErr("${inputFile.normalize.osPath} does not exist")
		if (inputFile.isDir)
			throw ArgErr("${inputFile.normalize.osPath} is not a file")

        log.info("Compiling `${inputFile.normalize.osPath}`...")
		
		try {
			opts	:= options ?: SassOptions()
			inFile	:= JFile( inputFile.normalize.osPath).toURI
			outFile	:= JFile(outputFile.normalize.osPath).toURI	// not really sure what this does - it's not created!
			output	:= Compiler().compileFile(inFile, outFile, opts.getOpts)

			return SassResult {
				it.css 		 = output.getCss
				it.sourceMap = output.getSourceMap
				it.options	 = opts
				it.inputFile = inputFile
			}
		} catch (Err err) {
			exp := Interop.toJava(err)
			if (exp is CompilationException)
				throw SassCompilationErr(exp)
			throw err
		}
	}
}
