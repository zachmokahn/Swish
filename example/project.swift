import Swish
import SwishBuildSwift

Swish.app("CLI", ["Middleman"]) { app in 
  app.sources = [(path: "src/CLI", pattern: "*.swift")]
}

Swish.lib("Contacts") { lib in
  lib.sources = [(path: "src/Contacts", pattern: "*.swift")]
}

Swish.lib("Middleman", ["Contacts"]) { lib in
  lib.sources = [(path: "src/Middleman", pattern: "*.swift")]
}

Swish.task("build", ["Middleman:build", "Contacts:build", "CLI:build"])
Swish.task("run", ["build", "CLI:run"])

Swish.script("greet", ["Contacts"])

Swish.run()
