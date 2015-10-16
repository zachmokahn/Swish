import Swish
import SwishUtils

public typealias Link = (name: String, path: String)
public typealias Source = (path: String, pattern: String)

final public class BuildTarget : Target {
	public let key: String
	public var build: BuildTarget -> Void
	public var sources: [Source] = []

	public var buildDir: String { get { return "build/\(key)" }}
	public var targetDeps: [String] = []
	public var moduleDeps: [Link] = []

	var _productName: String?
	public var productName: String {
		get { return _productName ?? key }
		set { _productName = newValue }
	}

	static func links(target: BuildTarget) -> [Link] {
		let targetLinks = target.subtargets.map { st in
			Link(name: st.productName, path: System.pwd + "/" + st.buildDir)
		}

		let parentLinks = target.subtargets.flatMap { links($0) }.uniq({ $0.path })
		return targetLinks + target.moduleDeps + parentLinks
	}

	public init(key: String, deps: [String], build: BuildTarget -> Void) {
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
}
