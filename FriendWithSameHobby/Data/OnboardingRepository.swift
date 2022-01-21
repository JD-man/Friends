//
//  OnboardingRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import UIKit
import RxSwift

final class OnboardingRepository: OnboardingRepositoryInterface {
    
    let assetsImage: [UIImage] = [
        AssetsImages.onboardingImg1.image,
        AssetsImages.onboardingImg2.image,
        AssetsImages.socialLifeCuate.image
    ]
    
    func getOnboardingImages(idx: Int) -> UIImage {
        return assetsImage[idx]
    }
}
