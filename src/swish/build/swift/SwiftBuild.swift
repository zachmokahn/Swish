import SwishUtils
import Swish

public struct SwiftBuild {
  var target: BuildTarget

  var linkPaths: [String] {
    return BuildTarget.links(target).map { "-L\($0.path)" }
  }

  var importPaths: [String] {
    return BuildTarget.links(target).map { "-I\($0.path)" }
  }

  var linkModules: [String] {
    return BuildTarget.links(target).map { "-l\($0.name)" }
  }

  var sdk: String = "macosx"
  var sources: [String] {
    return target.sources.flatMap { source in
      FS.scan(source.path, pattern: source.pattern).map {
        "\(Swish.root)/\($0.path)"
      }
    }
  }

  var otherFlags: [String] = []

  var cmd: String {
    return
      [
        ["(cd ./\(target.buildDir) &&", "xcrun", "-sdk \(sdk)", "swiftc"],
        linkPaths,
        importPaths,
        linkModules,
        otherFlags,
        sources,
        [")"]
      ].flatMap { $0.uniq() }.join(" ")
  }

  init(target: BuildTarget) {
    self.target = target
  }
}
