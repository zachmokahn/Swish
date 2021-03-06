# Swish
### What is it?
It's a (working, but rudimentary) command-line build tool for Swift projects.
Think of it like `make`, `rake`, `lein`, or `grunt`, except made primarily to
work with Swift (and siblings)

### What does it do?
Right now, it compiles and links pure-Swift code. It runs simple
tasks and scripts. In the future, it could do all sorts of things: run tests,
download and install dependencies, deploy code, whatever.

### How do I use it?
First, know that Swish is unpublished, and doesn't have a "version" yet. It's
more like a prototype. To install it, put `bin/swish` somewhere on your path and
modify it to point to the directory Swish is cloned to. Run `bin/build` to build.

Make a new project directory. Add a file called `project.swift` to that new
directory. This file tells Swift some metadata about your project, so that
Swish knows how to bootstrap the build process (plugins, etc)

example:

    import Swish

    Swish.defineProject { project in
      project.name = "Swish"
      project.authors = ["Virginia Woolf", "Mark Twain"]
      project.repo = .GitHub("bppr/Swish")
      project.homepage = "http://bppr.github.io/Swish"

      project.description = "A command-line build-tool for Swift."
      project.license = "MIT"

      project.plugins = ["Swiftest"]
    }


Then, you can create some tasks (in `src/tasks`):

    project.task("turtles") {
      print("I like turtles.")
    }

And run them

    $ swish turtles
    I like turtles

You can use Swish to build some Swift code. Here, I'll define a dynamic library
target called "swish:core", and give it a few simple configuration options.

    Swish.lib("swish:core") { lib in
      lib.srcDir = "src/swish/core"
      // the name of the created module
      lib.productName("Swish")
    }

A module target creates a pure-Swift dynamic library. This module can be
imported by other targets or projects. Adding a module target also adds a build
task for the given module. For our target above, we could build it with
`swish:core:build`.

We can also define an `app` target, which will create an executable. Here,
we'll create an app called "swish:client", and make it depend on the "core"
library we built previously.

    Swish.app("swish:client", ["swish:core"]) { app in
      app.srcDir = "src/swish/core"

      // the name of the binary executable file
      app.productName("swish")
    }

Similarly to the module step, this will add a task for building, but it also
adds a second for running the compiled app. Using `swish:client:run`, we can
run our new app target, linking it with our module target, and hey-presto!

I can also create a task that simply invokes other tasks.

    Swish.task("run-with-turtles", ["turtles", "swish:client:run"])

Or, I can put a file in `src/scripts/` and run it, linked to the other projects.

    Swish.script("example-script", ["swish:core"])


### Roadmap
##### Done
* project meta-client
* extensible API for declaring projects, builds, tasks, and scripts
* task running: runs pre-requisite tasks, skips re-runs
* basic builder for pure-Swift targets
* basic logging
* doesn't rebuild existing, unchanged targets (could be optimized further,
  but.. later)
* bootstrappable build (shell script)

##### Undone
* build profiles + optimization levels for release and debug
* builder for Clang for pure-C/Obj-C targets, linkable with Swift
* logging enhancements
* support for external dependencies
* support for plugins
* brew installation
* repl? (still needs proof of concept)
* improve error cases: short-circuit on error, more helpful error messages
* investigate Linux implementation details
