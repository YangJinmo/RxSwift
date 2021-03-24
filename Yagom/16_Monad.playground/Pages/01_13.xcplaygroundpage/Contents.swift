import UIKit

// 16. Monad


// 16-1

func addThree(_ num: Int) -> Int {
  print(num + 3)
  return num + 3
}


// 16-2

addThree(2) // 5


// 16-3

//addThree(Optional(2)) // 오류 발생 !
// Cannot convert value of type 'Optional<Int>' to expected argument type 'Int'

addThree(Optional(2)!) // 5
print(Optional(2)!) // 2


// 16-4

Optional(2).map(addThree) // Optional(5)


// 16-5

var value: Int? = 2

//print(value + 3) // 오류 발생 ! - Int랑 Int?은 다른 타입이기 때문
// Value of optional type 'Int?' must be unwrapped to a value of type 'Int'
print(value! + 3)

let optional2Map: Int? = value.map { $0 + 3 }
print(optional2Map) // Optional(5) - 맵은 컨테이너의 값을 변형시킬 수 있는 고차함수이기 때문

value = nil // Optional.none

let optionalNoneMap: Int? = value.map { $0 + 3 }
print(optionalNoneMap) // nil - 값이 없다면 빈 컨텍스트로 다시 반환


// 16-6

extension Optional {
  func map<U>(f: (Wrapped) -> U) -> U? {
    switch self {
    case .some(let x): return f(x)
    case .none: return .none
    }
  }
}


// 16-7

// 짝수면 2를 곱해서 반환하고 짝수가 아니라면 nil을 반환하는 함수
func doubleEven(_ num: Int) -> Int? {
  if num % 2 == 0 {
    return num * 2
  }
  return nil
}

let optional3FlatMap: Int? = Optional(3).flatMap(doubleEven)
print(optional3FlatMap) // nil  == Optional.none


// 16-8

let optionalArr: [Int?] = [1, 2, nil, 5]

let mappedArr: [Int?] = optionalArr.map { $0 }
let compactMappedArr: [Int] = optionalArr.compactMap { $0 }

print(mappedArr) // [Optional(1), Optional(2), nil, Optional(5)]
print(compactMappedArr) // [1, 2, 5]

//

let optionalAnyArr: [Any?] = [1, 2, nil, "four", 5]

let mappedOptionalAnyArr: [Any?] = optionalAnyArr.map { $0 }
let compactMappedOptionalAnyArr: [Any?] = optionalAnyArr.compactMap { $0 }

print(mappedOptionalAnyArr) // [Optional(1), Optional(2), nil, Optional("four"), Optional(5)]
print(compactMappedOptionalAnyArr) // [1, 2, "four", 5]

//

let possibleNumbers: [String] = ["1", "2", "three", "///4///", "5"]

let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
let compactMapped: [Int] = possibleNumbers.compactMap { str in Int(str) }

print(mapped) // [Optional(1), Optional(2), nil, nil, Optional(5)]
print(compactMapped) // [1, 2, 5]


// 16-9

let multipleContainer = [[1, 2, Optional.none], [3, Optional.none], [4, 5, Optional.none]]

let mappedMultipleContainer = multipleContainer.map { $0.map { $0 } }
let flatMappedMultipleContainer = multipleContainer.flatMap { $0.compactMap { $0 } }
let compactMappedMultipleContainer = multipleContainer.compactMap { $0.compactMap { $0 } }

print(mappedMultipleContainer) // [[Optional(1), Optional(2), nil], [Optional(3), nil], [Optional(4), Optional(5), nil]]
print(flatMappedMultipleContainer) // [1, 2, 3, 4, 5]
print(compactMappedMultipleContainer) // [[1, 2], [3], [4, 5]]


// 16-10

func stringToInt(str: String) -> Int? {
  return Int(str)
}

func intToString(integer: Int) -> String? {
  return "\(integer)"
}

var optionalString: String? = "2"

var result: Any = optionalString
  .flatMap(stringToInt)
  .flatMap(intToString)
  .flatMap(stringToInt)

print(result) // Optional(2)

result = optionalString
  .map(stringToInt)?
  .map(intToString)
  //.map(stringToInt) - 더 이상 체인 연결 불가

print(result) // Optional(Optional("2"))



// 16-11

//func map<U>(_ transform: (wrapped) throws -> U) rethrows -> U?
//func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
//func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]


// 16-12

if let str: String = optionalString {
  if let num: Int = stringToInt(str: str) {
    if let finalStr: String = intToString(integer: num) {
      if let finalNum: Int = stringToInt(str: finalStr) {
        result = Optional(finalNum)
      }
    }
  }
}

print(result) // Optional(2)

if let str: String = optionalString,
   let num: Int = stringToInt(str: str),
   let finalStr: String = intToString(integer: num),
   let finalNum: Int = stringToInt(str: finalStr) {
  
  result = Optional(finalNum)
}

print(result) // Optional(2)


// 16-13

func intToNil(param: Int) -> String? {
  return nil
}


var optionalString2: String? = " 2 "

var result2 = optionalString2
  .flatMap(stringToInt)
  .flatMap(intToNil)
  .flatMap(stringToInt)

print(result2) // nil

let names: [String?] = ["Tom", nil, "Peter", nil, "Harry"]

let mappedCounts = names.map { $0?.count }
print(mappedCounts) // [Optional(3), nil, Optional(5), nil, Optional(5)]

let compactMappedCounts = names.compactMap { $0?.count }
print(compactMappedCounts) // [3, 5, 5]
