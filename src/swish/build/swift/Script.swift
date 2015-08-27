import Swish
import SwishUtils

func RunScript(name: String, deps: [String])() {
  let targets: [BuildTarget] = deps.map() { name in
    workspace.findTarget(name, ofType: BuildTarget.self)
  }.compact()

  let ldPath = targets.map { $0.buildDir }.join(":")

  let links = targets.map { target in
    "-I\(Swish.root)/\(target.buildDir) -l\(target.productName)"
  }.join(" ")

  let path: String

  path = "src/tasks/\(name).swift"
  let cmd = "DYLD_LIBRARY_PATH=\(ldPath) xcrun swift \(links) \(path)"

  Swish.logger.debug(cmd)
  System.exec(cmd)
}
