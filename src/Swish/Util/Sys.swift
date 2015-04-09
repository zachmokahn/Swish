import Darwin

struct Sys {
  static func exec(cmd: String) -> Int32 {
    errno = 0
    pclose(popen(cmd, "w"))
    return errno
  }

  static func exec(cmd: String, read: Bool) -> (output: String, status: Int32) {
    var readBuffer : UnsafeMutablePointer<Int8> = nil
    errno = 0

    var filePtr = popen(cmd, "r")
    var output = ""

    var line: Int = 0
    while getline(&readBuffer, &line, filePtr) != -1 {
      if let readString = String.fromCString(readBuffer) {
        output += readString
      }

      line += 1
    }

    free(readBuffer)
    pclose(filePtr)

    return (output: output, status: errno)
  }

  static func exit(status: Int32) {
    Darwin.exit(status)
  }
}

