프로토콜(Protocol)은 클래스나 구조체가 어떤 기준을 만족하거나 또한 특수한 목적을 달성하기 위해 구현해야 하는 메소드와 프로퍼티의 목록입니다. 다른 개체지향 언어에서 사용되는 인터페이스와 거의 비슷한 개념입니다.

iOS는 특정 컨트롤에서 발생하는 각종 이벤트를 효율적으로 관리하기 위해 대리자(delegate)를 지정하여 이벤트 처리를 위임하고, 실제로 이벤트가 발생하면 위임된 대리자가 콜백 메소드를 호출해주는 델리게이트 패턴(Delegate Pattern)을 많이 사용하는데, 이 패턴을 구현하기 위해 이용되는 것이 프로토콜입니다.

프로토콜에는 구현해야 할 메소드의 명세가 작성되어 있어서 프로토콜만 보더라도 무엇을 어떻게 호출해야 하는지에 대한 것을 알 수 있습니다. 델리게이트 패턴에서 이벤트에 대한 위임 처리를 하기 위해서는 특정 프로토콜을 구현해야 합니다.

델리게이트 패턴이 프로토콜을 활용하는 아주 좋은 사례이지만, 스위프트에서 프로토콜이 사용되는 영역은 이보다 더 넓습니다. 구조체나 클래스를 구현하는 과정에서도 프로토콜을 사용하여 구현할 메소드의 형식을 공통으로 정의할 수 있으며, 인터페이스의 역할이 대부분 그렇기는 하지만 프로토콜을 구현한 객체의 메소드나 속성을 은닉하고 프로토콜에서 선언된 명세의 내용만 제공하는 기능을 하기도 합니다.

이같은 프로토콜의 역할을 한 마디로 설명하자면 특정 기능이나 속성에 대한 설계도입니다. 프로토콜은 구체적인 내용이 없는 프로퍼티나 메소드의 단순한 선언 형태로 구성되며, 구체적인 내용은 이 프로토콜을 이용하는 객체에서 담당합니다. 사실 어떤 내용을 정의하는지 프로토콜에서 관심을 갖지 않습니다. 중요한 것은 형식일 뿐이죠.

이때 프로토코에 선언된 프로포티나 메소드의 형식을 프로토콜의 '명세'라고 부르고, 이 명세에서 맞추어 실질적인 내용을 작성하는 것을 '프로토콜을 구현(Implement)한다'하고 합니다. 프로토코의 구현은 프로토콜을 상속받은 구조체나 클래스에서 담당합니다. 특정 객체가 프로토콜을 구현했다면 컴파일러는 기본적으로 프로토콜에 선언된 기능과 프로퍼티가 모두 작성된 것으로 간주합니다.

## 10.1 프로토콜의 정의

> 프로토콜 정의

```swift
protocol <프로토콜명> {
	<구현해야 할 프로퍼티 명세 1>
	<구현해야 할 프로퍼티 명세 2>
	<구현해야 할 프로퍼티 명세 3>
	...
}
```

프로토콜을 구현할 수 있는 구현체

1. 구조체
2. 클래스
3. 열거형
4. 익스텐션

> 프로토콜 구현

```swift
struct/class/enum/extension 객체명: 구현할 프로토콜명 {

}
```

### 10.1.1 프로토콜 프로퍼티

프로토콜에 선언되는 프로퍼티에는 초기값을 할당할 수 없습니다.

연산 프로퍼티인지 저장 프로퍼티인지도 구분하지 않습니다.

프로퍼티의 종류, 이름, 변수/상수 구분, 타입, 읽기 전용인지 읽고 쓰기가 가능한지에 대해서만 정의할 뿐입니다.

> SomePropertyProtocol 프로토콜 정의

```swift
protocol SomePropertyProtocol {
	var name: String { get set } // 읽고 쓰기
	var description: String { get } // 읽기 전용
}
```

- 연산 프로퍼티: get set / get
- 저장 프로퍼티: get set

> SomePropertyProtocol 프로토콜을 구현한 구조체

```swift
struct RubyMember: SomePropertyProtocol {
	var name = "홍길동"
	var description: String {
		return "Name: \\(self.name)"
	}
}
```

### 10.1.2 프로토콜 메소드

> SomeMethodProtocol 프로토콜 정의

```swift
protocol SomeMethodProtocol {
	func execute(cmd: String)
	func showPort(p: Int) -> String
}
```

- 반드시 매개변수를 정의해야하는 것은 아닙니다.
- 프로토콜 메소드가 클래스 메소드와 다른 점은 메소드의 선언 뒤에 중괄호 블록이 없다는 점입니다. 실제 실행할 내용을 작성하지 않기 때문입니다.

> SomeMethodProtocol 프로토콜을 구현한 구조체

```swift
struct RubyService: SomeMethodProtocol {
	func execute(cmd: String) {
		if cmd == "start" {
			print("실행합니다.")
		}
	}

	func showPort(p: Int) -> String {
		return "Port: \\(p)"
	}
}
```

