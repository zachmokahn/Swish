class ModuleBuildCommand : BuildCommand {
  override init(sources: String, target: Target) {
    super.init(sources: sources, target: target)
    self.flags = [
      "-emit-library -module-name \(target.name)",
      "-emit-module"
    ]
  }
}

class AppBuildCommand : BuildCommand {
  override init(sources: String, target: Target) {
    super.init(sources: sources, target: target)
    self.flags = [ "-o \(target.name)" ]
  }
}

class BuildCommand {
  static func forTarget(target: Target) -> BuildCommand {
    let srcDir = Swish.root + target.sourceDir
    let sources = "\(srcDir)/*.swift"

    switch target.type {
    case .Module:
      return ModuleBuildCommand(sources: sources, target: target)

    case .App:
      return AppBuildCommand(sources: sources, target: target)
    }
  }

  var target: Target
  var sources: String
  var flags: [String] = []
  var sdk = "macosx"
  var buildDir: String { return Swish.root + target.buildDir }

  var links: String {
    return join(Strings.space, map(target.links) { ln in
      "-L\(Swish.root + ln.path) -I\(Swish.root + ln.path) -l\(ln.module)"
    })
  }

  var command: String {
    return "mkdir -p \(buildDir) && (cd \(buildDir) && xcrun --sdk \(sdk) " +
      "swiftc \(links) \(join(Strings.space, flags)) \(sources))"
  }

  init(sources: String, target: Target) {
    (self.sources, self.target) = (sources, target)
  }
}

struct Build {
  static func execute(target: Target) {
    if should(target) {
      let cmd = BuildCommand.forTarget(target).command

      Swish.log.debug(cmd)
      Sys.exec(cmd)
    }
  }

  static func should(target: Target) -> Bool {
    return true
  }
}
