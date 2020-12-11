//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx // var disposedBag = DisposeBag()을 일일히 선언할 필요가 없음

class MemoListViewController: UIViewController, ViewModelBindableType {
   
    var viewModel: MemoListViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // Rx에서는 RxCocoa가 추가한 탭 속성을 구독하거나 action 속성에 직접 action을 할당
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        // ViewModel과 View를 바인딩
        // 1. ViewModel에 정의한 title과 navigation title을 Binding
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag) // ViewModel에 저장된 title이 Navigation bar에 표시
        
        // 2. 메모 목록을 tableView에 Binding하면 끝
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        // 3. +버튼과 Action을 Binding
        addButton.rx.action = viewModel.makeAction()
        
        // 테이블뷰에서 메모를 선택하면 ViewModel의 detailAction을 통해서 전달 -> 선택한 메모 필요
        
        // 선택한 셀은 선택해제 -> indexPath 필요. RxCocoa에서 선택 이벤트 처리를 extension으로 제공
        
        // 선택한 indexPath 필요 시: itemSelected 속성 사용
        // 선택한 데이터(메모) 필요 시: modelSelected 메소드 사용
        
        // zip: 두 멤버가 리턴하는 Observable을 병합 -> Tuple형태로 방출
        Observable.zip(listTableView.rx.modelSelected(Memo.self),listTableView.rx.itemSelected)
            // Next event가 전달되면 선택 상태를 해제
            .do(onNext: { [unowned self] (_, indexPath) in // [unowned self]: 옵셔널을 인정하지 않는 약한 참조
                self.listTableView.deselectRow(at: indexPath, animated: true)
            }) // 이후 indexPath가 필요없기 때문에 map 연산자로 데이터만 방출
            .map { $0.0 }
            .bind(to: viewModel.detailAction.inputs) // 전달된 메모를 ViewModel의 detailAction과 Binding
            .disposed(by: rx.disposeBag)
        
        
     }
}
