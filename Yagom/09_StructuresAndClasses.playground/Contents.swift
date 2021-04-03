import UIKit

struct BasicInfomation {
    var name: String
    var age: Int
}

var zzimssInfo: BasicInfomation = BasicInfomation(name: "zzimss", age: 99)
zzimssInfo.age = 100
zzimssInfo.name = "galaxy"

var friendInfo: BasicInfomation = zzimssInfo  // 구조체이므로 값 복사

print("zzimss's age: \(zzimssInfo.age)")  // 100
print("friend's age: \(friendInfo.age)")  // 100

friendInfo.age = 999

print("zzimss's age: \(zzimssInfo.age)")  // 100
print("friend's age: \(friendInfo.age)")  // 999


class Person {
    var height: Float = 0.0
    var weight: Float = 0.0
}

var zzimss: Person = Person()
var friend: Person = zzimss

print("zzimss's height: \(zzimss.height)")  // 0.0
print("friend's height: \(friend.height)")  // 0.0

friend.height = 185.5

print("zzimss's height: \(zzimss.height)")  // 185.5
print("friend's height: \(friend.height)")  // 185.5

func changeBasicInfo(_ info: BasicInfomation) {
    var copiedInfo: BasicInfomation = info
    copiedInfo.age = 1
}

func changePersonInfo(_ info: Person) {
    info.height = 155.3
}

changeBasicInfo(zzimssInfo)
print("zzimss's age: \(zzimssInfo.age)")  // 100
// changeBasicInfo(_:)로 전달되는
// 전달인자는 값이 복사되어 전달되기 때문에 zzimssInfo의 값만 전달되는 것입니다.

changePersonInfo(zzimss)
print("zzimss's height: \(zzimss.height)")  // 155.3
// changePersonInfo(_:)의
// 전달인자로 zzimss의 참좌 전달되었기 때문에 zzimss가 참조하고 있는 값들의 변화가 생깁니다.


var anotherFriend: Person = Person() // 새로운 인스턴스 생성

print(zzimss === friend)        // true
print(zzimss === anotherFriend) // false
print(friend !== anotherFriend) // true
