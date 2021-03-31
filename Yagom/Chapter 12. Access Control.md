객체지향 프로그래밍 패러다임에서 은닉화는 중요한 개념 중의 하나입니다.

## 12.1 접근제어란

접근제어(Access Control)는 코드끼리 상호작용을 할 때 파일 간 또는 모듈 간에 접근을 제한할 수 있는 기능입니다. 접근 제어를 통해 코드의 상세 구현은 숨기고 허용된 기능만 사용하는 인터페이스를 제공할 수 있습니다.

### 12.1.1 접근제어의 필요성

객체지향 프로그래밍 패러다임에서 중요한 캡슐화와 은닉화를 구현하려면 외부에서 보이지 않거나 접근하지 말아야 할 코드가 있습니다. 불필요한 접근으로 의도치 않은 결과를 초래하거나 꼭 필요한 부분만 제공을 해야하는데 전체 코드가 노출될 가능성이 있을 때 우리는 접근제어를 통해 우리가 의도한 대로 코드를 사용하는 프로그래머에게 코드를 작성하도록 유도할 수 있습니다.

### 12.1.2 모듈과 소스파일

스위프트의 접근 제어는 모듈과 소스파일 기반으로 설계되었습니다.

**모듈(Module)**은 배포할 코드의 묶음 단위입니다. 통상 하나의 프레임워크(Framework)나 라이브러리(Library) 또는 애플리케이션(Application)이 모듈 단위가 될 수 있습니다. 스위프트에서는 import 키워드를 사용하여 불러옵니다.

**소스파일**은 하나의 스위프트 소스 코드 파일을 의미합니다. 자바나 Objective-C와 같은 기준의 프로그래밍 언어에서 통상 파일 하나에 타입을 하나만 정의합니다. 스위프트에서도 보통 파일 하나에 타입 하나만 정의하지만, 때로는 소스파일 하나에 여러 타입(여러 개의 클래스나 구조체, 열거형 등)이나 함수 등 많은 것을 정의하거나 구현할 수도 있습니다.

## 12.2 접근수준

접근제어는 접근수준(Access Level) 키워드를 통해 구현할 수 있습니다. 각 타입 (클래스, 구조체, 열거형 등)에 특정 접근수준을 지정할 수 있고, 타입 내부의 프로퍼티, 메서드, 이니셜라이저, 서브스크립트 각각에도 접근수준을 지정할 수 있습니다. 접근수준을 명시할 수 있는 키워드는 open, public internal, fileprivate, private 다섯 가지가 있습니다.

스위프트의 접근기준은 기본적으로 모듈과 소스파일에 따라 구분지어집니다.

