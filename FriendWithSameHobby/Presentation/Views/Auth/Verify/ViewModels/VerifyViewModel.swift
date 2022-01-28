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
    
    var useCase: VerifyUseCase? = VerifyUseCase()
    weak var coordinator: AuthCoordinator?
    
    var phoneID: String
    
    init(phoneId: String) {
        self.phoneID = phoneId
    }
    
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
                self?.useCase?.excuteAuthNumber(phoneID: self?.phoneID ?? "")
            }.disposed(by: disposeBag)
        
        // UseCase to Coordinator
        useCase?.userExistRelay
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                if $0 { self?.coordinator?.finish(to: .mainTab, completion: nil) }
            }.disposed(by: disposeBag)
        
        useCase?.authErrorRelay
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] error in
                switch error {
                case .exitedUser:
                    self?.coordinator?.pushNicknameVC()
                default:
                    print(self?.coordinator, error)
                    self?.coordinator?.pop(to: .phoneAuth, completion: {
                        self?.coordinator?.toasting(message: error.localizedDescription)
                    })
                }                
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase?.verifyButtonStatusRelay
            .bind(to: output.verifyButtonStatus)
            .disposed(by: disposeBag)
        return output
    }
}
