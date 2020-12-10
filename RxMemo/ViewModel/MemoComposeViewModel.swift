//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// 해당 Model은 ComposeScene에서 사용될 것
// ComposeScene에서는 새로운 메모 추가 or 메모 편집(수정, 삭제)
class MemoComposeViewModel : CommonViewModel {
    
    // ComposeScene에 표시할 메모를 저장하는 속성
    private let content: String? // 처음에 새로운 메모를 생성할 때는 nil, 기존의 메모를 편집할 때는 기존의 메모 내용이 들어있을 것
    
    // View에 Binding할 수 있도록 Driver추가
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    // Actions -> 추후 nav bar의 저장, 취소 버튼과 Binding
    let saveAction : Action<String, Void>  // 1. Action을 저장하는 속성
    let cancelAction: CocoaAction //  2. Action을 취소하는 속성
    
    // saveAction, cancelAction이 이렇게 parameter로 받는 이유는 viewModel에서 처리방식을 하나로 고정하지 않고
    // 이전 화면에서 동적으로 처리방식을 결정할 수 있음
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content
        
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction { // saveAction일 경우 action이 실행되고 화면을 닫음
                action.execute(input) // Action은 .execute()를 해야 실제로 실행됨
            }
            
            // saveAction이 아닐 경우 그냥 화면만 닫고 종료
            return sceneCoordinator.close(animated: true).asObservable().map { _ in  }
        }
        
        // cancelAction도 마찬가지로
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in  }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
