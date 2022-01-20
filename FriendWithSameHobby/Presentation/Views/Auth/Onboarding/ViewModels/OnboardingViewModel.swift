//
//  OnboardingViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import Foundation
import RxSwift

final class OnboardingViewModel: ViewModelType {
    struct Input {
        // Page Control (-> Swipe Gesture)
        // Button
        
    }
    
    struct Output {
        // Page Number BehaviorRelay Int
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