- 프로토콜에 선언된 메소드 중에서 일부를 구현하지 않고 누락하면 오류가 발생합니다.
- 반대로 프로토콜에 정의되어 있지 않더라도 구현체에 임의로 메소드를 추가하는 것은 아무런 문제가 되지 않습니다.
- RubyService 구조체에 정의된 매개변수명이 프로토콜에 선언된 메소드의 매개변수명과 완전히 일치해야 합니다.

> 외부 매개변수명이 포함된 프로토콜 메소드와 이를 구현한 예제

```swift
protocol NewMethodProtocol {
	mutating func execute(cmd command: String, desc: String)
  func showPort(p: Int, memo desc: String) -> String
}
struct RubyNewService: NewMethodProtocol {
  func execute(cmd comm: String, desc d: String) {
    if comm == "start" {
      print("\\(d)를 실행합니다.")
    }
  }

  func showPort(p port: Int, memo: String) -> String {
    return "Port: \\(port), Memo: \\(memo)"
  }
}
```

일치시켜야 하는 매개변수명은 외부로 드러나는 매개변수명에 국한됩니다. 다시 말해 외부 매개변수명은 프로토콜을 그대로 따라야하지만 내부 매개변수명은 임의로 바꾸어 사용해도 된다는 말입니다.

> 프로토콜에서의 mutating, static 사용

구조체 내의 메소드가 프로퍼티를 변경하는 경우, 메소드 앞에 반드시 mutating 키워드를 붙여 이 메소드가 프로퍼티 값을 수정하는 메소드임을 표시하도록 강제하고 있습니다.

이때 그 메소드가 만약 프로토콜에서 선언된 메소드라면 mutating 키워드를 붙이기 위해서는 반드시 프로토콜에 mutating 키워드가 추가되어 있어야 합니다.

클래스와 같은 참조타입은 mutating 키워드를 붙이지 않아도 메소드 내에서 마음대로 프로퍼티를 수정할 수 있지만, 구조체나 열거형은 프로토콜의 메소드에 mutating 키워드가 추가되어 있지 않을 경우 프로퍼티의 값을 변경할 수 없습니다. 프로토콜에 선언되지 않은 mutating 키워드를 임의로 구현할 수 없기 때문입니다. 만약 억지로 mutating 키워드를 붙여서 메소드를 구현하면 컴파일러는 이를 프로토콜을 구현한 것으로 인정하지 않으므로, 구현 대상이 누락되어있다는 오류가 발생합니다.

이런 면에서, 프로토콜은 자신을 구현하는 구조체가 마음대로 프로퍼티를 수정하지 못하도록 통제할 수 있는 권한을 가지고 있습니다. mutating 키워드를 허용하지 않으면, 이를 구현하는 구조체는 메소드 내에서 프로퍼티 값을 수정할 수 없기 때문입니다. 일잔적으로 프ㄹ프로토콜에서 메소드 선언에 mutating 키워드가 붙지 않는 것은 다음 두 가지 중 하나로 해석할 수 있습니다.

1. 구조체나 열거형 등 값 타입의 객체에서 내부 프로퍼티의 값을 변경하기를 원치 않을 때
2. 주로 클래스를 대상으로 간주하고 작성된 프로토콜일 때

프로토콜에서 mutating 키워드를 붙일 때에는 메소드를 표시하는 func 키워드 앞에 mutating을 추가하기만 하면 됩니다. 프로토콜 메소드에 mutating 키워드가 있으면 이를 구현하는 구조체나 열거형에서도 mutating 키워드를 사용할 수 있습니다.

```swift
protocol MService {
	mutating func execute(cmd: String)
	func showPort(p: Int) -> String
}
struct RubyMService: MService {
	var paramCommand: String?

	// 프로퍼티를 변경하기 때문에 mutating 키워드를 사용
	mutating func execute(cmd: String) {
		self.paramCommand = cmd
		if cmd == "start" {
			print("실행합니다.")
		}
	}

	func showPort(p: Int) -> String {
		return "Port: \\(p), now command: \\(self.paramCommand!)"
	}
}
struct RubyMService2: MService {
	var paramCommand: String?

	// 프로퍼티를 변경하지 않기 때문에 프로토콜 쪽에 mutating 키워드가 추가되어 있도 생략 가능
	func execute(cmd: String) {
		if cmd == "start" {
			print("실행합니다.")
		}
	}

	func showPort(p: Int) -> String {
		return "Port: \\(p), now command: \\(self.paramCommand!)"
	}
}
```

이처럼 프로토콜에서 mutating 처리되지 않은 메소드를 구조체에서 임의로 mutating 처리하는 것은 프로토콜의 구현 명세를 위반하는 오류이지만, 그 반대의 경우는 허용됩니다. 이는 열거형에서도 동일합니다.

