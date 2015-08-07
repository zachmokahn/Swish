class BuildCommand {
  static func forTarget(target: Target) -> BuildCommand {
    let srcDir = Swish.root + target.sourceDir
    let sources = "$(find \(srcDir) -name *.swift)"

    switch target.type {
    case .Module:
      return BuildSwiftModule(sources: sources, target: target)

    case .App:
      return BuildSwiftApp(sources: sources, target: target)
    }
  }

  var sdk = "macosx"
  var target: Target
  var sources: String
  var flags: [String] = []
  var buildDir: String { return Swish.root + target.buildDir }

  var links: String {
    return Strings.space.join(target.links.map() { ln in
      "-L\(Swish.root + ln.path) -I\(Swish.root + ln.path) -l\(ln.module)"
    })
  }

  var commands: [(Void -> Void)] {
    return [
      ShellCommand.run("mkdir -p \(buildDir)"),
      ShellCommand.run(
        "swiftc \(links) \(Strings.space.join(flags)) \(sources)",
        directory: buildDir
      )
    ]
  }

  init(sources: String, target: Target) {
    (self.sources, self.target) = (sources, target)
  }
}
