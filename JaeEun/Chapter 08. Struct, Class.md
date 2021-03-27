## 8.1 구조체와 클래스의 기본 개념

구조체와 클래스는 하나의 큰 코드 블록입니다. 이 안에 변수나 상수를 넣어 값을 저장할 수도 있고, 함수를 넣어서 기능을 정의할 수도 있습니다. 값을 저장할 수는 없지만 특정 기능을 실행할 수 있는 함수와, 값을 저장할 수 있지만 혼자서 특정 기능을 실행할 수는 없는 변수 상수의 특성을 모두 모아놓았다고 이해하면 편리합니다. 이런 특성 때문에 클래스와 구조체는 다른 종류의 객체에 의존하지 않고도 자체적으로 값을 저장하거나 함수적인 기능을 구현할 수 있습니다.

독자적인 프로세스 수행 능력 덕분에 매우 강력한 사용성을 지니는 이들 객체는 스위프트가 언어적으로 유연성을 가질 수 있게 해주는 근간을 이룹니다. 여기서 말하는 **유연성**이란 코드를 떼어서 다른 곳으로 옮기거나 새로운 코드를 추가하기가 쉽다는 뜻으로, **의존성**의 반대 개념입니다. 분리할 때 떼어 내어야 하는 부분이 많으면 분리가 힘들고 이 것을 의존성이 높다고 표현합니다.

구조체와 클래스 내에서 정의된 변수와 상수, 그리고 함수는 부르는 명징이 일반의 그것과는 다릅니다.

- **변수와 상수 → 프로퍼티(Properties), 속성 변수와** **상수**
- **펑션(Function) → 메소드(Method)**
- 프로퍼티와 메소드를 합해서 **구조체나 클래스의 멤버(Member)**

이는 변수와 상수, 함수가 구조체나 클래스 안에 들어가면서 특별한 성격을 갖기 때문입니다.

> **구조체 VS 클래스**

**공통점**

- **프로퍼티:** 변수나 상수를 사용하여 값을 저장하는 프로퍼티를 정의할 수 있다.
- **메소드:** 함수를 사용하여 기능을 제공하는 메소드를 정의할 수 있다.
- **서브스크립트:** 속성값에 접근할 수 있는 방법을 제공하는 서브스크립트를 정의할 수 있다.
- **초기화 블록:** 객체를 원하는 초기 상태로 설정해주는 초기화 블록을 정의할 수 있다.
- **확장:** 객체에 함수적 기능을 추가하는 확장(extends) 구문을 사용할 수 있다.
- **프로토콜:** 특정 형식의 함수적 표준을 제공하기 위한 프로토콜을 구현할 수 있다.

**클래스는 추가적으로 할 수 있는 기능**

- **상속:** 클래스의 특성을 다른 클래스에게 물려줄 수 있다.
- **타입 캐스팅:** 실행 시 컴파일러가 클래스 인스턴스의 타입을 미리 파악하고 검사할 수 있다.
- **소멸화 구문:** 인스턴스가 소멸되기 직전에 처리해야 할 구문을 미리 등록해 놓을 수 있다.
- **참조에 의한 전달:** 클래스 인스턴스가 전달될때에는 참조 형식으로 제공되며, 이때 참조가 가능한 개수는 제약이 없다.

### 8.1.1 정의 구문

```swift
// 구조체
struct 구조체_이름 {
  // 구조체 정의 내용이 들어갈 부분
}
// 클래스
class 클래스_이름 {
  // 클래스 정의 내용이 들어갈 부분
}
```

### 8.1.2 메소드와 프로퍼티

```swift
// 구조체
struct Resolution {
  var width = 0
  var height = 0
  
  func desc() -> String {
    return "Resolution 구조체"
  }
}
// 클래스
class VideoMode {
  var interlaced = false
  var frameRate = 0.0
  var name: String?

	var res = Resolution()
  
  func desc() -> String {
    return "VideoMode 클래스"
  }
}
```

### 8.1.3 인스턴스