클래스는 참조 타입의 객체이므로 메소드 내부에서 프로퍼티를 수정하더라도 mutating 키워드를 붙일 필요가 없습니다. mutating 키워드가 붙어있는 프로토콜 메소드를 구현할 때도 클래스에서는 프로퍼티의 수정 여부와 관계없이 mutating 키워드를 사용하지 않습니다.

타입 메소드나 타입 프로퍼티도 프로토콜에 정의할 수 있습니다. 프로토콜의 각 선언 앞에 static 키워드를 붙이면 됩니다. 클래스에서 타입 메소드를 선언할 때 사용할 수 있는 또 다른 키워드인 class는 프로토콜에서 사용할 수 없습니다. 프로토콜은 구조체나 열거형, 그리고 클래스에 모두 사용할 수 있는 형식으로 정의되어야 하기 때문입니다.

하지만 프로토콜에서 static 키워드로 선언되어있더라도 실제 클래스에서 구현할 때는 필요에 따라 static이나 class 키워드를 선택하여 사용할 수 있습니다. 물론 구조체나 열거형에서 구현할 때는 선택의 여지 없이 static 키워드를 붙여야 합니다.

```swift
protocol SomeTypeProperty {
	static var defaultValue : String { get set }
	static func getDefaultValue() -> String
}
struct TypeStruct: SomeTypeProperty {
	static var defaultValue = "default"

	static func getDefaultValue() -> String {
		return defaultValue
	}
}
class ValueObject: SomeTypeProperty {
	static var defaultValue = "default"

	class func getDefaultValue() -> String {
		return defaultValue
	}
}
```

프로토콜이 class 가 아닌 static 키워드를 사용하는 것에 특별한 이유는 없습니다. 단지 class 키워드가 클래스에 국한된 키워드인 반면 static 키워드는 구조체와 클래스, 그리고 열거형 등의 객체가 공통으로 사용하는 키워드이기 때문입니다. 따라서 클래스에서 프로토콜을 구현할 때 필요에 따라 static 키워드 대신 class 키워드를 사용하는 것은 프로토콜 명세를 올바르게 구현하는 것으로 간주됩니다.

### 10.1.3 프로토콜과 초기화 메소드

> SomeInitProtocol 프로토콜의 정의

```swift
protocol SomeInitProtocol {
	init()
	init(cmd: String)
}
```

> SomeInitProtocol 프로토콜을 구현한 구조체

```swift
struct SInit: SomeInitProtocol {
	var cmd: String

	init() {
		self.cmd = "start"
	}

	init(cmd: String) {
		self.cmd = cmd
	}
}
```

> SomeInitProtocol 프로토콜을 구현한 클래스

```swift
class CInit: SomeInitProtocol {
	var cmd: String

	required init() {
		self.cmd = "start"
	}

	required init(cmd: String) {
		self.cmd = cmd
	}
}
```

1. 구현되는 초기화 메소드의 이름과 매개변수명은 프로토콜의 명세에 작성된 것과 완전히 일치해야 함
2. 프로토콜 명세에 선언된 초기화 메소드는 그것이 기본 제공되는 초기화 메소드 일지라도 직접 구현해야 함
3. 클래스에서 초기화 메소드를 구현할 때는 required 키워드를 붙여야 함

클래스는 상속과 프로토콜 구현이 동시에 가능한 객체입니다. 즉, 부모 클래스로부터 초기화 메소드, 메소드와 프로퍼티 등을 상속받으면서 동시에 프로토콜에 정의된 초기화 메소드, 프로퍼티나 메소드를 구현할 수 있다는 뜻입니다. 이때 부모 클래소로부터 물려받은 초기화 구문과 프로토콜로부터 구현해야 하는 초기화 메소드가 충돌하는 경우가 종종 생깁니다.

상속을 통해 초기화 메소드를 물려받았다 할지라도 구현해야 할 프로토콜 명세에 동일한 초기화 메소드가 선언되어 있다면 이를 다시 구현해야 합니다. 이는 곧 부모 클래스의 관점에서 볼 때 상속받은 초기화 메소드를 오버라이드하는 셈입니다. 이때에는 초기화 메소드에 required 키워드와 override 키워드를 모두 붙여주어야 합니다.

```swift
// init 메소드를 가지는 프로토콜
protocol Init {
	init()
}

// init() 메소드를 가지는 부모 클래스
class Parent {
	init() {
	}
}

// 부모클래스의 init() + 프로토콜의 init()
class Child: Parent, Init {
	// 두 개의 키워드를 붙이는 순서는 관계 없습니다.
	override required init() {

	}
}
```

Child 클래스는 Parent 클래스와 Init 프로토콜로 부터 동시에 초기화 구문 init()을 전달 받습니다. 먼저 프로토콜 쪽을 봅시다. Child 클래스가 프로토콜을 구현하기 위해서는 required 키워드가 추가된 init() 메소드를 작성해야합니다. 이 과정이 끝나면 클래스 Child는 다음과 같은 형태로 만들어집니다.

