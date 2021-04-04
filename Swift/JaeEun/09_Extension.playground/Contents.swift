import UIKit

// 9.2 익스텐션

extension Double {
  var km: Double { return self * 1_000.0 }
  var m: Double { return self }
  var cm: Double { return self / 100.0 }
  var mm: Double { return self / 1_000.0 }
  var description: String {
    "\(self)km는 \(self.km)m, \(self)cm는 \(self.cm)m, \(self)mm는 \(self.mm)m"
  }
}

2.km
5.5.cm
125.mm
7.0.description

let distance = 42.0.km + 195.m
print("마라톤의 총 거리는 \(distance)m 입니다.")


extension Int {
  func repeatRun(task: () -> Void) {
    for _ in 0 ..< self {
      task()
    }
  }
}

let d = 3

d.repeatRun(task: {
  print("반갑습니다!")
})

d.repeatRun {
  print("반갑습니다!")
}

extension Int {
  mutating func square() {
    self = self * self
  }
}

var value = 3
value.square() // 9


//let value = 3
//value.square() // X

//3.square() // X


// 9.2.3 익스텐션을 활용한 코드 정리

public class DataSync {
  public func save(_ value: Any, forKey: String) { }
  public func load(_ key: String) { }
  public func remove(_ key: String) { }
}

extension DataSync {
  public func stringToDate(_ value: String) -> Date { return Date() }
  public func dateToString(_ value: Date) -> String { return String() }
}



protocol NewMethodProtocol {
  mutating func execute(cmd command: String, desc: String)
  func showPort(p: Int, memo desc: String) -> String
}

struct RubyNewService: NewMethodProtocol {
  func execute(cmd comm: String, desc d: String) {
    if comm == "start" {
      print("\(d)를 실행합니다.")
    }
  }

  func showPort(p port: Int, memo: String) -> String {
    return "Port: \(port), Memo: \(memo)"
  }
}


protocol MService {
  mutating func execute(cmd: String)
  func showPort(p: Int) -> String
}

struct RubyMService: MService {
  var paramCommand: String?

  mutating func execute(cmd: String) {
    self.paramCommand = cmd
    if cmd == "start" {
      print("실행합니다.")
    }
  }

  func showPort(p: Int) -> String {
    return "Port: \(p), now command: \(self.paramCommand!)"
  }
}

struct RubyMService2: MService {
  var paramCommand: String?

  func execute(cmd: String) {
    if cmd == "start" {
      print("실행합니다.")
    }
  }

  func showPort(p: Int) -> String {
    return "Port: \(p), now command: \(self.paramCommand!)"
  }
}

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
  override required init() {

  }
}

protocol SomeInitProtocol {
  init()
  init(cmd: String)
}

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
      print("\(d)를 실행합니다.")
    }
  }

  func showPort(p port: Int, memo: String) -> String {
    return "Port: \(port), Memo: \(memo)"
  }
}


class BaseObject {
  var name: String = "홍길동"
}

class MultiImplWithInherit: BaseObject, NewMethodProtocol, SomeInitProtocol {
  required override init() {
    
  }
  
  func execute(cmd command: String, desc: String) {
    
  }
  
  func showPort(p: Int, memo desc: String) -> String {
    return ""
  }
  
  required init(cmd: String) {
    
  }
}

// 10.2 타입으로서의 프로토콜

protocol Wheel {
  func spin()
  func hold()
}



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


let trans = Bicycle()

trans.moveState
trans.pedal()
trans.pullBreak()
trans.spin()
trans.hold()

let wheel: Wheel = Bicycle()

wheel.spin()
wheel.hold()



//protocol A {
//  func doA()
//}
//
//protocol B {
//  func doB()
//}
//
//class Impl: A, B {
//  func doA() {
//
//  }
//
//  func doB() {
//
//  }
//
//  func desc() -> String {
//    return "Class instance method"
//  }
//}
//
//var ipl: A & B = Impl()
//ipl.doA()
//ipl.doB()
// ipl.desc() // (X)



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



// 10.4 프로토콜 활용

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
    print("\(self.name!)님이 일을 합니다")
  }
}

let man = Man(name: "개발자")
man.doWork()
// 개발자님이 일을 합니다



// 10.4.2


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

abc is C
abc is A & B
abc is A
abc is B
a is C
a is B
ab is C
abc is A & B & C


protocol Machine {
  func join()
}

protocol Wheel2: Machine {
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

class Car2: Vehicle, Wheel2 {
  required override init(name: String, currentSpeed: Double = 0.0) {
    super.init(name: name, currentSpeed: currentSpeed)
  }
  
  func join() {
    // join parts
  }
  
  func locate() {
    print("\(self.name)의 바퀴가 회전합니다.")
  }
}

class Carpet: Vehicle, Machine {
  func join() {
    // join parts
  }
}

var translist = [Vehicle]()
translist.append(Car2(name: "자동차", currentSpeed: 10.0))
translist.append(Carpet(name: "양탄자", currentSpeed: 15.0))

for trans in translist {
  if let obj = trans as? Wheel2 {
    obj.locate()
  } else {
    print("\(trans.name)의 하위 타입 변환이 실패했습니다.")
  }
}

// 자동차의 바퀴가 회전합니다.
// 양탄자의 하위 타입 변환이 실패했습니다.


protocol SomeClassOnlyProtocol: class {
  // 클래스에서 구현할 내용 작성
}


protocol SomeClassOnlyProtocol2: class, Wheel, Machine {
  // 클래스에서 구현할 내용 작성
}



// 10.4.4 optional

import Foundation

@objc
protocol MsgDelegate {
  @objc optional func onReceive(new: Int)
}


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


class Watch: MsgDelegate {
  var msgCenter: MsgCenter?
  
  init(msgCenter: MsgCenter) {
    self.msgCenter = msgCenter
  }
  
  func onReceive(new: Int) {
    print("\(new) 건의 메세지가 도착했습니다.")
  }
}