```swift
// Resolution 구조체에 대한 인스턴스를 생성하고 상수 insRes에 할당
let insRes = Resolution()

// VideoMode 클래스에 대한 인스턴스를 생성하고 상수 insVMode에 할당
let insVMode = VideoMode()
let width = insRes.width
print("insRes 인스턴스의 width 값은 \\(width)입니다")
// insRes 인스턴스의 width 값은 0입니다
let vMode = VideoMode()
print("vMode 인스턴스의 width 값은 \\(vMode.res.width)입니다")
// vMode 인스턴스의 width 값은 0입니다
vMode.name = "Sample"
vMode.res.width = 1280 // 체인(Chain): 연속된 접근 지원
print("\\(vMode.name!) 인스턴스의 width 값은 \\(vMode.res.width)입니다")
// Sample 인스턴스의 width 값은 1280입니다
// 체인 방식을 지원하지 않을 경우
var res = vMode.res
res.width = 1280

// view.frame.size.width
// 체인 방식은 생산성 향상
```

### 8.1.4 초기화

```swift
// 초기화 구문 (Initializer)
// Resolution 인스턴스 생성
let insRes = Resolution()
// 내부적으로 프로퍼티를 초기화하지 않음
// 멤버와이즈 초기화 구문(Memberwise Initializer)
// width와 height를 매개변수로 하여 Resolution 인스턴스 생성
let defaultRes = Resolution(width: 1024, height: 768)
print("width: \\(defaultRes.width), height: \\(defaultRes.height)")
// 내부적으로 모든 프로퍼티를 초기화 함
```

### 8.1.5 구조체의 값 전달 방식 : 복사에 의한 전달

```swift
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd // 값 타입 (Value Type), 복사에 의한 전달

cinema.width = 2048

print("cinema 인스턴스의 width 값은 \\(cinema.width)입니다")
// cinema 인스턴스의 width 값은 2048입니다

print("hd 인스턴스의 width 값은 \\(hd.width)입니다")
// hd 인스턴스의 width 값은 1920입니다
hd.width = 4096 // Cannot assign to property: 'hd' is a 'let' constant
```

### 8.1.6 클래스의 값 전달 방식 : 참조에 의한 전달

```swift
let video = VideoMode()
video.name = "Original Video Instance"

print("video 인스턴스의 name 값은 \\(video.name!)입니다")
// video 인스턴스의 name 값은 Original Video Instance입니다
let dvd = video
dvd.name = "DVD Video Instance"

print("video 인스턴스의 name 값은 \\(video.name!)입니다")
// video 인스턴스의 name 값은 DVD Video Instance입니다
func changeName(v: VideoMode) {
  v.name = "Function Video Instance"
}

changeName(v: video)
print("video 인스턴스의 name 값은 \\(video.name!)입니다")
// video 인스턴스의 name 값은 Function Video Instance입니다
```

클래스 인스턴스를 참조하는 곳을 계속 검사하고, 참조하는 곳들이 모두 제거되면 더는 해당 인스턴스를 사용하지 않는다고 판단하여 메모리에서 해제해야 합니다.

ARC는 Auto Reference Counter의 약자로서 '지금 클래스 인스턴스를 참조하는 곳이 모두 몇 군데인지 자동으로 카운트해주는 객체'입니다.

이 객체는 인스턴스를 모니터링하면서 변수나 상수, 함수의 인자값으로 할당되면 카운트를 1 증가시키고 해당 변수나 상수들이 종료되면 카운트를 1 감소시키는 작업을 계속하면서 인스턴스의 참조 수를 계산하는데 이 과정에서 인스턴스의 참조 카운트가 0이 되면 메모리 해제 대상으로 간주하여 적절히 메모리에서 해제합니다.

> **동일 인스턴스인지 비교**

```swift
if video === dvd { // 동일 인스턴스가 아닌지 비교: ****!==
  print("video와 dvd는 동일한 VideoMode 인스턴스를 참조하고 있군요.")
} else {
  print("video와 dvd는 서로 다른 VideoMode 인스턴스를 참조하고 있군요.")
}

// video와 dvd는 동일한 VideoMode 인스턴스를 참조하고 있군요.
let vs = VideoMode()
let ds = VideoMode()

if vs === ds {
  print("vs와 ds는 동일한 VideoMode 인스턴스를 참조하고 있군요.")
} else {
  print("vs와 ds는 서로 다른 VideoMode 인스턴스를 참조하고 있군요.")
}

// vs와 ds는 서로 다른 VideoMode 인스턴스를 참조하고 있군요.
```

