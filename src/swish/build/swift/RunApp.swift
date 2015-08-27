import Swish
import SwishUtils

func RunApp(target: BuildTarget)() {
  let libPath = BuildTarget.links(target).map { _, path in path }.join(":")

  let cmd = "DYLD_LIBRARY_PATH=\(libPath):DYLD_LIBRARY_PATH \(target.buildDir)/\(target.productName)"

  Swish.logger.debug(cmd)
  System.exec(cmd)
}
