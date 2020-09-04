
internal const class Autoprefix {

	** Property names that require vendor prefixes. (Stolen from dom::Style)
	private const static Str[] vendor := [
		"align-content",
		"align-items",
		"animation",
		"animation-delay",
		"animation-direction",
		"animation-duration",
		"animation-iteration-count",
		"animation-name",
		"animation-play-state",
		"animation-timing-function",
		"animation-fill-mode",
		"appearance",		// added by SlimerDude
		"flex",
		"flex-direction",
		"flex-wrap",
		"justify-content",
		"transform",
		"user-select",
	].map { "${it}:" }
	
	
//	Str autoprefix(Str css) {
//		// TODO need to parse out the value
//		// TODO need a CSS parser 
//		vendor.each |prop| {
//			css = css.replace(prop, )
//			
//		}
//	    if (vendor.containsKey(name))
//	    {
//	      setProp("-webkit-$name", sval)
//	      setProp(   "-moz-$name", sval)
//	      setProp(    "-ms-$name", sval)
//	    }
//	}
}
