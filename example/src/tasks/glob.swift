import Darwin

func identity<T>(v: T) -> T { return v }

struct System {
  static var pwd: String {
    var buf = Array<Int8>(count: Int(MAXNAMLEN), repeatedValue: 0)
    return String.fromCString(getcwd(&buf, Int(MAXNAMLEN)))!
  }
}

private func __callback(fPath: UnsafePointer<Int8>,
                        ftwStat: UnsafePointer<stat>,
                        typeflag: Int32,
                        ftwBuf: UnsafeMutablePointer<FTW>) -> Int32 {

  return FS.__walkCallback(fPath: fPath,
                    ftwStat: ftwStat, typeflag: typeflag, ftwBuf: ftwBuf)
}

public struct File {
  public let path: String

  public let mtime: UInt
  public let atime: UInt
  public let ctime: UInt
  public let uid: UInt
  public let gid: UInt
  public let isDir: Bool

  init(path: UnsafePointer<Int8>, raw: UnsafePointer<stat>, type: Int32) {
    self.path = String.fromCString(path)!
    self.mtime = UInt(raw.memory.st_mtimespec.tv_sec)
    self.atime = UInt(raw.memory.st_atimespec.tv_sec)
    self.ctime = UInt(raw.memory.st_ctimespec.tv_sec)
    self.uid = UInt(raw.memory.st_uid)
    self.gid = UInt(raw.memory.st_gid)
    self.isDir = type == 1
  }
}

public struct FS {
  static let globFlags = Darwin.GLOB_TILDE | Darwin.GLOB_BRACE | Darwin.GLOB_MARK

  static func glob(pattern: String) -> [String] {
    var globRes = Darwin.glob_t()
    var result: [String] = []

    Darwin.glob(pattern.withCString(identity), globFlags, nil, &globRes)

    let resultCount = Int(globRes.gl_matchc)
    for var i = 0; i < resultCount; i++ {
      result.append(String.fromCString(globRes.gl_pathv[i])!)
    }

    return result
  }

  public typealias WalkCallback = (
    fPath: UnsafePointer<Int8>,
    ftwStat: UnsafePointer<stat>,
    typeflag: Int32,
    ftwBuf: UnsafeMutablePointer<FTW>
  ) -> Int32

  static private var noop: WalkCallback = { (_, _, _, _) in return 0 }
  static private var __walkCallback = noop

  static private func withWalkCallback(cb: WalkCallback, fn: Void -> Void) {
    __walkCallback = cb
    fn()
    __walkCallback = noop
  }

  static public func ftw(path: String, cb: WalkCallback) {
    withWalkCallback(cb) {
      nftw(path.withCString(identity), __callback, 200, FTW_CHDIR)
    }
  }

  static public func walk(path: String, cb: File -> Void) {
    ftw(path) { fPath, ftwStat, type, _ in
      cb(File(path: fPath, raw: ftwStat, type: type))

      return 0
    }
  }

  static public func scan(root: String, pattern: String) -> [File] {
    var files = [File]()

    walk(root) { file in
      if !file.isDir && fnmatch(pattern, file.path, 0) == 0 {
        files.append(file)
      }
    }

    return files
  }
}

let root = "/Users/pratt/src/projects/Swish"

for file in FS.scan(root, pattern: "*.swift").sort({ $0.mtime > $1.mtime }) {
  print("\(file.path) -- \(file.mtime)")
}

// { file in
//   print("\(file.path) -- \(file.mtime)")
// }
