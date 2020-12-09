//
//  TransitionModel.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation

// Scene 전환시 필요한 열거형 선언
enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError :Error {
    case navigationControllerMissing
    case cannotPop
    case unknown    
}
