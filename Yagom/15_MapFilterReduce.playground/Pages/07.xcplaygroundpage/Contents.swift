//: [Previous](@previous)

import Foundation

// 15-7

let numbers: [Int] = [1, 2, 3]

// 초깃값이 0이고 정수 배열의 모든 값을 더합니다.
var sum: Int = numbers.reduce(0, { (first: Int, second: Int) -> Int in
  print("\(first) + \(second)")
//  0 + 1
//  1 + 2
//  3 + 3
  return first + second
})

print(sum) // 6

// 초깃값이 0이고 정수 배열의 모든 값을 뺍니다.
var subtract: Int = numbers.reduce(0, { (first: Int, second: Int) -> Int in
  print("\(first) - \(second)")
//  0 - 1
//  -1 - 2
//  -3 - 3
  return first - second
})

print(subtract) // -6

// 초깃값이 3이고 정수 배열의 모든 값을 더합니다.
let sumFromThree: Int = numbers.reduce(3) {
  print("\($0) + \($1)")
//  3 + 1
//  4 + 2
//  6 + 3
  return $0 + $1
}

print(sumFromThree) // 9

// 초깃값이 3이고 정수 배열의 모든 값을 뺍니다.
let subtractFromThree: Int = numbers.reduce(0, {
  print("\($0) - \($1)")
//  0 - 1
//  -1 - 2
//  -3 - 3
  return $0 - $1
})

print(subtractFromThree) // -6

//: [Next](@next)
