//
//  PhoneAuthViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class PhoneAuthViewModel: ViewModelType {
    init(useCase: PhoneAuthUseCase?, coordinator: AuthCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct Input {
        // TextField text
        let phoneNumberText: Driver<String>        
        // button tap
        let buttonTap: Driver<(BaseButtonStatus, String)>
    }
    
    struct Output {
        // formatted number text
        let formattedNumberRelay = PublishRelay<String>()
        // textfield status
        let textFieldStatusRelay = PublishRelay<BaseTextFieldStatus>()
        // button status
        let buttonStatusRelay = PublishRelay<BaseButtonStatus>()
    }
    
    var useCase: PhoneAuthUseCase?    
    weak var coordinator: AuthCoordinator?
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        
        input.buttonTap
            .drive { [weak self] in
                let buttonStatus = $0.0
                let phoneNumber = $0.1
                switch buttonStatus {
                case .disable:
                    self?.coordinator?.toasting(message: "잘못된 전화번호 형식입니다.")
                case .fill:
                    BaseActivityIndicator.shared.show()
                    self?.coordinator?.toasting(message: "전화 번호 인증 시작")
                    self?.useCase?.execute(phoneNumber: phoneNumber)
                default:
                    break
                }                
            }.disposed(by: disposeBag)
        
        // Input to Output (Validation)
        
        input.phoneNumberText
            .map(numberFormatting)
            .drive { output.formattedNumberRelay.accept($0) }
            .disposed(by: disposeBag)
        
        input.phoneNumberText
            .map(validatePhoneNumber)
            .drive { output.buttonStatusRelay.accept($0) }
            .disposed(by: disposeBag)
        
        // UseCase to Coordinator
        useCase?.authSuccessRelay
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                BaseActivityIndicator.shared.hide()
                if $0 != "" { self?.coordinator?.pushVerifyVC(phoneId: $0) }
            }.disposed(by: disposeBag)
        
        useCase?.authErrorRelay
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                BaseActivityIndicator.shared.hide()
                self?.coordinator?.toasting(message: $0.description)
            }
            .disposed(by: disposeBag)        
        return output
    }
    
    private func numberFormatting(text: String) -> String {
        var temp = text
        if temp.count == 3 || temp.count == 8 { temp += "-" }
        return temp
    }
    
    private func validatePhoneNumber(text: String) -> BaseButtonStatus {
        let phoneNumberRegex = "^01([0-9])-([0-9]{3,4})-([0-9]{4})$"
        let phoneNumberPred = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)        
        guard phoneNumberPred.evaluate(with: text) else { return .disable }
        return .fill
    }
}
