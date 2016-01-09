using [java] java.nio::ByteBuffer
using [java] com.alienfactory.sassjna::SassLibrary
using [java] com.alienfactory.sassjna::SassLibrary$Sass_Compiler		as Sass_Compiler
using [java] com.alienfactory.sassjna::SassLibrary$Sass_Context			as Sass_Context
using [java] com.alienfactory.sassjna::SassLibrary$Sass_File_Context	as Sass_File_Context
using [java] fanx.interop::Interop

** The wrapper around LibSass.
class SassCompiler {
	
	** Compiles the given Sass / Scss file to a CSS string.
	** 
	** To compile a file:
	** 
	**   syntax: fantom
	**   in  := `file:/C:/`
	**   css := SassCompiler().compileStream(in)
	** 
	SassResult compileFile(File inputFile, SassOptions? options := null) {
		if (inputFile.exists.not)
			throw ArgErr("${inputFile.normalize.osPath} does not exist")
		if (inputFile.isDir)
			throw ArgErr("${inputFile.normalize.osPath} is not a file")

		fileCtx		:= libSass.sass_make_file_context(inputFile.normalize.osPath)
		opts		:= libSass.sass_file_context_get_options(fileCtx)
		options?.setOptions(opts)
		ctx			:= libSass.sass_file_context_get_context(fileCtx)
		compiler	:= libSass.sass_make_file_compiler(fileCtx)
		result		:= compileSass(compiler, ctx)

		libSass.sass_delete_file_context(fileCtx)
		return SassResult {
			it.css 		 = result[0]
			it.sourceMap = result[1]
			it.options	 = options ?: SassOptions()
			it.inputFile = inputFile
		}
	}

	// Doesn't work - further investigation required
	// Both css and sourceMap return null - then the whole JVM blows up when the dataCtx is deleted!

//	** Compiles the given stream of Sass / Scss characters to a CSS string.
//	** 
//	** To compile a 'Str':
//	** 
//	**   syntax: fantom
//	**   in  := "html { background-color: pink; }".toBuf.in
//	**   css := SassCompiler().compileStream(in)
//	** 
//	SassResult compileStream(InStream inStream, SassOptions? options := null) {
//		dataCtx		:= libSass.sass_make_data_context(Interop.toJava(inStream.readAllBuf))
//		opts		:= libSass.sass_data_context_get_options(dataCtx)
//		options?.setOptions(opts)		
//		ctx			:= libSass.sass_data_context_get_context(dataCtx)
//		compiler	:= libSass.sass_make_data_compiler(dataCtx)
//		result		:= compileSass(compiler, ctx)
//
//		libSass.sass_delete_data_context(dataCtx)
//		return SassResult {
//			it.css 		 = result[0]
//			it.sourceMap = result[1]
//			it.options	 = options ?: SassOptions()
//			it.inputFile = null
//		}
//	}
	
	** Returns the libSass version this compiler wraps.
	Str version() {
		libSass.libsass_version
	}

	** Compiles the given ctx into a CSS string.
	private static Str[] compileSass(Sass_Compiler compiler, Sass_Context ctx) {
		parseStatus		:= libSass.sass_compiler_parse(compiler)
		compileStatus	:= libSass.sass_compiler_execute(compiler)
		css				:= libSass.sass_context_get_output_string(ctx) ?: ""
		sourceMap		:= libSass.sass_context_get_source_map_string(ctx) ?: ""

		// delete the underlying native compiler object and release allocated memory
		libSass.sass_delete_compiler(compiler)

		// Error handling
		if (parseStatus != 0)	throwCompilationErr(ctx, parseStatus)
		if (compileStatus != 0)	throwCompilationErr(ctx, compileStatus)
		return [css, sourceMap]
	}

	private static Void throwCompilationErr(Sass_Context ctx, Int compileStatus) {
		throw SassCompilationErr(
				compileStatus,
				libSass.sass_context_get_error_message(ctx),
				libSass.sass_context_get_error_file(ctx),
				libSass.sass_context_get_error_line(ctx).intValue,
				libSass.sass_context_get_error_column(ctx).intValue,
				libSass.sass_context_get_error_json(ctx)
		)
	}
	
	private static SassLibrary libSass() {
		SassLibrary.INSTANCE
	}
}
