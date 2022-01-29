//
//  VerifyViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class VerifyViewModel: ViewModelType {
    init(useCase: VerifyUseCase?, coordinator: AuthCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct Input {
        // verifyButton tap
        let verifyButtonTap: ControlEvent<Void>
        // timer
        
        // retryButton tap
        let retryButtonTap: ControlEvent<Void>
        // verifyTextField text
        let verifyTextFieldText: ControlProperty<String>        
    }
    
    struct Output {
        // textField status
        let textFieldStatus = PublishRelay<BaseTextFieldStatus>()
        // verifyButton status
        let verifyButtonStatus = PublishRelay<BaseButtonStatus>()
        
        // edit begin empty string
        let emptyStringRelay = PublishRelay<String>()
    }
    
    var useCase: VerifyUseCase?
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        // Input to UseCase
        input.verifyTextFieldText
            .asDriver()
            .drive { [weak self] in
                self?.useCase?.validation(text: $0)
            }.disposed(by: disposeBag)
        
        input.verifyButtonTap
            .asDriver()
            .drive { [weak self] _ in
                BaseActivityIndicator.shared.show()
                self?.useCase?.excuteAuthNumber()
            }.disposed(by: disposeBag)
        
        input.retryButtonTap
            .asDriver()
            .drive { [weak self] _ in
                BaseActivityIndicator.shared.show()
                self?.useCase?.requestRegisterCode()
            }.disposed(by: disposeBag)
        
        // UseCase to Coordinator
        useCase?.authSuccessRelay
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                BaseActivityIndicator.shared.hide()
                if $0 { self?.coordinator?.finish(to: .mainTab, completion: nil) }
            }.disposed(by: disposeBag)
        
        useCase?.authErrorRelay
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] error in
                BaseActivityIndicator.shared.hide()
                switch error {
                case .unregistered:
                    print(error)
                    self?.coordinator?.pushNicknameVC()
                default:
                    self?.coordinator?.toasting(message: error.description)                    
                }                
            }.disposed(by: disposeBag)
        
        useCase?.retrySuccessRelay
            .asDriver(onErrorJustReturn: false)
            .drive { _ in
                BaseActivityIndicator.shared.hide()
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase?.verifyButtonStatusRelay
            .bind(to: output.verifyButtonStatus)
            .disposed(by: disposeBag)
        return output
    }
}
