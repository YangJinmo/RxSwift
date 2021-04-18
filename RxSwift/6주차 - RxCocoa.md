## RxCocoa

- RxCocoa 란?
- ObserverType, ObservableType
  - ControlProperty
  - Binder
- Observable 바인딩하기
  - bind(to:)
- RxRelay
  - Publish Relay
  - Behavior Relay
- Driver
  - 메인 스레드에서의 실행이 보장되는 객체

## Traits

- Single
- Completable
- Maybe

------

## RxCocoa 란?

UIKit 및 Cocoa 개발을 지원하는 Rx 클래스, RxSwift의 확장

> 기존 방식과 RxCocoa를 사용한 방식 비교

```swift
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  
  let someButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 기존 방식을 사용한 처리방법
    self.someButton.addTarget(
      self,
      action: #selector(self.someButtonTouched(_:)),
      for: .touchUpInside
    )
    
    // RxCocoa를 사용한 처리방법
    self.someButton.rx.tap
      .bind { _ in
        // 버튼 액션
      }
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - Event
  
  // 기존 방식을 사용한 touchUpInside 이벤트 처리방법
  @objc func someButtonTouched(_ sender: UIButton) {
    // 버튼 액션
  }
}
```

------

## ObserverType

값을 주입(Inject)시킬 수 있는 타입

이벤트를 보내는 protocol 입니다.

Subject가 ObserverType을 채택하고 있기 때문에 이벤트를 보낼 수 있습니다.

> ObserverType 구현체

```swift
/// Supports push-style iteration over an observable sequence.
public protocol ObserverType {
    /// The type of elements in sequence that observer can observe.
    associatedtype Element

    @available(*, deprecated, message: "Use `Element` instead.")
    typealias E = Element

    /// Notify observer about sequence event.
    ///
    /// - parameter event: Event that occurred.
    func on(_ event: Event<Element>)
}

/// Convenience API extensions to provide alternate next, error, completed events
extension ObserverType {
    
    /// Convenience method equivalent to `on(.next(element: Element))`
    ///
    /// - parameter element: Next element to send to observer(s)
    public func onNext(_ element: Element) {
        self.on(.next(element))
    }
    
    /// Convenience method equivalent to `on(.completed)`
    public func onCompleted() {
        self.on(.completed)
    }
    
    /// Convenience method equivalent to `on(.error(Swift.Error))`
    /// - parameter error: Swift.Error to send to observer(s)
    public func onError(_ error: Swift.Error) {
        self.on(.error(error))
    }
}
```

------

## ObservableType

값을 관찰할 수 있는 타입

이벤트를 관찰하는 subscribe 함수가 있는 protocol 입니다.

> ObservableType 구현체

```swift
/// Represents a push style sequence.
public protocol ObservableType: ObservableConvertibleType {
    /**
    Subscribes `observer` to receive events for this sequence.
    
    ### Grammar
    
    **Next\\* (Error | Completed)?**
    
    * sequences can produce zero or more elements so zero or more `Next` events can be sent to `observer`
    * once an `Error` or `Completed` event is sent, the sequence terminates and can't produce any other elements
    
    It is possible that events are sent from different threads, but no two events can be sent concurrently to
    `observer`.
    
    ### Resource Management
    
    When sequence sends `Complete` or `Error` event all internal resources that compute sequence elements
    will be freed.
    
    To cancel production of sequence elements and free resources immediately, call `dispose` on returned
    subscription.
    
    - returns: Subscription for `observer` that can be used to cancel production of sequence elements and free resources.
    */
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element
}

extension ObservableType {
    
    /// Default implementation of converting `ObservableType` to `Observable`.
    public func asObservable() -> Observable<Element> {
        // temporary workaround
        //return Observable.create(subscribe: self.subscribe)
        return Observable.create { o in
            return self.subscribe(o)
        }
    }
}
```

------

## ControlProperty

ObservableType과 ObserverType을 채택한 ControlPropertyType를 채택한 구조체로

Subject 처럼 프로퍼티에 새 값을 주입시킬 수 있고 (ObserverType), 값의 변화도 관찰할 수 있는 타입 (ObservableType).

> ControlProperty 구현체

