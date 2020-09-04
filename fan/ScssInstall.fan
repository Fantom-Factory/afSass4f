
** Copies native LibSass files to '%FAN_HOME%/bin/' (if they don't exist).
** 
** Is run when Sass4F is started.
** 
class ScssInstall {
	
	** Do it!
	Void go() {
		log := typeof.pod.log
		
		// these files are exploded into the pod via jsass.jar
		libFile := Main#.pod.files.find { it.uri.pathStr.startsWith("/${Env.cur.platform}/") && it.basename == "sass" }
		if (libFile == null)
			return log.warn("Platform '${Env.cur.platform}' is not supported")
		
		dstFile := Env.cur.homeDir + `bin/${libFile.name}`
		if (dstFile.exists.not) {
			log.info("First time usage:")
			log.info("Copying ${libFile.name} to `${dstFile.parent.normalize.osPath}`\n")
			libFile.copyTo(dstFile)
		}
	}
}
