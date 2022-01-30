//
//  ProfileViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    let baseCardView = BaseCardView()
    
    let testingWhite = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        view.addSubview(baseCardView)
        view.addSubview(testingWhite)
        baseCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        testingWhite.snp.makeConstraints { make in
            make.top.equalTo(baseCardView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func binding() {
        baseCardView.moreButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                let isExpanding = self?.baseCardView.sesacTitleView.isHidden ?? false
                print(self?.baseCardView.sesacTitleView.isHidden)
                self?.baseCardView.expanding(isExpanding: !isExpanding)
                
                self?.baseCardView.sesacTitleView.isUserInteractionEnabled.toggle()
                self?.baseCardView.sesacReviewView.isUserInteractionEnabled.toggle()
                
                if isExpanding {
                    self?.baseCardView.sesacTitleView.isHidden.toggle()
                    self?.baseCardView.sesacReviewView.isHidden.toggle()
                }
                
                UIView.animate(withDuration: 1) {
                    self?.view.layoutIfNeeded()
                } completion: { _ in
                    if !isExpanding {
                        self?.baseCardView.sesacTitleView.isHidden.toggle()
                        self?.baseCardView.sesacReviewView.isHidden.toggle()
                    }
                }
            }.disposed(by: disposeBag)
    }
}
