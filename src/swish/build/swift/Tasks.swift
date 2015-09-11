import Swish

public typealias ConfigFn = BuildTarget -> Void
public let defaultConfig: ConfigFn = { t in return }

public struct SwiftBuildDSL {
	public func app(
		key: String,
		_ deps: [String] = [],
		configure: ConfigFn = defaultConfig
	) {
		let target = BuildTarget(key: key, deps: deps, build: BuildApp)

		workspace.tasks.append(
			Task(
				key: "\(target.key):run",
				prereqs: deps + ["\(target.key):build"],
				fn: RunApp(target)
			)
		)

		addTarget(target: target, configure: configure)
	}

	public func lib(
		key: String,
		_ deps: [String] = [],
		configure: ConfigFn = defaultConfig
	) {
		let target = BuildTarget(key: key, deps: deps, build: BuildLib)
		addTarget(target: target, configure: configure)
	}

	public func script(
		key: String,
		_ deps: [String] = []
	) {
		workspace.tasks.append(
			Task(key: key, prereqs: deps, fn: RunScript(key, deps: deps))
		)
	}

	private func addTarget(target target: BuildTarget, configure: ConfigFn) {
		configure(target)
		workspace.targets.append(target)

		let buildDeps = target.targetDeps.map { "\($0):build" }

		workspace.tasks.append(
			Task(key: "\(target.key):build", prereqs: buildDeps, fn: { target.build(target) })
		)
	}
}

extension Swish {
	public static let Swift = SwiftBuildDSL()
}
