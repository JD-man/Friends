//
//  OnboardingRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import Foundation
import RxSwift

struct OnboardingLabelText {
    var fullText: String
    var rangeText: String
}

final class OnboardingRepository: OnboardingRepositoryInterface {
    
    let assetsImage: [ImageAsset] = [
        AssetsImages.onboardingImg1,
        AssetsImages.onboardingImg2,
        AssetsImages.socialLifeCuate
    ]
    
    let onboardingLabelTexts: [OnboardingLabelText] = [
        OnboardingLabelText(fullText: "위치 기반으로 빠르게\n주위친구를 확인", rangeText: "위치 기반"),
        OnboardingLabelText(fullText: "관심사가 같은 친구를\n찾을 수 있어요", rangeText: "관심사가 같은 친구"),
        OnboardingLabelText(fullText: "SeSAC Friends", rangeText: ""),
    ]
    
    func getOnboardingImages(idx: Int) -> ImageAsset {
        UserProgressManager.onboardingPassed = true
        return assetsImage[idx]
    }
    
    func getOnboardingTexts(idx: Int) -> OnboardingLabelText {
        return onboardingLabelTexts[idx]
    }
}
