import SwishBuildSwift
import SwishUtils
import Swish

public enum RepoType {
	case GitHub
	case Git
}

public class Project {
	public var name = ""
	public var plugins = [String]()
	public var authors = [String]()

	public var repo: RepoType?
	public var homepage: String?
	public var description: String?
	public var license: String?
}

public func defineProject(configure: Project -> Void) {
	let project = Project()
	configure(project)

	buildAndRunProject(project)
}

func buildAndRunProject(project: Project) {
	let files = FS.scan("src/tasks/", pattern: "*.swift")

	let isStale: Bool
	let productPath = File.join(Swish.root, "build", "project", "project")
	if !File.exists(productPath) {
		isStale = true
	} else {
		let lastBuilt = File.mtime(productPath)
		let lastChanged: UInt = files.map { $0.mtime }.sort().first ?? lastBuilt + 1
		isStale = lastChanged >= lastBuilt
	}

	let target = BuildTarget(key: "project", deps: [], build: SwishBuildSwift.BuildApp)
	target.sources = [(path: "build/project", pattern: "*.swift")]

	if(!isStale) {
		Swish.logger.debug("Project up-to-date")

		SwishBuildSwift.RunApp(target)(args: System.args)
		return ()
	}

	System.exec("mkdir -p build/project")

	let filenames = files.map { $0.path }.join(" ")
	System.exec("cat \(filenames) > build/project/project.swift")
	System.exec("echo 'Swish.run()' >> build/project/project.swift")

	let path = System.env("SWISH_DIR") ?? File.join(System.pwd, ".swish", "lib")

	for lib in project.plugins + ["Swish", "SwishUtils", "SwishBuildSwift"] {
		target.link(module: lib, path: path)
	}

	var build = SwiftTargetBuild(target: target)
	build.otherFlags = [ "-o \(target.productName)" ]

	Swish.logger.debug("Building project")
	System.exec(build.cmd)

	SwishBuildSwift.RunApp(target)(args: System.args)
}
