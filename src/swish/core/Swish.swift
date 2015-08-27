import SwishUtils

public typealias VoidFn = Void -> Void

public let noop: VoidFn = {}
public let workspace = Workspace()

public struct Swish {
  public static func task(key: String, _ prereqs: [String] = [], fn: VoidFn = noop) {
    workspace.tasks.append(Task(key: key, prereqs: prereqs, fn: fn))
  }

  public static func run() {
    var args = Array(Process.arguments)
    args.removeAtIndex(0)

    Client(workspace: workspace).run(args)
  }

  public static var logger = Log()

  public static let log = logger.info
  public static let root = System.pwd
}