일반적인 지침에 따르면 다음 조건에 하나이상 해당하는 경우라면 구조체를 사용하는 것이 좋습니다.

1. 서로 연관된 몇 개의 기본 데이터 타입들을 캡슐화하여 묶는 것이 목적일 때
2. 캡슐화된 데이터에 상속이 필요하지 않을 때
3. 캡슐화된 데이터를 전달하거나 할당하는 과정에서 참조 방식보다는 값이 복사되는 것이 합리적일 때
4. 캡슐화된 원본 데이터를 보존해야 할 때

## 8.2 프로퍼티

1. 저장 프로퍼티
   - 입력된 값을 저장하거나 저장된 값을 제공하는 역할
   - 상수 및 변수를 사용해서 정의 기능
   - 클래스와 구조체에서는 사용이 가능하지만, 열거형에서는 사용할 수 없음
2. 연상 프로퍼티
   - 특정 연산을 통해 값을 만들어 제공하는 역할
   - 변수만 사용해서 정의 가능
   - 클래스, 구조체, 열거형 모두에서 사용 가능

저장 프로퍼티와 연산프로퍼티는 대체로 클래스나 구조체를 바탕으로 만들어진 개별 인스턴스에 소속되어 값을 저장하거나 연산 처리하는 역할을 합니다. 따라서 프로퍼티를 사용하려면 인스턴스가 필요합니다. 인스턴스를 생성한 다음 이 인스턴스를 통해 프로퍼티를 참조하거나 값을 할당해야 하죠. 이렇게 인스턴스에 소속되는 프로퍼티를 **인스턴스 프로퍼티(Instance Properties)**라고 합니다.

예외적으로 일부 프로퍼티는 클래스와 구조체 자체에 소속되어 값을 가지기도 합니다. 이런 프로퍼티들을 **타입 프로퍼티(Type Properties)**라고 합니다. 타입 프로퍼티는 인스턴스를 생성하지 않아도 사용할 수 있습니다.

> **프로퍼티의 분류**

- **역할에 따른 분류:** 저장 프로퍼티, 연산 프로퍼티
- **소속에 따른 분류:** 인스턴스 프로퍼티, 타입 프로퍼티

프로퍼티의 값을 모니터링하기 위해 **프로퍼티 옵저버(Property Observer)**를 정의하여, 사용자가 정의한 특정 액션과 반응을 하도록 처리할 수 있습니다. 프로퍼티 옵저버는 우리가 직접 정의한 저장 프로퍼티에 추가할 수 있으며 슈퍼 클래스로부터 상속받은 서브 클래스에서도 추가할 수 있습니다.

### 8.2.1 저장 프로퍼티

```swift
class User { // Class 'User' has no initializers
  var name: String
}
```

> 해결책

```swift
class User {
  var name: String
  
  init() {
    self.name = ""
  }
}

// 초기화 구문을 작성하고, 그 안에서 초기값을 할당해 줍니다.
class User {
  var name: String?
}

class User {
  var name: String!
}

// 프로퍼티를 옵셔널 타입으로 바꿔 줍니다.
class User {
  var name: String = ""
}

// 프로퍼티에 초기값을 할당해 줍니다.
```

> **저장 프로퍼티의 분류**

- var 키워드로 정의되는 변수형 저장 프로퍼티 (멤버 변수)
- let 키워드로 정의되는 상수형 저장 프로퍼티 (멤버 상수)

> **구조체에서 저장 프로퍼티**

