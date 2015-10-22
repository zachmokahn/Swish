import SwishUtils

private var taskRunStatus: [String:Bool] = [:]

public struct Tasks {
	public static func findTask(key: String) -> Task? {
		return workspace.tasks.find { $0.key == key }
	}

	public static func didRun(task: Task) -> Bool { 
		return taskRunStatus[task.key] ?? false
	}

	private static func markRun(task: Task) {
		taskRunStatus[task.key] = true
	}

	public static func run(task: Task) {
		Swish.logger.debug("run task \(task.key)")

		for p in task.prereqs.map(findTask) {
			if let prereq = p where !didRun(prereq) { run(prereq) }
		}

		task.fn()
		markRun(task)
	}
}
