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
    struct Input {
        // TextField text
        let phoneNumberText: Driver<String>
        
        // button tap
        let buttonTap: Driver<Void>
    }
    
    struct Output {
        // formatted number text
        let formattedNumberRelay = PublishRelay<String>()
        // textfield status
        let textFieldStatusRelay = PublishRelay<BaseTextFieldStatus>()
        // button status
        let buttonStatusRelay = PublishRelay<BaseButtonStatus>()
    }
    
    var useCase: PhoneAuthUseCase? = PhoneAuthUseCase()
    private var disposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        input.phoneNumberText
            .distinctUntilChanged()
            .drive { [unowned self] in
                self.useCase?.validation(text: $0)
            }.disposed(by: disposeBag)
        
        input.buttonTap
            .drive { [unowned self] _ in
                self.useCase?.execute()
                //self.coordinator?.pushVerifyVC(phoneId: "test")
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase?.formattedTextRelay
            .bind(to: output.formattedNumberRelay)
            .disposed(by: disposeBag)
        
        useCase?.buttonStatusRelay
            .bind(to: output.buttonStatusRelay)
            .disposed(by: disposeBag)
        
        useCase?.textFieldStatusRelay
            .bind(to: output.textFieldStatusRelay)
            .disposed(by: disposeBag)
        
        // UseCase to Coordinator
        useCase?.authSuccessRelay
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] in
                if $0 != "" {
                    print("auth success")
                    print($0)
                    self?.coordinator?.pushVerifyVC(phoneId: $0)
                }
            }.disposed(by: disposeBag)
        
        useCase?.authErrorRelay
            .asDriver(onErrorJustReturn: .authFail)
            .drive {
                print($0)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