```swift
class Child: Parent, Init {
	required init() {

	}
}
```

부모 클래스인 Parent 입장에서 보면 자신이 물려준 init() 메소드가 Child 클래스에서 새롭게 정의된 셈입니다. 이는 부모 클래스에 정의된 것과 동일한 형식으로 재정의된 것이므로 override 키워드를 붙여주어야 합니다.

required 키워드는 초기화 메소드에만 붙습니다. 일반 메소드나 연산 프로퍼티에는 붙이지 않습니다.

```swift
protocol Init {
	func getValue()
}

class Parent {
	func getValue() {

	}
}

class Child: Parent, Init {
	override func getValue() {

	}
}
```

단일 상속만 허용되는 클래스의 상속 개념과 달리, 객체에서 구현할 수 있는 프로토콜의 개수에는 제한이 없습니다. 두 개 이상의 프로토콜을 구현하고자 할 때는 구현할 프로토콜들을 쉼표로 구분하여 나란히 작성해 줍니다. 이 때 프로토콜의 선언 순서는 상관 없지만, 각 프로토콜에서 구현해야 하는 내용들은 빠짐없이 모두 구현되어야 합니다.

> NewMethodProtocol과 SomeInitProtocol 프로토콜 모두를 구현한 구조체

```swift
struct MultiImplement: NewMethodProtocol, SomeInitProtocol {
  var cmd: String

  init() {
    self.cmd = "defalut"
  }

  init(cmd: String) {
    self.cmd = cmd
  }
  
  mutating func execute(cmd: String, desc d: String) {
    self.cmd = cmd
    if cmd == "start" {
      print("\\(d)를 실행합니다.")
    }
  }

  func showPort(p port: Int, memo: String) -> String {
    return "Port: \\(port), Memo: \\(memo)"
  }
}
```

> 부모 클래스가 있다면 반드시 프로토콜 선언보다 앞서 작성

```swift
class BaseObject {
  var name: String = "홍길동"
}
class MultiImplWithInherit: BaseObject, NewMethodProtocol, SomeInitProtocol {
	required override init() {
    
  }

  func execute(cmd command: String, desc: String) {
    
  }
  
  func showPort(p: Int, memo desc: String) -> String {
    
  }
  
  required init(cmd: String) {
    
  }
}
```

## 10.2 타입으로서의 프로토콜

프로토콜은 그 자체로는 아무런 기능을 구현하지 못하므로 인스턴스를 만들수 없을 뿐더러 프로토콜만으로 할 수 있는 일도 거의 없습니다. 하지만 프로토콜은 특별히 기능을 부여하지 않더라도 코드 내에서 자료형으로 사용하기에는 부족함이 없는 객체입니다. 이 때문에 때로는 타입으로서 중요한 역할을 하기도 합니다. 우리는 다음과 같은 여러 상황에서 프로토콜을 사용할 수 있습니다. 이는 마치 프로토콜을 상위 클래스 타입으로 간주하여 상요하는 것과 유사합니다.

- 상수나 변수, 그리고 프로퍼티의 타입으로 사용할 수 있음
- 함수, 메소드 또는 초기화 구문에서 매개변수 타입이나 반환 타입으로 프로토콜을 사용할 수 있음
- 배열이나 사전, 혹은 다른 컨테이너의 타입으로 사용할 수 있음

특정 프로토콜을 구현한 구조체나 클래스들이 있을 때, 우리는 이들의 인스턴스를 각각의 타입이 아니라 프로토콜 타입으로 정의된 변수나 상수에 할당할 수 있습니다. 이렇게 프로토콜 타입으로 정의된 변수나 상수에 할당된 객체는 프로토콜 이외에 구현체에서 추가한 프로퍼티나 메소드들을 컴파일러로부터 은닉해줍니다.

```swift
protocol Wheel {
	func spin()
	func hold()
}
```

Wheel 이라는 프로토콜을 선언하고, 여기에 spin()과 hold() 두 개의 메소드를 정의하였습니다. 이 프로토콜은 바퀴를 의미하며 정의된 두 개의 메소드는 바퀴가 움직이고 멈추는 기능을 하므로 바퀴를 가지는 모든 이동 수단에서 구현하여 움직임을 부여할 수 있습니다.

```swift
class Bicycle: Wheel {
  var moveState = false
  
  func spin() {
    self.pedal()
  }
  
  func hold() {
    self.pullBreak()
  }
  
  func pedal() {
    self.moveState = true
  }
  
  func pullBreak() {
    self.moveState = false
  }
}
let trans = Bicycle() // 타입 추론에 의하여 Bicycle 타입

trans.moveState
trans.pedal()
trans.pullBreak()
trans.spin()
trans.hold()
let wheel: Wheel = Bicycle()

wheel.spin()
wheel.hold()
```

