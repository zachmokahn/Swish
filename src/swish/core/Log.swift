import Darwin

public struct Log {
  public func info(msg: String) {
    out(msg)
  }

  public func error(msg: String) {
    Darwin.fputs(msg + "\n", Darwin.stderr)
  }

  public func debug(msg: String) {
    if options.verbose { out(msg) }
  }

	public func out(msg: String) {
		Darwin.fputs(msg + "\n", Darwin.stdout)
	}
}
