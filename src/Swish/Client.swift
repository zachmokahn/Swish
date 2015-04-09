struct Client {
  static func run() {
    let options = Swish.options
    if(options.isEmpty) { printHelp() }

    let taskName = options[0]

    if let task = Tasks.named(taskName) { 
      return Tasks.run(task)
    }

    Swish.log.info("unknown task \(taskName)")
  }

  static func printHelp() {
    Swish.log.info("Tasks:")

    for task in Swish.tasks {
      Swish.log.info(task.name)
    }

    Sys.exit(0)
  }
}
