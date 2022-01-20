//
//  OnboardingViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture

class OnboardingViewController: UIViewController {
    
    var viewModel: OnboardingViewModel?
    private var disposeBag = DisposeBag()
    
    private let pageImageView = UIImageView().then {
        $0.image = AssetsImages.onboardingImg1.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.pageIndicatorTintColor = AssetsColors.gray5.color
        $0.currentPageIndicatorTintColor = AssetsColors.black.color
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [pageImageView, pageControl]
            .forEach { view.addSubview($0) }
        
        pageImageView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(pageImageView.snp.width)
            make.centerY.equalTo(view)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(pageImageView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    private func binding() {
        let input = OnboardingViewModel
            .Input(didSwipeGesture: view.rx.swipeGesture([.left, .right]))
        let output = viewModel?.transform(input, disposeBag: disposeBag)            
    }
}
