import Darwin

public struct Log {
  public let out: String -> Void = print

  public func info(msg: String) {
    out(msg)
  }

  public func error(msg: String) {
    Darwin.fputs((msg + "\n").withCString({ $0 }), Darwin.stderr)
  }

  public func debug(msg: String) {
    if workspace.options.verbose { out(msg) }
  }
}
