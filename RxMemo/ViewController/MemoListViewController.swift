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
    }
}
