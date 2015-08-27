extension String {
  var length: Int { get { return characters.count } }
  var first: Character { get { return self[self.startIndex] }}
  var last: Character { get { return self[self.endIndex.predecessor()] }}

  func contains(fragment: String) -> Bool {
    return self.indexOf(fragment) != nil
  }

  func indexOf(fragment: String) -> String.Index? {
    guard let startAt = characters.indexOf(fragment.first) else {
      return nil
    }

    var i = distance(startIndex, startAt)

    while i <= (self.length - fragment.length) {
      let range = Range(
        start: advance(startIndex, i),
        end:   advance(startIndex, i + fragment.length)
      )

      if self[range] == fragment { return range.startIndex }

      i++
    }

    return nil
  }

  func split(delimiter: String) -> [String] {
    var chunks: [String] = []
    var currentIndex = startIndex

    var i = distance(startIndex, indexOf(delimiter) ?? startIndex)

    while i <= (self.length - delimiter.length) {
      let scanStart = advance(startIndex, i)
      let scanEnd   = advance(startIndex, i + delimiter.length)

      if self[scanStart..<scanEnd] == delimiter {
        chunks.append(self[currentIndex..<scanStart])
        i += delimiter.length
        currentIndex = advance(startIndex, i)
      } else {
        i++
      }
    }

    chunks.append(self[currentIndex..<endIndex])

    return chunks
  }

  func strip() -> String {
    return self.lstrip().rstrip()
  }

  func lstrip() -> String {
    var newStr = self

    while newStr.first == " " {
      newStr = newStr[newStr.startIndex.successor()..<newStr.endIndex]
    }

    return newStr
  }

  func rstrip() -> String {
    var newStr = self

    while newStr.last == " " {
      newStr = newStr[newStr.startIndex..<newStr.endIndex.predecessor()]
    }

    return newStr
  }

  func reverse() -> String {
    return String(self.characters.reverse())
  }

  func sub(
    fragment: String,
    withString replacement: String,
    global: Bool = true
  ) -> String {
    guard let startAt = self.indexOf(fragment) else {
      return self
    }

    var i = distance(startIndex, startAt)
    var newStr = self

    while i <= (newStr.length - fragment.length) && newStr.indexOf(fragment) != nil {
      let range = Range(
        start: advance(newStr.startIndex, i),
        end:   advance(newStr.startIndex, i + fragment.length)
      )

      if newStr[range] == fragment {
        newStr.replaceRange(range, with: replacement)
        if(!global) { return newStr }
      }

      i++
    }

    return newStr
  }
}
