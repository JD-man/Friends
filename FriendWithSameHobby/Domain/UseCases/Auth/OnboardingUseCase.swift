//
//  OnboardingUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import Foundation
import RxSwift
import RxRelay

final class OnboardingUseCase: UseCaseType {
    
    let repository = OnboardingRepository()
    
    var idxRelay = BehaviorRelay<Int>(value: 0)
    var assetImageRelay = BehaviorRelay<ImageAsset>(value: AssetsImages.onboardingImg1)
    var highlightedTextRelay = BehaviorRelay<NSMutableAttributedString>(value: NSMutableAttributedString())
    
    init() {
        execute(offset: 0)
    }
    
    func execute(offset: Int) {
        var newIdx = idxRelay.value + offset
        
        switch offset {
        case 1:
            newIdx = min(2, newIdx)
        case -1:
            newIdx = max(0, newIdx)
        default:
            break
        }        
        idxRelay.accept(newIdx)
        highlightedTextRelay.accept(highlighting(idx: newIdx))
        assetImageRelay.accept(repository.getOnboardingImages(idx: newIdx))
    }
    
    private func highlighting(idx: Int) -> NSMutableAttributedString {
        let texts = repository.getOnboardingTexts(idx: idx)
        return texts.fullText.highlightText(range: texts.rangeText)
    }    
}
