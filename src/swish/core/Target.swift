public protocol Target {
  var key: String { get }
  var build: Self -> Void { get set }
}

public extension Target {
  public func runBuild() { self.build(self) }
}

public func NullBuild<T:Target>(t: T) {}
