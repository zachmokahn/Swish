Swish
==

![Swish!](https://d13yacurqjgara.cloudfront.net/users/31664/screenshots/1256215/court-2.gif)

Swish is an overly-optimistic take on a command-line build tool for Swift. It's
based on tools like Rake, Gulp, or Leiningen that have in-language DSLs for
configuration of builds.

The goal for Swish is to maintain a simple core API for compilation, linking,
and automation with an extensible architecture to enable plugins for, well, all
kinds of stuff! Right now, Swish is a proof-of-concept, but it's still usable.

The other goal is to explicitly avoid using anything proprietary to Apple beyond
the Swift compiler itself and Darwin (Apple's implementation of libC).  The idea
is that if Swift becomes open-sourced, XCode, `xcodebuild`, CoreFoundation,
Cocoa -- these won't be.

Also, Swift without Cocoa is really interesting and fun as a thought experiment,
so there's that, too.

The Gist
---

```swift
import Swish

Swish.project("MyProject") { project in

  // define a module target called 'Contacts'
  project.module("Contacts")

  // define an app target called 'CLI' that depends on 'Contacts' module
  project.app("CLI", ["Contacts"])

  // define tasks that are a collection of dependent tasks
  project.task("build", ["Contacts:build", "CLI:build"])
  project.task("run", ["CLI:run"])

  // define a simple task that runs a function
  project.task("Hello") {
    println("Hello!")
  }

  // define a script, a runnable file that can link with application code
  // the src/scripts/Greet.swift script will run,linking the Contacts module
  project.script("Greet", ["Contacts"])
}

```

You can check out the [Example Project](src/example/project.swift)!

Current Features
---
* builds pure-Swift apps and modules
* links targets and apps
* runs simple tasks, with dependencies
* runs scripts linked with project libraries

RoadMap
---
* Clang targets for C/Obj-C code
* better build logging/output
* only build targets if they contain code that has changed
* profiles (production / development by default: optimization levels, etc)
* installation script (brew?)
* nested projects / recursive discovery
* re-organization of build output / build dirs to simplify build cmds?
  * symlink of dylibs/swiftmodules?
* plugin API
