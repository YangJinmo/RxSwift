# Study

## 1.1 스위프트 언어의 탄생과 배경

**탄생**

2014년 6월 WWDC14, iOS 8, Xcode 6, Swift 베타 버전 공개.
20년 가까이 애플 내에서 주력 언어로 사용해왔던 Objective-C를 대체할 새로운 언어를 발표.
2010년 부터 개발이 시작된 Swift는 Objective-C, Ruby, Python, C#, Rust, Haskell, CLU 등 기존의 언어와 새로운 언어들의 여러 부분을 참고하여 만들어졌다.

****

**배경**

Swift는 기존의 Objective-C가 C언어로부터 가져온 저수준 프로그래밍을 자동 관리 영역으로 대체 했고, 생소한 문법이지만 객체지향을 위해 사용할 수 밖에 없었던 스몰토크의 메시지 문법을 사람들에게 익숙한 자바, 파이썬, C#의 문법으로 바꾸었으며, Objective-C와 호환까지 가능하도록 설계되는 등 여러 가지 언어적 강점을 가지고 태어났습니다. 고급 개발자 용이 아니라, 갓 입문한 사람들도 무리 없이 사용할 수 있는 언어가 되기 위해 태어났습니다.

## 1.2 스위프트 언어의 특징

### 1.2.1 스위프트 언어에서 차용하고 있는 주요 기능들

1. 딕셔너리(해시 테이블) - 자바스크립트, 파이썬
2. 데이터 타입 추론 - 함수형 프로그래밍 언어
3. 데이터 구조체 타입 선언 - C#과 Java
4. 문자열 템플릿 - 콜드 퓨전, JSP, 파이썬 등
5. 선택사항인 세미콜론 - 자바스크립트와 파이썬
6. 프로토콜(인터페이스) - 자바와 C#
7. 튜플(Tuple) - 리스프와 파이썬
8. 자동 참조(가비지 콜렉터 비슷) - 자바, C#, 오브젝티브-C
9. 부호 있는 정수와 부호 없는 정수 - C#, 오브젝티브-C
10. 클로저(Closure) - 리스프와 스킴에서 자바스크립트까지
11. 멀티 라인 쿼우팅(Multi-Line Quoting) - 파이썬

### 1.2.2 구조적 특징

**1. Modern (현대적)**

스위프트는 파이썬 언어에 기반을 둔 읽고 쓰기 쉬운 문법을 채택했다. 그 결과, 코드 작성이나 디버깅, 유지보수 과정에서 기존의 오브젝티브-C보다 훨씬 적은 양의 코드가 사용된다. 게다가 손쉬운 유지보수를 위해 헤더 파일 사용 대신 메일 파일에 통합하여 코드를 작성할 수 있다. 스위프트는 옵셔널(Optional), 제네릭(Generics), 클로저(Closure), 튜블(Tuple) 뿐만 아니라 현대 프로그래밍 언어의 특성까지도 상당수 포함하고 있다.

**2. Safety by Design (안전 중심 설계)**

스위프트 언어 차원에서 안전성을 담보하기 위한 설계로 여러 장치를 해 두었다. 변수나 상수는 반드시 선언한 후에 사용하도록 강제하였으며 타입 추론 기능에 의해 변수의 초기값을 기준으로 타입을 정의함으로써 데이터 입력에 대한 안정성을 높이고자 하였다. 또한 스위프트는 포인터에 직접 접근하는 시도를 차단하고, 클래스를 통해 간접적으로만 레퍼런스를 참고할 수 있도록 제한했다. ARC(Auto Referencing Counter)를 이용해 자동으로 메모리르 관리하여 메모리 누수 현상에 대한 안정성도 높일 수 있다. 다른 안전 기능은 기본적으로 Swift 객체가 결코 nil이 될 수 없게 하는 것이다. 단, nil 이 유효하고 적절한 경우엔 "?" 옵셔널 타입 선언 구문을 통해 안전하게 처리할 수 있다.

**3. Fast and Powerful (빠르고 강력한 성능)**

Swift는 최초 개념 설정 시점부터 빠르게 동작하도록 만들어졌다. Swift 코드는 뛰어난 고성능 LLVM 컴파일러 기술을 사용하여 최신 하드웨어를 최대한 활용할 수 있도록 최적화된 기본 코드로 변환된다. 또한 구문 및 표준 라이브러리는 손목에 착용한 시계에서든 서버 클러스터 전반에서든, 코드를 작성하는 가장 확실한 방법으로, 최고의 성능을 발휘하도록 조정되었다. Swift는 C 및 Objective-C 언어의 후속 언어로 유형, 흐름 제어, 연산자와 같은 하위 수준 프리미티브를 포함한다. 또한 클래스, 프로토콜, 제네릭과 같은 객체 지향 기능을 제공하므로 Cocoa 및 Cocoa Touch 개발자에게 필요한 성능과 파워를 제공한다.

**4. Great First Language (탁월한 제 1언어)**

Xcode6 버전부터 애플은 스위프트 코드의 프로토타이핑을 위해 플레이그라운드(PlayGround) 편집기를 제공한다. 스위프트 코드를 작성하고, 그 결과 메모리 스택 등의 정보 확인을 즉시 확인할 수 있어 상호반응적으로 코드를 작성할 수 있으며 디버깅도 쉽다. 이러한 특징은 스위프트를 이용한 코딩의 효율성을 높여준.

### 1.2.3 문제점

**1. 컴파일 속도**

Objective-C를 사용해보진 않았지만, Objective-C에 비해 빌드 속도가 현저히 느려졌다고 한다. 근데 굳이 비교하지 않아도 빌드할 때 객관적으로 느리다. SwiftUI를 사용하지 않고 코드로 UI를 짠다면, 매번 시뮬레이터를 돌리며 View를 확인해야하는데 복장 터진다.

**2. Xcode의 전반적인 반응 속도**

Xcode PlayGround 포함해서, Swift 3.0이후 CPU가 full로 사용된다. 당연히 느려지지.

**3. 문자열 조작**

이것 때문에 알고리즘 문제를 풀 때 코드가 너무 길어보인다. 정말! 문자열 조작이 정말 불편해 죽겠다. 다른 언어에서 1줄에 끝내면 될 것을 스위프트는 2~3줄 이상을 작성해야 한다. 문자 인덱스 처리가 정말 불편.

[Apple iOS 앱 개발 언어, Swift의 탄생부터 오늘까지! (애플 스위프트 Swift 역사, Swift 업데이트 과정)](https://m.blog.naver.com/jdusans/222080069092)

## 1.3 Objective-C vs Swift

Objective-C

- Semicolons required
- Types must be declared
- Header files
- Pointers
- KVO and custom setters

Swift

- Types are inferred
- Functions are first class objects (1급 객체) → 고차 함수 (High order function) 사용 가능
- Collections are typed using generics
- Simple string manipulation
- Memory is managed automatically

First-class function

- passing functions as arguments to other functions
- returning them as the values from other functions
- assigning them to variables or storing them in data structures

[Swift VS Objective-C: What language to Choose in 2020?](https://gbksoft.com/blog/swift-vs-objective-c/)

객체지향, 프로토콜, 함수형

certification file

proviserning file

development file

uuid

distribution 배포

런타임
