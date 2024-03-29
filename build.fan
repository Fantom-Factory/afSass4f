using build::BuildPod
 
class Build : BuildPod {

	new make() {
		podName = "afSass4f"
		summary = "A wrapper around libSass 3.6.4 - the compiler for Sass and Scss"
		version = Version("0.2.1")

		meta = [	
			"pod.dis"		: "Sass4f",
			"repo.tags"		: "app, web",
			"repo.public"	: "true"
		]

		depends = [
			"sys        1.0.68 - 1.0",
			"util       1.0.68 - 1.0",
			"concurrent 1.0.68 - 1.0",
		]

		srcDirs = [`fan/`, `fan/internal/`]
		resDirs = [`doc/`, `lib/`]
	}
}