이처럼 객체 본래 타입이 아니라 프로토콜 타입으로 선언한 변수나 상수에 할당받아 사용하는 것은 특정 프로토콜을 구현한 모든 클래스나 구조체를 변수나 상수에 할당할 수 있다는 장점이 있습니다. 개별 구조체나 클래스 타입으로 변수나 상수가 한정되지 않으므로 실질적으로 정의된 객체가 무엇이든지 특정 프로토콜을 구현하기만 했다면 모두 할당받을 수 있습니다.

물론 클래스는 AnyObject 타입으로 변수나 상수를 선언하면 모든 클래스를 할당받을 수 있지만, 이는 클래스로 제한될 뿐만 아니라 프로토콜에 정의된 프로퍼티나 메소드를 전혀 사용할 수 없는 결과를 가져옵니다.

하나의 특정 프로토콜을 구현한 어떤 객체든지 변수나 상수에 할당하고자 할 때는 특정 프로토콜의 타입으로 정의하여 사용하면 되지만, 필요에 따라 두 개 이상의 특정 프로토콜들 타입을 모두 사용해야할 때도 있습니다. 두 프로토콜에서 제공하는 프로퍼티나 메소드, 초기화 구문들을 사용해야 할 때가 이에 해당합니다.

```swift
protocol A {
  func doA()
}

protocol B {
  func doB()
}

class Impl: A, B {
  func doA() {
    
  }
  
  func doB() {
    
  }
  
  func desc() -> String {
    return "Class instance method"
  }
}
var ipl: A & B = Impl()
ipl.doA()
ipl.doB()
// ipl.desc() // (X)
```

### 10.3 델리게이션

프로토콜 타입으로 선언된 값을 사용한다는 것은 여기에 할당된 객체가 구체적으로 어떤 기능을 갖추고 있는지 상관 없다는 뜻이기도 합니다. 그저 단순히 할당된 객체를 사용하여 프로토콜에 정의된 프로퍼티나 메소드를 호출하겠다는 의미가 되죠.

```swift
"네가 누군지 난 알 필요 없다. 다만 너는 내가 호출할 메소드를 구현하고 있기만 하면 된다."
```

코코아 터치 프레임워크에서는 이러한 프로토콜 타입의 특성을 이용하여 델리게이션이라는 기능을 구현합니다.

델리게이션(Delegation)은 델리게이트 패턴과 연관되는 아주 중요한 개념으로, 특정 기능을 다른 객체에 위임하고, 그에 따라 필요한 시점에서 메소드의 호출만 받는 패턴이라고 할 수 있습니다.

```swift
protocol FuelPumpDelegate {
  func lackFuel()
  func fullFuel()
}
class FuelPump {
  var maxGage: Double = 100.0
  var delegate: FuelPumpDelegate? = nil
  
  var fuelGage: Double {
    didSet {
      if oldValue < 10 {
        // 연료가 부족해지면 델리게이트의 lackFuel 메소드를 호출한다.
        self.delegate?.lackFuel()
      } else if oldValue == self.maxGage {
        // 연료가 가득차면 델리게이트의 fullFuel 메소드를 호출한다.
        self.delegate?.fullFuel()
      }
    }
  }
  
  init(fuelGage: Double = 0) {
    self.fuelGage = fuelGage
  }
  
  func startPump() {
    while true {
      if self.fuelGage > 0 {
        self.jetFuel()
      } else {
        break
      }
    }
  }
  
  // 연료를 엔진에 분사한다. 분사할 때마다 연료 게이지의 눈금은 내려간다.
  func jetFuel() {
    self.fuelGage -= 1
  }
}
class Car: FuelPumpDelegate {
  var fuelPump = FuelPump(fuelGage: 100)
  
  init() {
    self.fuelPump.delegate = self
  }
  
  // fuelPump가 호출하는 메소드입니다.
  func lackFuel() {
    // 연료를 보충한다.
  }
  
  // fuelPump가 호출하는 메소드입니다.
  func fullFuel() {
    // 연료 보충을 중단한다.
  }
  
  // 자동차에 시동을 겁니다.
  func start() {
    fuelPump.startPump()
  }
}
```

delegate 프로퍼티에는 Car의 인스턴스가 할당되어 있으므로 Car 클래스에서 작성한 lackFuel() 메소드가 실행됩니다. 약간 복잡해 보이는 구성이지만, 델리게이트 참조를 통해 메소드를 호출할 인스턴스 객체를 전달받고, 이 인스턴스 객체가 구현하고 있는 프로토콜에 선언된 메소드를 호출하는 것이 델리게이션이라고 할 수 있습니다.

그렇다면 왜 프로토콜일까요? 앞에서 배우는 바와 같이 클래스를 이용하는 경우에도 부모 클래스를 상속받은 자식 클래스의 인스턴스들은 모두 부모 클래스 타입으로 정의된 변수나 상수에 할당할 수 있었습니다. 그리고 부모 클래스 타입으로 선언된 변수나 상수에 할당된 자식 클래스의 인스턴스들은 모두 자식 클래스에서 구현한 프로퍼티나 메소드들을 봉인 당해야 했습니다. 이를 ㄷ꺼내어 사용하려면 타입 캐스팅 과정을 거쳐야 했지만 어쨋든 각 클래스의 종류와 관계없이 같은 클래스를 부모로 둔 자식 클래스들은 모두 모 클래스 타입으로 선언된 변수/상수에 할당되므로 이를 사용하면 될일 입니다.

