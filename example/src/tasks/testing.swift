import Darwin

let path = "/Users/pratt/src/work/artisan"
let dir = UnsafeMutablePointer<dirent>.alloc(1)
let root = path.withCString() { str in opendir(str) }

if(root != nil) {
  let dir = readdir(root)
  print(dir)
}

print(root)

dir.dealloc(1)
