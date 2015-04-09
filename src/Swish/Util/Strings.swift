struct Strings {
  static let space = " "
  static let empty = ""

  static func strip(var output: String, amount: Int = -1) -> String {
    output.removeAtIndex(advance(output.endIndex, amount))
    return output
  }
}
