
** Copies native LibSass files to '%FAN_HOME%/bin/' (if they don't exist).
class ScssInstall {
	
	** Do it!
	Void go() {
		return
		log := typeof.pod.log
		log.info("Sass4f/${typeof.pod.version} with jsass/5.10.4 and libsass/3.6.4")

		logged := false
		nativeLibFiles.each |libFile| {
			dstFile := Env.cur.homeDir + `bin/${libFile.name}`
			if (dstFile.exists.not) {
				if (!logged) {
					logged = true
					log.info("First time usage:")
				}
				log.info("Copying ${libFile.name} to `${dstFile.parent.normalize.osPath}`...\n")
				libFile.copyTo(dstFile)
			}
		}
	}
	
	** Manually map Fantom Runtime info to the bundled jsass files
	private File[] nativeLibFiles() {
		log := typeof.pod.log
		dir := ""

		// jsass also has dirs (support) for "linux-aarch64" and "linux-armhf32" 
		// but I wouldn't know how to recognise the need for them
		// i.e. armhf32 = arm hard float x32, e.g. a black beagle

			 if (Env.cur.os == "win32")
			dir += "windows"
		else if (Env.cur.os == "macosx")
			dir += "darwin"
		else
			dir += "linux"

		if (dir != "darwin")
			if (Env.cur.arch.endsWith("64"))
				dir += "-x64"
			else
				dir += "-x32"

		// these files are exploded into the pod via jsass.jar
		libFiles := typeof.pod.files.findAll { it.uri.isDir == false && it.uri.path.first == dir }
		if (libFiles.isEmpty)
			log.warn("Platform '${Env.cur.platform}' is not supported")
		return libFiles
	}
	
	@NoDoc
	Void main() { go }
}
