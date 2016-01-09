
** Copies native LibSass files to '%FAN_HOME%/bin/'.
class Install {
	
	** Do it!
	Void go() {
		log := typeof.pod.log
		libFile := Main#.pod.files.find { it.uri.pathStr.startsWith("/res/${Env.cur.platform}/") && it.basename == "sass" }
		if (libFile == null)
			log.warn("Platform '${Env.cur.platform}' is not supported")
		else {
			dstFile := Env.cur.homeDir + `bin/${libFile.name}`
			if (dstFile.exists.not) {
				log.info("First time usage:")
				log.info("Copying ${libFile.name} to `${dstFile.parent.normalize.osPath}`\n")
				libFile.copyTo(dstFile)
			}
		}
	}
}