그런데도 프로토콜을 사용하여 이처럼 데릴게이션을 구현하는 것은 클래스가 단일 상속만을 지원하기 때문입니다. 하나의 부모 클래스를 상속받고 나면 더는 다른 클래스를 상속받을 수 없으므로 기능을 덧붙이기에는 제한적입니다. 이를 극복하기 위해 구현 개수에 제한이 없는 프로토콜을 이용하여 필요한 기능 단위별 객체를 작성하는 것입니다.

iOS 앱이 동작하는 방식 대다수가 델리게이션 패턴으로 이루어져 있고, 델리게이트 패턴을 이루는 핵심이 바로 프로토콜입니다. 그런 만큼 프로토콜이 사용되는 방식과 프로토콜을 이용하여 델리게이션을 구현하는 원리에 대해 자세히 알아둘 필요가 있습니다.

## 10.4 프로토콜의 활용

### 10.4.1 확장 구문과 프로토콜

클래스나 구조체, 열거형 등의 특정 객체에서 프로토콜을 구현해야 할 경우, 객체 자체의 코드를 수정하여 직접 구현할 수도 있지만 이를 대신하여 익스텐션에서 프로토콜을 구현할 수도 있습니다. 익스텐션은 별도의 타입으로 존재하는 객체라기보다는 기존의 정의되었던 객체 자체를 확장하여 새로운 기능을 추가하는 역할이므로 익스텐션에서 프로토콜을 구현한가는 것은 이랍ㄴ적으로 구조체나 클래스, 열거형에서 프로토콜을 구현하는 것과 차이가 없스빈다.

```swift
extension <기존 객체>: <구현할 프로토콜1>, <구현할 프로토콜2>, ... {
	// 프로토콜의 요소에 대한 구현 내용
}
```

이때 호가장하기 전 본래의 객체에서는 프로토콜을 구현하지 않았더라도 익스텐션에서는 프로토콜을 구현한다면 이후로 해당 객체는 프로토콜을 구현한 것으로 처리됩니다.

```swift
class Man {
  var name: String?
  
  init(name: String = "홍길동") {
    self.name = name
  }
}

protocol Job {
  func doWork()
}
extension Man: Job {
  func doWork() {
    print("\\(self.name!)님이 일을 합니다")
  }
}

let man = Man(name: "개발자")
man.doWork()
// 개발자님이 일을 합니다
```

주의할 점은 익스텐션에서 저장 프로퍼티를 정의할 수는 없다는 점입니다. 만약 프로토콜에 정의된 프로퍼티를 익스텐션에서 구현해야 한다면, 이때에는 연산 프로퍼티로 구현해주어야 합니다.

### 10.4.2 프로토콜의 상속

프로토콜은 클래스처럼 상속을 통해 정의된 프로퍼티나 메소드, 그리고 초기화 블록의 선언을 다른 프로토콜에 물려줄 수 있습니다. 하지만 프로토콜은 클래스와 다르게 다중 상속이 가능합니다. 즉 여러 개의 프로토콜을 하나의 프로토콜에 한꺼번에 상속하여 각 프로토콜들의 명세를 하나의 프로토콜에 담을 수 있습니다.

```swift
protocol A {
  func doA()
}

protocol B {
  func doB()
}

protocol C: A, B {
  func doC()
}

class ABC: C {
  func doA() {
    
  }
  
  func doB() {
    
  }
  
  func doC() {
    
  }
}
var a: A = ABC()
a.doA()

var ab: A & B = ABC()
ab.doA()
ab.doB()

var abc: A & B & C = ABC()
abc.doA()
abc.doB()
abc.doC()

var c: C = ABC()
c.doA()
c.doB()
c.doC()
func foo(abc: C) { }
foo(abc: ABC())

func boo(abc: A & B) { }
boo(abc: ABC())
```

이처럼 상속으로 구성된 프로토콜은 상위 프로토콜에 대한 기능들을 고스란히 가지고 있으므로 상위 프로토콜 타입으로 선언된 변수/상수나 함수의 인자값으로 사용될 수 있습니다.

또한 프로토콜을 상속할 때 부모 프로토콜에서의 선언과 자식 프로토콜에서의 선언이 겹치더라도 클래스에서처럼 override 키워드를 붙여야하는 제약이 없습니다.

```swift
protocol C: A, B {
  func doA()
  func doB()
  func doC()
}
```