```swift
public struct ControlProperty<PropertyType> : ControlPropertyType {
    public typealias Element = PropertyType

    let _values: Observable<PropertyType>
    let _valueSink: AnyObserver<PropertyType>

    /// Initializes control property with a observable sequence that represents property values and observer that enables
    /// binding values to property.
    ///
    /// - parameter values: Observable sequence that represents property values.
    /// - parameter valueSink: Observer that enables binding values to control property.
    /// - returns: Control property created with a observable sequence of values and an observer that enables binding values
    /// to property.
    public init<Values: ObservableType, Sink: ObserverType>(values: Values, valueSink: Sink) where Element == Values.Element, Element == Sink.Element {
        self._values = values.subscribeOn(ConcurrentMainScheduler.instance)
        self._valueSink = valueSink.asObserver()
    }

    /// Subscribes an observer to control property values.
    ///
    /// - parameter observer: Observer to subscribe to property values.
    /// - returns: Disposable object that can be used to unsubscribe the observer from receiving control property values.
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._values.subscribe(observer)
    }

    /// `ControlEvent` of user initiated value changes. Every time user updates control value change event
    /// will be emitted from `changed` event.
    ///
    /// Programmatic changes to control value won't be reported.
    ///
    /// It contains all control property values except for first one.
    ///
    /// The name only implies that sequence element will be generated once user changes a value and not that
    /// adjacent sequence values need to be different (e.g. because of interaction between programmatic and user updates,
    /// or for any other reason).
    public var changed: ControlEvent<PropertyType> {
        return ControlEvent(events: self._values.skip(1))
    }

    /// - returns: `Observable` interface.
    public func asObservable() -> Observable<Element> {
        return self._values
    }

    /// - returns: `ControlProperty` interface.
    public func asControlProperty() -> ControlProperty<Element> {
        return self
    }

    /// Binds event to user interface.
    ///
    /// - In case next element is received, it is being set to control value.
    /// - In case error is received, DEBUG buids raise fatal error, RELEASE builds log event to standard output.
    /// - In case sequence completes, nothing happens.
    public func on(_ event: Event<Element>) {
        switch event {
        case .error(let error):
            bindingError(error)
        case .next:
            self._valueSink.on(event)
        case .completed:
            self._valueSink.on(event)
        }
    }
}

extension ControlPropertyType where Element == String? {
    /// Transforms control property of type `String?` into control property of type `String`.
    public var orEmpty: ControlProperty<String> {
        let original: ControlProperty<String?> = self.asControlProperty()

        let values: Observable<String> = original._values.map { $0 ?? "" }
        let valueSink: AnyObserver<String> = original._valueSink.mapObserver { $0 }
        return ControlProperty<String>(values: values, valueSink: valueSink)
    }
}
```

> ControlPropertyType 구현체

```swift
/// Protocol that enables extension of `ControlProperty`.
public protocol ControlPropertyType : ObservableType, ObserverType {

    /// - returns: `ControlProperty` interface
    func asControlProperty() -> ControlProperty<Element>
}
```

------

## Binder

ObserverType을 채택한 구조체로 값을 생성해내고 주입할 수는 있으나 값을 관찰할 수는 없음.

- `error` 이벤트를 방출할 수 없음.
- `RxCocoa` 에서 `binding`은 Publisher에서 Subscriber로 향하는 단방향 binding임.
- `bind(to:)` 메소드는 `subscribe()` 의 별칭
- `bind(to: observer)` 를 호출하게 되면 `subscribe(observer)` 가 실행됨.

> Binder 구현체

```swift
/**
 Observer that enforces interface binding rules:
 * can't bind errors (in debug builds binding of errors causes `fatalError` in release builds errors are being logged)
 * ensures binding is performed on a specific scheduler

 `Binder` doesn't retain target and in case target is released, element isn't bound.
 
 By default it binds elements on main scheduler.
 */
public struct Binder<Value>: ObserverType {
    public typealias Element = Value
    
    private let _binding: (Event<Value>) -> Void

    /// Initializes `Binder`
    ///
    /// - parameter target: Target object.
    /// - parameter scheduler: Scheduler used to bind the events.
    /// - parameter binding: Binding logic.
    public init<Target: AnyObject>(_ target: Target, scheduler: ImmediateSchedulerType = MainScheduler(), binding: @escaping (Target, Value) -> Void) {
        weak var weakTarget = target

        self._binding = { event in
            switch event {
            case .next(let element):
                _ = scheduler.schedule(element) { element in
                    if let target = weakTarget {
                        binding(target, element)
                    }
                    return Disposables.create()
                }
            case .error(let error):
                bindingError(error)
            case .completed:
                break
            }
        }
    }

    /// Binds next element to owner view as described in `binding`.
    public func on(_ event: Event<Value>) {
        self._binding(event)
    }

    /// Erases type of observer.
    ///
    /// - returns: type erased observer.
    public func asObserver() -> AnyObserver<Value> {
        return AnyObserver(eventHandler: self.on)
    }
}
```

------

## Observable 바인딩하기

- Observable에 여러 개의 Observer를 바인드 하는 bind(to:) 함수가 있습니다.
- RxCocoa에서 ControlProperty에서 bind함수를 호출해서 Observer를 파라미터로 넣어주고 Observable에서 bind함수를 호출해서 Binder를 파라미터로 넣어줍니다.

> 예시

```swift
class ViewController: UIViewController {

  // MARK: - UI

	let someButton: UIButton = {
    let button = UIButton()
    return button
  }()

	let valueLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

		someButton.rx.tap
			.map { "Hello, RxCocoa" }
			.bind(to: valueLabel.rx.text)
			.disposed(by: bag)
  }
}
```

