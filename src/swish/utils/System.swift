import Darwin

public func identity<T>(v: T) -> T { return v }
private let maxNameLength = Int(MAXNAMLEN)

public struct System {
	public static func exec(cmd: String) {
		Darwin.pclose(popen(cmd, "w"))
	}

	public static func exit(status: Int32) {
		Darwin.exit(status)
	}

	public static var pwd: String {
		var buf = Array<Int8>(count: maxNameLength, repeatedValue: 0)
		return String.fromCString(getcwd(&buf, maxNameLength))!
	}

	public static var args: [String] {
		var args = Array(Process.arguments)
		args.removeAtIndex(0)

		return args
	}

	public static func env(key: String) -> String? {
		return String.fromCString(Darwin.getenv(key))
	}
}
