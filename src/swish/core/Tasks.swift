import SwishUtils

public var taskRunStatus: [String:Bool] = [:]

public struct Tasks {
  public static func findTask(key: String) -> Task? {
    return workspace.tasks.find { $0.key == key }
  }

  public static func didRun(task: Task) -> Bool { 
    return taskRunStatus[task.key] ?? false
  }

  public static func run(task: Task) {
    Swish.logger.debug("run task \(task.key)")

    for prereq in task.prereqs.map(findTask) {
      if let t = prereq where !didRun(t) { run(t) }
    }

    task.fn()
  }
}
