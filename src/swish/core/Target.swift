public protocol Target {
  var key: String { get }
  var build: Self -> Void { get set }
}

public func NullBuild<T:Target>(t: T) {}
