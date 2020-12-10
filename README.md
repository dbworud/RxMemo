# RxMemo

## Libaray(출처: RxSwiftCommunity)
- RxSwift: enable easy composition of asynchronous operations and event/data streams
- RxCocoa: 기존의 코코아 프레임워크에 reactive library의 장점을 더함 
- RxCoreData: RxSwift + CoreData 사용 시 
- RxDataSources: data를 Observable sequence로 변환하여 UICollectionView와 UITableView에 데이터 바인딩 시 유용
- Action: provide an abstraction of observables. workFactory(몇 개의 input을 받아 observable을 리턴하는 클로저) 패턴
- NSObject-Rx: disposeBag을 일일히 선언하지 않고 .disposed(by: rx.disposeBag)

## Architecture Pattern 
- 화면전환은 MVC패턴으로(Storyboard & Segue), 나머지 부분은 MVVM으로 구현 -> 익숙하지만 의존성 주입코드가 복잡해짐
- Segue 사용하지 않고 ViewModel고 SceneCoordinator가 화면전환 처리 
- MVVM으로 구현할 경우, VM을 VC의 속성으로 추가 -> View와 VM을 Binding 

### 1. Model : 프로젝트에서 사용할 모델 
- 메모 구조체 or 클래스

### 2. ViewController 
- MVVM으로 구현할 경우, VM을 VC의 속성으로 추가 -> View와 VM을 Binding 역할을 수행하는 protocol ViewModelBindableType
- ViewModelBindableType에는 ViewController에 저장된 실제 ViewModel을 저장하고 bindViewModel()

### 3. ViewModel : 대부분의 비즈니스 로직 포함
- 의존성을 주입(DI)하는 생성자 
- Binding에 사용되는 속성과 메소드 
- ViewModel에서 1. 화면전환 2. 메모저장 처리 by using SceneCoordinaor & MemoStorage
- ViewModel을 생성하는 시점에 생성자를 통해 의존성을 주입
- RxSwift에서는 Observable과 tableView를 바인딩하는 방식으로 데이터를 표시 = DataSource를 연결할 필요X
- 메모 목록에서 메모 쓰기로 전환할 때 MemoListViewModel에서 화면전환 코드 작성 

### 4. Service : 메모 저장소와 관련된 파일
- 메모리 저장소
- Coredata 저장소

### 5. Scene : 화면전환과 관련된 파일
- Cocoa 방식으로 앱을 구현할 때, 스토리보드에 scene을 추가하고 scene과 scene을 segue(세그웨이)로 연결할 segue가 자동으로 화면전환
- 스토리보드에 Scene을 추가하고, SceneCoordinator를 통해 화면 생성 및 화면 전환 
- SceneCoordinator에서 storyboard ID를 사용해서 scene push하거나 modal로 표시하는 작업 처리
- SceneCoordinatorType이라는 protocol을 구현해서 SceneCoordinator가 공통적으로 구현해야하는 멤버 선언
- relationship Segue만 사용 (나머지는 사용X)
- 전환과 관련된 열거형(enum) 정의 + ErrorType 
