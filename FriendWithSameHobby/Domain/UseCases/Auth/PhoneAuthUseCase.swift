//
//  PhoneAuthUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import Foundation
import RxRelay

final class PhoneAuthUseCase: UseCaseType {
    
    let formattedTextRelay = PublishRelay<String>()
    let buttonStatusRelay = PublishRelay<BaseButtonStatus>()
    // lineView Status
    // label Status
    
    func execute(text: String) {
        numberFormatting(text: text)
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
            return
        }
        
        buttonStatusRelay.accept(.fill)
    }
}
