//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/10.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel : NSObject {
    
    // 앱을 구성하고 있는 모든 Scene은 navigationController에 emebeded되기 때문에 navigation title이 필요
    // title 속성을 추가하고 드라이버 형식으로 선언 -> Navigation Item에 쉽게 바인딩 가능
    
    let title: Driver<String> // Driver: 주로 UI요소를 바인딩할 때 (메인스레드에서 수행) 직관적인 trait
    
    
    // SceneCoordinator와 저장소를 저장하는 속성 선언, 실제 형식이 아닌 프로토콜로 선언 -> 추후 의존성을 쉽게 수정 가능
    let sceneCoordinator : SceneCoordinatorType
    let storage: MemoStorageType
    
    // 속성을 초기화하는 생성자
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
