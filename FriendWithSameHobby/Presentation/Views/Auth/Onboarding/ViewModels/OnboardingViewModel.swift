//
//  OnboardingViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxGesture

final class OnboardingViewModel: ViewModelType {
    struct Input {        
        // Swipe Gesture
        let didSwipeGesture: SwipeControlEvent
        // Button
        let didTapStartButton: ControlEvent<Void>
    }
    
    struct Output {
        // UIImage Relay
        let imageRelay = BehaviorRelay<UIImage?>(value: UIImage())
        // PageControl Current Page Index Relay
        let pageControlRelay = BehaviorRelay<Int>(value: 0)
        // Onboarding Text
        let onboardingTextRelay = BehaviorRelay<NSMutableAttributedString>(value: NSMutableAttributedString())
        
        // UserDefaults isOnboardingPassed PublishRelay Bool
    }
    
    var useCase: OnboardingUseCase? = OnboardingUseCase()
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        // Input To UseCase
        input.didSwipeGesture
            .when(.ended)            
            .subscribe(onNext: { [weak self] in
                var offset = 0
                switch $0.direction {
                case .left:
                    offset = 1
                case .right:
                    offset = -1
                default:
                    break
                }                
                self?.useCase?.execute(offset: offset)
            }).disposed(by: disposeBag)
        
        input.didTapStartButton
            .bind { [weak self] in
                //self?.coordinator?.pushPhoneAuthVC()
                self?.coordinator?.finish(to: .mainTab, completion: {
                    print("onboarding to tabbar")
                })
            }.disposed(by: disposeBag)
        
        // UseCase To Output
        useCase?.assetImageRelay
            .map { $0.image }
            .bind(to: output.imageRelay)            
            .disposed(by: disposeBag)
        
        useCase?.idxRelay
            .bind(to: output.pageControlRelay)
            .disposed(by: disposeBag)
        
        useCase?.highlightedTextRelay
            .bind(to: output.onboardingTextRelay)
            .disposed(by: disposeBag)
        return output
    }
}
