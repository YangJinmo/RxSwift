import UIKit

// Data Types (71 ~ 102p)
// 대문자 카멜케이스 // 파스칼 케이스 // 쌍봉낙타

// Any: 모든 데이터 타입을 사용할 수 있음
// AnyOject: class의 인스턴스에만 할당할 수 있음

// 정수 타입
let int: Int // +,- 부호를 포함한 정수
let uint: UInt // - 부호를 포함하지 않는 0을 포함한 양의 정수

let minInt = Int.min
let maxInt = Int.max

let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)

print(convertedNumber as Any)

var serverResponseCode: Int? = 404
// serverResponseCode contains an actual Int value of 404
serverResponseCode = nil
// serverResponseCode now contains no value

var surveyAnswer: String?
// surveyAnswer is automatically set to nil

if convertedNumber != nil {
    print("convertedNumber contains some integer value.")
}
// Prints "convertedNumber contains some integer value."

if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}
// Prints "convertedNumber has an integer value of 123."


if let actualNumber = Int(possibleNumber) {
    print("The string \"\(possibleNumber)\" has an integer value of \(actualNumber)")
} else {
    print("The string \"\(possibleNumber)\" could not be converted to an integer")
}
// Prints "The string "123" has an integer value of 123"


if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
// Prints "4 < 42 < 100"

if let firstNumber = Int("4") {
    if let secondNumber = Int("42") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
    }
}
// Prints "4 < 42 < 100"


let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // requires an exclamation mark

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString // no need for an exclamation mark

if assumedString != nil {
    print(assumedString!)
}
// Prints "An implicitly unwrapped optional string."

if let definiteString = assumedString {
    print(definiteString)
}
// Prints "An implicitly unwrapped optional string."

let index = 3
// In the implementation of a subscript...
precondition(index > 0, "Index must be greater than zero.")
//preconditionFailure()



// 면접 질문
// class vs struct
// 함수형 프로그래밍, 프토토콜 지향 프로그래밍
// 안정성? 왜 안전한지
// repl 리눅스


let greeting = "asdasd"
greeting[greeting.startIndex]

