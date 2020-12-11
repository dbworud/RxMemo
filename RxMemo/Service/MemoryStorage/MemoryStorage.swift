//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import Foundation
import RxSwift

class MemoryStorage: MemoStorageType {
    
    // dummy data, 외부에서 직접적으로 접근할 필요가 없기 때문에 private으로 선언
    private var list = [
        Memo(content: "Memo1", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Memo2", insertDate: Date().addingTimeInterval(-20))
    ] // Observable을 통해 외부로 공개 및 전달
    
    // list를 기반으로 새로운 Section Model
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    // Observable은 배열의 상태가 update되면 새로운 next event 방출 -> 그냥 Observable로 만들면 불가하기 때문에
    // 초기값(private var list)가 있는 BehaviorSubject로 선언
    // 기본값을 list로 선언하기 위해 lazy 사용
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel]) // 외부에서 접근할 필요 없음
    
    @discardableResult
    func create(content: String) -> Observable<Memo> {
        // 새로운 인스턴스 생성
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0) // 대상모델을 바꾸고 Section Model 방출
        
        store.onNext([sectionModel]) //subject에서 새로운 next event 방출, 이렇게 해야 나중에 tableView와 Binding할 때 정상적으로 변경점 업데이트
        
        return Observable.just(memo) // 새로운 메모를 방출하는 Observable return
        
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        // index가 같으면
        if let index = sectionModel.items.firstIndex(where: { $0 == memo}) {
            sectionModel.items.remove(at: index) // 원래 index에 있던 것 제거 후
            sectionModel.items.insert(updated, at : index) // update된 것 insert
        }
        
        store.onNext([sectionModel]) //subject에서 새로운 next event 방출
        
        return Observable.just(updated) // 업데이트된 메모를 방출하는 Observable return
        
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: { $0 == memo}) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo) // 삭제된 메모 방출하는 Observable return
    }
}
