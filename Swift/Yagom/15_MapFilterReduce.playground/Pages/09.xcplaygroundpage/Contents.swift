//: [Previous](@previous)

import Foundation

// 15-9

enum Gender {
  case male, female, unknown
}

struct Friend {
  let name: String
  let gender: Gender
  let location: String
  var age: UInt
}

var friends: [Friend] = [
  Friend(name: "진모", gender: .male, location: "발리", age: 30),
  Friend(name: "연주", gender: .female, location: "시드니", age: 24),
  Friend(name: "예빈", gender: .female, location: "경기", age: 27),
  Friend(name: "석준", gender: .male, location: "서울", age: 28),
  Friend(name: "현호", gender: .male, location: "충북", age: 31),
  Friend(name: "상진", gender: .male, location: "대전", age: 26),
  Friend(name: "다희", gender: .female, location: "부산", age: 24)
]

// 서울 외의 지역에 거주하며 25세 이상인 친구
var result: [Friend] = friends.map {
  Friend(
    name: $0.name,
    gender: $0.gender,
    location: $0.location,
    age: $0.age + 1
  )
}

result = result.filter { $0.location != "서울" && $0.age >= 25 }

let string: String = result.reduce("서울 외의 지역에 거주하며 25세 이상인 친구") {
  $0 + "\n" + "\($1.name) \($1.gender) \($1.location) \($1.age)세"
}

print(string)

//: [Next](@next)
