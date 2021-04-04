import UIKit

// 26. where 절


// 26-1

let tuples: [(Int, Int)] = [(1, 2), (1, -1), (1, 0), (0, 2)]

// 값 바인딩, 와일드카드 패턴
for tuple in tuples {
  switch tuple {
  case let (x, y) where x == y: print("x == y")
  case let (x, y) where x == -y: print("x == -y")
  case let (x, y) where x > y: print("x > y")
  case (1, _): print("x == 1")
  case (_, 2): print("y == 2")
  default: print("\(tuple.0), \(tuple.1)")
  }
}
/*
 x == 1
 x == -y
 x > y
 y == 2
 */

var repeatCount: Int = 0
// 값 바인딩 패턴
for tuple in tuples {
  switch tuple {
  case let (x, y) where x == y && repeatCount > 2: print("x == y")
  case let (x, y) where repeatCount < 2: print("\(x), \(y)")
  default: print("Nothing")
  }
  
  repeatCount += 1
}

/*
 1, 2
 1, -1
 Nothing
 Nothing
 */


let firstValue: Int = 50
let secondValue: Int = 30

// 값 바인딩 패턴
switch firstValue + secondValue {
case let total where total > 100: print("total > 100")
case let total where total < 0: print("wrong value")
case let total where total == 0: print("zero")
case let total: print(total)
}
// 80


// 26-2

let arrayOfOptionalInts: [Int?] = [nil, 2, 3, nil, 5]

for case let number? in arrayOfOptionalInts where number > 2 {
  print("Found a \(number)")
}
// Found a 3
// Found a 5


// 26-3

let anyValue: Any = "ABC"

switch anyValue {
case let value where value is Int: print("value is Int")
case let value where value is String: print("value is String")
case let value where value is Double: print("value is Double")
default: print("Unknown type")
} // value is String

var things: [Any] = [
  0,
  0.0,
  42,
  3.14159,
  "hello",
  (3.0, 5.0),
  { (name: String) -> String in "Hello, \(name)" }
]

for thing in things {
  switch thing {
  case 0 as Int:
    print("zero as an Int")
  case 0 as Double:
    print("zero as a Double")
  case let someInt as Int:
    print("an interger value of \(someInt)")
  case let someDouble as Double where someDouble > 0:
    print("a positive double value of \(someDouble)")
  case is Double:
    print("some other double value that I don't want to print")
  case let someString as String:
    print("a string value of \"\(someString)\"")
  case let (x, y) as (Double, Double):
    print("an (x, y) point at \(x), \(y)")
  case let stringConverter as (String) -> String:
    print(stringConverter("Michael"))
  default:
    print("something else")
  }
}

/*
 zero as an Int
 zero as a Double
 an interger value of 42
 a positive double value of 3.14159
 a string value of "hello"
 an (x, y) point at 3.0, 5.0
 Hello, Michael
 */



// 26-4

var point: (Int, Int) = (1, 2)

switch point {
case (0, 0):
  print("원점")
case (-2...2, -2...2) where point.0 != 1:
  print("\(point.0), \(point.1)은 원점과 가깝습니다.")
default:
  print("point (\(point.0), \(point.1))")
}



// 26-5
protocol SelfPrintable {
  func printSelf()
}

struct Person: SelfPrintable { }

extension Int: SelfPrintable { }
extension UInt: SelfPrintable { }
extension String: SelfPrintable { }
extension Double: SelfPrintable { }

extension SelfPrintable where Self: BinaryInteger {
  func printSelf() {
    print("BinaryInteger를 준수하면서 SelfPrintable을 준수하는 \(type(of: self)) 타입")
  }
}

extension SelfPrintable where Self: CustomStringConvertible {
  func printSelf() {
    print("CustomStringConvertible을 준수하면서 SelfPrintable을 준수하는 \(type(of: self)) 타입")
  }
}

extension SelfPrintable {
  func printSelf() {
    print("그 외 SelfPrintable을 준수하는 \(type(of: self)) 타입")
  }
}

Int(-8).printSelf()
UInt(8).printSelf()
String("zzimss").printSelf()
Double(8.0).printSelf()
Person().printSelf()

/*
 BinaryInteger를 준수하면서 SelfPrintable을 준수하는 Int 타입
 BinaryInteger를 준수하면서 SelfPrintable을 준수하는 UInt 타입
 CustomStringConvertible을 준수하면서 SelfPrintable을 준수하는 String 타입
 CustomStringConvertible을 준수하면서 SelfPrintable을 준수하는 Double 타입
 그 외 SelfPrintable을 준수하는 Person 타입
 */

// 26-6

// 타입 매개변수 T가 BinaryInteger 프로토콜을 준수하는 타입
func doubled1<T>(integerValue: T) -> T where T: BinaryInteger {
  return integerValue * 2
}

// 위 함수와 같은 표현입니다.
func doubled2<T: BinaryInteger>(integerValue: T) -> T {
  return integerValue * 2
}

// 타입 매개변수 T와 U가 CustomStringConvertible 프로토콜을 준수하는 타입
func prints1<T, U>(first: T, second: U) where T: CustomStringConvertible, U: CustomStringConvertible {
  print(first, second)
}

// 위 함수와 같은 표현입니다.
func prints2<T: CustomStringConvertible, U: CustomStringConvertible>(first: T, second: U) {
  print(first, second)
}

print(doubled1(integerValue: 10)) // 20
print(doubled2(integerValue: 10)) // 20

prints1(first: "1", second: "2") // 1 2
prints2(first: "1", second: "2") // 1 2
