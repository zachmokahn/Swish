import SwishUtils

struct Client {
  struct Options {
    let args: [String] = System.args

    var isEmpty: Bool { get { return args.isEmpty }}
    var verbose: Bool { get { return args.contains("--verbose") }}
    var isHelp: Bool  { get { return args.contains("--help") }}
    var tasks: [String] { get { return args.filter { !$0.hasPrefix("--") }}}
  }

  let workspace: Workspace

  init(workspace: Workspace) {
    self.workspace = workspace
  }

  func run() {
    guard !options.isEmpty || options.isHelp else { return help() }

    for key in options.tasks {
      if let task = Tasks.findTask(key) {
        Tasks.run(task)
      } else {
        Swish.logger.error("Unknown task: \(key)")
        System.exit(1)
      }
    }

    // Swish.logger.debug("finished with exit code 0")
    System.exit(0)
  }

  func help() {
    for task in workspace.tasks {
      Swish.log(task.key)
    }
  }
}
