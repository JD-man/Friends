//
//  NickNameViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class NickNameViewModel: ViewModelType {
    struct Input {
        // TextField Begin Edit
        let textFieldEditBegin: Driver<Void>
        // TextField Text
        let textFieldText: Driver<String>
        // Button Tap
        let nextButtonTap: Driver<Void>
    }
    
    struct Output {
        // TextField Status
        let textFieldStatus = BehaviorRelay<BaseTextFieldStatus?>(value: .inactive)
        // Button Status
        let nextButtonStatus = BehaviorRelay<BaseButtonStatus>(value: .disable)
        // text
        var textRelay = BehaviorRelay<String>(value: "")
    }
    
    var useCase: VerifyUseCase? = nil
    weak var coordinator: AuthCoordinator?
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.textFieldText
            .drive(output.textRelay)
            .disposed(by: disposeBag)
        
        input.textFieldText
            .map { (text) -> BaseButtonStatus in
                return text.count > 0 && text.count <= 10 ? .fill : .disable
            }.drive(output.nextButtonStatus)
            .disposed(by: disposeBag)
        
        input.textFieldText
            .map { (text) -> BaseTextFieldStatus? in
                return text.count > 10 ? .error(message: "10 글자 이내로 작성해주세요.") : nil                
            }.drive(output.textFieldStatus)
            .disposed(by: disposeBag)
        
        // Input To Coordinator && UserDefault nick save
        input.nextButtonTap
            .asDriver()
            .drive { [weak self] _ in
                UserDefaultsManager.nick = output.textRelay.value
                self?.coordinator?.pushBirthVC()
            }.disposed(by: disposeBag)
        
        return output
    }
}