```swift
// 고정 길이 범위 구조체
struct FixedLengthRange {
  var startValue: Int // 시작값
  let length: Int // 값의 범위
}

// 가변 길이 범위 구조체
struct FlexibleLengthRange {
  let startValue: Int // 시작값
  var length: Int // 값의 범위
}
// 아래 구조체 인스턴스는 정수값 0, 1, 2를 의미합니다.
var rangeOfFixedIntegers = FixedLengthRange(startValue: 0, length: 3)

// 아래처럼 시작값을 변경하면 객체 인스턴스는 정수값 4, 5, 6을 의미하게 됩니다.
rangeOfFixedIntegers.startValue = 4

// 아래 구조체 인스턴스는 정수값 0, 1, 2를 의미합니다.
var rangeOfFlexibleIntegers = FlexibleLengthRange(startValue: 0, length: 3)

// 아래처럼 범위값을 변경하면 객체 인스턴스는 정수값 0, 1, 2, 3, 4, 5를 의미하게 됩니다.
rangeOfFlexibleIntegers.length = 5
// 변수에 할당된 구조체 인스턴스라면
var variablesOfInstance = FixedLengthRange(startValue: 3, length: 4)

// 아래와 같이 저장 프로퍼티를 수정할 수 있음
variablesOfInstance.startValue = 0 // (O)

// 반면, 상수에 할당된 구조체 인스턴스라면
let constantsOfInstance = FixedLengthRange(startValue: 3, length: 4)

// 아래와 같이 저장 프로퍼티를 수정하려고 하면 오류가 발생함
constantsOfInstance.startValue = 0 // (X) 
// Cannot assign to property: 'constantsOfInstance' is a 'let' constant
```

구조체 프로퍼티의 값은 저장 프로퍼티와 인스턴스가 모두 변수일 경우에만 변경 가능

> **지연 저장 프로퍼티**

```swift
class OnCreate {
  init() {
    print("OnCreate")
  }
}

class LazyTest {
  var base = 0
  lazy var late = OnCreate()
  
  init() {
    print("Lazy Test")
  }
}
let lz = LazyTest()
// "Lazy Test"
lz.late
// "OnCreate"
```

> **클로저를 이용한 저장 프로퍼티 초기화**

```swift
class PropertyInit {
  
  // 저장 프로퍼티 - 인스턴스 생성 시 최초 한 번만 실행
  var value01: String! = {
    print("value01 execute")
    return "value01"
  }()

  // 저장 프로퍼티 - 인스턴스 생성 시 최초 한 번만 실행
  var value02: String! = {
    print("value02 execute")
    return "value02"
  }()

	// 프로퍼티 참조 시에 최초 한 번만 실행
  lazy var value03: String! = {
    print("value03 execute")
    return "value03"
  }()
}
let s = PropertyInit()
// value01 execute
// value02 execute
s.value01
s.value02

// 실행 결과 없음
// 저장 프로퍼티에 정의된 클로저 구문이 더 이상 재실행되지 않기 때문입니다.
s.value03

// value03 execute
// 참조되는 시점에 초기화되기 때문에 메모리 낭비를 줄일 수 있습니다.
```

### 8.2.2 연산 프로퍼티

다른 프로퍼티의 값을 연산 처리하여 값을 제공합니다. (class/struct/enum)

> **나이 계산**

```swift
struct UserInfo {
  // 저장 프로퍼티: 태어난 연도
  var birth: Int!
  
  // 연산 프로퍼티: 올해가 몇년도인지 계산
  var thisYear: Int! {
    get {
      let df = DateFormatter()
      df.dateFormat = "yyyy"
      return Int(df.string(from: Date()))
    }
  }
  
  // 연산 프로퍼티: 올해 - 태어난 연도 + 1
  var age: Int {
    get {
      return (self.thisYear - self.birth + 1)
    }
  }
}
let info = UserInfo(birth: 1980)
print(info.age)

// 42
```

> **사각형의 중심 좌표 계산**

