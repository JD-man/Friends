//
//  VerifyUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxRelay

final class VerifyUseCase: UseCaseType {
    let verifyButtonStatusRelay = PublishRelay<BaseButtonStatus>()
    
    func validation(text: String) {
        if text.count == 6 {
            verifyButtonStatusRelay.accept(.fill)
        }
        else {
            verifyButtonStatusRelay.accept(.disable)
        }
    }
}
