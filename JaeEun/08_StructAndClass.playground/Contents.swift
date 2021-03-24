import UIKit

struct 구조체_이름 {
  // 구조체 정의 내용이 들어갈 부분
}

class 클래스_이름 {
  // 클래스 정의 내용이 들어갈 부분
}

// 네이밍룰 (Naming Rule)

// 첫 글자는 대문자로 시작
//struct Integer {}
//struct String {}
//class Object {}
//class Controller {}

// 2단어 이상으로 이루어진 복합 단어일 때는 단어마다 대소문자를 번갈아 표시
struct SignedInteger {} // Signed + Integer
class ViewController {} // View + Controller

// 약어로 이루어진 부분은 모두 대문자로 표기
class NSNumber {} // NS: 파운데이션 프레임워크를 나타내는 약어 접두어
class UIView {} // UI: UIKit 프레임워크를 나타내는 약어 접두어
struct JSONDictionary {} // JSON은 JavaScript Object Notation을 나타내는 약어


struct Resolution {
  var width = 0
  var height = 0
  
  func desc() -> String {
    return "Resolution 구조체"
  }
}

class VideoMode {
  var interlaced = false
  var frameRate = 0.0
  var name: String?
  
  var res = Resolution()

  func desc() -> String {
    return "VideoMode 클래스"
  }
}

let insRes = Resolution()
let insVMode = VideoMode()

let width = insRes.width
print("insRes 인스턴스의 width 값은 \(width)입니다")

let vMode = VideoMode()
print("vMode 인스턴스의 width 값은 \(vMode.res.width)입니다")

vMode.name = "Sample"
vMode.res.width = 1280
print("\(vMode.name!) 인스턴스의 width 값은 \(vMode.res.width)입니다")

// 체인(Chain): 연속된 접근 지원
var res = vMode.res
res.width = 1280

// view.frame.size.width
// 생산성 향상

let defaultRes = Resolution(width: 1024, height: 768)
print("width: \(defaultRes.width), height: \(defaultRes.height)")

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd

cinema.width = 2048
print("cinema 인스턴스의 width 값은 \(cinema.width)입니다")
print("hd 인스턴스의 width 값은 \(hd.width)입니다")

//hd.width = 4096 // Cannot assign to property: 'hd' is a 'let' constant


let video = VideoMode()
video.name = "Original Video Instance"

print("video 인스턴스의 name 값은 \(video.name!)입니다")


let dvd = video
dvd.name = "DVD Video Instance"

print("video 인스턴스의 name 값은 \(video.name!)입니다")

func changeName(v: VideoMode) {
  v.name = "Function Video Instance"
}

changeName(v: video)
print("video 인스턴스의 name 값은 \(video.name!)입니다")

if video === dvd {
  print("video와 dvd는 동일한 VideoMode 인스턴스를 참조하고 있군요.")
} else {
  print("video와 dvd는 서로 다른 VideoMode 인스턴스를 참조하고 있군요.")
}

let vs = VideoMode()
let ds = VideoMode()

if vs === ds {
  print("vs와 ds는 동일한 VideoMode 인스턴스를 참조하고 있군요.")
} else {
  print("vs와 ds는 서로 다른 VideoMode 인스턴스를 참조하고 있군요.")
}

//class User { // Class 'User' has no initializers
//  var name: String
//
//  init() {
//    self.name = ""
//  }
//}

//class User {
//  var name: String?
//}

//class User {
//  var name: String!
//}

class User {
  var name: String = ""
}

// 구조체에서 저장 프로퍼티

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
//constantsOfInstance.startValue = 0 // (X) // Cannot assign to property: 'constantsOfInstance' is a 'let' constant


// 지연 저장 프로퍼티

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


// 클로저를 이용한 저장 프로퍼티 초기화

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

s.value01
s.value02

// 실행 결과 없음
// 저장 프로퍼티에 정의된 클로저 구문이 더 이상 재실행되지 않기 때문입니다.

s.value03


// 연산 프로퍼티

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
print("square.centerX = \(square.centerX), square.centerY = \(square.centerY)")

// square.centerX = 5.0, square.centerY = 5.0


