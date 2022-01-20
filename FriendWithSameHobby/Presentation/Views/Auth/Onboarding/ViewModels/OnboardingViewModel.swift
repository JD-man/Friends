//
//  OnboardingViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import Foundation
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
        // UIImage BehaviorRelay Int
        // let imageRelay: BehaviorRelay<UIImage>()
        // UserDefaults isOnboardingPassed PublishRelay Bool
    }
    
    var useCase = OnboardingUseCase()
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        // Input To UseCase
        
        // UseCase To Output
        return output
    }
}
