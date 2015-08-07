struct ShellCommand {
  static func run(cmd: String, directory: String) -> Void -> Void {
    return { Sys.exec("(cd \(directory) && \(cmd))") }
  }

  static func run(cmd: String) -> Void -> Void {
    return { Sys.exec(cmd) }
  }
}
