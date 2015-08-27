import Swish
import SwishUtils

public typealias Link = (name: String, path: String)
public typealias Source = (path: String, pattern: String)

final public class BuildTarget : Target {
  public let key: String
  public var build: BuildTarget -> Void
  public var sources: [Source] = []

  var buildDir: String { get { return "build/\(key)" }}
  var targetDeps: [String] = []
  var moduleDeps: [Link] = []

  var _productName: String?
  public var productName: String {
    get { return _productName ?? key }
    set { _productName = newValue }
  }

  init(key: String, deps: [String], build: BuildTarget -> Void) {
    self.key = key
    self.targetDeps = deps
    self.build = build
  }

  public func link(target target: String) {
    targetDeps.append(target)
  }

  public func link(module module: String, path: String) {
    moduleDeps.append(Link(name: module, path: path))
  }

  var subtargets: [BuildTarget] {
    return targetDeps.map { target in
      workspace.findTarget(target, ofType: BuildTarget.self)
    }.compact()
  }

  var links: [Link] {
    return subtargets.map { target in
      Link(name: target.productName, path: System.pwd + "/" + target.buildDir)
    } + moduleDeps
  }
}
