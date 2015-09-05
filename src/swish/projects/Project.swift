import SwishBuildSwift
import SwishUtils

public enum RepoType {
  case GitHub
  case Git
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

  let path = System.env("SWISH_DIR") ?? File.join(System.pwd, ".swish", "lib")

  for lib in ["Swish", "SwishUtils", "SwishBuildSwift"] {
    target.link(module: lib, path: path)
  }

  target.runBuild()
  SwishBuildSwift.RunApp(target)(args: System.args)
}
