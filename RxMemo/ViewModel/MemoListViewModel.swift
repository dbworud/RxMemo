//
//  MemoListViewMOdel.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoListViewModel : CommonViewModel {
    
    // 메모목록이 구현될 tableView와 Binding될 속성 : 메모목록
    var memoList : Observable<[Memo]> { // 메모 배열 방출
        return storage.memoList()
    }
    
    // 메모목록 화면 상단의 +버튼을 누르면 modal방식으로 메모쓰기 화면 표시
    // +버튼과 바인딩할 Action 구현
    // 메소드를 선언하고 리턴을 CocoaAction
    func makeAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.create(content: "")
                .flatMap { memo -> Observable<Void> in
                    // 클로저에서 화면전환 처리, sceneCoordinator와 storage는 지금 viewModel의 속성으로 바로 주입 가능
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    // 1. ComposeScene을 생성하고 연관값으로 MemoComposeViewModel을 저장
                    let composeScene = Scene.compose(composeViewModel)
                    
                    // 2. SceneCoordinator에서 에서 화면전환 메소드를 호출하고 scene을 modal방식으로 표시
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable().map{ _ in } // .asObservable() = subscribe
                    // transition의 리턴 타입은 Completable이기 때문에 map { _ in } 이용해서 Void 타입으로 전환
                }
            
        }
    }
    
    // saveAction에 대한 파라미터
    // Action<String, Void> = Input 타입이 String이고 return type이 Void = Observable이 방출하는 형식이 Void
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in // 입력값 input으로 memo update
            return self.storage.update(memo: memo, content: input) // return type은 편집된 메모 방출
                .map { _ in  } // return type이 Void가 됨
        }
    }
    
    // cancelAction을 구현하는 메소드: 생성된 메모를 삭제 (이미 makeAction에서 createMemo에서 메모를 실제로 생성하여 Observable로 방출되었기 때문)
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map{ _ in }
        }
    }
    
    // 이번에는 메소드를 구현하는 것이 아니라 속성 형태로 구현
    // 메모목록->보기 화면전환
    lazy var detailAction : Action<Memo, Void> = {
        return Action { memo in
            // 1. ViewModel 생성
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            // 2. Scene 생성
            let detailScene = Scene.detail(detailViewModel)
            
            // 3. SceneCoordinator로 transition 메소드 구현
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true) 
                .asObservable().map{ _ in }
        }
    }()

    // 테이블뷰에서 메모 삭제 구현, Never = no need to return a value
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        return Action { memo in
            // 이전화면으로 돌아가는 코드 구현없이 삭제만 하면 됨
            return self.storage.delete(memo: memo).ignoreElements() // Swift.Never 즉 리턴값이 필요없기 때문에 ignoreElements()로 completed/error 여부만 
        }
    }()
}
