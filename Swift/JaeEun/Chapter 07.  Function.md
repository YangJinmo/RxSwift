프로그램의 실행 과정 중에서 독립적으로 처리될 수 있는 부분을 분리하여 구조화한 객체

외부에 의존하는 부분 없이 툭 떼어 분리할 수 있는 실행 단위를 일종의 캡슐처럼 포장해놓은 것

독립적으로 작성된 함수는 간단한 방식으로 여러 번 호출하여 사용할 수 있어서 같은 코드를 반복해서 작성할 필요가 없습니다.

특히 스위프트는 함수형 프로그래밍 패러다임을 채택하고 있는 언어이므로 함수형 프로그래밍의 특성을 이해하는 것은 매우 중요합니다.

## 7.1 함수의 기본 개념

프로그래밍에서 함수가 필수요소는 아닙니다. 그럼에도 함수가 중요한 의미를 가지는 것은 다음과 같은 이점들 때문입니다.

- 동일한 코드가 여러 곳에서 사용될 때 이를 함수화하면 재작성할 필요 없이 함수 호출만으로 처리할 수 있습니다.
- 전체 프로세스를 하나의 소스 코드에서 연속적으로 작성하는 것보다 기능 단위로 함수화하면 가독성이 좋아지고, 코드와 로직을 이해하기 쉽습니다.
- 비지니스 로직을 변경해야 할 때 함수 내부만 수정하면 되므로 유지보수가 용이합니다.

### 7.1.1 사용자 정의 함수

```swift
func 함수이름(매개변수1: 타입, 매개변수2: 타입, ...) -> 반환타입 {
	실행내용
	return 반환값
}
```

- 스위프트는 명시적으로 func 키워드를 사용하여 함수를 선언해야 합니다.
- func 키워드 다음에는 함수의 이름을 작성하는데, 이때 [+, -, *, /] 같은 연산자와 예약어는 사용할 수 없습니다.
- 함수의 이름에 사용할 수 있는 문자들은 영어나 숫자, 한자, 바이너리 이미지 등으로 다양하지만, 첫 글자는 반드시 영어 또는 언더바(_)로 시작해야 합니다. 언더바 이외의 특수문자나 숫자로 시작할 경우 컴파일러에 의해 오류가 발생합니다. 대신 두 번째 글자부터는 이런 제약이 없으므로 영어, 숫자, 이룹 특수문자를 충분히 활용할 수 있습니다. 단, 숫자나 특수 문자 등을 너무 남발하면 함수의 핵심인 재사용성과 생산성 측면에서 불편함이 야기될 수 있으므로 주의해야 합니다.

```swift
// 1. 매개변수와 반환값이 모두 없는 함수
func printHello() {
	print("안녕하세요")
}

// 2. 매개변수가 없지만 반환값은 있는 함수
func sayHello() -> String {
	let resultValue = "안녕하세요"
	return resultValue
}

// 3. 매개변수는 있으나 반환값이 없는 함수
func printHelloWithName(name: String) {
	print("\\(name)님, 안녕하세요")
}

// 4. 매개변수와 반환값이 모두 있는 함수
func sayHelloWithName(name: String) -> String {
	let resultValue = "\\(name)님, 안녕하세요"
	return resultValue
}

// 옵셔널 바인딩이 실패했을 경우 return 구문을 호출하여 실행을 종료
func hello(name: String?) {
	guard let _name = name else {
		return
	}

	print("\\(name)님, 안녕하세요")
}
```

### 7.1.2 함수의 호출

```swift
printHello()
// 안녕하세요

let inputName = "홍길동"
printHelloWithName(name: inputName)
// 홍길동님, 안녕하세요

// 간혹 불필요한 코드를 줄이기 위해 인자값으로 실제 값을 넣어주기도 합니다.
// 이렇게 넣어주는 실제 값을 **리터럴(Literal)**이라고 합니다.
printHelloWithName(name: "홍길동")
func times(x: Int, y: Int) -> Int {
	return (x * y)
}

times(x: 5, y: 10) // 함수의 이름만으로 호출한 구문
times(x:y:)(5, 10) // 함수의 **식별자(Signature)**를 사용하여 호출한 구문
```

### 7.1.3 함수의 반환값과 튜플

함수는 반드시 하나의 값만을 반환해야 합니다.

여러 개의 값을 반환해야한다면, 이 값들을 **집단 자료형**에 담아 반환해야 합니다.

- 집단 자료형: 딕셔너리, 배열, 튜플, 구조체, 클래스

