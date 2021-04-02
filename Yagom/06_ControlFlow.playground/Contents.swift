import UIKit

// 6.1.1  if 구문
let first: Int = 5
let second: Int = 7

if first > second {
        print("first > second")
} else if first < second {
        print("first < second")
} else {
        print("first == second")
}

// 6.1.2  switch 구문
let integerValue: Int = 5

switch integerValue {
case 0:
    print("Value == zero")
case 1...10: //범위 연산자
    print("Value == 1~10")
    fallthrough // 관통하여 떨어지다.
case Int.min..<0, 101..<Int.max: // 한 번에 여러 범위 연산자를 지정하는 모습
    print("Value < 0 or Value > 100")
case Int.min..<0, 101..<Int.max:
    break // 실행 가능한 코드가 없는 경우 break 라도 있어야 함
default:
    print("10 < Value <= 100")
}


let stringValue: String = "zzimss"

switch stringValue {
case "Jyoung":
    print("She is Jyoung")
case "NOWEAT":
    print("He is Now eat")
case "Tomorrow":
    fallthrough
case "zzimss":
    fallthrough
case "졔":
    print("He or she is \(stringValue)")
default:
    print("\(stringValue) said 'I don't know who you are.'")
}


typealias NameAge = (name: String, age: Int)

let tupleValue: NameAge = ("zzimss", 91)

switch tupleValue {
case ("zzimss", 910):
    print("정확히 맞추셨습니다!")
case ("zzimss", let age):
    print("이름만 맞았습니다. 나이는 \(age)입니다.")
    //fallthrough
case (let name, 91):
    print("나이만 맞았습니다. 이름는 \(name)입니다.")
default:
    print("누굴 찾으시나?")
}

let 직급: String = "사원"
let 연차: Int = 1
let 인턴인가: Bool = false

switch 직급 {
case "사원" where 인턴인가 == true:
    print("인턴입니다.")
case "사원" where 연차 < 2 && 인턴인가 == false:
    print("신입입니다.")
case "사원" where 연차 > 5:
    print("아직도 사원입니다.")
case "사원":
    print("사원입니다.")
case "대리":
    print("대리입니다.")
default: // 열거형과 같은 명확히 한정적인 값이 아니면 default를 꼭 넣어야 함
    print("너 사장이냐?")
}

enum School {
    case primary, elementary, middle, hight, college, university, graduate
}

let 최종학력: School = School.university

switch 최종학력 {
case .primary:
    print("최종학력은 유치원입니다.")
case .elementary:
    print("최종학력은 초등학교입니다.")
case .middle:
    print("최종학력은 중학교입니다.")
case .hight:
    print("최종학력은 고등학교입니다.")
case .college, .university:
    print("최종학력은 대학(교)입니다.")
case .graduate:
    print("최종학력은 대학원입니다.")
}

// 자동 완성
// tab 버튼
// . 앞에



// 6.2  반복문

// 6.2.1  for-in 구문

for i in 0...2 {
    print(i)
}


for i in 0...5 {
    
    if i % 2 == 0 {
        print(i)
        continue // continue 키워드를 사용하면 바로 다음 시퀀스로 건너뜁니다.
    }
    print("\(i) == 홀수")
}

let helloSwift: String = "Hello Swift!"

for char in helloSwift {
    print(char)
}

var result: Int = 1

// 시퀀스에 해달하는 값이 필요 없다면 와일드카드 식별자(_)를 사용하면 됩니다.
for _ in 1...3 {
    result *= 10
}
print("10의 3제곱은 \(result)입니다.")


// Dictionary
let friends: [String: Int] = ["Jay":28, "Joy":35, "Jenny":31]

for tuple in friends {
    print(tuple)
}

let 주소: [String: String] = ["도":"경기", "시군구":"수원시 권선구", "동읍면":"권선동"]

for (키, 값) in 주소 {
    print("\(키):\(값)")
}


// Set
let 지역번호: Set<String> = ["02", "031", "032", "033", "041", "041"]

for 번호 in 지역번호 {
    print(번호)
}

// 중복검사
// 함수형 프로그래밍 패러다임: map, filter, flatMap


// 6.2.2  while 구문

var names: [String] = ["zzimss", "탄이", "김윤환", "필비"]

while names.isEmpty == false {
    print("Good Bye \(names.removeFirst())")
    // removeFirst()는 요소를 삭제함 과 동시에 삭제된 요소를 반환합니다.
}


// 6.2.3  repeat-while 구문

names = ["1", "2", "3", "4"]

repeat {
    print("Good Bye \(names.removeFirst())")
} while names.isEmpty == false


// 6.3  구문 이름표

var numbers: [Int] = [3, 234, 54, 6575]

numbersLoop: for num in numbers {
    if num > 5 || num < 1 {
        continue numbersLoop
    }
    
    var count: Int = 0
    
    printLoop: while true {
        print(num)
        count += 1
        
        if count == num {
            break printLoop
        }
    }
    
    removeLoop: while true {
        if numbers.first != num {
            break numbersLoop
        }
        numbers.removeFirst()
    }
}

// 주석 용도로도 활용할 수 있을 것 같네요
