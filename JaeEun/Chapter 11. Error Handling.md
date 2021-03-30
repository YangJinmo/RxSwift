오류를 처리하는 방법은 크게 두 가지 입니다.

옵셔널로 잘못된 처리의 결과나 실행 도중 실패했을 때 그 결과를 오류로 발생시키는 대신 nil 값으로 반환하여 개발자가 이를 알아서 적절히 처리하도록 유도하는 방법.

오류 처리 구문으로 반환값 타입이나 코드의 흐름과 상관없이 오류를 던질 수 있도록 하는 방법이 있습니다.

## 11.1 오류 처리 구문

try~catch와 같은 오류 처리 구분이 있어야 오류가 발생했을 때 오류에 대한 정보를 외부로 전달할 수 있습니다.

오류가 발생했을 때 함수나 메소드에서 해당 오류를 반환(returns)이 아닌 던지는(throws) 처리를 할 수 있게 끔 지원하는 이유는 오류를 던지는 것은 함수의 반환 타입과 일치하지 않아도 되기 때문에 효율적으로 정보를 전달할 수 있습니다.

오류 처리(Error Handling), 예외 처리(Exception Handling)은 조금 다른 개념이지만 편의상 묶어서 정리합니다.

### 11.1.1 오류 타입 정의하기

오류를 처리하기 위해서는 오류 정보를 담아 함수나 메소드 외부로 던질 오류 타입 객체가 필요합니다. 이 객체는 하나의 일관된 오류 주제에 소속된 여러가지 오류를 정의할 수 있어야 하므로, 보통 열거형 타입으로 정의하는 경우가 많습니다. 객체를 만들어 보면서 오류 타입을 정의하는 과정을 익혀봅시다.

YYYY-MM-DD 형태의 발생할 수 있는 오류들

1. 입력된 문자열의 길이가 필요한 크기와 맞지 않는 오류
2. 입력된 문자열의 형식이 YYYY-MM-DD 형태가 아닌 오류
3. 입력된 문자열의 값이 날짜와 맞지 않는 오류

오류 타입으로 사용되는 열거형을 정의할 때는 반드시 Error라는 프로토콜을 구현해야 합니다. 컴파일러는 Error 프로토콜을 구현한 열거형만을 오류 타입으로 인정합니다. 아무 열거형이나 오류 타입이라고 사용해버리면 컴파일러도 이를 처리하는 데 곤란을 겪을 것이기 때문입니다.

이때의 Error는 아무 기능도 정의되지 않은 빈 프로토콜입니다. 구현해야할 프로퍼티나 메소드도 필요하지 않습니다. 실제로 Error 프로토콜의 정의를 살펴보면 다음처럼 빈 프로토콜로 정의되어 있는 것을 볼 수 있습니다.

> Error 프로토콜의 정의

```swift
protocol Error {

}
```

간혹 이처럼 아무 내용도 작성되지 않은 프로토콜을 볼 수 있는데, 이들은 모두 프로토콜의 기능 구현 보다는 프로토콜을 구현했다는 사실 자체가 중요한 경우가 많습니다. Error 프로토콜 역시 마찬가지입니다. 이 프로토콜을 구현한 열거형은 오류타입으로 사용해도 된다는 인증마크라고 할 수 있죠.

> 문자열을 분석하여 날짜 형식으로 처리하는 과정에서 발생할 수 있는 오류들

```swift
enum DateParseError: Error {
  case overSizeString
  case underSizeString
  case incorrectFormat(part: String)
  case incorrectData(part: String)
}
```

- overSizeString: 입력된 데이터의 길이가 필요한 크기보다 큽니다.
- underSizeString: 입력된 데이터의 길이가 필요한 크기보다 부족합니다.
- incorrectFormat: 입력된 데이터의 형식이 맞지 않습니다.
- incorrectData: 입력된 데이터의 값이 올바르지 않습니다.

### 11.1.2 오류 던지기

우리가 작성한 오류 타입 객체는 함수나 메소드를 실행하는 과정에서 필요에 따라 외부로 던져 실행 흐름을 옮겨버릴 수 있습니다. 이때 함수나 메소드는 오류 객체를 외부로 던질 수 있다는 것을 컴파일러에게 알려주기 위해 정의 구문을 작성할 때 throws 키워드를 추가합니다.

throws 키워드는 반환 타입을 표시하는 화살표 (→) 앞에 작성해야 하는데, 이는 오류를 던지면 값이 반환되지 않는다는 의미이기도 합니다. 함수나 메소드, 또는 익명 함수인 클로저까지 모두 throws 키워드를 사용할 수 있습니다.

```swift
func canThrowErrors() throws -> String
```

위 함수는 실행 과정에서 오류가 발생하면 그 오류를 객체로 만들어 던질 수 있습니다.

> 클로저에서의 throws

```swift
{() throws -> String in
	...
}
```

이렇게 throws 키워드가 추가된 함수나 메소드, 또는 클로저는 실행 블록 어느 지점에서건 우리가 의도하는 오류를 던질 수 있습니다. 오류를 실제로 던질 때 throw 키워드를 사용하는데, 이는 함수나 메소드 등에서 오류를 던진다는 것을 선언할 때 사용했던 throws 키워드와 비슷하지만 단수라는 사실에 주의해야 합니다.

실제로 날짜를 분석하는 함수를 작성하고, 실행 과정에서 발생할 수 있는 오류 상황에서 오류 객체를 던져보겠습니다. 앞서 작성한 DateParseError 오류 객체를 사용합니다.

