import SwishUtils
import Swish

public func BuildLib(target: BuildTarget) {
  if(!isStaleBuild(target, "lib\(target.productName).dylib")) {
    Swish.logger.debug("\(target.key)... up-to-date")
    return
  }

  var build = SwiftBuild(target: target)

  build.otherFlags = [
    "-emit-module",
    "-emit-library",
    "-module-name \(target.productName)"
  ]

  Swish.log("building \(target.key)...")
  Swish.logger.debug("  create build directory")
  System.exec("mkdir -p \(target.buildDir)")

  Swish.logger.debug("  build Swift module \(target.productName)")
  // Swish.logger.debug(build.cmd)

  System.exec(build.cmd)
  Swish.log("  successfully built Swift module " +
            "\(target.buildDir)/\(target.productName)\n")
}
