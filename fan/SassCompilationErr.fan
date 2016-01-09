
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

	new make(Int status, Str msg, Str filename, Int line, Int column, Str json) : super("[${fileName}:${line}:${column}] ${msg}") {
		this.status 	= status
		this.fileName	= filename
		this.line		= line
		this.column		= column
		this.json		= json
	}
}
