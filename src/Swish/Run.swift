struct Run {
  static func execute(target: Target) {
    if(target.type != .App) {
      Swish.log.info("can't run \(target.name) - not a binary!")
      Sys.exit(1)
    }

    let cmd = "\(libPath(target.links)) \(target.buildDir)/\(target.name)"
    Swish.log.debug(cmd)
    Sys.exec(cmd)
  }

  static func libPath(links: [(module: String, path: String)]) -> String {
    return libPath(links.map() { _, path in path })
  }

  static func libPath(paths: [String]) -> String {
    let pathStr = ":".join(paths)
    return "DYLD_LIBRARY_PATH=\(pathStr):$DYLD_LIBRARY_PATH"
  }
}
