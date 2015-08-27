require 'fileutils'

project = "Swish"
working_dir = FileUtils.pwd
build_dir = File.join(working_dir, "build", project)
project_dir = File.join(working_dir, "src", project)

VERBOSE = false

def swish_bin(cmd)
  # "swish #{cmd}"
  "DYLD_LIBRARY_PATH=../build/Swish:../build/SwishBuildSwift:../build/SwishUtils " +
    "xcrun swift -I ../build/Swish -I ../build/SwishBuildSwift -I ../build/SwishUtils " +
    "-lSwish -lSwishBuildSwift -lSwishUtils project.swift #{cmd} #{"--verbose" if VERBOSE}"
end

def system(cmd)
  puts(cmd) if VERBOSE
  Kernel.system(cmd)
end

task :default => [:build_example, :run_example]

task :clean do
  FileUtils.rm_rf(build_dir)
end

task :build_example do
  # system("(cd ./example && #{swish_bin("Contacts:build")})")
  system("(cd ./example && #{swish_bin("CLI:build")})")
end

task :run_example do
  system("(cd ./example && #{swish_bin("CLI:run")})")
end

task :run_script do
  system("(cd ./example && #{swish_bin("greet")})")
end

task :publish do
  system(
    "cp ./build/Swish/*.{swiftmodule,dylib} /usr/local/bin/swish/"
  )
end
