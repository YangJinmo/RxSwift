## 9.2 익스텐션

객체에 새로운 기능을 추가하여 확장해주는 구문.

라이브러리나 프레임워크에 포함되어 소스코드에 직접 접근할 수 없는 객체라도 거의 제약 없이 새로운 기능을 추가할 수 있다.

- 새로운 연산 프로퍼티를 추가할 수 있습니다.
- 새로운 메소드를 정의할 수 있습니다.
- 새로운 초기화 구문을 추가할 수 있습니다.
- 네 기존 객체를 수정하지 않고 프로토콜을 구현할 수 있습니다.

```swift
extension <확장할 기존 객체명> {
	// 추가할 기능에 대한 구현 코드를 작성
}
```

### 9.2.1 익스텐션과 연산 프로퍼티

저장 프로퍼티는 추가할 수 없고, 연산 프로퍼티는 인스턴스 프로퍼티든 타입 프로퍼티든 추가할 수 있습니다.

```swift
extension Double {
  var km: Double { return self * 1_000.0 }
  var m: Double { return self }
  var cm: Double { return self / 100.0 }
  var mm: Double { return self / 1_000.0 }
  var description: String {
    "\\(self)km는 \\(self.km)m, \\(self)cm는 \\(self.cm)m, \\(self)mm는 \\(self.mm)m"
  }
}
// _ 는 자릿수 표현
2.km // 2000
5.5.cm // 0.055
125.mm // 0.125
7.0.description // "7.0km는 7000.0m, 7.0cm는 0.07m, 7.0mm는 0.007m"
let distance = 42.0.km + 195.m
print("마라톤의 총 거리는 \\(distance)m 입니다.")
// 마라톤의 총 거리는 42195.0m 입니다.
```

### 9.2.2 익스텐션과 메소드

익스텐션을 이용하면 기존 객체에 새로운 인스턴스 메소드나 타입 메소드를 정의할 수 있습니다. 매개변수 타입을 달리하면 서로 다른 메소드가 되는 메소드 오버로딩 특성을 이용해서 새로운 메소드를 정의할 수도 있고, 매개변수명을 변경하여 새로운 메소드를 작성할 수도 있습니다.

하지만 기존 객체에 사용된 같은 메소드를 익스텐션으로 재정의하는 것은 안 됩니다. 이는 오버라이딩을 뜻하는 것으로 어디까지나 클래스 객체에서 상속으로만 할 수 있는 기능이기 때문입니다.

```swift
extension Int {
  func repeatRun(task: () -> Void) {
    for _ in 0 ..< self {
      task()
    }
  }
}
```

repeatRun(task:)라는 이름으로 메소드를 정의하고 있는데, 이 메소드는 () → Void 형식의 함수를 인자값으로 입력받아 매개변수 task에 대입합니다. 물론 함수를 인자값으로 사용한가는 것은 그 대신 클로저를 인자값으로 사용할 수 있다는 뜻이기도 합니다.

인자값으로 입력받은 함수는 인자값과 반환값이 없는 형태이기만 하면 됩니다. 입력받은 함수는 Int 자료형에 할당된 값만큼 반복해서 실행하도록 구문이 작성되어 있습니다. 이를 위해 반 닫힌 범위 연산자가 사용된 것을 눈여겨 보기 바랍니다. 이렇게 확장된 Int 구조체를 사용해봅시다.

```swift
let d = 3

d.repeatRun(task: {
  print("반갑습니다!")
})

// 반갑습니다!
// 반갑습니다!
// 반갑습니다!
```

> 트레일링 클로저(Trailing Closure)

```swift
d.repeatRun {
  print("반갑습니다!")
}
```

인스턴스 메소드는 익스텐션에서도 mutating 키워드를 사용하여 인스턴스 자신을 수정하도록 허용할 수 있습니다. 구조체나 열거형에서 정의된 메소드가 자기 자신의 인스턴스를 수정하거나 프로퍼티를 변경해야할 때 mutating 키워드를 사용하는데, 익스텐션이 구조체나 열거형을 확장의 대상으로 삼았을 때가 이에 해당합니다. 이때는 본래의 구조체나 열거형에서 mutating 키워드를 추가하고 프로퍼티나 인스턴스를 수정하듯이 익스텐션에서도 동일하게 처리해주면 됩니다.

```swift
extension Int {
  mutating func square() {
    self = self * self
  }
}
var value = 3
value.square() // 9
```

