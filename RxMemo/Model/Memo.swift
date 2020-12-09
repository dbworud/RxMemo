//
//  Memo.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import SwiftUI

// 클래스 (class or struct) : 설계도, 틀
struct Memo : Equatable {
    
    // 객체 (object) : 설계도 안에서 구현할 대상
    var id: String // 메모 구분, Equatable
    var content: String
    var insertDate: Date
    
    
    // 인스턴스 (instance) : 설계도 안에서 구현된 실체, 실제 메모리에 올라감
    // 생성자 (init) : object -> instance 시키는 과정
    init(content: String, insertDate : Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.id = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    // 새로운 메모로 업데이트될 때 사용하는 생성자
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
    
}
