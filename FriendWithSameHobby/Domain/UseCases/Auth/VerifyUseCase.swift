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
    
    let userExistRelay = PublishRelay<Bool>()
    let authErrorRelay = PublishRelay<UserInfoError>()
    
    init(userRepo: UserRepositoryInterface, phoneAuthRepo: PhoneAuthRepositoryInterface) {
        self.userRepo = userRepo
        self.phoneAuthRepo = phoneAuthRepo
    }
    
    func excuteAuthNumber() {
        phoneAuthRepo?.verifyRegisterNumber(verificationCode: codeRelay.value,
                                            completion: { [weak self] result in
            switch result {
            case .success(let idToken):
                print(idToken)
                self?.userRepo?.getUserInfo(completion: { result in
                    switch result {
                    case .success(let response):
                        self?.userExistRelay.accept(true)
                        // FCM 토큰 갱신 필요!!!!!!!!!!
                    case .failure(let error):
                        self?.authErrorRelay.accept(error)
                    }
                })
            case .failure(let error):
                self?.authErrorRelay.accept(error)
            }
        })
    }
    
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
