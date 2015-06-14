public struct Swish {
  static var project: Project!
  static var options: Options!

  static var scripts: [Script] { return project.scripts }
  static var targets: [Target] { return project.targets }
  static var tasks: [Tasks.Task] { return project.tasks }
  static var log = Log()
  static let root = Strings.strip(Sys.exec("pwd", read: true).output) + "/"

  public static func run() {
    var args = Array(Process.arguments)
    args.removeAtIndex(0)
    options = Options.parse(args)

    Client.run()
  }

  public static func project(name: String, _ block: Project -> Void) {
    project = Project(name: name)
    block(project)
    run()
  }
}
