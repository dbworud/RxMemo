//
//  MemoListViewMOdel.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift
import RxCocoa


class MemoListViewModel : CommonViewModel {
    
    // 메모목록이 구현될 tableView와 Binding될 속성 : 메모목록
    var memoList : Observable<[Memo]> { // 메모 배열 방출
        return storage.memoList()
    }
    
}
