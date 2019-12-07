using [java] io.bit3.jsass::Options
using [java] java.io::File as JFile
using [java] java.util::Arrays

** Sass compilation options.
class SassOptions {

	** Input style for the input SCSS files.
	SassInputStyle	inputStyle		:= SassInputStyle.SCSS
	
	** Output style for the generated CSS code.
	SassOutputStyle	outputStyle		:= SassOutputStyle.nested

	** Additional include paths.
	File[]			includePaths	:= File[,]

	** Precision for fractional numbers.
	Int				precision		:= 3

	** Output indentation.
	Str				indent			:= "\t"

	** Emit comments in the compiled CSS indicating the corresponding source line.
	Bool			sourceComments	:= false

	** Source Map compilation options.
	SassSourceMapOptions sourceMap	:= SassSourceMapOptions()
	
	internal Options getOpts() {
		opts := Options()
		opts.setLinefeed("\n")
		opts.setIndent(indent)
		opts.setPrecision(precision)
		opts.setSourceComments(sourceComments)
		opts.setIsIndentedSyntaxSrc(inputStyle == SassInputStyle.SASS)
		opts.setIncludePaths(
			Arrays.asList(
				includePaths.map |file->JFile| { JFile(file.normalize.osPath) }
			)
		)
		return sourceMap.setOptions(opts)
	}
}

** Source Map compilation options.
class SassSourceMapOptions {

	** The directory where source map files will be generated.
	** 
	** If 'null' then the directory where the CSS files are generated is used.
	** This property affects the 'sourceMappingURL' comment and is generally the relative path from the CSS directory.
	File? outputPath

	** Prevents the generation of the 'sourceMappingURL' special comment as the last line of the compiled CSS. 
	Bool omitUrl

	** Embeds the whole source map directly in the compiled CSS file by means of a data URI.
	Bool embed

	** Inlines the Sass source files in the source map as a 'sourcesContent' property.
	Bool inlineSource
	
	** The 'sourceRoot' property of the generated source map.
	File? sourceRoot

	internal Options setOptions(Options opts) {
		opts.setSourceMapEmbed(embed)
		opts.setSourceMapContents(inlineSource)
		opts.setOmitSourceMapUrl(omitUrl)
		opts.setSourceMapFile(outputPath == null ? null : JFile(outputPath.normalize.osPath).toURI)
		opts.setSourceMapRoot(sourceRoot == null ? null : JFile(sourceRoot.normalize.osPath).toURI)
		return opts
	}
}