`tap` 속성은 ControlEvent 형식으로 선언되어 있고, TouchUpInside Event가 발생하면 Next Event를 방출하는 특별한 Observable이다.

이때 `map` 연산자를 사용하면 `tap`에서 방출된 Next Event를 문자열로 바꿀 수 있다.

이후, 구독자를 추가해야 Observable이 생성되고 이벤트를 방출하기 시작할 것이다.

RxSwift에서는 구독자를 추가할 때 `subscribe` 메소드를 이용했는데, RxCocoa는 더 쉬운 방법을 제공한다.

`bind` 메소드인데, 이렇게 하면 전달된 문자열이 `valueLabel` 의 `rx.text` 속성에 바인딩된다.

실행하여 버튼을 탭하면 Label이 업데이트된다.

------

## RxRelay

Relay는 기존의 Variable을 대체하기 위한 개념입니다.(정확히는 BehaviorRelay가 Variable을 대체합니다.) Variable이라는 이름에서 알 수 있듯 일반적인 변수를 대체해서 사용하기 위한 타입이였는데, Rx보다는 기존 상태기계(State Machine)에 더 가까워서 이를 대체하기 위해 나온 것이 Relay입니다.

Relay는 RxRelay패키지에 정의되어 있기 때문에, 사용하기 위해서는 RxRelay 패키지를 임포트( import) 해야 합니다. 하지만 RxCocoa 패키지가 내부적으로 이미 임포트 하고 있기 때문에 RxCocoa를 쓰신다면 따로 임포트 할 필요는 없습니다.

Relay는 Subject의 Wrapper 클래스라고 볼 수 있습니다. 대신 Subject와는 다른 특징을 가지고 있는데 바로 **절대 종료이벤트로 인해 종료되지 않는다는 것입니다.**

Relay는 아예 이벤트 객체를 받는 on() 메소드가 구현되어 있지 않기 때문에 이벤트를 바로 넘길 수는 없습니다. 대신 accept()라는 메소드를 대신 사용하는데, 이 메소드는 **값**을 인자로 받습니다. accept() 메소드는 값을 인자로 받아 next 이벤트로 감싸 내부의 Subject에게 흘려보냅니다.

error나 complete를 전달할 수 없고 next로 값(이벤트)만 전달할 수 있습니다.

Subject는 4종류가 있었는데, Relay는 이 중 BehaviorSubject, PublishSubject를 래핑한 BehaviorRelay, PublishRelay를 제공합니다. 기존 Subject의 경우와 마찬가지로 최근의 상태값을 가지고 구독시 이를 방출하는지 여부로 구분해서 사용하시면 됩니다.

Relay에 대해서 찾아보신 분들은 ‘Relay를 bind하는 것은 지양해야 한다’는 말을 들어보신 적이 있을 것입니다. 하지만 RxRelay에서는 옵저버블과 Relay를 bind하는 메소드를 제공해주고 있습니다.

```swift
// PublishRelay에 대한 bind 메소드. BehaviorRelay도 타입 빼고 같은 내용의 메소드가 있다. 
public func bind(to relays: PublishRelay<Element>...) -> Disposable {
    return bind(to: relays)
}

private func bind(to relays: [PublishRelay<Element>]) -> Disposable {
    return subscribe { e in
        switch e {
        case let .next(element):
            relays.forEach {
                $0.accept(element) // Relay 내부의 Subject에 next이벤트를 흘려보낸다.
            }
        case let .error(error):
						// 디버그 모드면 런타임 에러를, 릴리즈 모드면 그냥 에러 메시지를 print만 한다.
            // 즉, 어떻게 해서든 내부 subject에 에러가 흘러가지를 않는다.
            rxFatalErrorInDebug("Binding error to publish relay: \\(error)")
        case .completed:
            break
        }
    }
}
```

## PublishSubject

- 구독한 시점부터 전달되는 데이터를 소비하는 Observable입니다.
- 초기값이 없는 상태를 나타낼때 사용합니다.

> PublishSubject 구현체

```swift
/// PublishRelay is a wrapper for `PublishSubject`.
///
/// Unlike `PublishSubject` it can't terminate with error or completed.
public final class PublishRelay<Element>: ObservableType {
    private let _subject: PublishSubject<Element>

    // Accepts `event` and emits it to subscribers
    public func accept(_ event: Element) {
        self._subject.onNext(event)
    }

    /// Initializes with internal empty subject.
    public init() {
        self._subject = PublishSubject()
    }

    /// Subscribes observer
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}
```

## BehaviorRelay

- 구독한 시점에 가장 최근에 전달된 데이터를 먼저 소비하고 그 이후로 전달되는 데이터를 소비하는 Observable입니다.
- 초기값이 있는 상태를 나타낼때 사용합니다.

