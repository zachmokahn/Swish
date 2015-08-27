import Swish
import SwishBuildSwift

Swish.app("CLI", ["Contacts"]) { app in 
  app.sources = [(path: "src/CLI", pattern: "*.swift")]
}

Swish.module("Contacts") { module in
  module.sources = [(path: "src/Contacts", pattern: "*.swift")]
}

Swish.task("build", ["Contacts:build", "CLI:build"])
Swish.task("run", ["CLI:run"])

Swish.script("greet", ["Contacts"])

Swish.run()
