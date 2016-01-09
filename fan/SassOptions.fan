using [java] com.alienfactory.sassjna::SassLibrary
using [java] com.alienfactory.sassjna::SassLibrary$Sass_Options	as Sass_Options

** Sass compilation options.
class SassOptions {

	** Input style for the input SCSS files.
	SassInputStyle	inputStyle		:= SassInputStyle.SCSS
	
	** Output style for the generated CSS code.
	SassOutputStyle	outputStyle		:= SassOutputStyle.nested

	** Additional include paths.
	File[]			includePaths	:= File[,]

	** Precision for fractional numbers.
	Int				precision		:= 5

	** Emit comments in the compiled CSS indicating the corresponding source line.
	Bool			sourceComments	:= false

	** Source Map compilation options.
	SassSourceMapOptions sourceMap	:= SassSourceMapOptions()
	
	internal Void setOptions(Sass_Options opts) {
		libSass := SassLibrary.INSTANCE
		libSass.sass_option_set_is_indented_syntax_src(opts, inputStyle.ordinal)
		libSass.sass_option_set_output_style(opts, outputStyle.ordinal)
		libSass.sass_option_set_include_path(opts, includePaths.join(File.pathSep) { it.osPath }.trimToNull)
		libSass.sass_option_set_precision(opts, precision)
		libSass.sass_option_set_source_comments(opts, sourceComments ? 1 : 0)
		sourceMap.setOptions(opts)
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
	Uri? sourceRoot
	
	internal Void setOptions(Sass_Options opts) {
		libSass := SassLibrary.INSTANCE
		libSass.sass_option_set_source_map_embed(opts, embed ? 1 : 0)
		libSass.sass_option_set_source_map_contents(opts, inlineSource ? 1 : 0)
		libSass.sass_option_set_omit_source_map_url(opts, omitUrl ? 1 : 0)
		libSass.sass_option_set_source_map_file(opts, outputPath?.osPath)
		libSass.sass_option_set_source_map_root(opts, sourceRoot?.toStr)
	}
}
