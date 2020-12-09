//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import UIKit

protocol ViewModelBindableType {
    
    associatedtype ViewModelType // ViewModel의 타입은 ViewController에 따라 달라지므로 generic으로 정의
     
    var viewModel : ViewModelType! { get set } // 읽,쓰가 모두 가능한 연산 프로퍼티
    func bindViewModel()
}

extension ViewModelBindableType where Self : UIViewController {
    
    // ViewController에 저장된 실제 ViewModel을 저장하고 bindViewModel()호출하는 메소드
    // 개별 ViewController에 bindViewModel()을 직접 호출할 필요가 없어 코드 단순
    mutating func bind(viewModel : Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
    
}