```swift
import Foundation

struct Date {
  var year: Int
  var month: Int
  var date: Int
}

func parseDate(param: NSString) throws -> Date {
  // 입력된 문자열의 길이가 10이 아닐 경우 분석이 불가능하므로 오류
  guard param.length == 10 else {
    if param.length > 10 {
      throw DateParseError.overSizeString
    } else {
      throw DateParseError.underSizeString
    }
  }
  
  // 반환할 객체 타입 선언
  var dateResult = Date(year: 0, month: 0, date: 0)
  
  // 연도 정보 분석
  if let year = Int(param.substring(with: NSRange(location: 0, length: 4))) {
    dateResult.year = year
  } else {
    // 연도 분석 실패
    throw DateParseError.incorrectFormat(part: "year")
  }
  
  // 월 정보 분석
  if let month = Int(param.substring(with: NSRange(location: 5, length: 2))) {
    // 월에 대한 값은 1 ~ 12까지만 가능하므로 그 이외의 범위는 잘못된 값으로 처리한다.
    guard month > 0 && month < 13 else {
      throw DateParseError.incorrectData(part: "month")
    }
    dateResult.month = month
  } else {
    // 월 분석 실패
    throw DateParseError.incorrectFormat(part: "month")
  }
  
  // 일 정보 분석
  if let date = Int(param.substring(with: NSRange(location: 8, length: 2))) {
    // 일에 대한 값은 1 ~ 31까지만 가능하므로 그 이외의 범위는 잘못된 값으로 처리한다.
    guard date > 0 && date < 32 else {
      throw DateParseError.incorrectData(part: "date")
    }
    dateResult.date = date
  } else {
    // 일 분석 실패
    throw DateParseError.incorrectFormat(part: "date")
  }
  
  return dateResult
}
```

객체 이름 앞에 NS 접두어가 붙은 객체는 파운데이션 프레임워크를 호출해야 사용할 수 있습니다.

> 호출

```swift
try parseDate(param: "2020-02-28")
```

> 변수나 상수에 할당

```swift
let date = try parseDate(param: "2020-02-28")
```

### 11.1.3 오류 객체 잡아내기

```swift
do {
  try <오류를 던질 수 있는 함수>
	// 오류가 발생하지 않는 상황에서 실행할 구문
} catch <오류 타입1> {
	// 오류 타입1에 대한 대응
} catch <오류 타입2> {
	// 오류 타입2에 대한 대응
} catch {
	// 지정되지 않은 오류에 대한 대응
}
```

컴파일러는 do 구문 내부에 작성된 순서대로 코드를 실행하다가 try 함수가 호출에서 오류가 던져지면 이를 catch 구문으로 전달합니다.

catch 구문은 switch 구문에서의 case 처럼 오류 타입 각각을 지정하여 작성할 수 있는데, 이 때 각 오류 타입에 대응하는 코드를 작성해야 합니다.

```swift
func getPartsDate(date: NSString, type: String) {
  do {
    let date = try parseDate(param: date)
    
    switch type {
    case "year":
      print("\\(date.year)년입니다.")
    case "month":
      print("\\(date.month)월입니다.")
    case "date":
      print("\\(date.date)일입니다.")
    default:
      print("입력값에 해당하는 날짜정보가 없습니다.")
    }
  } catch DateParseError.overSizeString {
    print("입력된 문자열이 너무 깁니다. 줄여주세요")
  } catch DateParseError.underSizeString {
    print("입력된 문자열이 불충분합니다. 늘려주세요")
  } catch DateParseError.incorrectFormat(let part) {
    print("입력값의 \\(part)해당하는 형식이 잘못되었습니다.")
  } catch DateParseError.incorrectData(let part) {
    print("입력값의 \\(part)해당하는 값이 잘못사용되었습니다. 확인해주세요.")
  } catch {
    print("알 수 없는 오류가 발생하였습니다.")
  }
}
```

> 함수 호출

```swift
getPartsDate(date: "2015-12-31", type: "year")
getPartsDate(date: "2015-12-31", type: "month")
getPartsDate(date: "2015-13-31", type: "month")
getPartsDate(date: "2015-12-40", type: "date")
getPartsDate(date: "2015-13-40", type: "date")
getPartsDate(date: "2015-12-4x", type: "date")
getPartsDate(date: "2015-12-40x", type: "date")
getPartsDate(date: "2015-12-4", type: "date")
```

- 실행 결과

> 필요에 의해 오류를 던지지 않게 하고 싶은 때 try!

```swift
let date = try! parseDate(param: "2020-02-28")
print("\\(date)")
// Date(year: 2020, month: 2, date: 28)

let date = try! parseDate(param: "2020-22-28")
print("\\(date)")
```

- 실행 결과

스위프트가 구현하는 오류 처리는 아직 조금 더 발전해야 할 부분이 있습니다. 자바나 C#에서 지원되는 것처럼 오류가 발생하더라도 반드시 실행할 수 있는 블록인 finally가 제대로 지원되지 않기 때문입니다. 물론 함수나 메소드는 이와 같은 기능을 제공하는 defer() 구문을 지원하기는 하지만, 위치 상의 문제로 인해 오류 처리 구문내에서 정의된 변수나 상수를 참조할 수 없는 등의 제약이 있습니다. 이는 앞으로 개선해 나가야 할 부분입니다.