
** Sass CSS output style.
** 
** See `http://sass-lang.com/documentation/file.SASS_REFERENCE.html#output_style` for details.
enum class SassOutputStyle {

	** Nested style is the default Sass style, because it reflects the structure of the CSS styles and the HTML
	** document they’re styling. Each property has its own line, but the indentation isn’t constant.
	** Each rule is indented based on how deeply it’s nested.
	nested,

	** Expanded is a more typical human-made CSS style, with each property and rule taking up one line.
	** Properties are indented within the rules, but the rules aren’t indented in any special way.
	expanded,

	** Compact style takes up less space than Nested or Expanded.
	** It also draws the focus more to the selectors than to their properties.
	** Each CSS rule takes up only one line, with every property defined on that line.
	** Nested rules are placed next to each other with no newline, while separate groups of rules have
	** newlines between them.
	compact,

	** Compressed style takes up the minimum amount of space possible, having no whitespace except that necessary to
	** separate selectors and a newline at the end of the file. It also includes some other minor compressions, such as
	** choosing the smallest representation for colors. It’s not meant to be human-readable.
	compressed;
}
