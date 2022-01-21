//
//  OnboardingRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import Foundation
import RxSwift

final class OnboardingRepository: OnboardingRepositoryInterface {
    
    let assetsImage: [ImageAsset] = [
        AssetsImages.onboardingImg1,
        AssetsImages.onboardingImg2,
        AssetsImages.socialLifeCuate
    ]
    
    func getOnboardingImages(idx: Int) -> ImageAsset {
        return assetsImage[idx]
    }
}
