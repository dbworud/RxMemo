//
//  Scene.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import UIKit

 // 앱에서 구현할 Scene 열거형 선언
enum Scene {
    
    // Scene과 연관된 ViewModel을 연관값으로 저장
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    // 스토리보드에 있는 Scene을 생성하고 연관값으로 저장된 ViewModel을 바인딩해서 리턴
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil) // 1. 스토리보드 생성
        
        switch self {
        
        case .list(let viewModel):
            // 2. Scene 생성, identifier 에는 storyboar ID 사용
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            
            // 3. ViewModel 바인딩해서 리턴
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            listVC.bind(viewModel: viewModel) // 실제 Scene과 ViewModel을 Binding
            return nav
            
            
        case .detail(let viewModel):
            // 해당 Scene은 항상 Navigation Stack에 push되기 때문에 UINavigationController 고려할 필요가 없음
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "MemoDetailViewController") as? MemoDetailViewController else {
                fatalError()
            }
            
            detailVC.bind(viewModel: viewModel)
            return detailVC
            
        case .compose(let viewModel):
            // NavigationController에 embeded되어있기 때문에 구현 필요
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            composeVC.bind(viewModel: viewModel)
            return nav
        }
    }
}
