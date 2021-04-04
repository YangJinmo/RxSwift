import UIKit


// 22. 제네릭

// 22-1

//prefix operator **
//
//prefix func ** (value: Int) -> Int {
//  return value * value
//}
//
//let minusFive: Int = -5
//let sqrtMinusFive: Int = **minusFive
//
//print(sqrtMinusFive)


// 22-2

prefix operator **

prefix func ** <T: BinaryInteger> (value: T) -> T {
  return value * value
}

let minusFive: Int = -5
let five: UInt = 5

let sqrtMinusFive: Int = **minusFive
let sqrtFive: UInt = **five

print(sqrtMinusFive)
print(sqrtFive)


// 22-3

//func swapTwoInts(_ a: inout Int, _ b: inout Int) {
//  let temporaryA: Int = a
//  a = b
//  b = temporaryA
//}
//
var numberOne: Int = 5
var numberTwo: Int = 10
//
//swapTwoInts(&numberOne, &numberTwo)
//print("\(numberOne), \(numberTwo)") // 10, 5


// 23-4

//func swapTwoStrings(_ a: inout String, _ b: inout String) {
//  let temporaryA: String = a
//  a = b
//  b = temporaryA
//}
//
var stringOne: String = "A"
var stringTwo: String = "B"
//
//swapTwoStrings(&stringOne, &stringTwo)
//print("\(stringOne), \(stringTwo)") // B, A

// 23-5

//func swapTwoValues(_ a: inout Any, _ b: inout Any) {
//  let temporaryA: Any = a
//  a = b
//  b = temporaryA
//}
//
var anyOne: Any = 1
var anyTwo: Any = "B"
//
//swapTwoValues(&anyOne, &anyTwo)
//print("\(anyOne), \(anyTwo)") // B, 1


// 22-6

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
  let temporaryA: T = a
  a = b
  b = temporaryA
}

swapTwoValues(&numberOne, &numberTwo)
print("\(numberOne), \(numberTwo)") // 10, 5

swapTwoValues(&stringOne, &stringTwo)
print("\(stringOne), \(stringTwo)") // B, A

swapTwoValues(&anyOne, &anyTwo)
print("\(anyOne), \(anyTwo)") // B, 1

//swapTwoValues(&numberOne, &stringOne) // 오류 발생 - 같은 타입 끼리만 교환 가능


// 22-7

struct IntStack {
  var items = [Int]()
  
  mutating func push(_ item: Int) {
    items.append(item)
  }
  
  mutating func pop() -> Int {
    return items.removeLast()
  }
}

var integerStack: IntStack = IntStack()

integerStack.push(3)
print(integerStack.items) // [3]

integerStack.push(2)
print(integerStack.items) // [3, 2]

integerStack.push(3)
print(integerStack.items) // [3, 2, 3]

integerStack.push(5)
print(integerStack.items) // [3, 2, 3, 5]

integerStack.pop()
print(integerStack.items) // [3, 2, 3]

integerStack.pop()
print(integerStack.items) // [3, 2]

integerStack.pop()
print(integerStack.items) // [3]

integerStack.pop()
print(integerStack.items) // []

//integerStack.pop() // 오류 발생


// 22-8

//struct Stack<Element> {
//  var items = [Element]()
//
//  mutating func push(_ item: Element) {
//    items.append(item)
//  }
//
//  mutating func pop() -> Element {
//    return items.removeLast()
//  }
//}
//
//var doubleStack: Stack<Double> = Stack<Double>()
//
//doubleStack.push(1.0)
//print(doubleStack.items) // [1.0]
//
//doubleStack.push(2.0)
//print(doubleStack.items) // [1.0, 2.0]
//
//doubleStack.pop()
//print(doubleStack.items) // [1.0]
//
//var stringStack: Stack<String> = Stack<String>()
//
//stringStack.push("1")
//print(stringStack.items) // ["1"]
//
//stringStack.push("2")
//print(stringStack.items) // ["1", "2"]
//
//stringStack.pop()
//print(stringStack.items) // ["1"]
//
//var anyStack: Stack<Any> = Stack<Any>()
//
//anyStack.push(1.0)
//print(anyStack.items) // [1.0]
//
//anyStack.push("2")
//print(anyStack.items) // [1.0, "2"]
//
//anyStack.push(3)
//print(anyStack.items) // [1.0, "2", 3]
//
//anyStack.pop()
//print(anyStack.items) // [1.0, "2"]
//
//
//// 22-9
//
//
//extension Stack {
//  var topElement: Element? {
//    return self.items.last
//  }
//}
//
//print(doubleStack.topElement) // Optional(1.0)
//print(stringStack.topElement) // Optional("1")
//print(anyStack.topElement)    // Optional("2")


// 22-10

//@frozen public struct Dictionary<Key, Value> where Key : Hashable { ... }
//extension Dictionary : ExpressibleByDictionaryLiteral { ... }


// 22-11

