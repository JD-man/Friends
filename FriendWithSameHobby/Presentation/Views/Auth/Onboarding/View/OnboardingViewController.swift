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
    
    private let pageImageView = UIImageView().then {
        $0.image = AssetsImages.onboardingImg1.image
        $0.contentMode = .scaleAspectFit
    }
    
    private let pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.pageIndicatorTintColor = AssetsColors.gray5.color
        $0.currentPageIndicatorTintColor = AssetsColors.black.color
    }
    
    private let startButton = BaseButton(title: "시작하기", status: .fill, type: .h48)
    
    var viewModel: OnboardingViewModel?
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        binding()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [pageImageView, pageControl, startButton]
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
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(startButton.frame.height)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)            
        }
    }
    
    private func binding() {
        let input = OnboardingViewModel.Input(didSwipeGesture: view.rx.swipeGesture([.left, .right]),
                                              didTapStartButton: startButton.rx.tap)
        let output = viewModel?.transform(input, disposeBag: disposeBag)
        
        output?.imageRelay
            .asDriver(onErrorJustReturn: UIImage(systemName: "xmark"))
            .drive(pageImageView.rx.image)
            .disposed(by: disposeBag)
        
        output?.pageControlRelay
            .asDriver(onErrorJustReturn: 0)
            .drive(pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
}
