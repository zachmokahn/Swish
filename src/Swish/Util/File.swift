import Darwin

public struct File {
  public static func mtime(path: String) -> (status: Int32, time: UInt?) {
    let result = UnsafeMutablePointer<stat>.alloc(1)
    let status = path.withCString() { str in stat(str, result) }

    var time: UInt?

    if status == 0 {
      time = UInt(result.memory.st_mtimespec.tv_sec)
    }

    result.dealloc(1)
    return (status: status, time: time)
  }

  public static func exists(path: String) -> Bool {
    return access(path, F_OK) != -1
  }
}
