일반적으로 프로그래밍 과정에서 작성하는 소스 코드를 **구문(Statement)** 이라고 합니다.

구문은 크게 **단순구문**과 **흐름 제어 구문 두 가지**로 나눌 수 있습니다.

> 단순 구문

식이나 값 표현, 각종 객체의 선언이나 정의 등에 사용 되는 구문.

ex) 변수나 상수 선언, 연산 처리, 구조체, 클래스, 열거형 정의

> 흐름 제어 구문

실행 과정에서 실행 흐름을 능동적으로 제어하기 위한 목적으로 사용 되는 구문.

순차적으로 실행되어야 할 일부 실행 과정을 건너뛰거나 되돌아오도록 흐름을 제어하며 경우에 따라서는 반복적으로 실행 되도록 제어 하기도 함.

- 반복문 (Loop Statements)
- 조건문 (Conditional Statements)
- 제어 전달문 (Control Transfer Statements)

## 4.1 반복문

주어진 조건에 의해 특정 코드 블록을 반복적으로 실행할 수 있게 해주는 구문.

프로그래밍에서 코드 블록의 반복을 **루프(Loop)**,  반복되는 횟수를 **루프 횟수**라고 부름.

- **for 반복문** - 횟수에 의한 반복.

- While 반복문

   \- 조건에 의한 반복.

  - **while 구문** - 매번 루프를 시작할 때 조건식을 평가하여 다음 루프 실행 여부를 결정.
  - **repeat ~ while 구문** - 루프를 완료할 때마다 조건을 평가하여 다음 루프 실행 여부를 결정.

### 4.1.1 for~in 구문

```swift
for <루프 상수> in <순회 대상> {
		<실행할 구문>
}
// 중괄호 { }로 둘러싸인 영역 -> **코드 블록 (Code Block)**
```

> 순회 대상으로 사용할 수 있는 데이터 타입

- 배열 (Array)
- 딕셔너리 (Dictionary)
- 집합 (Set)
- 범위 데이터
- 문자열 (String)

```swift
// 닫힌 범위 연산자로 작성된 범위데이터 1...5를 순서대로 순회
for row in 1...5 {
    print(row)
}

// 구구단 2단을 출력하는 예제
for row in 1...9 {
		print("2 X \\(row) = \\(row * 2)")
}

// 태어난 연도
for year in 1940...2017 {
		print("\\(year)년도")
}

print("\\(year)년도") - error !
// 루프 상수는 for ~ in 구문의 실행 블록 내부에서만 사용할 수 있습니다.

// 문자열의 문자 순회
let lang: String = "swift"
for char in lang {
    print(char)
}

// 루프 상수의 생략
let size = 5
let padChar = "0"
var keyword = "3"
for _ in 1...size {
		keyword = padChar + keyword
}
print(keyword)
// 000003

// for~in 구문의 중첩
// 다중루프, 이중루프
// 구구단
for i in 1...9 {
    for j in 1...9 {
        print("\\(i) X \\(j) = \\(i * j)")
    }
}
```

### 4.1.2 while 구문

조건식의 결과가 false가 될 때까지 실행 구문을 계속 반복.

조건을 만족하는 동안은 계속 실행.

- 실행 횟수가 명확하지 않을 때
- 직접 실행해보기 전까지는 실행 횟수를 결코 알 수 없을 때
- 실행 횟수를 기반으로 할 수 없는 조건일 때

```swift
while <조건식> {
		<실행할 구문>
}
var n = 2

while n < 1000 {
		n = n * 2
}

print("n = \\(n)")

// n = 1024
// 조건식에서 false가 반환되면 순회 종료.
// n을 계속해서 2배씩 증가시키다가 1000보다 커지는 순간 루프를 중지하는 예.
// n에 입력될 값을 미리 알 수 없는 상태.
// 반복 실행할 기준이 횟수가 아니라 조건.
// n의 값이 1000보다 작을 조건.
```

### 4.1.3 repeat~while 구문

다른 언어에서는 do~while 구문에 해당.

```swift
repeat {
		<실행할 구문>
}
while <조건식>
```

while 구문은 조건식을 먼저 평가하여 false가 반환되면 실행 블록을 아예 수행하지 않지만

repeat~while 구문은 실행 블록의 수행을 최소 한 번은 보장.

```swift
var n = 1024

repeat {
		n = n * 2
}
while n < 1000

print("n = \\(n)")

// n = 2048
```

## 4.2 조건문

다른 말로는 **분기문(Branch Statements)**.

