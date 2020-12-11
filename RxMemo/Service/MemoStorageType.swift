//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift

// 기본적인 CRUD 선언
protocol MemoStorageType {
    
    @discardableResult // 작업 결과가 필요없는 경우를 위해
    func create(content: String) -> Observable<Memo>// return 형식이 Observable이면 구독자가 작업 결과를 원하는 방식으로 처리 가능
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
    
}
