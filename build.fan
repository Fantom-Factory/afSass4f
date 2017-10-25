using build
using compiler

class Build : BuildPod {

	new make() {
		podName = "afSass4f"
		summary = "A wrapper around libSass 3.2.5 - the compiler for Sass and Scss"
		version = Version("0.0.3")

		meta = [	
			"pod.dis"		: "Sass4f",
			"repo.tags"		: "app, web",
			"repo.internal"	: "true",
			"license.name"	: "The MIT Licence",
			"repo.public"	: "false"
		]

		depends = [
			"sys        1.0.68 - 1.0",
			"util       1.0.68 - 1.0",
			"concurrent 1.0.68 - 1.0",
		]

		srcDirs = [`fan/`]
		resDirs = [`doc/`, `res/linux-x86/`, `res/linux-x86_64/`, `res/macosx-x86_64/`, `res/win32-x86/`, `res/win32-x86_64/`]
		javaDirs= [`java/`]
	}
	
	override Void onCompileFan(CompilerInput ci) {
		
		// create an uber.jar
		jarDir := File.createTemp("afSass4f-", "")
		jarDir.delete
		jarDir = Env.cur.tempDir.createDir(jarDir.name).normalize

		echo
		`lib/`.toFile.normalize.listFiles(Regex.glob("*.jar")).each |jar| {
			echo("Expanding ${jar.name} to ${jarDir.osPath}")
			zipIn := Zip.read(jar.in)
			File? entry
			while ((entry = zipIn.readNext) != null) {
				fileOut := jarDir.plus(entry.uri.relTo(`/`))
				entry.copyInto(fileOut.parent, ["overwrite" : true])
			}
			zipIn.close
		}

		jarFile := jarDir.parent.createFile("${jarDir.name}.jar")
		zip  := Zip.write(jarFile.out)
		parentUri := jarDir.uri
		jarDir.walk |src| {
			if (src.isDir) return
			path := src.uri.relTo(parentUri)
			out := zip.writeNext(path)
			src.in.pipe(out)					
			out.close
		}
		zip.close
		
		jarDir.delete

		echo
		echo("Created Uber Jar: ${jarFile.osPath}")
		echo
		
		ci.resFiles.add(jarFile.deleteOnExit.uri)
	}
}
