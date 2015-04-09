struct Log {
  var out : String -> Void = println

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
