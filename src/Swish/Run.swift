struct Run {
  static func execute(target: Target) {
    if(target.type != .App) {
      Swish.log.info("can't run \(target.name) - not a binary!")
      Sys.exit(1)
    }

    Sys.exec("\(libPath(target.links)) \(target.buildDir)/\(target.name)")
  }

  static func libPath(links: [(module: String, path: String)]) -> String {
    return libPath(map(links) { _, path in path })
  }

  static func libPath(paths: [String]) -> String {
    let pathStr = join(":", map(paths) { Swish.root + $0 })
    return "DYLD_LIBRARY_PATH=\(pathStr):$DYLD_LIBRARY_PATH"
  }
}
