class BuildSwiftModule : BuildCommand {
  override init(sources: String, target: Target) {
    super.init(sources: sources, target: target)

    self.flags = [
      "-emit-library -module-name \(target.name)",
      "-emit-module"
    ]
  }
}
