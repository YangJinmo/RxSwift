import UIKit

// 15. Map, Filter, Reduce


// 15-1

let numbers: [Int] = [0, 1, 2, 3, 4]

var doubleNumbers: [Int] = [Int]()
var strings: [String] = [String]()

// for 구문 사용
for number in numbers {
  doubleNumbers.append(number * 2)
  strings.append("\(number)")
}

print(doubleNumbers)  // [0, 2, 4, 6, 8]
print(strings)        // ["0", "1", "2", "3", "4"]

// map 메서드 사용
doubleNumbers = numbers.map({ (number: Int) -> Int in
  return number * 2
})
strings = numbers.map({ (number: Int) -> String in
  return "\(number)"
})

print(doubleNumbers)  // [0, 2, 4, 6, 8]
print(strings)        // ["0", "1", "2", "3", "4"]



// 15-2

// 기본 클로저 표현식 사용
doubleNumbers = numbers.map({ (number: Int) -> Int in
  return number * 2
})

// 매개변수 및 반환 타입 생략
doubleNumbers = numbers.map({ return $0 * 2 })

// 반환 키워드 생략
doubleNumbers = numbers.map({ $0 * 2 })

// 후행 클로저 사용
doubleNumbers = numbers.map { $0 * 2 }


// 15-3

let evenNumbers: [Int] = [0, 2, 4, 6, 8]
let oddNumbers: [Int] = [0, 1, 3, 5, 7]
let multiplyTwo: (Int) -> Int = { $0 * 2 }

let doubledEvenNumbers = evenNumbers.map(multiplyTwo)
print(doubledEvenNumbers) // [0, 4, 8, 12, 16]

let doubledOddNumbers = oddNumbers.map(multiplyTwo)
print(doubledOddNumbers) // [0, 2, 6, 10, 14]


// 15-4
let alphabetDictionary: [String: String] = ["a": "A", "b": "B"]

var keys: [String] = alphabetDictionary.map { (tuple: (String, String)) -> String in
  return tuple.0
}

keys = alphabetDictionary.map { $0.0 }

let values: [String] = alphabetDictionary.map { $0.1 }

print(keys)   // ["b", "a"]
print(values) // ["B", "A"]


var numberSet: Set<Int> = [1, 2, 3, 4, 5]
let resultSet = numberSet.map { $0 * 2 }
print(resultSet) // [2, 6, 8, 4, 10]


let optionalInt: Int? = 3
let resultInt: Int? = optionalInt.map { $0 * 2 }
print(resultInt) // Optional(6)


let range: CountableClosedRange = (0...3)
let resultRange: [Int] = range.map { $0 * 2 }
print(resultRange) // [0, 2, 4, 6]
