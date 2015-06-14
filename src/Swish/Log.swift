struct Log {
  var out : String -> Void = print

  init() {}

  func info(msg: String) {
    out(msg)
  }

  func debug(msg: String) {
    if Swish.options.verbose {
      out(msg)
    }
  }
}