```swift
struct Rect {
  // 사각형이 위치한 기준 좌표(좌측 상단 기준)
  var originX: Double = 0.0, originY: Double = 0.0
  
  // 가로 세로 길이
  var sizeWidth: Double = 0.0, sizeHeight: Double = 0.0
  
  // 사각형의 X 좌표 중심
  var centerX: Double {
    get {
      return originX + (sizeWidth / 2)
    }
    set(newCenterX) {
      originX = newCenterX - (sizeWidth / 2)
    }
  }
  
  // 사각형의 Y 좌표 중심
  var centerY: Double {
    get {
      return originY + (sizeHeight / 2)
    }
    set(newCenterY) {
      originY = newCenterY - (sizeHeight / 2)
    }
  }
}
var square = Rect(originX: 0.0, originY: 0.0, sizeWidth: 10.0, sizeHeight: 10.0)
print("square.centerX = \\(square.centerX), square.centerY = \\(square.centerY)")

// square.centerX = 5.0, square.centerY = 5.0
```

### 8.2.3 프로퍼티 옵저버

프로퍼티 값이 변경되면 반응합니다.

- willSet: 프로퍼티의 값이 변경되기 직전에 호출되는 옵저버
- didSet: 프로퍼티의 값이 변경된 직후 호출되는 옵저버

```swift
struct Job {
  var income: Int = 0 {
    willSet {
      print("이번 달 월급은 \\(income)원에서 \\(newValue)원으로 변경될 예정입니다.")
    }
    didSet {
      if income > oldValue {
        print("월급이 \\(income)원 증가하셨네요. 소득세가 상향조정될 예정입니다.")
      } else {
        print("저런 월급이 삭감되었군요. 그래도 소득세는 깍아드리지 않아요. 알죠?")
      }
    }
  }
}
var job = Job()
job.income = 1000
// 이번 달 월급은 0원에서 1000원으로 변경될 예정입니다.
// 월급이 1000원 증가하셨네요. 소득세가 상향조정될 예정입니다.
job.income = 500
//이번 달 월급은 1000원에서 500원으로 변경될 예정입니다.
//저런 월급이 삭감되었군요. 그래도 소득세는 깍아드리지 않아요. 알죠?
```

### 8.2.4 타입 프로퍼티

인스턴스에 관련된 값을 다루어야 할 때, 인스턴스를 생성하지 않고 클래스나 구조체 자체에 값을 저장하는 것

```swift
struct Foo {
  // 타입 저장 프로퍼티
  static var sFoo = "구조체 타입 프로퍼티값"
  
  // 타입 연산 프로퍼티
  static var cFoo: Int {
    return 1
  }
}

class Boo {
  // 타입 저장 프로퍼티
  static var sFoo = "클래스 타입 프로퍼티값"
  
  // 타입 연산 프로퍼티
  static var cFoo: Int {
    return 10
  }
  
  // 재정의가 가능한 타입 연산 프로퍼티
  class var oFoo: Int {
    return 100
  }
}
print(Foo.sFoo)
// 구조체 타입 프로퍼티값

Foo.sFoo = "새로운 값"
print(Foo.sFoo)
// 새로운 값

print(Boo.sFoo)
// 클래스 타입 프로퍼티값

print(Boo.cFoo)
// 10
```

## 8.3 메소드

클래스나 구조체, 열거형과 같은 객체 내에서 함수가 선언될 경우 이를 메소드라고 통칭합니다.

즉, 메소드는 특정 타입의 객체 내부에서 사용하는 함수.

함수와 메소드의 차이점은 구현 목적이 가지는 독립성과 연관성에 있습니다. 함수는 독립적인 기능을 구현하기 위해 만들어지는 것이지만, 메소드는 하나의 객체 내에 정의된 다른 메소드들과 서로 협력하여 함수적인 기능을 수행합니다.

**구분**

- **인스턴스 메소드(Instance Method):** 객체의 인스턴스를 생성해야 사용할 수 있는 메소드.
- **타입 메소드(Type Method):** 객체의 인스턴스를 생성하지 않아도 사용할 수 있는 메소드.

인스턴스 메소드는 주어진 객체의 인스턴스와 함께 특수한 임무나 함수적인 기능을 수행하도록 캡슐화된 메소드.

타입 메소드는 객체 타입 자체에 관련된 메소드.

### 8.3.1 인스턴스 메소드

클래스, 구조체 또는 열거형과 같은 객체 타입이 만들어내는 인스턴스에 소속된 함수.