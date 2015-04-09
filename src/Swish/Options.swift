struct Options {
  static func parse(args: [String]) -> Options {
    var options = Options(args: args)

    options.verbose = options.has("--verbose")

    return options
  }

  let args: [String]
  var verbose = false
  var isEmpty: Bool { return args.isEmpty }
  var count: Int { return args.count }

  init(args: [String]) {
    self.args = args
  }

  func has(flag: String) -> Bool {
    return !args.filter({ $0 == flag }).isEmpty
  }

  subscript(index: Int) -> String {
    return args[index]
  }

}
