struct Seq {
  static func find<C: CollectionType>(
    collection: C,
    fn: C.Generator.Element -> Bool
  ) -> C.Generator.Element? {
    for element in collection { 
      if(fn(element)) { return element }
    }

    return nil
  }

  static func compact<T>(list: [T?]) -> [T] {
    var result: [T] = []

    for item in list {
      if let i = item { result.append(i) }
    }

    return result
  }
}
