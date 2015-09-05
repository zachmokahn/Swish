import Contacts

public func middleman() -> String {
  let greeting = Greeting(greeting: "Hello")
  let person = Person(name: "Brian")


  return greeting.greet(person)
}
