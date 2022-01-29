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
    let phoneAuthRepo: PhoneAuthRepositoryInterface?
    
    let verifyButtonStatusRelay = PublishRelay<BaseButtonStatus>()
    
    let codeRelay = BehaviorRelay<String>(value: "")
    private var disposeBag = DisposeBag()
    
    let authSuccessRelay = PublishRelay<Bool>()
    let retrySuccessRelay = PublishRelay<Bool>()
    let authErrorRelay = PublishRelay<UserInfoError>()
    
    init(userRepo: UserRepositoryInterface, phoneAuthRepo: PhoneAuthRepositoryInterface) {
        self.userRepo = userRepo
        self.phoneAuthRepo = phoneAuthRepo
    }
    
    // MARK: - Verify Register code
    func excuteAuthNumber() {
        phoneAuthRepo?.verifyRegisterNumber(verificationCode: codeRelay.value,
                                            completion: { [weak self] result in
            switch result {
            case .success(let idToken):                
                self?.getUserInfo()
                print(idToken)
            case .failure(let error):
                self?.authErrorRelay.accept(error)
            }
        })
    }
    
    private func getUserInfo() {
        userRepo?.getUserInfo(completion: { [weak self] result in
            switch result {
            case .success(_):
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
    
    // MARK: - Validation
    func validation(text: String) {
        codeRelay.accept(text)
        
        let registerNumberRegex = "^([0-9]{6})$"
        let registerNumberPred = NSPredicate(format: "SELF MATCHES %@", registerNumberRegex)
        
        guard registerNumberPred.evaluate(with: text) else {
            verifyButtonStatusRelay.accept(.disable)
            return
        }
        verifyButtonStatusRelay.accept(.fill)
    }
}
