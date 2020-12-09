//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    // 1. 새로운 Scene을 표시.  Completable로 리턴하는데 오로지 complete/error만 전달하고 결과값은 전달하지 않음
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated : Bool) -> Completable
    
    // 2. 현재 Scene을 닫고 이전 Scene으로 돌아감
    @discardableResult
    func close(animated: Bool) -> Completable
    
    // 구독자를 추가하고 화면전환이 완료된 후에 원하는 작업 가능 
}
