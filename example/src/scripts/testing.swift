import Darwin

public func env(key: String) -> String? {
  return String.fromCString(
                            Darwin.getenv(key.withCString { $0 })
                            )
}

print(env("POOP"))
print(env("FARTS"))
