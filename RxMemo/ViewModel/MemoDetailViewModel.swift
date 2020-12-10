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
}
