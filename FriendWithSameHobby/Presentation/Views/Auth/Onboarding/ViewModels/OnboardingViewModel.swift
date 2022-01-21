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
        // ViewDidLoad
        
        // Swipe Gesture
        let didSwipeGesture: SwipeControlEvent
        // Button
    }
    
    struct Output {
        // UIImage Relay
        let imageRelay = PublishRelay<UIImage>()
        // PageControl Current Page Index Relay
        let pageControlRelay = PublishRelay<Int>()
        
        // UserDefaults isOnboardingPassed PublishRelay Bool
    }
    
    var useCase = OnboardingUseCase()
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        // Input To UseCase
        input.didSwipeGesture
            .when(.ended)            
            .subscribe(onNext: { [weak self] in                
                self?.useCase.execute(of: $0.direction)
            }).disposed(by: disposeBag)
        
        // UseCase To Output
        useCase.assetImageRelay
            .bind(to: output.imageRelay)            
            .disposed(by: disposeBag)
        
        useCase.idxRelay
            .bind(to: output.pageControlRelay)
            .disposed(by: disposeBag)
        return output
    }
}
