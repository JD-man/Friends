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
    
    var useCase: PhoneAuthUseCase?    
    weak var coordinator: AuthCoordinator?
    private var disposeBag = DisposeBag()
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        input.phoneNumberText
            .distinctUntilChanged()
            .drive { [weak self] in
                self?.useCase?.validation(text: $0)
            }.disposed(by: disposeBag)
        
        input.buttonTap
            .drive { [weak self] _ in
                BaseActivityIndicator.shared.show()
                self?.useCase?.execute()
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
}
