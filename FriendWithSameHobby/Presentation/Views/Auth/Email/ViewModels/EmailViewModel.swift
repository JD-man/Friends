//
//  EmailViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class EmailViewModel: ViewModelType {
    
    struct Input {
        // TextField Text
        let textFieldText: Driver<String>
        // Button Tap
        let nextButtonTap: Driver<String>
    }
    
    struct Output {
        // TextField Status
        let textFieldStatus = BehaviorRelay<BaseTextFieldStatus?>(value: .inactive)
        // Button Status
        let nextButtonStatus = BehaviorRelay<BaseButtonStatus>(value: .disable)
    }
    
    var useCase: VerifyUseCase? = nil
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let validation = input.textFieldText
            .map { [unowned self] in emailValidation(text: $0) }
            .asDriver()
        
        validation
            .map { (isValidated) -> BaseButtonStatus in
                return isValidated ? .fill : .disable
            }.drive(output.nextButtonStatus)
            .disposed(by: disposeBag)
        
        validation
            .map { (isValidated) -> BaseTextFieldStatus? in
                return isValidated ? .focus : .error(message: "이메일 형식으로 입력해주세요.")
            }.drive(output.textFieldStatus)
            .disposed(by: disposeBag)
        
        // Input To Coordinator && UserDefault nick save
        input.nextButtonTap
            .asDriver()
            .drive { [weak self] in
                switch output.nextButtonStatus.value {
                case .fill:                    
                    UserDefaultsManager.email = $0
                    self?.coordinator?.pushRegisterVC()
                default:
                    print("invalid nickname")
                }
            }.disposed(by: disposeBag)
        
        return output
    }
    
    func emailValidation(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        guard emailPred.evaluate(with: text) else {
            return false
        }
        
        return true
    }
}
