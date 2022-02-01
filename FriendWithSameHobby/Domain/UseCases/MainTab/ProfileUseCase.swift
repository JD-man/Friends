//
//  ProfileUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import Foundation
import RxRelay

final class ProfileUseCase: UseCaseType {
    var phoneAuthRepo: PhoneAuthRepository?
    var userRepo: UserRepositoryInterface?
    
    let withdrawSuccess = PublishRelay<Bool>()
    let withdrawFail = PublishRelay<UserWithdrawError>()
    
    init(phoneAuthRepo: PhoneAuthRepository, userRepo: UserRepositoryInterface?) {
        self.phoneAuthRepo = phoneAuthRepo
        self.userRepo = userRepo
    }
    
    func execute() {
        userRepo?.withdrawUser(completion: { [weak self] result in
            switch result {
            case .success(let isWithdrawed):
                UserProgressManager.registered = nil
                self?.withdrawSuccess.accept(isWithdrawed)
            case .failure(let error):
                switch error {
                case .tokenError:
                    print("tokenError")
                    self?.tokenErrorHandling()
                default:
                    self?.withdrawFail.accept(error)
                }            
            }
        })
    }
    
    func tokenErrorHandling() {
        phoneAuthRepo?.refreshingIDtoken(completion: { [weak self] result in
            switch result {
            case .success(let idToken):
                UserInfoManager.idToken = idToken
                self?.execute()
            case .failure(_):
                self?.withdrawFail.accept(.unknownError)
            }
        })
    }
}
