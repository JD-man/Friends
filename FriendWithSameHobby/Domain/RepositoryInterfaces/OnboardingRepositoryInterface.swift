//
//  OnboardingRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import RxSwift
import UIKit

protocol OnboardingRepositoryInterface {
    func getOnboardingImages(idx: Int) -> UIImage
}
