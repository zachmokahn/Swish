public typealias ConfigFn = Target -> Void

public class Project {
  static let nullConfig: ConfigFn = { t in return }

  public enum ProjectType {
    case Module
    case App
  }

  let name: String

  var targets: [Target] = []
  var scripts: [Script] = []
  var tasks: [Tasks.Task] = []

  init(name: String) {
    self.name = name
  }

  func addTarget(
    name: String,
    type: ProjectType,
    deps: [String],
    configFn: ConfigFn
  ) -> Target {
    let target = Target(name: name, deps: deps, type: type)
    self.targets.append(target)

    configFn(target)

    let buildDeps = deps.map() { "\($0):build" }
    self.task("\(name):build", buildDeps) { Build.execute(target) }
    return target
  }

  public func app(
    name: String,
    _ deps: [String] = [],
    configFn: ConfigFn = nullConfig
  ) {
    let target = addTarget(name, type: .App, deps: deps, configFn: configFn)
    self.task("\(name):run", ["\(name):build"]) { Run.execute(target) }
  }

  public func module(
    name: String,
    _ deps: [String] = [],
    configFn: ConfigFn = nullConfig
  ) {
    addTarget(name, type: .Module, deps: deps, configFn: configFn)
  }

  public func script(name: String, _ deps: [String] = []) {
    let script = (name: name, targets: Seq.compact(deps.map(Targets.named)))
    self.task(name, fn: { Scripts.run(script) })
  }

  public func task(name: String, _ prereqs: [String] = [], fn: Void -> Void = {}) {
    tasks.append(Tasks.Task(name: name, fn: fn, prereqs: prereqs))
  }
}

