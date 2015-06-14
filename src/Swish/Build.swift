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
