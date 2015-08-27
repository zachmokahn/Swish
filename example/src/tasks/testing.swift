import Darwin

func identity<T>(v: T) -> T { return v }

extension String {
  var asCString: UnsafePointer<Int8> {
    return self.withCString(identity)
  }
}

typealias WalkCallback = (
  fPath: UnsafePointer<Int8>,
  ftwStat: UnsafePointer<stat>,
  typeflag: Int32
) -> Int32

private var noop: WalkCallback = { (_, _, _) in return 0 }
private var __walkCallback = noop

private func __callback(
  fPath: UnsafePointer<Int8>,
  ftwStat: UnsafePointer<stat>,
  typeflag: Int32
) -> Int32 {
  __walkCallback(fPath: fPath, ftwStat: ftwStat, typeflag: typeflag)
  return 0
}

private func withWalkCallback(cb: WalkCallback, fn: Void -> Void) {
  __walkCallback = cb
  fn()
  __walkCallback = noop
}

func walk(path: String, cb: WalkCallback) {
  withWalkCallback(cb) {
    ftw(path.asCString, __callback, 1)
  }
}

var fts: UnsafePointer<stat> = nil
var count = 0

struct File {
  let path: String

  let mtime: UInt
  let atime: UInt
  let ctime: UInt
  let uid: UInt
  let gid: UInt
  let isDir: Bool

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

class Fudge {
  var pwd: String {
    var buf = Array<Int8>(count: Int(MAXNAMLEN), repeatedValue: 0)
    return String.fromCString(getcwd(&buf, Int(MAXNAMLEN)))!
  }
}

var dir = Fudge().pwd

walk(".") { fPath, ftwStat, ft in
  if ft == FTW_F && fnmatch("src/**.swift", fPath, 4) == 0 {
    let f = File(path: fPath, raw: ftwStat, type: ft)
    print(f.path)
  }

  return 0
}
