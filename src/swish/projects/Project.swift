import SwishBuildSwift
import SwishUtils

public enum RepoType {
  case GitHub
}

public class Project {
  public var name = ""
  public var plugins = [String]()
  public var authors = [String]()

  public var repo: RepoType?
  public var homepage: String?
  public var description: String?
  public var license: String?
}

public func defineProject(configure: Project -> Void) {
  let project = Project()
  configure(project)

  buildProject(project)
}

func buildProject(project: Project) {
  let target = BuildTarget(key: "project", deps: [], build: SwishBuildSwift.BuildApp)

  target.sources = [(path: "src/tasks", pattern: "*.swift")]

  let root = System.pwd

  target.link(module: "Swish", path: "\(root)/../build/Swish")
  target.link(module: "SwishUtils", path: "\(root)/../build/SwishUtils")
  target.link(module: "SwishBuildSwift", path: "\(root)/../build/SwishBuildSwift")

  target.runBuild()

  SwishBuildSwift.RunApp(target)(args: System.args)
}
