struct Tasks {
  struct Task {
    let name: String
    let fn: Void -> Void
    let prereqs: [String]
  }

  static func named(name: String) -> Task? {
    return Seq.find(Swish.tasks) { $0.name == name }
  }

  static func run(task: Task) {
    for taskName in task.prereqs {
      if let prereq = Tasks.named(taskName) {
        Tasks.run(prereq)
      }
    }

    task.fn()
  }
}
