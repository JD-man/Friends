//
//  AccountViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class AccountViewController: UIViewController {
    
    weak var coordinator: AccountCoordinator?
    
    let testButton = UIButton()
    
    private var disposeBag = DisposeBag()
    
    init(coordinator: AccountCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountVC")
        view.backgroundColor = .brown
        
        view.addSubview(testButton)
        
        testButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        testButton.center = view.center
        testButton.backgroundColor = .green
        
        testButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                (self?.coordinator?.parentCoordinator as? MainTabCoordinator)?
                    .finish(to: .auth, completion: {
                    print("tabbar to auth")
                })
                //self?.coordinator?.pushProfileVC()
            }.disposed(by: disposeBag)
    }
}
