# RxMemo

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

### 4. Service : 메모 저장소와 관련된 파일
- 메모리 저장소
- Coredata 저장소

### 5. Scene : 화면전환과 관련된 파일
- Cocoa 방식으로 앱을 구현할 때, 스토리보드에 scene을 추가하고 scene과 scene을 segue(세그웨이)로 연결학 segue가 자동으로 화면전환
- 스토리보드에 Scene을 추가하고, SceneCoordinator를 통해 화면 생성 및 화면 전환 
- SceneCoordinator에서 storyboard ID를 사용해서 scene push하거나 modal로 표시하는 작업 처리
- relationship Segue만 사용 (나머지는 사용X)
