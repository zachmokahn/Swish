import Swish

Swish.project("Swish") { project in
  project.module("Swish", ["SwishUtils"]) { target in
    target.sourceDir = "src/swish/core"
  }

  project.module("SwishUtils") { target in
    target.sourceDir = "src/swish/utils"
  }

  project.module("SwishProjects", ["SwishBuildSwift", "Swish", "SwishUtils"]) { target in
    target.sourceDir = "src/swish/projects"
  }

  project.module("SwishBuildSwift", ["Swish", "SwishUtils"]) { target in
    target.sourceDir = "src/swish/build/swift"
  }

  project.task("build", ["SwishProjects:build"])
}

