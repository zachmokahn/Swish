import Swish
import SwishUtils

public func RunApp(target: BuildTarget)() {
  return RunApp(target)(args: [])
}

public func RunApp(target: BuildTarget)(args: [String]) {
  let libPath = BuildTarget.links(target).map { _, path in path }.join(":")
  let argsStr = args.join(" ")

  let cmd = "DYLD_LIBRARY_PATH=\(libPath):$DYLD_LIBRARY_PATH \(target.buildDir)/\(target.productName) \(argsStr)"

  Swish.logger.debug(cmd)
  System.exec(cmd)
}
