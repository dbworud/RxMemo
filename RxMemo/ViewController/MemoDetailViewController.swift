//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoDetailViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        // 첫번째 셀이라면 내용
        viewModel.contents
            .bind(to: listTableView.rx.items) { tableView, row, value in
                switch row {
                case 0:
                    // tableView에서 contentCell이라는 cell을 지정
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    // cell의 textLabel에 해당 값을 집어넣음
                    cell.textLabel?.text = value
                    return cell
                    
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                    
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        /* 기존의 backButton과 다른 문제점 -> SceneCoordinator에서 수정
        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        // title이 driver형태이기 때문에 title 생성자로는 전달할 수 없음
        viewModel.title
            .drive(backButton.rx.title)
            .disposed(by: rx.disposeBag)
        
        backButton.rx.action = viewModel.popAction
        // backButton의 style만 변경될 뿐, action은 여전하기 때문에 backButton을 숨기고 leftBarButtonItem로 넣음
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton// default된 backbutton 대체
        */
        
        // #1. rx의 action 방식을 활용
        editButton.rx.action = viewModel.makeEditAction() // View(ViewController)와 ViewModel을 Binding
        
        // #2. rx의 tap 방식을 활용
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) // 더블탭 방지
            .subscribe(onNext: { [weak self] _ in
                guard let memo = self?.viewModel.memo.content else { return }
                
                // content배열로 구성된 memo에 대한 service
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
    }
}
