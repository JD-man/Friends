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
        let veriftButtonTap: ControlEvent<Void>
        // timer
        
        // retryButton tap
        let retryButtonTap: ControlEvent<Void>
        // verifyTextField text
        let verifyTextFieldText: ControlProperty<String>
        // verifyTextField edit begin
        let verifyTextFieldEditBegin: ControlEvent<Void>
    }
    
    struct Output {
        // textField status
        
        // verifyButton status
        let verifyButtonStatus = PublishRelay<BaseButtonStatus>()
    }
    
    var useCase = VerifyUseCase()
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        // Input to UseCase
        input.verifyTextFieldText
            .asDriver()
            .drive { [unowned self] in
                self.useCase.validation(text: $0)
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase.verifyButtonStatusRelay
            .bind(to: output.verifyButtonStatus)
            .disposed(by: disposeBag)
        
        return output
    }
}
