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
    let userRepo: UserRepository? = UserRepository()
    let phoneAuthRepo: PhoneAuthRepository? = PhoneAuthRepository()
    
    let verifyButtonStatusRelay = PublishRelay<BaseButtonStatus>()
    
    let codeRelay = BehaviorRelay<String>(value: "")
    private var disposeBag = DisposeBag()
    
    let userExistRelay = PublishRelay<Bool>()
    let authErrorRelay = PublishRelay<UserInfoError>()
    
    func excuteAuthNumber(phoneID: String) {
        phoneAuthRepo?.verifyRegisterNumber(verificationCode: codeRelay.value, id: phoneID)
            .subscribe { [weak self] event in
                switch event {
                case .success(let idToken):                    
                    // idToken으로 유저 가입 여부 확인하기
                    self?.userRepo?.getUserInfo()
                        .subscribe {
                            switch $0 {
                            case .success(let response):
                                print(response)
                                self?.userExistRelay.accept(true)
                            case .failure(let error):
                                guard let userInfoError = error as? UserInfoError else { return }
                                self?.authErrorRelay.accept(userInfoError)
                            }
                        }.disposed(by: self?.disposeBag ?? DisposeBag())
                case .failure(let error):                    
                    self?.authErrorRelay.accept(.firebaseAuthError)
                }
            }.disposed(by: disposeBag)
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
