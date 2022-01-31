//
//  ProfileUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/31.
//

import Foundation
import RxRelay

final class ProfileUseCase: UseCaseType {
    var userRepo: UserRepositoryInterface?
    
    let withdrawSuccess = PublishRelay<Bool>()
    let withdrawFail = PublishRelay<UserWithdrawError>()
    
    init(userRepo: UserRepositoryInterface?) {
        self.userRepo = userRepo
    }
    
    func execute() {
        userRepo?.withdrawUser(completion: { [weak self] result in
            switch result {
            case .success(let isWithdrawed):
                self?.withdrawSuccess.accept(isWithdrawed)
            case .failure(let error):
                switch error {
                case .tokenError:
                    print("token error")
                default:
                    self?.withdrawFail.accept(error)
                }            
            }
        })
    }
}