상속 관계가 성립된 프로토콜은 is, as와 같은 타입 연산자들을 사용하여 타입에 대한 비교와 타입 변환을 할 수 있습니다. is 연산자는 주어진 객체를 비교 대상 타입과 비교하여 그 결과를 반환하는데 이때 선언된 변수나 상수의 타입이 아니라 할당된 실제 객체의 인스턴스를 기준으로 비교합니다. 할당된 객체가 비교 대상 타입과 같거나 비교 대상 타입을 상속받았을 경우 모두 true를 반환하고, 이외에는 false를 반환합니다.

앞에서 프로토콜 A, B, C를 이용하여 다양하게 선언했던 상수들을 대상으로 is 연산자를 사용한 다음의 결과들은 모두 true를 반환합니다. 이는 어떤 타이븡로 선언된 상수에 인스턴스를 할당받았든 실제로 할당된 인스턴스가 주어진 비교 대상 조건을 모두 만족하기 때문입니다.

```swift
abc is C
abc is A & B
abc is A
abc is B
a is C
a is B
ab is C
abc is A & B & C
```

as 연산자의 사용법도 클래스에서의 타입 캐스팅과 같습니다. 객체와 비교 대상과의 타입 비교를 위주로 하는 is 연산자와는 달리 as 연산자는 제한된 범위 내에서 타입을 캐스팅할 수 있도록 해줍니다.

제한된 범위

1. 실제로 할당된 인스턴스 타입
2. 인스턴스가 구현한 프로토콜 타입
3. 클래스가 상속을 받았을 경우 모든 상위 클래스
4. 프로토콜 타입이 상속을 받았을 경우 모든 상위 프로토콜

인스턴스 객체를 할당한 변수나 상수가 있을 때, 이 변수나 상수가 선언된 타입보다 상위 타입으로 캐스팅하는 것은 아무런 문제가 되지 않으므로 일반 캐스팅 연산자인 as를 사용하여 안전하게 캐스팅할 수 있지만, 선언된 타입보다 하위 타입으로 캐스팅할 때는 주의하여야 합니다. 실제로 할당된 인스턴스 객체에 따라서 캐스팅이 성공할 수도, 실패할 수도 있기 때문이빈다.

실제로 할당된 인스턴스 객체의 타입을 기준으로 일치하거나 상위 타입이면 캐스팅이 잘 되겠지만 그렇지 안흐으면 ㅋ캐스팅에 실패압니다. 이는 캐스팅 결과값으로 nil이 반환될 수도 있다는 의미죠. 이 떄문에 하위 캐스팅에서는 일반 캐스팅 연산자를 사용하는 대신 옵셔널 타입으로 캐스팅 결과를 반환하는 옵셔널 캐스팅(=as?) 연산자와 캐스팅 실패 가능성을 감안하고서라도 일반 타입으로 캐스팅하는 강제 캐스팅(=as!) 연산자 중에서 선택해서 사용해야 합니다.

```swift
protocol Machine {
  func join()
}

protocol Wheel: Machine {
  func locate()
  
  init(name: String, currentSpeed: Double)
}

class Vehicle {
  var currentSpeed = 0.0
  var name = ""
  
  init(name: String, currentSpeed: Double) {
    self.name = name
    self.currentSpeed = currentSpeed
  }
}
class Car: Vehicle, Wheel {
  required override init(name: String, currentSpeed: Double = 0.0) {
    super.init(name: name, currentSpeed: currentSpeed)
  }
  
  func join() {
    // join parts
  }
  
  func locate() {
    print("\\(self.name)의 바퀴가 회전합니다.")
  }
}
class Carpet: Vehicle, Machine {
  func join() {
    // join parts
  }
}
var translist = [Vehicle]()
translist.append(Car(name: "자동차", currentSpeed: 10.0))
translist.append(Carpet(name: "양탄자", currentSpeed: 15.0))

for trans in translist {
  if let obj = trans as? Wheel {
    obj.locate()
  } else {
    print("\\(trans.name)의 하위 타입 변환이 실패했습니다.")
  }
}

// 자동차의 바퀴가 회전합니다.
// 양탄자의 하위 타입 변환이 실패했습니다.
```

이처럼 프로토콜에서 타입 캐스팅은 공통 타입으로 선언된 객체의 인스턴스를 필요한 타입으로 적절히 변환하여 본래 인스턴스가 가지고 있던 고유한 기능들을 사용할 수 있도록 해줍니다.

### 10.4.3 클래스 전용 프로토콜

프로토콜은 문법적으로 구조체에서 확장체에 이르기까지 광범위한 객체들이 구현할 수 있지만, 때로는 클래스만 구현할 수 있도록 제한된 프로토콜을 정의해야 할 때가 있습니다. 이를 클래스 전용 프로토콜이라고 하는데, 프로토콜 정의 시 class 키워드를 사용하는 위치는 프로토콜의 이름 뒤 클론으로 구분된 영역입니다.

> 클래스 전용 프로토콜을 선언하는 예

```swift
protocol SomeClassOnlyProtocol: class {
	// 클래스에서 구현할 내용 작성
} 
```

