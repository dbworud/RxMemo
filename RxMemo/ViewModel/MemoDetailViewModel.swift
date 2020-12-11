//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel : CommonViewModel {
    // ViewModel에서 사용할 속성
    let memo: Memo  // 1. 이전 Scene에서 전달된 메모가 저장
    
    private var formatter : DateFormatter = {
       let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.timeStyle = .medium
        f.dateStyle = .medium
        return f
    }()
    
    // 메모는 테이블뷰에 표시되는데 첫번재 cell에는 메모내용, 두번째 cell에는 날짜
    // 마찬가지로, 테이블뷰에 데이터를 표시할 때 Observable과 바인딩
    // 테이블뷰에 표시할 내용은 [내용, 날짜]
    // BehaviorSubject를 사용하는 이유: 메모를 편집한 후 보기화면으로 돌아왔을 때 편집된 내용이 반영되려면 새로운 문자열 배열을 방출해야 함
    // 일반 Observable은 불가능
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    // navigationController와 SceneCoordinator는 아무 연관이 없기 때문에 뒤로가기를 눌러도 현재화면이 pop되고 이전화면으로 돌아갈 뿐
    // currentVC, 즉 MemoDetailViewController는 다시 nil이 되어 else 문 호출
    // 따라서 back button과 close함수를 binding 필요
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable().map{ _ in }
    }
    
    // 여기에서 리턴하는 액션은 ComposeViewModel로 전달하는 Action
    
    // Subject와 binding 되어있는데 subject가 수정한 내용을 다시 방출하도록 해야 버그가 fix
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in // 입력값 input으로 memo update
            self.storage.update(memo: memo, content: input) // return type은 편집된 메모 방출
                // .map { _ in  } // return type이 Void가 됨
                // 새로운 구독자를 추가하고 subject로 업데이트된 메모를 전달
                .subscribe(onNext: { updated in
                    self.contents.onNext([
                        updated.content,
                        self.formatter.string(from: updated.insertDate)
                    ])
                })
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    // EditButton을 눌렀을 때의 Action -> 이후, DetailViewController에 있는 EditButton과 Binding
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            // 1. ComposeViewModel 생성, content 파라미터에 편집할 내용
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            // 2. ComposeScene생성
            let composeScene = Scene.compose(composeViewModel)
            
            // Scene을 modal 형식으로 표시
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable()
                .map{ _ in }
        }
        
    }
}
