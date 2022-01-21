//
//  OnboardingUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import UIKit
import RxSwift
import RxRelay

final class OnboardingUseCase: UseCaseType {
    
    let repository = OnboardingRepository()
    
    var idxRelay = BehaviorRelay<Int>(value: 0)
    var assetImageRelay = PublishRelay<UIImage>()
    
    func execute(of direction: UISwipeGestureRecognizer.Direction) {
        var idx = idxRelay.value
        switch direction {
        case .left:
            idx = idx >= 2 ? 2 : idx + 1
        case .right:
            idx = idx <= 0 ? 0 : idx - 1
        default:
            break
        }        
        idxRelay.accept(idx)
        assetImageRelay.accept(repository.getOnboardingImages(idx: idx))
    }
}
