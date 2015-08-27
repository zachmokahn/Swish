import SwishUtils

struct Client {
  struct Options {
    let args: [String]

    init(args: [String]) { self.args = args }

    var isEmpty: Bool { get { return args.isEmpty }}
    var verbose: Bool { get { return args.contains("--verbose") }}
    var isHelp: Bool  { get { return args.contains("--help") }}
  }

  let workspace: Workspace

  init(workspace: Workspace) {
    self.workspace = workspace
  }

  func run(args: [String]) {
    workspace.options = Options(args: args)

    let opts = workspace.options

    guard !opts.isEmpty || opts.isHelp else { return help() }

    if let task = Tasks.findTask(args[0]) {
      Tasks.run(task)
      Swish.logger.debug("finished with exit code 0")

      System.exit(0)
    }

    Swish.logger.error("Unknown task: \(args[0])")
    System.exit(1)
  }

  func help() {
    for task in workspace.tasks {
      Swish.log(task.key)
    }
  }
}
