import Darwin

let path = "/Users/pratt/src/work/artisan"

var newestFile: (filePath: String?, mtime: UInt) = (filePath: nil, mtime: 0)

func callback(fPath: UnsafePointer<Int8>, ftwStat: UnsafePointer<stat>, typeflag: Int32) -> Int32 {
  let fmtime = UInt(ftwStat.memory.st_mtimespec.tv_sec)

  if(fmtime > newestFile.mtime) {
    newestFile = (filePath: String.fromCString(fPath), mtime: fmtime)
  }

  return 0
}

let res = path.withCString() { cPath in
  ftw(cPath, callback, 1)
}

if res == 0 {
  print(newestFile)
} else {
  print(errno)
}

