typealias Script = (name: String, targets: [Target])

struct Scripts {
  static func run(script: Script) {
    Sys.exec(ScriptCommand(script: script).command)
  }
}

struct ScriptCommand {
  let script: Script

  init(script: Script) {
    self.script = script
  }

  var pathStr: String {
    return Run.libPath(script.targets.map() { $0.buildDir })
  }

  var links: String {
    return " ".join(script.targets.map() { target in
      "-I\(Swish.root + target.buildDir) -l\(target.name)"
    })
  }

  var scriptFile: String { return "src/tasks/\(script.name).swift" }

  var command: String {
    return "\(pathStr) xcrun swift \(links) \(scriptFile)"
  }
}
