//
//  PhoneAuthUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import Foundation
import RxSwift
import RxRelay

final class PhoneAuthUseCase: UseCaseType {
    
    var phoneAuthRepo: PhoneAuthRepositoryInterface?
    
    let authSuccessRelay = PublishRelay<String>()
    let authErrorRelay = PublishRelay<UserInfoError>()
    
    private var disposeBag = DisposeBag()
    
    init(phoneAuthRepo: PhoneAuthRepositoryInterface) {
        self.phoneAuthRepo = phoneAuthRepo
    }
    
    func execute(phoneNumber: String) {
        phoneAuthRepo?.verifyPhoneNumber("+82" + phoneNumber) { [weak self] result in
            switch result {
            case .success(let id):
                UserInfoManager.phoneNumber = phoneNumber
                UserProgressManager.loggedIn = true
                self?.authSuccessRelay.accept(id)
            case .failure(let error):
                self?.authErrorRelay.accept(error)
            }
        }
    }
}
