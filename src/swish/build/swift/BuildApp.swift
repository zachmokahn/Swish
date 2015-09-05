import SwishUtils
import Swish

public func BuildApp(target: BuildTarget) {
  if(!isStaleBuild(target, target.productName)) {
    Swish.logger.debug("\(target.key)... up-to-date")
    return
  }

  Swish.log("building \(target.key)...")

  var build = SwiftBuild(target: target)
  build.otherFlags = [ "-o \(target.productName)" ]

  Swish.logger.debug("  create build directory")
  System.exec("mkdir -p \(target.buildDir)")

  Swish.logger.debug("  build Swift app \(target.productName)")
  // Swish.logger.debug(build.cmd)

  System.exec(build.cmd)
  Swish.log("  successfully built Swift app " +
            "\(target.buildDir)/\(target.productName)\n")
}
