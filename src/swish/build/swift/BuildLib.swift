import SwishUtils
import Swish

func BuildLib(target: BuildTarget) {
  Swish.log("building \(target.key)...")

  var build = SwiftBuild(target: target)

  build.otherFlags = [
    "-emit-module",
    "-emit-library",
    "-module-name \(target.productName)"
  ]

  Swish.logger.debug("  create build directory")
  System.exec("mkdir -p \(target.buildDir)")

  Swish.logger.debug("  build Swift module \(target.productName)")
  Swish.logger.debug(build.cmd)

  System.exec(build.cmd)
  Swish.log("  successfully built Swift module " +
            "\(target.buildDir)/\(target.productName)\n")
}
