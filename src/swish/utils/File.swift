import Darwin

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

  public static func mtime(path: String) -> UInt {
    return File.stat(path).mtime
  }

  public static func join(chunks: String...) -> String {
    return chunks.join("/")
  }

  public static func exists(path: String) -> Bool {
    return Darwin.access(path, Darwin.F_OK) != -1
  }

  public static func stat(path: String) -> File {
    let statBuf = UnsafeMutablePointer<Darwin.stat>.alloc(1)

    Darwin.stat(path, statBuf)
    let file = File(path: path, raw: statBuf, type: 0)

    statBuf.destroy()

    return file
  }
}
