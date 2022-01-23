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
    let userRepo = UserRepository()
    let phoneAuthRepo = PhoneAuthRepository()    
    let verifyButtonStatusRelay = PublishRelay<BaseButtonStatus>()
    
    let codeRelay = BehaviorRelay<String>(value: "")
    private var disposeBag = DisposeBag()
    
    let userExistRelay = PublishRelay<Bool>()
    let authErrorRelay = PublishRelay<Error>()
    
    func excuteAuthNumber(phoneID: String) {
        phoneAuthRepo.verifyRegisterNumber(verificationCode: codeRelay.value, id: phoneID)
            .subscribe { [unowned self] event in
                switch event {
                case .success(let idToken):
                    print(idToken)
                    // idToken으로 유저 가입 여부 확인하기
                case .failure(let error):
                    authErrorRelay.accept(error)
                }
            }.disposed(by: disposeBag)
    }
    
    func validation(text: String) {
        codeRelay.accept(text)
        if text.count == 6 {
            verifyButtonStatusRelay.accept(.fill)
        }
        else {
            verifyButtonStatusRelay.accept(.disable)
        }
    }
}
