import Swish
import SwishUtils

public func RunApp(target: BuildTarget)() {
	return RunApp(target)(args: [])
}

public func RunApp(target: BuildTarget)(args: [String]) {
	let argsStr = args.join(" ")
	let cmd = "\(target.buildDir)/\(target.productName) \(argsStr)"

	Swish.logger.debug(cmd)
	System.exec(cmd)
}