```swift
func getUserInfo() -> (Int, String) {
	// 데이터 타입이 String으로 추론되는 것을 방지하기 위해 타입 어노테이션 선언
	let gender: Character = "M"
	let height = 180
	let name = "꼼꼼한 재은씨"

	return (height, gender, name)
}

// 튜플을 반환하는 변수를 받아 사용하는 방법
// 튜플을 반환하는 함수의 반환값을 대입 받은 변수나 상수는
// 튜플의 인덱스를 이용하여 튜플 내부의 요소를 사용할 수 있습니다.
var uInfo = getUserInfo()
uInfo.0 // 180
uInfo.1 // "M"
uInfo.2 // "꼼꼼한 재은씨"

// 인덱스를 사용하는 대신 가독성과 편리성을 위해
// 튜플 요소 각각을 변수로 직접 받을 수도 있습니다.
var (a, b, c) = getUserInfo()
a // 180
b // "M"
c // "꼼꼼한 재은씨"

// 일부 필요하지 않은 튜플 항목은 
// 언더바를 이용하면 변수 할당 없이 건너뛸 수 있습니다.
var (height, _, name) = getUserInfo()
```

실행 결과로 반환되는 튜플의 각 아이템을 함수 정의 구문을 통해 변수에 미리 할당해 둘 수도 있습니다. 반환값 타입을 설정할 때 튜플 항목 하나하나에 미리 변수를 정의해 놓는 겁니다. 이렇게 정의해 두면 함수를 실행할 때 결과값을 바인딩하지 않아도 특정 변수명으로 바인딩된 튜플 인자를 사용할 수 있습니다.

```swift
func getUserInfo() -> (h: Int, g: Character, n: String) {
	let gender: Character = "M"
	let height = 180
	let name = "꼼꼼한 재은씨"

	return (height, gender, name)
}

// 튜플 인자 타입 앞에 각각의 변수를 붙여 주면 
// 함수의 결과값을 받은 변수에도 이들이 자동으로 바인딩 됩니다.
var result = getUserInfo()
result.h // 180
result.g // "M"
result.n // "꼼꼼한 재은씨"
```

함수가 여러 개의 값을 반환할 때 이를 간단하게 묶기 위해 사용하는 것이 튜플이지만, 특정 튜플 타입이 여러 곳에서 사용될 경우에는 **타입 알리어스**를 통해 새로운 축약형 타입을 정의하는 것이 좋습니다.

타입 얼리어스는 이름이 길거나 사용하기 복잡한 타입 표현을 새로운 타입명으로 정의해주는 문법으로, .typealias 키워드를 사용하여 정의합니다.

```swift
typealias <새로운 타입 이름> = <타입 표현>
typealias infoResult = (Int, Character, String)

func getUserInfo() -> infoResult {
	let gender: Character = "M"
	let height = 180
	let name = "꼼꼼한 재은씨"

	return (height, gender, name)
}
```

타입 알리어스를 이용하여 축약 표현을 만들 때 변수가 바인딩된 튜플을 정의할 수도 있습니다.

```swift
typealias infoResult = (h: Int, g: Character, n: String)

let info = getUserInfo()

info.h // 180
info.g // "M"
info.n // "꼼꼼한 재은씨"
```

## 7.2 매개변수

스위프트는 기본적인 매개변수의 호출 발법이 다른 언어와 다르기도 하지만, 그 이외에도 특별한 기능들을 적지않게 가지고 있습니다.

### 7.2.1 내부 매개변수명, 외부 매개변수명

```swift
func 함수 이름(<외부 매개변수명> <내부 매개변수명>: <타입>, ...) {
	// 내용
}
func printHello(name: String, msg: String) {
	print("\\(name)님, \\(msg)")
}

printHello(name: "홍길동", msg: "안녕하세요")

// 함수명: printHello(name:msg:)
// 외부 매개변수 지정
func printHello(to name: String, welcomeMessage msg: String) {
	print("\\(name)님, \\(msg)")
}

printHello(to: "홍길동", welcomeMessage : "안녕하세요")

// 함수명: printHello(to:welcomeMessage:)
// 외부 매개변수 생략
func printHello(_ name: String, _ msg: String) {
	print("\\(name)님, \\(msg)")
}

printHello("홍길동", "안녕하세요")

// 함수명: printHello(_:_:)
```

## 7.2.2 가변 인자

가변적인 개수의 인자값을 입력받는 경우

```swift
func 함수 이름(매개변수명: 타입...) // 생략의 의미가 아님
```

> 입력된 값들의 평균값을 계산하는 함수

```swift
func avg(score: Int...) -> Double {
	var total = 0 // 점수 합계
	for r in score { // 배열로 입력된 값들을 순회 탐색하면서 점수를 합산
		total += r
	}
	return (Double(total) / Double(score.count)) // 평균값을 구해서 반환
}

print(avg(score: 10, 20, 30, 40)) // 25.0
```