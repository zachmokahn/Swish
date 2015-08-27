public protocol IsOptional {
  typealias T

  func forceOptional() -> T?
}

extension Optional: IsOptional {
  public func forceOptional() -> T? {
    return self.flatMap { $0 }
  }
}

extension SequenceType {
  public func all(fn: Generator.Element -> Bool) -> Bool {
    for element in self {
      if !fn(element) { return false }
    }

    return true
  }

  public func any(fn: Generator.Element -> Bool) -> Bool {
    for element in self {
      if fn(element) { return true }
    }

    return false
  }

  public func find(fn: Generator.Element -> Bool) -> Generator.Element? {
    for element in self {
      if(fn(element)) { return element }
    }

    return nil
  }

  public func uniq<T:Hashable>(fn: Generator.Element -> T) -> [Generator.Element] {
    var addedDict: [T:Bool] = [:]
    return self.filter { addedDict.updateValue(true, forKey: fn($0)) == nil }
  }
}

extension SequenceType where Generator.Element: Equatable {
  public func uniq() -> [Generator.Element] {
    return self.reduce([]) { acc, element in
      if acc.contains(element) { return acc }
      return acc + [element]
    }
  }
}

extension SequenceType where Generator.Element: IsOptional {
  public func compact() -> [Generator.Element.T] {
    var result: [Generator.Element.T] = []

    for element in self {
      if let e = element.forceOptional() {
        result.append(e)
      }
    }

    return result
  }
}

extension SequenceType where Generator.Element == String {
  public func join(str: String = "") -> String {
    return str.join(self)
  }
}
