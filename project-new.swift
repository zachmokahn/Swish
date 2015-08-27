import Swish

Swish.module("swish:core", ["swish:utils"]) { module in
  module.srcDir = "src/swish/core"
  module.moduleName = "Swish"
}

Swish.module("swish:utils") { module in
  module.srcDir = "src/swish/utils"
  module.moduleName = "SwishUtils"
}

Swish.task("build", ["swish:core:build"])
Swish.run()
