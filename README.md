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

Clearly this is alpha software. You agree that you won't blame me if it breaks.
License TBD.

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
    print("Hello!")
  }

  // define a script, a runnable file that can optionally link with
  // application code
  project.script("Greet", ["Contacts"])
}

```

You can check out the [Example Project](src/example/project.swift)!

Current Features
---
* builds pure-Swift apps and dynamic modules
* links targets and apps
* runs tasks, with optional dependencies
* runs scripts, linked with project libraries

RoadMap
---
* Clang targets for C/Obj-C code
* better build logging/output
* only build targets if they contain code that has changed
  * this is going to require that I write some C or Obj-C
* profiles (production / development by default: optimization levels, etc)
* installation script (brew?)
* nested projects / recursive discovery / compilation of build "app"
* re-organization of build output / build dirs to simplify build cmds?
  * symlink of dylibs/swiftmodules?
* plugin API

Installing
----------- 
Clone the repo, run `rake build`, edit `bin/swish` to point to the
newly-created "build" directory, and copy `bin/swish` somewhere on your `$PATH`

To verify, `(cd example && swish run)`

I know, it's rudimentary. It's alpha software. What do you expect? :P
