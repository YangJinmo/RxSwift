import UIKit

// 12. 접근제어

// 12.3
/*
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
*/

// 12.4

//private class AClass {
//  // 공개 접근수준을 부여해도 AClass의 접근수준이 비공개 접근수준이므로
//  // 이 메서드의 접근수준도 비공개 접근수준으로 취급합니다.
//  public func someMethod() {
//    // ...
//  }
//}

// AClass의 접근수준이 비공개 접근수준이므로
// 공개 접근수준 함수의 매개변수나 반환 값 타입으로 사용될 수 없습니다.
//public func someFunction(a: AClass) -> AClass { // 오류 발생
//  return a
//}

internal class InternalClass {} // 내부 접근수준 클래스
private struct PrivateStruct {} // 비공개 접근수준 구조체

// 요소로 사용되는 InternalClass와 PrivateStruct의 접근수준이
// PublicTuple 보다 낮기 때문에 사용할 수 없습니다.
//public var publicTuple: (first: InternalClass, second: PrivateStruct) =
//(InternalClass(), PrivateStruct())

// 요소로 사용되는 InternalClass와 PrivateStruct의 접근수준이
// PublicTuple과 같거나 높기 때문에 사용할 수 있습니다.
private var privateTuple: (first: InternalClass, second: PrivateStruct) =
(InternalClass(), PrivateStruct())



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


// 12.5

// 12-8
//public struct SomeType {
//  private var privateVariable = 0
//  fileprivate var fileprivateVariable = 0
//}
//
//// 같은 타입의 익스텐션에서는 private 요소에 접근 가능
//extension SomeType {
//  public func publicMethod() {
//    print("\(self.privateVariable), \(self.fileprivateVariable)")
//  }
//
//  private func privateMethod() {
//    print("\(self.privateVariable), \(self.fileprivateVariable)")
//  }
//
//  fileprivate func fileprivateMethod() {
//    print("\(self.privateVariable), \(self.fileprivateVariable)")
//  }
//}
//
//struct AnotherType {
//  var someInstance: SomeType = SomeType()
//
//  mutating func someMethod() {
//    // public 접근수준에는 어디서든 접근 가능
//    self.someInstance.publicMethod() // 0, 0
//
//    // 같은 파일에 속해있는 코드이므로 fileprivate 접근수준 요소에 접근 가능
//    self.someInstance.fileprivateVariable = 100
//    self.someInstance.fileprivateMethod() // 0, 100
//
//    // 다른 타입 내부의 코드이므로 private 요소에 접근 불가 - 오류
//    //self.someInstance.privateVariable = 100
//    //self.someInstance.privateMethod()
//  }
//}
//
//var anotherInstance = AnotherType()
//anotherInstance.someMethod()


// 12-9
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
