import SwishUtils
import Swish

public func isStaleBuild(target: BuildTarget, _ filename: String) -> Bool {
	let productPath = File.join(Swish.root, target.buildDir, filename)

	if !File.exists(productPath) {
		return true
	}

	let lastBuilt = File.mtime(productPath)

	let sources = target.sources.flatMap { source in
		return FS.scan(
			File.join(Swish.root, source.path),
			pattern: source.pattern
		)
	}

	let lastChanged: UInt = sources.map { $0.mtime }.sort().first ?? lastBuilt + 1

	return lastBuilt <= lastChanged
}

public struct SwiftTargetBuild {
	var target: BuildTarget
  public var linkerFlags = [String]()

	var linkPaths: [String] {
		return BuildTarget.links(target).map { "-L\($0.path)" }.uniq()
	}

	var importPaths: [String] {
		return BuildTarget.links(target).map { "-I\($0.path)" }.uniq()
	}

	var linkModules: [String] {
		return BuildTarget.links(target).map { "-l\($0.name)" }.uniq()
	}

	var _linkerFlags: [String] {
		return linkerFlags.map { "-Xlinker \($0)" }
	}

	var sources: [String] {
		return target.sources.flatMap { source in
			FS.scan(source.path, pattern: source.pattern).map {
				"\(Swish.root)/\($0.path)"
			}
		}
	}

	public var otherFlags: [String] = []
	public var sdk: String = "macosx"

	public var cmd: String {
		return [
			["(cd ./\(target.buildDir) &&", "xcrun", "-sdk \(sdk)", "swiftc"],
			linkPaths,
			importPaths,
			linkModules,
			_linkerFlags,
			otherFlags,
			sources,
			[")"]
		].flatMap { $0 }.join(" ")
	}

	public init(target: BuildTarget) {
		self.target = target
	}
}
