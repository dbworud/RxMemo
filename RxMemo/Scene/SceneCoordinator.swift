//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    
    private let bag = DisposeBag() // 리소스, 메모리 정리
    
    // SceneCoordinator는 화면전환을 담당하기 때문에 Window 인스턴스와 현재 화면에 표시되어 있는 Scene을 가지고 있어야한다
    private var window: UIWindow
    private var currentVC : UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        // 1. 전환결과를 방출할 Subject 선언
        // Completable.create쓰면 클로저로 구현해야해서 코드가 필요 이상으로 길어지기 때문에 PublishSubject<Void>() + return subject.ignoreElements()
        let subject = PublishSubject<Void>()
        
        // 2. Scene을 생성 from 'extension Scene'
        let target = scene.instantiate()
        
        // 3. transition style에 따라서 실제 전환
        switch style {
            case .root: // rootViewController를 바꿔주면 됨
                currentVC = target
                window.rootViewController = target
                subject.onCompleted()
                
            case .push: // navController에 embeded인 경우만 valid -> navController에 embeded 여부
                guard let nav = currentVC.navigationController else {
                    subject.onError(TransitionError.navigationControllerMissing)
                    break
                }
                
                // 해당하는 Scene을 nav에 push & onCompleted
                nav.pushViewController(target, animated: animated)
                currentVC = target
                
                subject.onCompleted()
            
            case .modal: // modal에서는 Scene을 present
                currentVC.present(target, animated: animated) {
                    subject.onCompleted() // Completion Handler에서 전달
                }
                currentVC = target
        }
        return subject.ignoreElements() // return값이 Completable이기 때문에 Element들은 무시되고 Completable로 변환되어 리턴
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            
            // 1) ViewController가 modal 방식으로 표시되어 있다면, 현재 Scene을 dismiss
            if let presentingVC = self.currentVC.presentingViewController { // currentVC를 presenting한 VC로 돌아감
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            }
            
            
            // 2) navigation stack에 push 된 경우라면, pop
            else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else { // pop을 할 수 없는 상황이라면 error event 보내고 종료
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }
            
            
            // 3) 나머지 경우 error event 보내고 종료
            else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}
