//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by jaekyung you on 2020/12/09.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {

    var viewModel: MemoComposeViewModel!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
         
        // 메모 쓰기모드에서는 빈 문자열 표시, 편집모드에서는 편집할 내용이 표시
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        // action 속성에 binding하는 방식. 취소버튼을 누르면 cancelAction에 wrapping되어있는 코드가 실행
        cancelButton.rx.action = viewModel.cancelAction
        
        // tap했을 때 내용을 새롭게 저장
        // doubletap을 방지하기 위해 throttle 연산자로 0.5초마다 탭을 처리
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) // 데이터가 MainThread(UITableView)에 있음을 확신
            .withLatestFrom(contentTextView.rx.text.orEmpty)// 입력된 text를 방출하는 연산자, orEmpty: 옵셔널 말고 String으로 받고 싶을 때
            .bind(to: viewModel.saveAction.inputs)// 방출된 text를 viewModel의 saveAction과 binding
            .disposed(by: rx.disposeBag)
    }
    
    // keyboard 입력이 바로 활성화 되도록 viewWillAppear에서 textView를 firstResponder로 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    
    // 반대로 이전 화면으로 돌아가기 전에 responder 해제
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
