struct Targets {
  static func named(name: String) -> Target? {
    return Seq.find(Swish.targets) { $0.name == name }
  }
}

public typealias Link = (module: String, path: String)

public class Target {
  public var name: String
  public var type: Project.ProjectType

  public var sourceDir: String
  public var buildDir: String

  public var targetDeps: [String] = []
  public var moduleDeps : [Link] = []

  var links: [Link] {
    let subtargets = Seq.compact(targetDeps.map(Targets.named))

    return subtargets.map() {
      Link(module: $0.name, path: $0.buildDir)
    } + moduleDeps
  }

  init(name: String, deps: [String], type: Project.ProjectType) {
    self.name = name
    self.type = type
    self.targetDeps = deps
    self.buildDir = "build/\(name)"
    self.sourceDir = "src/\(name)"
  }

  public func link(target target: String) {
    self.targetDeps.append(target)
  }
 
  public func link(module module: String, path: String) {
    self.moduleDeps.append(Link(module: module, path: path))
  }
}