struct Job {
  var income: Int = 0 {
    willSet {
      print("이번 달 월급은 \(income)원에서 \(newValue)원으로 변경될 예정입니다.")
    }
    didSet {
      if income > oldValue {
        print("월급이 \(income)원 증가하셨네요. 소득세가 상향조정될 예정입니다.")
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

//class AtomicValue<T> {
//  let queue = DispatchQueue(label: "queue")
//
//  private(set) var storedValue: T
//
//  init(_ storedValue: T) {
//    self.storedValue = storedValue
//  }
//
//  var value: T {
//    get {
//      return self.storedValue
//    }
//    set {
//      self.storedValue = newValue
//      print("value: \(newValue)")
//    }
//  }
//
//  func mutate(_ transform: (inout T) -> Void) {
//    queue.sync {
//      transform(&self.storedValue)
//      print("mutate: \(self.storedValue)")
//    }
//  }
//}
//
//let atomicInComplete = AtomicValue<Int>(0)
//let atomicComplete = AtomicValue<Int>(0)
//DispatchQueue.concurrentPerform(iterations: 100000) { (idx) in
//  print("con: \(idx)")
//  atomicInComplete.value + idx
//  atomicComplete.mutate { $0 += idx }
//}

// 8.3.1 인스턴스 메소드
struct Resolution2 {
  var width = 0
  var height = 0
  
  // 구조체의 요약된 설명을 리턴해주는 인스턴스 메소드
  func desc() -> String {
    let desc = "이 해상도는 가로 \(self.width) X \(self.height)로 구성됩니다."
    return desc
  }
  
  func judge() -> Bool {
    let width = 30
    return self.width == width
  }
}

class VideoMode2 {
  var resolution = Resolution2()
  var interlaced = false
  var frameRate = 0.0
  var name: String?
  
  // 클래스의 요약된 설명을 리턴해주는 인스턴스 메소드
  func desc() -> String {
    if self.name != nil {
      let desc = "이 \(self.name!) 비디오 모드는 \(self.frameRate)의 프레임 비율로 표시됩니다."
      return desc
    } else {
      let desc = "이 비디오 모드는 \(self.frameRate)의 프레임 비율로 표시됩니다."
      return desc
    }
  }
}

var res2 = Resolution2()
res2.width

class Counter {
  
  // 카운트를 저장. 변수 프로퍼티
  var count = 0
  
  // 카운트를 1 증가. 인스턴스 메소드
  func increment() {
    self.count += 1
  }
  
  // 입력된 값만큼 카운트를 증가. 인스턴스 메소드
  func incrementBy(amount: Int) {
    self.count += amount
  }
  
  // 카운트를 0으로 초기화. 인스턴스 메소드
  func reset() {
    self.count = 0
  }
}

let counter = Counter() // count: 0

counter.increment() // count: 1

counter.incrementBy(amount: 5) // count: 6

counter.reset() // count: 0

struct Point3 {
  var x = 0.0
  let y = 0.0
}

var point3 = Point3(x: 3.5)

point3.x = 5.5
print("\(point3.x), \(point3.y)") // 1.5, 12.0

//point3.y = 7.5
// Cannot assign to property: 'y' is a 'let' constant


struct Point {
  var x = 0.0, y = 0.0
  
  mutating func moveBy(x deltaX: Double, y deltaY: Double) {
    self.x += deltaX
    self.y += deltaY
  }
}

var point = Point(x: 10.5, y: 12.0)
point.x = 1.5
print("\(point.x), \(point.y)") // 1.5, 12.0
point.moveBy(x: 3.0, y: 4.5)
print("\(point.x), \(point.y)") // 4.5, 16.5

let point2 = Point(x: 10.5, y: 12.0)
//point2.x = 1.5
// Cannot assign to property: 'point2' is a 'let' constant
//point2.moveBy(x: 3.0, y: 4.5)
// Cannot use mutating member on immutable value: 'point2' is a 'let' constant

class Location {
  var x = 0.0, y = 0.0
  
  func moveBy(x deltaX: Double, y deltaY: Double) {
    self.x += deltaX
    self.y += deltaY
  }
}

let loc = Location()
loc.x = 10.5
loc.y = 12.0
loc.moveBy(x: 3.0, y: 4.5)
print("이제 새로운 좌표는 (\(loc.x), \(loc.y)) 입니다.")
// 이제 새로운 좌표는 (13.5, 16.5) 입니다.


// 8.3.2 타입 메소드
class Foo2 {
  // 타입 메소드 선언
  class func fooTypeMethod() {
    // 타입 메소드의 구현 내용
  }
}

let f = Foo2()
//f.fooTypeMethod()
// Static member 'fooTypeMethod' cannot be used on instance of type 'Foo2'
Foo2.fooTypeMethod()


// 8.4 상속 (inheritance)

class A {
  var name = "Class A"
  
  var description: String {
    return "This class name is \(self.name)"
  }
  
  func foo() {
    print("\(self.name)'s method foo is called")
  }
}

let a = A()
a.name // "Class A"
a.description // "This class name is Class A"
a.foo()

//UIViewController
//open class UIViewController : UIResponder, NSCoding, UIAppearanceContainer, UITraitEnvironment, UIContentContainer, UIFocusEnvironment

class B: A {
  var prop = "Class B"
  
  func boo() -> String {
    return "Class B prop = \(self.prop)"
  }
}

let b = B()
b.prop // "Class B"
b.boo() // "Class B prop = Class B"

b.name // "Class A"
b.foo() // Class A's method foo is called

b.name = "Class C"
b.foo() // Class C's method foo is called


class Vehicle {
  var currentSpeed = 0.0
  
  var description: String {
    return "시간당 \(self.currentSpeed)의 속도로 이동하고 있습니다."
  }
  
  func makeNoise() {
    // 임의의 교통수단 자체는 경적을 울리는 기능이 필요 없습니다.
  }
}

let baseVehicle = Vehicle()
baseVehicle.description


class Bicycle: Vehicle {
  var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true

bicycle.currentSpeed = 20.0
print("자전거: \(bicycle.description)")

class Tandem: Bicycle { // Tendem: 2인용 자전거
  var passengers = 0
}

let tandem = Tandem()

tandem.hasBasket = true
tandem.passengers = 2
tandem.currentSpeed = 14.0
print("Tandem: \(tandem.description)") // Tandem: 시간당 14.0의 속도로 이동하고 있습니다.


class Car: Vehicle {
  var gear = 0
  var engineLevel = 0
  
  override var currentSpeed: Double {
    get {
      return Double(self.engineLevel * 50)
    }
    set {
      // 아무것도 하지 않음
    }
  }
  
  override var description: String {
    get {
      return "Car: engineLevel = \(self.engineLevel), so currentSpeed = \(self.currentSpeed)"
    }
    set {
      print("New Value is \(newValue)")
    }
  }
}

let c = Car()
c.engineLevel = 5
c.currentSpeed
c.description = "New Class Car" // New Value is New Class Car
print(c.description)

class AutomaticCar: Car {
  override var currentSpeed: Double {
    didSet {
      self.gear = Int(currentSpeed / 10.0) + 1
    }
  }
}

class Bike: Vehicle {
  override func makeNoise() {
    print("빠라바라바라밤")
  }
  
  func makeNoise(param: Int) {
    print("빠라바라바라밤")
  }
}

let bk = Bike()
bk.makeNoise()


class HybridCar: Car {
  
}

class KickBoard: Vehicle {
  
}

let h = HybridCar()
h.description // "Car: engineLevel = 0, so currentSpeed = 0.0"

let k = KickBoard()
k.description // "시간당 0.0의 속도로 이동하고 있습니다."


// 8.5 타입 캐스팅

class Vehicle2 {
  var currentSpeed = 0.0
  
  func accelerate() {
    self.currentSpeed += 1
  }
}

class Car2: Vehicle2 {
  var gear: Int {
    return Int(self.currentSpeed / 20) + 1
  }
  
  func wiper() {
    // 창을 닦습니다.
  }
}

let trans: Vehicle2 = Car2()
trans.currentSpeed
trans.accelerate()
//trans.gear // Value of type 'Vehicle2' has no member 'wiper'
//trans.wiper() // Value of type 'Vehicle2' has no member 'wiper'


//let car: Car = Vehicle() // Cannot convert value of type 'Vehicle' to specified type 'Car'


class SUV: Car2 {
  var fourWheel = false
}

let jeep: Vehicle2 = SUV()

// 함수나 메소드의 인자값을 정의할 때 하위 클래스 타입으로 선언하는 것보다 상위 클래스 타입으로 선언하면 인자값으로 사용할 수 있는 객체의 범위가 훨씬 넓어집니다.

func move(param: SUV) {
  param.accelerate()
}

func move(param: Vehicle2) {
  param.accelerate()
}
// 훨씬 넓은 범위의 객체를 인자값으로 받을 수 있습니다.

var suvList = [SUV]()
suvList.append(SUV())

var vehicleList = [Vehicle2]()
vehicleList.append(Vehicle2())
vehicleList.append(Car2())
vehicleList.append(SUV())

SUV() is SUV
SUV() is Car2 // true (일치함)
SUV() is Vehicle2 // true (일치함)

Car2() is Vehicle2 // true (일치함)
Car2() is SUV // false (일치하지 않음)

let myCar: Vehicle2 = SUV()

if myCar is SUV {
  print("myCar는 SUV 타입입니다.")
} else {
  print("myCar는 SUV 타입이 아닙니다.")
}

let newCar: Vehicle2 = Car2()

if newCar is SUV {
  print("newCar는 SUV 타입입니다.")
} else {
  print("newCar는 SUV 타입이 아닙니다.")
}



// 8.5.2 타입 캐스팅 연산

let soemCar: Vehicle2 = SUV()
// 컴파일러는 이 상수를 Vehicle 타입으로 간주.
// Vehicle 클래스에 선언된 프로퍼티나 메소드만 사용할 수 있음.

let anyCar: Car2 = SUV()
let anyVehicle = anyCar as Vehicle2

let anyCar2: Car2 = Car2()
let anySUV2 = anyCar as? SUV

anyCar.wiper()
//anyVehicle.wiper()

let anySUV = anyCar as? SUV
if anySUV != nil {
  print("\(anySUV!) 캐스팅이 성공하였습니다.")
}

if let anySUV = anyCar as? SUV {
  print("\(anySUV) 캐스팅이 성공하였습니다.")
}

//let anySUV2 = anyCar as! SUV
//print("\(anySUV2) 캐스팅이 성공하였습니다.")

// 8.5.3 Any, AnyObject


var allCar: AnyObject = Car()
allCar = SUV()

func move(_ param: AnyObject) -> AnyObject {
  return param
}

move(Car())
move(Vehicle())

var list = [AnyObject]()
list.append(Vehicle())
list.append(Car())
list.append(SUV())

let obj: AnyObject = SUV()

if let suv = obj as? SUV {
  print("\(suv) 캐스팅이 성공하였습니다.")
}

var value: Any = "Sample String"
value = 3
value = false
value = [1, 3, 4]
value = {
  print("함수가 실행됩니다.")
}

func name(_ param: Any) {
  print("\(param)")
}

name(3)
name(false)
name([1, 3, 4])
name {
  print(">>>")
}


// 8.6.1 init 초기화 메소드


struct Resolution3 {
  var width = 0
  var height = 0
  
  init(width: Int) {
    self.width = width
  }
}

class VideoMode3 {
  
  var resolution = Resolution3(width: 2048)
  var interlaced = false
  var frameRate = 0.0
  var name: String?
  
  init(interlaced: Bool) {
    self.interlaced = interlaced
  }
  
  init(interlaced: Bool, frameRate: Double) {
    self.interlaced = interlaced
    self.frameRate = frameRate
  }
}

let resolution = Resolution3.init(width: 4096)
let videoMode = VideoMode3.init(interlaced: true, frameRate: 40.0)
let videoMode2 = VideoMode3(interlaced: true)

//let defaultVideoMode = VideoMode3()
// Missing argument for parameter 'interlaced' in call


// 8.6.2 초기화 구문의 오버라이딩

//class Base {
//  var baseValue: Double
//  init(inputValue: Double) {
//    self.baseValue = inputValue
//  }
//}
//
//class ExBase: Base {
//  override init(inputValue: Double) {
//    super.init(inputValue: 10.5)
//  }
//}

//class Base {
//  var baseValue: Double
//
//  init() {
//    self.baseValue = 0.0
//    print("Base Init")
//  }
//}
//
//class ExBase: Base {
//  override init() {
//    print("ExBase Init")
//  }
//}
//
//let ex = ExBase()

class Base {
  var baseValue: Double
  
  init() {
    self.baseValue = 0.0
    print("Base Init")
  }
  
  init(baseValue: Double) {
    self.baseValue = baseValue
  }
}

class ExBase: Base {
  override init() {
    super.init()
    print("ExBase Init")
  } // 'super.init' isn't called on all paths before returning from initializer
}

let ex = ExBase()





class Vehicle3 {
    var vehicle = "vehicle"
}
class Car3: Vehicle {
    var car = "car"
}
class SUV3: Car {
    var suv = "suv"
}

let anyCar3: Car3 = Car3() // Car 본인이 어디서 상속되고 있는지 불분명 nil
//let anySUV3 = anyCar as? SUV3 // nil
//dump(anySUV3)


// 8.7 옵셔널 체인

struct Human {
  var name: String?
  var man: Bool = true
}

var boy: Human? = Human(name: "홍길동", man: true)


if boy != nil {
  if boy!.name != nil {
    print("이름은 \(boy!.name!)입니다.")
  }
}

if let b = boy {
  if let name = b.name {
    print("이름은 \(name)입니다.")
  }
}

struct Company {
  var ceo: Human?
  var companyName: String?
  
  func getCEO() -> Human? {
    return self.ceo
  }
}

var startup: Company? = Company(
  ceo: Human(name: "나대표", man: false),
  companyName: "루비페이퍼"
)

if let company = startup {
  if let ceo = company.ceo {
    if let name = ceo.name {
      print("대표이사의 이름은 \(name)입니다.")
    }
  }
}

if let name = startup!.ceo!.name {
  print("대표이사의 이름은 \(name)입니다.")
}

if let name = startup?.ceo?.name {
  print("대표이사의 이름은 \(name)입니다.")
}

startup?.ceo?.name = "찜쓰"

print(startup?.ceo?.man)

var someCompany: Company? = Company(
  ceo: Human(name: "팀쿡", man: true),
  companyName: "Apple"
)

let name = someCompany?.getCEO()?.name
if name != nil {
  print("대표이사의 이름은 \(name)입니다.")
}


// 가변 / 불변 상태

var variable: Int = 1
let constant: Int = 1

variable = 2
//constant = 2
// Cannot assign to value: 'constant' is a 'let' constant


// 1. 함수를 변수나 상수에 대입할 수 있다.

func foo(base: Int) -> String {
  print("함수 foo가 실행됩니다.")
  return "결과 값은 \(base + 1) 입니다."
}

let fn2: (Int) -> String = foo
fn2(5) // 결과 값은 6 입니다.


// 2. 함수의 반환 타입으로 함수를 사용 할 수 있다.

func plus(a: Int, b: Int) -> Int {
  return a + b
}

func calc(_ operand: String) -> (Int, Int) -> Int {
  switch operand {
  case "+":
    return plus
  default:
    return plus
  }
}

let operand: (Int, Int) -> Int = calc("+")
operand(3, 4) // 7


// 3. 함수의 인자값으로 함수를 사용 할 수 있다.

func increment(param: Int) -> Int {
  return param + 1
}

func broker(base: Int, function fn: (Int) -> Int) -> Int {
  return fn(base)
}

let x = broker(base: 4, function: increment)
print(x) // 5


// 4. 함수 내에 다른 함수를 정의해서 사용 할 수 있습니다. → 중첩 함수 (Nested Functions)

func outer(base: Int) -> String {
  
  func inner(inc: Int) -> String {
    return "\(inc)를 반환"
  }

  return inner(inc: base + 1)
}

let y = outer(base: 4)
print(y) // 5를 반환
