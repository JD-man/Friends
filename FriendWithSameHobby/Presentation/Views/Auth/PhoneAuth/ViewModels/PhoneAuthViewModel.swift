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
        // TextField edit begin
        let editBegin: Driver<()>
        
        // TextField text
        let phoneNumberText: Driver<String>
        // button tap
    }
    
    struct Output {
        // edit begin
        let emptyStringRelay = PublishRelay<String>()
        
        // formatted number text
        let formattedNumberRelay = PublishRelay<String>()
        
        // textfield status
        
        // button status
        let buttonStatusRelay = PublishRelay<BaseButtonStatus>()
    }
    
    var useCase = PhoneAuthUseCase()
    private var disposeBag = DisposeBag()
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        input.phoneNumberText
            .distinctUntilChanged()
            .drive { [unowned self] in
                self.useCase.execute(text: $0)
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase.formattedTextRelay
            .bind(to: output.formattedNumberRelay)
            .disposed(by: disposeBag)
        
        useCase.buttonStatusRelay
            .bind(to: output.buttonStatusRelay)
            .disposed(by: disposeBag)
        
        // edit begin output
        input.editBegin
            .drive { _ in
                output.emptyStringRelay.accept("")
            }.disposed(by: disposeBag)
        
        return output
    }
}