//func swapTwoValues<T: BinaryInteger>(_ a: inout T, _ b: inout T) {
//  // 함수 구현
//}
//
//struct Stack<Element: Hashable> {
//  // 구조체 구현
//}


// 22-12

func swapTwoValues<T: BinaryInteger>(_ a: inout T, _ b: inout T) where T: FloatingPoint, T: Equatable {
  // 함수 구현
}


// 22-13

//func substractTwoValues<T>(_ a: T, _ b: T) -> T {
//  return a - b
//}



// 22-14

func substractTwoValues<T: BinaryInteger>(_ a: T, _ b: T) -> T {
  return a - b
}


// 22-15

func makeDictionaryWithTwoValue<Key: Hashable, Value>(key: Key, value: Value) -> Dictionary<Key, Value> {
  let dictionary: Dictionary<Key, Value> = [key:value]
  return dictionary
}


// 22-16

protocol Container {
//  associatedtype ItemType
//
//  var count: Int { get }
//
//  mutating func append(_ item: ItemType)
//
//  subscript(i: Int) -> ItemType { get }
}


// 22-17

class MyContainer: Container {
  var items: Array<Int> = Array<Int>()
  
  var count: Int {
    return items.count
  }
  
  func append(_ item: Int) {
    items.append(item)
  }
  
  subscript(i: Int) -> Int {
    return items[i]
  }
}


// 22-18

//struct InStack: Container {
//
//  // 기존 IntStack 구조체 구현
//  var items = [Int]()
//
//  mutating func push(_ item: Int) {
//    items.append(item)
//  }
//
//  mutating func pop() -> Int {
//    return items.removeLast()
//  }
//
//  // Container 프로토콜 준수를 위한 구현
//  mutating func append(_ item: Int) {
//    self.push(item)
//  }
//
//  var count: Int {
//    return items.count
//  }
//
//  subscript(i: Int) -> Int {
//    return items[i]
//  }
//}


// 22-19

struct InStack: Container {
  typealias ItemType = Int
  
  // 기존 IntStack 구조체 구현
  var items = [ItemType]()
  
  mutating func push(_ item: ItemType) {
    items.append(item)
  }
  
  mutating func pop() -> ItemType {
    return items.removeLast()
  }
  
  // Container 프로토콜 준수를 위한 구현
  mutating func append(_ item: ItemType) {
    self.push(item)
  }
  
  var count: ItemType {
    return items.count
  }
  
  subscript(i: ItemType) -> ItemType {
    return items[i]
  }
}



// 22-20

struct Stack<Element>: Container {
  
  // 기존 Stack<Element> 구조체 구현
  var items = [Element]()
  
  mutating func push(_ item: Element) {
    items.append(item)
  }

  mutating func pop() -> Element {
    return items.removeLast()
  }
  
  // Container 프로토콜 준수를 위한 구현
  mutating func append(_ item: Element) {
    self.push(item)
  }
  
  var count: Int {
    return items.count
  }
  
  subscript(i: Int) -> Element {
    return items[i]
  }
}

/*
 
 var a: Int? = tot["현호님"]
 var b: Player? = tot["현호님"]
 var c = tot["현호님"]


extension Stack {
    subscript<Indices: Sequence>(indices: Indices) -> [Element] where Indices.Iterator.Element == Int {
        guard let range = indices as? ClosedRange<Int> else {
            return []
        }
        return Array(items[range])
    }
}

protocol Container {
    associatedtype ItemType

    var count: Int { get }
    mutating func append(_ item: ItemType)
    subscript(i: Int) -> ItemType { get }
}

class MyContainer<T>: Container {
    typealias ItemType = T

    private var items: [ItemType] = []

    var count: Int {
        items.count
    }

    func append(_ item: ItemType) {
        items.append(item)
    }

    subscript(i: Int) -> ItemType {
        items[i]
    }
}
class MyConainer<T>: Container<T>
 
 // api 호출
 func request<T: Codable>(url: String, completionHandler: @escaping (T) -> Void) {...}
 
 
*/




/*
 
 var a: Int = 5
 var b: Int = 10
 var temp: Int

 temp = a
 a = b
 b = temp
 나오후 3:19
 ㅋㅋㅋㅋㅋㅋㅋ
 ㅋㅋㅋㅋㅋ
 무마니오후 3:20
 a = a + b
 b = a - b
 a = a - b

 print(a)
 print(b)
 홍다희오후 3:20
 xor bitwise
 SeokJun Jeong오후 3:21
 a = a ^ b
 b = a ^ b
 a = a ^ b
 개발자리오후 3:21
 (b,a) = (a,b)
 
 
 
 
 
 
 var a: Int = 5
 var b: Int = 10
 //var temp: Int

 //temp = a
 //a = b
 //b = temp

 // 1
 a = a + b
 b = a - b
 a = a - b

 print(a)
 print(b)

 // 2
 a = a ^ b
 b = a ^ b
 a = a ^ b

 print(a)
 print(b)

 // 3
 (a, b) = (b, a)

 print(a)
 print(b)
 
 */
