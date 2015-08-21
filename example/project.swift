import Swish

Swish.project("ContactBook") { project in

  project.app("CLI", ["Contacts"])
  project.module("Contacts")

  project.script("greet", ["Contacts"])

  project.task("build", ["CLI:build"])
  project.task("run", ["CLI:run"])

  project.script("testing")
}
