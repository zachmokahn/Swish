import SwishUtils

public typealias Task = (key: String, prereqs: [String], fn: VoidFn)
public typealias Script = (key: String, deps: [String])

enum SwishError: ErrorType {
  case InvalidTarget
}

public class Workspace {
  public var tasks:   [Task] = []
  public var targets: [Any] = []
  public var scripts: [Script] = []

  var options: Client.Options!

  public func findTarget<T:Target>(key: String, ofType:T.Type) -> T? {
    for target in targets {
      if let t = target as? T where t.key == key {
        return t
      }
    }

    return nil
  }
}