> BehaviorRelay 구현체

```swift
/// BehaviorRelay is a wrapper for `BehaviorSubject`.
///
/// Unlike `BehaviorSubject` it can't terminate with error or completed.
public final class BehaviorRelay<Element>: ObservableType {
    private let _subject: BehaviorSubject<Element>

    /// Accepts `event` and emits it to subscribers
    public func accept(_ event: Element) {
        self._subject.onNext(event)
    }

    /// Current value of behavior subject
    public var value: Element {
        // this try! is ok because subject can't error out or be disposed
        return try! self._subject.value()
    }

    /// Initializes behavior relay with initial value.
    public init(value: Element) {
        self._subject = BehaviorSubject(value: value)
    }

    /// Subscribes observer
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}
```

------

------

## Traits

- General
  - [Why](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#why)
  - [How they work](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#how-they-work)
- RxSwift traits
  - Single
    - [Creating a Single](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#creating-a-single)
  - Completable
    - [Creating a Completable](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#creating-a-completable)
  - Maybe
    - [Creating a Maybe](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#creating-a-maybe)
- RxCocoa traits
  - Driver
    - [Why is it named Driver](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#why-is-it-named-driver)
    - [Practical usage example](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#practical-usage-example)
  - [Signal](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#signal)
  - [ControlProperty / ControlEvent](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md#controlproperty--controlevent)

### **Why**

Swift has a powerful type system that can be used to improve the correctness and stability of applications and make using Rx a more intuitive and straightforward experience.

Swift는 애플리케이션의 정확성과 안정성을 개선하고 Rx를 보다 단정하고 안정적인 경험으로 만드는 데 사용할 수 있는 강력한 유형 시스템을 가지고 있습니다.

Traits help communicate and ensure observable sequence properties across interface boundaries, as well as provide contextual meaning, syntactical sugar and target more specific use-cases when compared to a raw Observable, which could be used in any context. **For that reason, Traits are entirely optional. You are free to use raw Observable sequences everywhere in your program as all core RxSwift/RxCocoa APIs support them.**

특성은 모든 컨텍스트에서 사용할 수있는 원시 Observable과 비교할 때 컨텍스트 의미, 구문적 달콤함 및 더 구체적인 사용 사례를 제공할뿐만 아니라 인터페이스 경계를 넘어서 관찰 가능한 시퀀스 속성을 전달하고 보장하는데 도움이됩니다. 따라서 특성은 전적으로 선택 사항입니다. 모든 핵심 RxSwift / RxCocoa API가 지원하므로 프로그램의 모든 곳에서 원시 Observable 시퀀스를 자유롭게 사용할 수 있습니다.

- syntactical sugar: https://en.wikipedia.org/wiki/Syntactic_sugar

***Note:** Some of the Traits described in this document (such as `Driver`) are specific only to the [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/main/RxCocoa) project, while some are part of the general [RxSwift](https://github.com/ReactiveX/RxSwift) project. However, the same principles could easily be implemented in other Rx implementations, if necessary. There is no private API magic needed.*

참고 :이 문서에 설명 된 일부 특성 (예 : *`Driver`*)은 RxCocoa 프로젝트에만 해당되는 반면 일부는 일반적인 RxSwift 프로젝트의 일부입니다. 그러나 필요한 경우 다른 Rx 구현에서도 동일한 원칙을 쉽게 구현할 수 있습니다. 개인 API 마법이 필요하지 않습니다.

### **How they work**

Traits are simply a wrapper struct with a single read-only Observable sequence property.

Traits들은 단일의 읽기 전용 Observable 시퀀스 속성이 있는 단순 래퍼 구조체입니다.

```swift
struct Single<Element> {
    let source: Observable<Element>
}

struct Driver<Element> {
    let source: Observable<Element>
}
...
```

You can think of them as a kind of builder pattern implementation for Observable sequences. When a Trait is built, calling `.asObservable()` will transform it back into a vanilla observable sequence.

Observable 시퀀스에 대한 일종의 빌더 패턴 구현으로 생각할 수 있습니다. Trait이 빌드 될 때 .asObservable ()을 호출하면 원래의 관찰 가능한 시퀀스로 다시 변환됩니다.

------

## RxSwift traits

### Single (단 하나의, 단일의)

A Single is a variation of Observable that, instead of emitting a series of elements, is always guaranteed to emit either *a single element* or *an error*.

Single은 일련의 요소를 내보내는 대신 항상 단일 요소 또는 오류를 내보내도록 보장되는 Observable의 변형입니다.

- Emits exactly one element, or an error. 정확히 하나의 요소 또는 오류를 내 보냅니다.
- Doesn't share side effects. 부작용을 공유하지 않습니다.

One common use case for using Single is for performing HTTP Requests that could only return a response or an error, but a Single can be used to model any case where you only care for a single element, and not for an infinite stream of elements.

Single을 사용하는 일반적인 사용 사례 중 하나는 응답이나 오류만 반환 할 수 있는 HTTP 요청을 수행하는 것입니다. 그러나 Single은 요소의 무한 스트림이 아닌 단일 요소 만 신경 쓰는 모든 경우를 모델링하는 데 사용할 수 있습니다.

### Completable (전부 갖출 수 있는 , 완성할 수 있는.)

A Completable is a variation of Observable that can only *complete* or *emit an error*. It is guaranteed to not emit any elements.

Completable은 완료 또는 오류만 발생시킬 수 있는 Observable의 변형입니다. 어떤 요소도 방출하지 않는 것이 보장됩니다.

- Emits zero elements. 0 개의 요소를 방출합니다.
- Emits a completion event, or an error. 완료 이벤트 또는 오류를 내보냅니다.
- Doesn't share side effects. 부작용을 공유하지 않습니다.

A useful use case for Completable would be to model any case where we only care for the fact an operation has completed, but don't care about a element resulted by that completion. You could compare it to using an `Observable<Void>` that can't emit elements.

Completable의 유용한 사용 사례는 작업이 완료된 사실만 신경 쓰고 그 완료로 인한 요소는 신경 쓰지 않는 경우를 모델링하는 것입니다. 요소를 내보낼 수 없는 `Observable <Void>`를 사용하는 것과 비교할 수 있습니다.

### Maybe (어쩌면, 아마)

A Maybe is a variation of Observable that is right in between a Single and a Completable. It can either emit a single element, complete without emitting an element, or emit an error.

Maybe는 Single과 Completable 사이에 있는 Observable의 변형입니다. 단일 요소를 방출하거나 요소를 방출하지 않고 완료하거나 오류를 방출 할 수 있습니다.

**Note:** Any of these three events would terminate the Maybe, meaning - a Maybe that completed can't also emit an element, and a Maybe that emitted an element can't also send a Completion event.

참고: 이 세 가지 이벤트 중 하나라도 Maybe가 종료됩니다. 즉, 완료된 Maybe는 요소도 내보낼 수 없고, Maybe는 요소를 내보낸 Maybe도 Completion 이벤트를 보낼 수 없습니다.

- Emits either a completed event, a single element or an error. 완료된 이벤트, 단일 요소 또는 오류를 내보냅니다.
- Doesn't share side effects. 부작용을 공유하지 않습니다.

You could use Maybe to model any operation that **could** emit an element, but doesn't necessarily **have to** emit an element.

Maybe를 사용하여 요소를 내보낼 수 있지만 반드시 요소를 내보낼 필요는 없는 작업을 모델링 할 수 있습니다.

------

## RxCocoa traits

### **Driver**

This is the most elaborate trait. Its intention is to provide an intuitive way to write reactive code in the UI layer, or for any case where you want to model a stream of data *Driving* your application.

이것이 가장 정교한 특성입니다. 그 목적은 UI 레이어에 반응 형 코드를 작성하는 직관적인 방법을 제공하거나 애플리케이션을 구동하는 데이터 스트림을 모델링하려는 경우에 제공하는 것입니다.

- Can't error out. 오류를 내보낼 수 없습니다.
- Observe occurs on main scheduler. 관찰은 메인 스케줄러에서 발생합니다.
- Shares side effects (`share(replay: 1, scope: .whileConnected)`). 부작용을 공유합니다 (`share(replay: 1, scope: .whileConnected)`).

### **Why is it named Driver**

Its intended use case was to model sequences that drive your application.

의도된 사용 사례는 애플리케이션을 구동하는 시퀀스를 모델링하는 것이었습니다.

E.g.

- Drive UI from CoreData model. Core Data 모델에서 GUI를 구동합니다.
- Drive UI using values from other UI elements (bindings). ... 다른 UI 요소 (바인딩)의 값을 사용하여 UI를 구동합니다. ...

Like normal operating system drivers, in case a sequence errors out, your application will stop responding to user input.

일반 운영 체제 드라이버와 마찬가지로 시퀀스 오류가 발생하면 응용 프로그램이 사용자 입력에 응답하지 않습니다.

It is also extremely important that those elements are observed on the main thread because UI elements and application logic are usually not thread safe.

UI 요소와 응용 프로그램 논리는 일반적으로 스레드로부터 안전하지 않기 때문에 이러한 요소가 기본 스레드에서 관찰되는 것도 매우 중요합니다.

Also, a `Driver` builds an observable sequence that shares side effects.

또한 `Driver`는 부작용을 공유하는 관찰 가능한 시퀀스를 빌드합니다.

E.g.

### **Practical usage example**

This is a typical beginner example.

```swift
let results = query.rx.text
    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
    .flatMapLatest { query in
        fetchAutoCompleteItems(query)
    }

results
    .map { "\\($0.count)" }
    .bind(to: resultCount.rx.text)
    .disposed(by: disposeBag)

results
    .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
        cell.textLabel?.text = "\\(result)"
    }
    .disposed(by: disposeBag)
```

The intended behavior of this code was to: 이 코드의 의도 된 동작은 다음과 같습니다.

- Throttle user input. 사용자 입력을 제한합니다.
- Contact server and fetch a list of user results (once per query). 서버에 접속하여 사용자 결과 목록을 가져옵니다 (쿼리 당 한 번).
- Bind the results to two UI elements: results table view and a label that displays the number of results. 결과를 결과 테이블보기와 결과 수를 표시하는 레이블의 두 UI 요소에 바인딩합니다.

So, what are the problems with this code?:

그렇다면이 코드의 문제점은 무엇입니까? :

- If the `fetchAutoCompleteItems` observable sequence errors out (connection failed or parsing error), this error would unbind everything and the UI wouldn't respond any more to new queries. `fetchAutoCompleteItems` 관찰 가능한 시퀀스 오류가 발생하면 (연결 실패 또는 파싱 오류)이 오류는 모든 바인딩을 해제하고 UI가 더 이상 새 쿼리에 응답하지 않습니다.
- If `fetchAutoCompleteItems` returns results on some background thread, results would be bound to UI elements from a background thread which could cause non-deterministic crashes. fetchAutoCompleteItems가 일부 백그라운드 스레드에서 결과를 반환하면 결과가 백그라운드 스레드의 UI 요소에 바인딩되어 비 결정적 비정상 종료가 발생할 수 있습니다.
- Results are bound to two UI elements, which means that for each user query, two HTTP requests would be made, one for each UI element, which is not the intended behavior. 결과는 두 개의 UI 요소에 바인딩됩니다. 즉, 각 사용자 쿼리에 대해 의도 된 동작이 아닌 각 UI 요소에 대해 하나씩 두 개의 HTTP 요청이 만들어집니다.

A more appropriate version of the code would look like this:

더 적절한 버전의 코드는 다음과 같습니다.

```swift
let results = query.rx.text
    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
    .flatMapLatest { query in
        fetchAutoCompleteItems(query)
            .observeOn(MainScheduler.instance)  // results are returned on MainScheduler
            .catchErrorJustReturn([])           // in the worst case, errors are handled
    }
    .share(replay: 1)                           // HTTP requests are shared and results replayed
                                                // to all UI elements
results
    .map { "\\($0.count)" }
    .bind(to: resultCount.rx.text)
    .disposed(by: disposeBag)

results
    .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
        cell.textLabel?.text = "\\(result)"
    }
    .disposed(by: disposeBa
```

Making sure all of these requirements are properly handled in large systems can be challenging, but there is a simpler way of using the compiler and traits to prove these requirements are met.

이러한 모든 요구 사항이 대규모 시스템에서 제대로 처리되는지 확인하는 것은 어려울 수 있지만 컴파일러와 특성을 사용하여 이러한 요구 사항이 충족되었음을 증명하는 더 간단한 방법이 있습니다.

The following code looks almost the same:

다음 코드는 거의 동일합니다.

```swift
let results = query.rx.text.asDriver()        // This converts a normal sequence into a `Driver` sequence.
    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
    .flatMapLatest { query in
        fetchAutoCompleteItems(query)
            .asDriver(onErrorJustReturn: [])  // Builder just needs info about what to return in case of error.
    }

results
    .map { "\\($0.count)" }
    .drive(resultCount.rx.text)               // If there is a `drive` method available instead of `bind(to:)`,
    .disposed(by: disposeBag)              // that means that the compiler has proven that all properties
                                              // are satisfied.
results
    .drive(resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
        cell.textLabel?.text = "\\(result)"
    }
    .disposed(by: disposeBag)
```

So what is happening here?

그래서 여기서 무슨 일이 일어나고 있습니까?

This first `asDriver` method converts the `ControlProperty` trait to a `Driver` trait.

이 첫번째 asDriver 메소드는 ControlProperty trait를 드라이버 trait로 변환합니다.

```swift
query.rx.text.asDriver()
```

Notice that there wasn't anything special that needed to be done. `Driver` has all of the properties of the `ControlProperty` trait, plus some more. The underlying observable sequence is just wrapped as a `Driver` trait, and that's it.

수행해야 할 특별한 사항이 없음에 유의하십시오. Driver에는 ControlProperty trait의 모든 속성과 그 밖의 여러 속성이 있습니다. 기본 관찰 가능 시퀀스는 드라이버 trait로 래핑되며 그게 전부입니다.

The second change is:

두 번째 변경 사항은 다음과 같습니다.

```swift
.asDriver(onErrorJustReturn: [])
```

Any observable sequence can be converted to `Driver` trait, as long as it satisfies 3 properties:

관찰 가능한 모든 시퀀스는 3 가지 속성을 충족하는 한 `Driver` trait로 변환할 수 있습니다.

- Can't error out. 오류를 내보낼 수 없습니다.
- Observe on main scheduler. 메인 스케줄러를 관찰하십시오.
- Sharing side effects (`share(replay: 1, scope: .whileConnected)`). 부작용 공유 (`share (replay : 1, scope : .whileConnected)`).

So how do you make sure those properties are satisfied? Just use normal Rx operators. `asDriver(onErrorJustReturn: [])` is equivalent to following code.

그렇다면 이러한 속성이 충족되는지 어떻게 확인합니까? 일반 Rx 연산자를 사용하십시오. `asDriver (onErrorJustReturn : [])` 다음 코드와 동일합니다.

```swift
let safeSequence = xs
  .observeOn(MainScheduler.instance)        // observe events on main scheduler
  .catchErrorJustReturn(onErrorJustReturn)  // can't error out
  .share(replay: 1, scope: .whileConnected) // side effects sharing

return Driver(raw: safeSequence)            // wrap it up
```

The final piece is using `drive` instead of using `bind(to:)`.

마지막 부분은 `bind(to:)`를 사용하는 대신 `drive`를 사용하는 것입니다.

`drive` is defined only on the `Driver` trait. This means that if you see `drive` somewhere in code, that observable sequence can never error out and it observes on the main thread, which is safe for binding to a UI element.

`drive`는 `Driver` 특성에서만 정의됩니다. 즉, 코드에서 `drive`가 표시되는 경우 관찰 가능한 시퀀스는 오류가 발생하지 않으며 UI 요소에 바인딩하기에 안전한 기본 스레드에서 관찰됩니다.

Note however that, theoretically, someone could still define a `drive` method to work on `ObservableType` or some other interface, so to be extra safe, creating a temporary definition with `let results: Driver<[Results]> = ...` before binding to UI elements would be necessary for complete proof. However, we'll leave it up to the reader to decide whether this is a realistic scenario or not.

그러나 이론적으로 누군가는 ObservableType 또는 다른 인터페이스에서 작동하는 드라이브 방법을 정의 할 수 있으므로 더욱 안전하게 `let results: Driver<[Results]> = ...`로 임시 정의를 생성할 수 있습니다. UI 요소에 바인딩하기 전에 완전한 증명을 위해 필요합니다. 그러나 이것이 현실적인 시나리오인지 아닌지를 결정하는 것은 독자에게 맡길 것입니다.

### **Signal (신호)**

A `Signal` is similar to `Driver` with one difference, it does **not** replay the latest event on subscription, but subscribers still share the sequence's computational resources.

신호는 Driver와 유사하지만 한 가지 차이점이 있습니다. 구독시 최신 이벤트를 재생하지 않지만 구독자는 여전히 시퀀스의 계산 리소스를 공유합니다.

It can be considered a builder pattern to model Imperative Events in a Reactive way as part of your application.

애플리케이션의 일부로 반응 방식으로 명령형 이벤트를 모델링하는 것은 빌더 패턴으로 간주 될 수 있습니다.

A `Signal`:

- Can't error out. 오류를 내보낼 수 없습니다.
- Delivers events on Main Scheduler. 메인 스케줄러에서 이벤트를 전달합니다.
- Shares computational resources (`share(scope: .whileConnected)`). 계산 리소스를 공유합니다 (`share (scope : .whileConnected)`).
- Does NOT replay elements on subscription. 구독에서 요소를 재생하지 않습니다.

## **ControlProperty / ControlEvent**

### **ControlProperty (제어 속성)**

Trait for `Observable`/`ObservableType` that represents a property of UI element.

Sequence of values only represents initial control value and user initiated value changes. Programmatic value changes won't be reported.

It's properties are:

- it never fails

- ```
  share(replay: 1)
  ```

   behavior

  - it's stateful, upon subscription (calling subscribe) last element is immediately replayed if it was produced

- it will `Complete` sequence on control being deallocated

- it never errors out

- it delivers events on `MainScheduler.instance`

The implementation of `ControlProperty` will ensure that sequence of events is being subscribed on main scheduler (`subscribeOn(ConcurrentMainScheduler.instance)` behavior).

### **Practical usage example**

We can find very good practical examples in the `UISearchBar+Rx` and in the `UISegmentedControl+Rx`:

```swift
extension Reactive where Base: UISearchBar {
    /// Reactive wrapper for `text` property.
    public var value: ControlProperty<String?> {
        let source: Observable<String?> = Observable.deferred { [weak searchBar = self.base as UISearchBar] () -> Observable<String?> in
            let text = searchBar?.text
            
            return (searchBar?.rx.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBar(_:textDidChange:))) ?? Observable.empty())
                    .map { a in
                        return a[1] as? String
                    }
                    .startWith(text)
        }

        let bindingObserver = Binder(self.base) { (searchBar, text: String?) in
            searchBar.text = text
        }
        
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}

extension Reactive where Base: UISegmentedControl {
    /// Reactive wrapper for `selectedSegmentIndex` property.
    public var selectedSegmentIndex: ControlProperty<Int> {
        value
    }
    
    /// Reactive wrapper for `selectedSegmentIndex` property.
    public var value: ControlProperty<Int> {
        return UIControl.rx.value(
            self.base,
            getter: { segmentedControl in
                segmentedControl.selectedSegmentIndex
            }, setter: { segmentedControl, value in
                segmentedControl.selectedSegmentIndex = value
            }
        )
    }
}
```

### **ControlEvent**

Trait for `Observable`/`ObservableType` that represents an event on a UI element.

It's properties are:

- it never fails
- it won't send any initial value on subscription
- it will `Complete` sequence on control being deallocated
- it never errors out
- it delivers events on `MainScheduler.instance`

The implementation of `ControlEvent` will ensure that sequence of events is being subscribed on main scheduler (`subscribeOn(ConcurrentMainScheduler.instance)` behavior).

### **Practical usage example**

This is a typical case example in which you can use it:

```swift
public extension Reactive where Base: UIViewController {
    
    /// Reactive wrapper for `viewDidLoad` message `UIViewController:viewDidLoad:`.
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
}
```

And in the `UICollectionView+Rx` we can found it in this way:

```swift
extension Reactive where Base: UICollectionView {
    
    /// Reactive wrapper for `delegate` message `collectionView:didSelectItemAtIndexPath:`.
    public var itemSelected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { a in
                return a[1] as! IndexPath
            }
        
        return ControlEvent(events: source)
    }
}
```

RxCocoa는 `bind(to:)` 외에도 Cocoa 프레임워크와 UIKit에 대한 진보된 기능들을 제공합니다.

해당 기능들을 담당하는 것을 `Trait`이라고 칭하며 이는 UI 처리에 특화된 Observable 항목의 특수 구현을 제공합니다.

`Trait` 는 UI 작업에 대하여 직관적이고 작성하기 쉬운 코드를 작성하는데 도움이 되는 Observable 특수 클래스 입니다.

**ControlProperty 와 Driver**

**Trait**의 특장점은 앞서 살펴봤으나 다시 한번 정리하겠습니다.

- Trait은 에러 방출이 불가합니다.
- Trait은 메인 스케줄러에서 관찰 / 구독 합니다.
- Trait은 부수작용들을 공유합니다.

RxCocoa에서 제공하는 Trait은 아래와 같습니다.

- `ControlProperty`: 데이터를 UI에 바인딩할 떄 rx 익스텐션을 통해 사용합니다.
- `ControlEvent`: UI 컴포넌트에서의 이벤트 리스너 역할을 합니다. (ex: 텍스트필드에서의 리턴 버튼 터치)
- `Driver`: 에러를 방출하지 않는 특별한 Observable 입니다. 모든 과정은 메인 스레드에서 이루어집니다.

Trait을 이용하면 앞서 UI 작업을 위해 호출했던 `.observeOn(MainScheduler.instance)` 와 같은 메소드는 잊어버려도 좋습니다.

기존의 코드를 `ControlProperty` 와 `Driver`를 이용하여 리팩토링 해보겠습니다.

```swift
let search = searchCityName.rx.text
  .filter { ($0 ?? "").count > 0 }
  .flatMapLatest {
		textinreturnApiController.shared.currentWeather(city: text ?? "Error")
  }
  .asDriver(onErrorJustReturn:ApiController.Weather.empty)   // error 핸들링
```

위 코드에서 중요한 부분은 제일 마지막 줄 입니다.

`.asDriver` 메소드를 통해 `Observable<Weather>` 를 `Driver<Weather>` 타입으로 변환하며 방출된 에러에 대한 핸들링을 진행합니다.

이후, `Observable` 에서는 `bind(to:)` 메소드를 통해 바인딩 했으나 `Driver`는 `drive()` 메소드를 이용합니다.

따라서 바인딩 로직 코드를 아래와 같이 고쳐줍니다.

```swift
search.map { "\\($0.temperature)℃"}
  .drive(tempLabel.rx.text)
  .disposed(by: disposeBag)

search.map { "\\($0.humidity)%" }
  .drive(humidityLabel.rx.text)
  .disposed(by: disposeBag)

search.map { $0.cityName }
  .drive(cityNameLabel.rx.text)
  .disposed(by: disposeBag)

search.map { $0.icon }
  .drive(iconLabel.rx.text)
  .disposed(by: disposeBag)
```

## Driver

- error를 전달하지 않고 MainScheduler에서 값(이벤트)를 전달하는 struct 입니다.
- 데이터를 가져와서 MainScheduler에서 ui를 갱신해야할 때 사용됩니다.
- asDriver()함수로 ControlProperty를 Driver로 변경할 수 있습니다.
- Driver를 구독하기 위해서는 drive()함수를 사용합니다.