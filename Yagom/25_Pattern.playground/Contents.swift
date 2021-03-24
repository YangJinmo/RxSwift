import UIKit

// 25. 패턴

// 25-1

let string: String = "ABC"

switch string {
case _: print(string) // ABC -> 어떤 값이 와도 상관없기에 항상 실행됩니다.
}

// ABC

let optionalString: String? = "ABC"

switch optionalString {
case "ABC"?:
  print(optionalString)
  // optionalString이 Optional("ABC")일 때만 실행됩니다.
case _?:
  print("Has value, but not ABC")
  // optionalString이 Optional("ABC") 외의 값일 때만 실행됩니다.
case nil:
  print("nil")
  // optionalString이 값이 없을 때만 실행됩니다.
}

// Optional("ABC")


let zzimss = ("zzimss", 99, "Male")

switch zzimss {
case ("zzimss", _, _):
  print("Hello zzimss!")
  // 첫번째 요소가 zzimss 일 때만 실행됩니다.
case (_, _, _):
  print("Who cares!")
  // 그 외 언제든지 실행됩니다.
}

// Hello zzimss!

for _ in 0..<2 {
  print("Hello")
}

// Hello
// Hello