하나 또는 그 이상의 조건 값에 따라 특정 구문을 분기하는 역할.

- if
- guard
- switch

### 4.2.1 if 구문

```swift
if <조건식> {
		<실행할 구문>
}
```

조건이 참(true)일 때만 코드 블록 내부의 구문을 실행.

```swift
let adult = 19
let age = 15

if age < adult {
		print("당신은 미성년자!")
}

// 당신은 미성년자!
```

> if~else

```swift
if <조건식> {
		<조건이 참일 때 실행할 구문>
} else {
		<조건이 거짓일 때 실행할 구문>
}
let adult = 19
let age = 21

if age < adult {
		print("당신은 미성년자!")
}
if age >= adult { // -> else
		print("당신은 성년자!")
}

// 당신은 성년자!
```

> if 구문의 중첩

```swift
let adult = 19
let age = 21
let gender = "M"

if age < adult {
	if gender == "M" {
		print("당신은 남자 미성년자입니다.")
	} else {
		print("당신은 여자 미성년자입니다.")
	}
} else {
	...
}
```

> if~else if

조건이 여러 개일 경우.

다중 조건.

```swift
if <조건1> {
		<조건1이 참일 때 실행할 구문>
} else if <조건2> {
		<조건2가 참일 때 실행할 구문>
} else {
		<앞의 조건들을 모두 만족하지 않을 때 실행할 구문>
}
let gender = "M"

if gender == "M" {
	print("남자")
} else if gender == "F" {
	print("여자")
} else {
	print("남자와 여자 어느 쪽에도 속하지 않습니다.")
}
```

### 4.2.2 guard 구문

if 구문과 마찬가지로 주어진 표현식의 결과가 참인지 거짓인지에 따라 구문의 실행 여부를 결정짓는 방식.

else 블록이 필수.

```swift
guard <조건식 또는 표현식> else {
		<조건식 또는 표현식의 결과가 false일 때 실행될 코드>
}
func divide(base: Int) {

	guard base != 0 else {
		print("연산할 수 없습니다.")
		return
	}

	let result = 100 / base
	print(result)
}
func divide(base: Int) {

	if base == 0 {
		print("연산할 수 없습니다.")
		return
	}

	let result = 100 / base
	print(result)
}
```

코드의 깊이가 깊어지지 않음.

### 4.2.3 #available 구문

```swift
if #available(iOS 10.0, *) {
  UIApplication.shared.open(url, options: [:], completionHandler: nil)
} else {
  UIApplication.shared.openURL(url)
}
```

### 4.2.4 switch 구문

C나 Java에서는 비교 패턴이 일치할 경우 우선 실행 구문을 처리한 다음, 나머지 case에 대한 비교를 계속 진행.

추가로 일치하는 패텅이 있다면 이를 모두 실행, 마지막 case를 비교한 후에야 분기문 종료.

swift는 일치하는 비교 패턴이 있을 경우 해당 블록의 실행 코드를 처리하고 더 이상의 비교 없이 전체 분기문 종료.

설사 일치하는 비교 패턴이 여러 개 있더라도 맨 처음 일치하는 case 구문 하나만 실행.

다른 언어에서 switch 구문의 각 case 키워드 블록마다 추가해야 하는 break 구문을 생략할 수 있는 이유.

```swift
let val = 2

switch val {
	case 1:
		print("일치하는 값은 1입니다.")
	case 2:
		print("일치하는 값은 2입니다.")
	case 2:
		print("일치하는 값 2가 더 있습니다.") // warning
	default:
		print("어느 패턴과도 일치하지 않았습니다.")
}

// swift
// 일치하는 값은 2입니다.

// 다른 언어
// 일치하는 값은 2입니다.
// 일치하는 값 2가 더 있습니다.
// 어느 패턴과도 일치하지 않았습니다.
```

> Fall Through

```swift
let sampleChar: Character = "a"

switch sampleChar {
case "a":
  fallthrough // 암시적인 fallthrough를 지원하지 않음.
case "A":
  print("글자는 A 입니다.")
default:
  print("일치하는 글자가 없습니다.")
}

switch sampleChar {
case "a", "A": // 하나의 case에 다수의 비교 패턴을 넣어 처리할 수 있음.
  print("글자는 A 입니다.")
default:
  print("일치하는 글자가 없습니다.")
}
```

> switch 구문의 특성

반드시 default 구문을 추가해야 하지만 모든 패턴을 매칭 시킬 수 있는 구문이 존재하는 경우 생략할 수 있다.