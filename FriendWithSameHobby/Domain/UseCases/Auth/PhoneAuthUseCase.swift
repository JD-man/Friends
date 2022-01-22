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
    
    var repository = PhoneAuthRepository()
    
    let formattedTextRelay = BehaviorRelay<String>(value: "")
    let buttonStatusRelay = BehaviorRelay<BaseButtonStatus>(value: .disable)
    let textFieldStatusRelay = BehaviorRelay<BaseTextFieldStatus>(value: .disable)
    
    let authSuccessRelay = PublishRelay<String>()
    let authErrorRelay = PublishRelay<PhoneAuthError>()
    
    private var disposeBag = DisposeBag()
    
    func validation(text: String) {
        numberFormatting(text: text)
    }
    
    func execute() {        
        if buttonStatusRelay.value == .fill {
            repository.verifyPhoneNumber(formattedTextRelay.value)
                .subscribe { [unowned self] in
                    switch $0 {
                    case .success(let id):
                        self.authSuccessRelay.accept(id)
                    case .failure(_):
                        self.authErrorRelay.accept(.authFail)
                    }
                }.disposed(by: disposeBag)
        }
        else {
            authErrorRelay.accept(.notFillButton)
        }
    }
    
    private func numberFormatting(text: String) {
        var temp = text
        if temp.count == 3 || temp.count == 8 {
            temp += "-"
        }
        formattedTextRelay.accept(temp)
        validatePhoneNumber(text: temp)
    }
    
    private func validatePhoneNumber(text: String) {
        let phoneNumberRegex = "^01([0-9])-([0-9]{3,4})-([0-9]{4})$"
        let phoneNumberPred = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        
        guard phoneNumberPred.evaluate(with: text) else {
            // accept validation result
            buttonStatusRelay.accept(.disable)
            textFieldStatusRelay.accept(.error(message: "전화번호 형식으로 입력해주세요."))
            return
        }
        
        textFieldStatusRelay.accept(.success(message: "알맞은 전화번호 형식입니다."))
        buttonStatusRelay.accept(.fill)
    }
}