[접근기준](https://www.notion.so/49968b1cc10e42189f63982aa39214fb)

### 12.2.1 공개 접근수준, public

public 키워드로 접근수준이 저정된 요소는 어디서든 쓰일 수 있습니다. 자신이 구현되어 있는 소스파일은 물론, 그 소스파일이 속해 있는 모듈, 그리고 그 모듈을 가져다 쓰는 모듈 등 그 모든 곳에서 사용될 수 있습니다. 공개(Public) 접근수준은 주로 프레임워크에서 외부와 연결될 인터페이스를 구현하는데 많이 쓰입니다. 우리가 사용하는 스위프트의 기본 요소는 모두 공개 접근수준으로 구현되어 있다고 생각하면 됩니다.

> 스위프트 표준 라이브러리에 정의되어 있는 Bool 타입

```swift
/// A value type whose instances are either `true` or `false`.
@frozen public struct Bool {

    /// Creates an instance initialized to `false`.
    ///
    /// Do not call this initializer directly. Instead, use the Boolean literal
    /// `false` to create a new `Bool` instance.
    public init()
}
```

### 12.2.2 개방 접근수준, open

open 키워드로 지정할 수 있는 개방(Open) 접근수준은 공개 접근수준 이상으로 접근수준이 높은 수준이며, 클래스와 클래스의 멤버에서만 사용할 수 있습니다. 기본적으로 공개 접근수준의 접근수준과 비슷하지만 다음과 같은 차이점이 있습니다.

- 개방 접근수준을 제외한 다른 모든 접근수준의 클래스는 그 클래스가 정의된 모듈 안에서만 상속될 수 있습니다.
- 개방 접근수준을 제외한 다른 모든 접근수준의 클래스 멤버는 그 멤버가 정의된 모듈 안에서만 재정의될 수 있습니다.
- 개방 접근수준의 클래스는 그 클래스가 정의된 모듈 밖의 다른 모듈에서도 상속될 수 있습니다.
- 개방 접근수준의 클래스 멤버는 그 멤버가 정의된 모듈 밖의 다른 모듈에서도 정의될 수 있습니다.

클래스를 개반 접근수준으로 명시하는 것은 그 클래스를 다른 모듈에서도 부모 클래스로 사용할 수 있으며, 그 목적으로 클래스를 설계하고 코드를 작성했음을 의미합니다.

> Foundation 프레임워크에 정의되어 있는 개방 접근수준의 NSString 클래스

```swift
open class NSString : NSObject, NSCopying, NSMutableCopying, NSSecureCoding {

    open var length: Int { get }

    open func character(at index: Int) -> unichar

    public init()

    public init?(coder: NSCoder)
}
```

### 12.2.3 내부 접근수준, internal

internal 키워드 지정하는 내부(Internal) 접근수준은 기본적으로 모든 요소에 암묵적으로 지정되는 기본 접근수준입니다. 내부 접근수준으로 접근수준이 지정된 요소는 구현된 소스파일이 속해 있는 모듈 어디에서든 쓰일 수 있습니다. 다만, 그 모듈을 가져다 쓰는 외부 모듈에서는 접근할 수 없습니다. 보통 외부에서 사용될 클래스나 구조체가 아니며, 모듈 내부에서 광역적으로 사용될 경우 내부 접근수준을 지정하게 됩니다.

### 12.2.4 파일외부비공개 접근수준, fileprivate

파일외부비공개(File-private) 접근수준으로 접근수준이 지정된 요소는 그 요소가 구현된 소스파일 내부에서만 사용할 수 있습니다. 해당 소스파일 외부에서 값이 변경되거나 함수가 호출되면 부작용이 생길 수 있는 경우에 사용하면 좋습니다.

### 12.2.5 비공개 접근수준, private

비공개(Private) 접근수준은 가장 한정적인 범위입니다. 비공개 접근수준으로 접근수준이 지정된 요소는 그 기능이 정의되고 구현된 범위내에서만 사용될 수 있습니다. 비공개 접근수준으로 지정된 기능은 심지어 같은 소스파일 안에 구현된 다른 타입이나 기능에서도 사용할 수 없습니다.

## 12.3 접근제어 구현

접근제어는 접근수준을 지정해서 구현할 수 있습니다. 각각의 접근수준을 요소 앞에 지정해주기만 하면 됩니다. internal은 기본 접근수준이므로 굳이 표기해주지 않아도 됩니다.

> 접근수준을 명기한 각 요소들의 예

```swift
open class OpenClass {
	open var openProperty: Int = 0
	public var publicProperty: Int = 0
	internal var internalProperty: Int = 0
	fileprivate var filePrivateproperty: Int = 0
	private var privateProperty: Int = 0

	open func openMethod() {}
	public func publicMethod() {}
	internal func internalMethod() {}
	fileprivate func fileprivateMethod() {}
	private func privateMethod() {}
}

public class PublicClass {}
public struct PublicStruct {}
public enum PublicEnum {}
public var publicVariable = 0
public let publicConsstant = 0
public func publicFunction() {}

internal class InternalClass {}
internal struct InternalStruct {}
internal enum InternalEnum {}
internal var InternalVariable = 0
internal let InternalConsstant = 0
internal func InternalFunction() {}

fileprivate class FilePrivateClass {}
fileprivate struct FilePrivateStruct {}
fileprivate enum FilePrivateEnum {}
fileprivate var filePrivateVariable = 0
fileprivate let filePrivateConstant = 0
fileprivate func filePrivateFunction() {}

private class PrivateClass {}
private struct PrivateStruct {}
private enum PrivateEnum {}
private var privateVariable = 0
private let privateConstant = 0
private func privateFunction() {}
```

## 12.4 접근제어 구현 참고사항

모든 타입에 적용되는 접근수준의 규칙은 '상위 요소보다 하위 요소가 더 높은 접근수준을 가질 수 없다.'입니다. 비공개 접근수준으로 정의된 구조체 내부의 프로퍼티로 내부수준이나 공개수준을 가지는 프로퍼티가 정의될 수 없습니다. 또, 함수의 매개변수로 특정 접근수준이 부여된 타입이 전달되거나 반환된다면, 그 타입의 접근수준보다 함수의 접근수준이 높게 설정될 수 없습니다. 잘못된 접근수준의 예를 살펴봅시다.

> 잘못된 접근수준 부여

```swift
private class AClass {
	// 공개 접근수준을 부여해도 AClass의 접근수준이 비공개 접근수준이므로
	// 이 메서드의 접근수준도 비공개 접근수준으로 취급합니다.
	public func someMethod() {
		// ...
	}
}

// AClass의 접근수준이 비공개 접근수준이므로
// 공개 접근수준 함수의 매개변수나 반환 값 타입으로 사용될 수 없습니다.
public func someFunction(a: AClass) -> AClass { // 오류 발생
	return a
}
```

함수뿐만 아니라 튜플의 내부 요소 타입 또한 튜플의 내부 요소 타입 또한 튜플의 접근수준보다 같거나 높아야 합니다.

> 튜플의 접근수준 부여

```swift
internal class InternalClass {} // 내부 접근수준 클래스
private struct PrivateStruct {} // 비공개 접근수준 구조체

// 요소로 사용되는 InternalClass와 PrivateStruct의 접근수준이
// PublicTuple 보다 낮기 때문에 사용할 수 없습니다.
public var publicTuple: (first: InternalClass, second: PrivateStruct) =
(InternalClass(), PrivateStruct()) // 오류 발생

// 요소로 사용되는 InternalClass와 PrivateStruct의 접근수준이
// PublicTuple과 같거나 높기 때문에 사용할 수 있습니다.
private var privateTuple: (first: InternalClass, second: PrivateStruct) =
(InternalClass(), PrivateStruct())
```

> 접근수준에 따른 접근 결과

```swift
// AClass.swift 파일과 Common.swift 파일이 같은 모듈에 속해 있을 경우

// AClass.swift 파일
class AClass {
	func internalMethod() {}
	fileprivate func filePrivateMethod() {}
	var internalProperty = 0
	fileprivate var filePrivateProperty = 0
}

// Common.swift 파일
let aInstance: AClass = AClass()
aInstance.internalMethod() // 같은 모듈이므로 호출 가능
aInstance.filePrivateMethod() // 다른 파일이므로 호출 불가 - 오류
aInstance.internalProperty = 1 // 같은 모듈이므로 접근 가능
aInstance.filePrivateProperty = 1 // 다른 파일이므로 접근 불가 - 오류
```

> 열거형의 접근수준

```swift
private typealias PointValue = Int

// 오류 - PointValue가 Point보다 접근수준이 낮기 때문에 원시 값으로 사용할 수 없습니다.
enum Point: PointValue {
	case x, y
}
```

열거형으로 접근수준을 구현할 때, 열거형 내부의 각각의 케이스별로 따로 접근수준을 부여할 수 없습니다. 각각의 케이스의 접근수준은 열거형 자체의 접근수준을 따릅니다. 또한, 열거형의 원시 값의 타입으로 열거형의 접근수준보다 낮은 접근수준의 타입이 올 수는 없습니다. 연관 값의 타입 또한 마찬가지입니다.

## 12.5 private와 fileprivate

같은 파일 내부에서 private 접근수준과 fileprivate 접근수준은 사용할 때 분명한 차이가 있습니다. fileprivate 접근수준으로 지정한 요소는 같은 파일 어떤 코드에서도 접근할 수 있습니다.

반면에 private 접근수준으로 지정한 요소는 같은 파일 내부에 다른 타입의 코드가 있더라도 접근이 불가능합니다. 그러나 자신을 확장하는 익스텐션 코드가 같은 파일에 존재하는 경우에는 접근할 수 있습니다.

> 같은 파일에서의 private와 fileprivate

```swift
public struct SomeType {
  private var privateVariable = 0
  fileprivate var fileprivateVariable = 0
}

// 같은 타입의 익스텐션에서는 private 요소에 접근 가능
extension SomeType {
  public func publicMethod() {
    print("\\(self.privateVariable), \\(self.fileprivateVariable)")
  }

  private func privateMethod() {
    print("\\(self.privateVariable), \\(self.fileprivateVariable)")
  }

  fileprivate func fileprivateMethod() {
    print("\\(self.privateVariable), \\(self.fileprivateVariable)")
  }
}

struct AnotherType {
  var someInstance: SomeType = SomeType()

  mutating func someMethod() {
    // public 접근수준에는 어디서든 접근 가능
    self.someInstance.publicMethod() // 0, 0

    // 같은 파일에 속해있는 코드이므로 fileprivate 접근수준 요소에 접근 가능
    self.someInstance.fileprivateVariable = 100
    self.someInstance.fileprivateMethod() // 0, 100

    // 다른 타입 내부의 코드이므로 private 요소에 접근 불가 - 오류
    //self.someInstance.privateVariable = 100
    //self.someInstance.privateMethod()
  }
}

var anotherInstance = AnotherType()
anotherInstance.someMethod()
```

## 12.6 읽기 전용 구현

구조체 또는 클래스를 사용하여 저장 프로퍼티를 구현할 때는 허용된 접근수준에서 프로퍼티 값을 가져갈 수 있습니다. 그러면 값을 변경할 수 없도록 구현하고 싶다면 어떻게 해야 할까요? 또, 서브스크립트도 읽기만 가능하도록 제한하려면 어떻게 해야할까요 ?

그럴 때는 설정자(Setter)만 더 낮은 접근수준을 갖도록 제한할 수 있습니다. 요소의 접근수준 키워드 뒤에 접근수준(set)처럼 표현하면 설정자의 접근수준만 더 낮도록 지정해줄 수 있습니다.

설정자 접근수준 제한은 프로퍼티, 서브스크립트, 변수 등에 적용될 수 있으며, 해당 요소의 접근수준보다 같거나 낮은 수준으로 제한해주어야 합니다.

> 설정자의 접근수준 지정

```swift
public struct SomeType {
  // 비공개 접근수준 저장 프로퍼티 count
  private var count: Int = 0

  // 공개 접근수준 저장 프로퍼티 publicStoredProperty
  public var publicStoredProperty: Int = 0

  // 공개 접근수준 저장 프로퍼티 publicGetOnlyStoredProperty
  // 설정자는 비공개 접근수준
  public private(set) var publicGetOnlyStoredProperty: Int = 0

  // 내부 접근수준 저장 프로퍼티 internalComputedProperty
  internal var internalComputedProperty: Int {
    get {
      return count
    }
    set {
      count += 1
    }
  }

  // 내부 접근수준 저장 프로퍼티: internalGetOnlyComputedProperty
  // 설정자는 비공개 접근수준
  internal private(set) var internalGetOnlyComputedProperty: Int {
    get {
      return count
    }
    set {
      count += 1
    }
  }

  // 공개 접근수준 서브스크립트
  public subscript() -> Int {
    get {
      return count
    }
    set {
      count += 1
    }
  }

  // 공개 접근수준 서브스크립트
  // 설정자는 내부 접근수준
  public internal(set) subscript(some: Int) -> Int {
    get {
      return count
    }
    set {
      count += 1
    }
  }
}

var someInstance: SomeType = SomeType()

// 외부에서 접근자, 설정자 모두 사용 가능
print(someInstance.publicStoredProperty) // 0
someInstance.publicStoredProperty = 100

// 외부에서 접근자만 사용 가능
print(someInstance.publicGetOnlyStoredProperty) // 0
//someInstance.publicGetOnlyStoredProperty = 100

// 외부에서 접근자, 설정자 모두 사용 가능
print(someInstance.internalComputedProperty) // 0
someInstance.internalComputedProperty = 100

// 외부에서 접근자만 사용 가능
print(someInstance.internalGetOnlyComputedProperty) // 1
//someInstance.internalGetOnlyComputedProperty = 100

// 외부에서 접근자, 설정자 모두 사용 가능
print(someInstance[]) // 1
someInstance[] = 100

// 외부에서 접근자만, 같은 모듈 내에서는 설정자도 사용 가능
print(someInstance[0]) // 2
someInstance[0] = 100
```