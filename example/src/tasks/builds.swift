import Swish
import SwishBuildSwift

Swish.Swift.app("CLI", ["Middleman"]) { app in 
  app.sources = [(path: "src/CLI", pattern: "*.swift")]
}

Swish.Swift.lib("Contacts") { lib in
  lib.sources = [(path: "src/Contacts", pattern: "*.swift")]
}

Swish.Swift.lib("Middleman", ["Contacts"]) { lib in
  lib.sources = [(path: "src/Middleman", pattern: "*.swift")]
}

Swish.task("build", ["Middleman:build", "Contacts:build", "CLI:build"])
Swish.task("run", ["build", "CLI:run"])

Swish.Swift.script("greet", ["Contacts"])

Swish.run()
