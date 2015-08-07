struct Build {
  static func execute(target: Target) {
    for step in BuildCommand.forTarget(target).commands {
      step()
    }
  }
}
