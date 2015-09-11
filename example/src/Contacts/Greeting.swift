import Darwin

public class Greeting {
	public var greeting: String

	public init(greeting: String) {
		self.greeting = greeting
	}

	public func greet(person: Person) -> String {
		return "\(self.greeting), \(person.name)!!!"
	}
}
