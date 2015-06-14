class BuildSwiftApp : BuildCommand {
  override init(sources: String, target: Target) {
    super.init(sources: sources, target: target)
    self.flags = [ "-o \(target.name)" ]
  }
}
