//: [Previous](@previous)

import Foundation

// 16-8

let names: [String?] = ["Tom", nil, "Peter", nil, "Harry"]

// let valid = names.flatMap { $0 } // 'flatMap' is deprecated, Use 'compactMap'
let valid = names.compactMap { $0 }
print(valid) // ["Tom", "Peter", "Harry"]


//

let words = ["53", "nine", "hello", "0"]

// let values = words.flatMap { Int($0) }
let values = words.compactMap { Int($0) } // Returns [Int]
print(values) // [53, 0]


// 플랫맵 더보기


// 1. Using flatMap on a sequence with a closure that returns a sequence:

let scores: [[Int]] = [[5, 2, 7], [4, 8], [9, 1, 3]]

let allScores: [Int] = scores.flatMap { $0 }
let passMarks: [Int] = scores.flatMap { $0.filter { $0 > 5} }

print(allScores) // [5, 2, 7, 4, 8, 9, 1, 3]
print(passMarks) // [7, 8, 9]

//

let numbers: [Int] = [1, 2, 3, 4]

let mapped: [[Int]] = numbers.map { Array(repeating: $0, count: $0) }
let flatMapped: [Int] = numbers.flatMap { Array(repeating: $0, count: $0) }

print(mapped) // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]
print(flatMapped) // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]


// 2. Using flatMap on an optional

let input: Int? = Int("8")
let passMark: Int? = input.flatMap { $0 > 5 ? $0 : nil }
print(passMark as Any) // Optional(8)


// 3. Using flatMap on a sequence with a closure that returns an optional.

//let names: [String?] = ["Tom", nil, "Peter", nil, "Harry"]

let mappedCounts = names.map { $0?.count }
let compactMappedCounts = names.compactMap { $0?.count }

print(mappedCounts) // [Optional(3), nil, Optional(5), nil, Optional(5)]
print(compactMappedCounts) // [3, 5, 5]


//

let possibleNumbers = ["1", "2", "three", "///4///", "5"]

let mappedNumbers: [Int?] = possibleNumbers.map { str in Int(str) }
let compactMappedNumbers: [Int] = possibleNumbers.compactMap { str in Int(str) }

print(mappedNumbers) // [Optional(1), Optional(2), nil, nil, Optional(5)]
print(compactMappedNumbers) // [1, 2, 5]


//

let myNames: [String] = ["John", "Joe", "Jack"]

let myCounts1: [Int] = myNames.map { $0.count }
let myCounts2: [Int] = myNames.compactMap { $0.count }

print(myCounts1) // [4, 3, 4]
print(myCounts2) // [4, 3, 4]

//: [Next](@next)
