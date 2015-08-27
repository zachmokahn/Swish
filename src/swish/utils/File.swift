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
}