Int 구조체에 익스텐션을 이용하여 square()라는 메소드를 정의하였습니다. 이 메소드는 별도의 반환값 없이 값 자체를 제곱값으로 변경해버리는 역할입니다. value에 3이 할당되었고, 값을 제곱값으로 변경하였으므로 메소드의 실행 결과는 9가 됩니다. 이때 주의할 점은 해당 메소드가 인스턴스 자체의 값을 변경하고 있으므로 값을 상수에 할당해서는 안됩니다. 즉 다음과 같이 작성하면 오류가 발생합니다.

```swift
let value = 3
value.square() // X
```

값을 변수에 할당하지 않고 다음과 같이 리터럴에 대해 직접 메소드를 호출하는 경우도 마찬가지 입니다. square() 메소드의 실행결과 인스턴스의 값 자체를 변경해야 하는데, 이렇게 변경할 곳에 리터럴 3이 들어가는 것은 상수에 값을 할당한 것과 마찬가지입니다. 메모리에 저장된 3이라는 값 자체를 다른 값으로 변경할 수는 없기 때문입니다.

```swift
3.square() // X
```

익스텐션으로 확장할 수 있는 기능에는 분명 제한적인 부분도 있겠지만, 직접 소스코드를 수정할 수 없는 라이브러리나 스위프트 언어 기반을 이루는 객체들까지 모두 확장할 수 있다는 점에서 매우 매력적인 기능임에는 분명합니다. 무엇보다 여러분이 한번 작성해놓은 스위프트 코드들을 라이버러리화한 상태에서 추가해야 할 사한이 생겼을 때 익스텐션을 사용한다면 매우 간단하게 처리할 수 있습니다.

하지만 익스텐션을 남용하면 객체의 정의를 모호하게 만들거나 각 실행 위치에 따라 서로 다른 정의로 구성된 객체를 사용하게 만드는 결과를 가져올 수 있습니다. 어느 위치에서는 익스텐션의 영향을 받아 추가된 프로퍼티나 메소드들이 제공되는데, 또 다른 위치에서는 익스텐션의 영향을 받지 않아 추가된 프로퍼티나 메소드들을 전혀 사용할 수 없는 경우가 생길수 있기 때문입니다.

또한, 객체의 정의가 파편화되기 쉬운 까닭에 객체의 정확한 구성을 파악하기 어렵다는 단점도 있습니다. 객체의 구성 요소를 정확하게 파악하려면 관련 객체의 정의 구문에 더하여 익스텐션 정의를 따라가며 기능 정의를 모두 확인해야하기 때문입니다. 익스텐션이 반드시 한 곳에서만 정의되었다는 보장도 할 수 없으므로 해당 객체의 전체 구조를 보려면 전체 소스 코드를 뒤져서 파편화된 모든 익스텐션들을 모아야만 할 수도 있습니다.

이를 방지하기 위해 익스텐션은 필요한 곳에서는 충분히 사용하되 남용하지 않고, 여기저기에 분산해서 작성하기보다는 전체적인 정의와 구조를 파악할 수 있는 위치에서 작성하는 것이 좋습니다.

### 9.2.3 익스텐션을 활용한 코드 정리

기존 소스 코드를 건드리지 않고도 원하는 내용을 확장할 수 있다는 특징 때문에, 익스텐션은 주로 라이브러리에 정의된 클래스의 기능을 추가할 때나 오버라이드할 때 사용됩니다.

```swift
final class ViewController: BaseNavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

		self.configureSubviews()
		self.configureConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }

	override func rightButtonTouched(_ button: UIButton) {

  }
}

// MARK: - Configuring

extension ViewController {
  
  func configureSubviews() {
    self.view.addSubviews(
      self.pageCollectionView,
      self.bottomPagingView
    )
  }
  
  func configureConstraints() {
    self.pageCollectionView.snp.makeConstraints {
      $0.top.equalTo(self.titleView.snp.bottom)
      $0.leading.right.equalTo(self.titleView)
      $0.height.equalTo(44)
    }
    self.bottomPagingView.snp.makeConstraints {
      $0.top.equalTo(self.pageCollectionView.snp.bottom)
      $0.leading.right.equalTo(self.titleView)
      $0.bottom.equalTo(0)
    }
  }
}

// MARK: - UIPageViewControllerDataSource

extension ViewController: UIPageViewControllerDataSource {
  
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    return nil
  }
}
```

클래스에 공식적으로 포함되어 있어야하는 메소드는 원래 클래스, 비공식적인 메소드와 델리게이트 패턴 구현은 익스텐션에 작성하였습니다.

@IBAction 어트리뷰트가 붙는 액션 메소드는 익스텐션에 작성할 수 없습니다.