클래스 전용 프로토콜에서는 메소드를 정의할 때 mutating 키워드를 붙일 수 없습니다. 본래 mutating 키워드는 구조체나 열거형 등 클래스가 아닌 객체가 메소드 내에서 프로퍼티를 수정할 수 있게 하기 위한 목적으로 사용하는 것이니만큼 구조체나 열거형이 구현할 수 없는 클래스 전용 프로토콜에서는 사용할 필요가 없기 때문입니다. 이와는 달리 static 키워드는 클래스에서도 이용하는 것이므로 클래스 전용 프로토콜에서도 제약없이 사용할 수 있습니다.

만약 프로토콜이 다른 프로토콜을 상속받는다면, 상속된 프로토콜 이름들을 나열하기 전에 맨 먼저 클래스 전용임을 표시해야 합니다. 클래스가 프로토콜과 부모 클래스를 표기할 때 맨 먼저 부모 클래스를 표기하는 것처럼, class 키워드와 상속 프로토콜 이름을 작성할 때는 class 키워드를 맨 앞에 작성해야 합니다.

```swift
protocol SomeClassOnlyProtocol: class, Wheel, Machine {
	// 클래스에서 구현할 내용 작성
}
```

### 10.4.4 optional

프로토콜에서 사용되는 optional 키워드에 대해 알아봅시다. 프로토콜을 구현할 때는 기본적으로 프로토콜의 명세에 포함된 모든 프로퍼티와 메소드, 그리고 초기화 구문을 구현해야 합니다. 그렇지 않으면 필요한 항목의 구현이 누락되었다는 오류가 발생합니다. 하지만 구현해야 하는 객체에 따라 특별히 필요하지 않은 프로퍼티나 메소드, 초기화 구문이 있을 수 있습니다.

이런 메소드까지 모두 일일이 구현해야 한다면 상당히 벌거로워집니다. 무의미한 코드도 늘어나겠죠. 이런 상황을 방지하기 위한 해법으로 바로 선택적 요청이라고 불리는 문법입니다. 이 문법은 프로토콜에서 선언된 프로퍼티나 메소드, 초기화 구문 등 프로토콜을 구현할 때 작성해야 하는 요소들을 필수 사항에서 선ㅌ택 사항으로 바꾸어줍니다.

프로토콜을 정의할 때 선택적 요청을 개별 요소마다 지정할 수 있는데, 이때 optional 키워드를 사용하여 프로퍼티나 메소드, 초기화 구문 앞에 표시합니다. 이 키워드가 붙은 ㅇ요소들은 프로토콜을 구현할 때 반드시 구현하지 않아도 된다는 것을 의미합니다.

프로토콭에서 optional 키워드를 사용하려면 약간의 제약이 있습니다. 프로토콜 앞에 @objc를 표시해야 합니다. @objc는 파운데이션 프레임워크에 정의된 어노테이션의 일종으로서, 이 어노테이션이 붙은 코드나 객체를 오브젝티브-C 코드에서도 참조할 수 있도록 노출됨을 의미합니다. 실제로 독자여러분이 정의한 프로토콜이 오브젝티브-C 코드와 상호 동작할 일이 없더라도 말입니다. 또한, @objc 어노테이션이 붙은 프로토콜은 구조체나 열거형 등에서 구현할 수 없습니다. 오로지 클래스만 이 프로토콜을 구현할 수 있습니다.

정리하자면, optional 키워드가 붙은 선택적 요청 프로토콜은 클래스만 구현할 수 있다는 뜻입니다. 이런 의미에서 optional 키워드 역시 클래스 전용 프로토콜임을 뜻하는 것이라고 할 수 있습니다.

```swift
import Foundation

@objc
protocol MsgDelegate {
  @objc optional func onReceive(new: Int)
}
```

optional 키워드가 추가되어 있으므로 반드시 구현하지 않아도 됩니다.

```swift
class MsgCenter {
  var delegate: MsgDelegate?
  var newMsg: Int = 0
  
  func msgCheck() {
    if newMsg > 0 { // 새로운 메세지가 도착했다면
      self.delegate?.onReceive?(new: self.newMsg)
      self.newMsg = 0
    }
  }
}
```

메소드가 반환하는 값이 일반 값이라 할지라도 옵셔널 메소드 형식으로 사용하면 결과값도 옵셔널 타입입니다.

강제 해제 연산자도 사용할 수 있습니다.

```swift
class Watch: MsgDelegate {
  var msgCenter: MsgCenter?
  
  init(msgCenter: MsgCenter) {
    self.msgCenter = msgCenter
  }
  
  func onReceive(new: Int) {
    print("\\(new) 건의 메세지가 도착했습니다.")
  }
}
```

코코아 터치 프레임워크에서도 반드시 필요한 메소드들만을 제외하고 나머지 다음 그림과 같이 대부분 optional 키워드로 선언되어 선택적으로 구현할 수 있습니다.