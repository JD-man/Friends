//
//  VerifyUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxSwift
import RxRelay

final class VerifyUseCase: UseCaseType {
    let userRepo: UserRepositoryInterface?
    let phoneAuthRepo: FirebaseAuthRepositoryInterface?
    
    private var disposeBag = DisposeBag()
    
    let authSuccessRelay = PublishRelay<Bool>()
    let retrySuccessRelay = PublishRelay<Bool>()
    let authErrorRelay = PublishRelay<UserInfoError>()
    
    init(userRepo: UserRepositoryInterface, phoneAuthRepo: FirebaseAuthRepositoryInterface) {
        self.userRepo = userRepo
        self.phoneAuthRepo = phoneAuthRepo
    }
    
    // MARK: - Verify Register code
    func excuteAuthNumber(code: String) {
        phoneAuthRepo?.verifyRegisterNumber(verificationCode: code,
                                            completion: { [weak self] result in
            switch result {
            case .success(let idToken):
                UserInfoManager.idToken = idToken
                self?.getUserInfo()
            case .failure(let error):
                self?.authErrorRelay.accept(error)
            }
        })
    }
    
    private func getUserInfo() {
        userRepo?.getUserInfo(completion: { [weak self] result in
            switch result {
            case .success(_):
                UserProgressManager.registered = true
                self?.updateFCMtoken()
            case .failure(let error):
                self?.authErrorRelay.accept(error)
            }
        })
    }
    
    private func updateFCMtoken() {
        let model = UpdateFCMtokenModel()
        userRepo?.updateFCMtoken(model: model, completion: { [weak self] result in
            switch result {
            case .success(let isCompleted):
                self?.authSuccessRelay.accept(isCompleted)
            case .failure(let error):
                self?.authErrorRelay.accept(error)
            }
        })
    }
    
    // MARK: - Request Register Code for Retry
    func requestRegisterCode() {
        phoneAuthRepo?.retryPhoneNumber(completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.retrySuccessRelay.accept(true)
            case .failure(let error):
                self?.authErrorRelay.accept(error)
            }
        })
    }
}
