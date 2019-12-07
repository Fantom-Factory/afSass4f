using util::JsonInStream
using [java] io.bit3.jsass::CompilationException

** Thrown when Sass compilation fails.
const class SassCompilationErr : Err {

	** Numeric status code as returned by the libsass compiler.
	const Int status

	** Name of the input file that caused issues.
	const Str fileName

	** Line number of the input that caused the compilation error.
	const Int line

	** Column number of the input that caused the compilation error.
	const Int column

	** JSON representation of the error message.
	const Str json;

	new make(Int status, Str msg, Str fileName, Int line, Int column, Str json) : super("[${fileName.toUri.name}:${line}:${column}] ${msg}") {
		this.status 	= status
		this.fileName	= fileName
		this.line		= line
		this.column		= column
		this.json		= json
	}
	
	static new fromException(CompilationException err) {
		map := (Str:Obj?) JsonInStream(err.getErrorJson.in).readJson
		return SassCompilationErr(
			map["status"	], 
			map["formatted"	],
			map["file"		],
			map["line"		] ?: -1,
			map["column"	] ?: -1,
			err.getErrorJson)
	}
}
