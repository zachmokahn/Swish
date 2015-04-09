require 'fileutils'

project = "Swish"
working_dir = FileUtils.pwd
build_dir = File.join(working_dir, "build", project)
project_dir = File.join(working_dir, "src", project)

def swish_bin(cmd)
  "DYLD_LIBRARY_PATH=../build/Swish xcrun swift -I ../build/Swish -lSwish project.swift #{cmd}"
end

task :default => [:clean, :build, :build_example, :run_example]

task :clean do
  FileUtils.rm_rf(build_dir)
end

task :build do
  FileUtils.mkdir_p(build_dir)
  FileUtils.cd(build_dir) do
    cmd = "xcrun --sdk macosx swiftc -emit-library -module-name #{project} -emit-module $(find #{project_dir} -name *.swift)"
    puts cmd
    system(cmd)
  end
end

task :run => [:build] do
  cmd = "DYLD_LIBRARY_PATH=#{build_dir} " +
    "xcrun swift -I#{build_dir} " +
    "-l#{project} example/project.swift"

  puts cmd
  system(cmd)
end

task :build_example do
  system("(cd ./example && #{swish_bin("Contacts:build")})")
  system("(cd ./example && #{swish_bin("CLI:build")})")
end

task :run_example do
  system("(cd ./example && swish CLI:run)")
end
