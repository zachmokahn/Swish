import Darwin

public struct Log {
  public var out: String -> Void = print

  public func info(msg: String) {
    out(msg)
  }

  public func error(msg: String) {
    Darwin.fputs((msg + "\n").withCString({ $0 }), Darwin.stderr)
  }

  public func debug(msg: String) {
    if options.verbose { out(msg) }
  }
}
