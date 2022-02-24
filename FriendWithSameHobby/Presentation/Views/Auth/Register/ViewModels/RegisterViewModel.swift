//
//  RegisterViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class RegisterViewModel: ViewModelType {
    init(useCase: RegisterUseCase, coordinator: AuthCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct Input {
        let maleButtonTap: ControlEvent<Void>
        let femaleButtonTap: ControlEvent<Void>
        let registerTap: Driver<Void>
    }
    
    struct Output {
        let selectedGender = BehaviorRelay<UserGender>(value: .unselected)
    }
    
    var useCase: RegisterUseCase
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to Output
        
        // Input to UseCase
        input.registerTap
            .drive { [weak self] _ in
                BaseActivityIndicator.shared.show()
                self?.useCase.executeRegister(gender: output.selectedGender.value)
            }.disposed(by: disposeBag)
        
        Observable.merge(
            input.maleButtonTap.map { _ in return UserGender.male },
            input.femaleButtonTap.map { _ in return UserGender.female })
            .bind(to: output.selectedGender)
            .disposed(by: disposeBag)
                
        // UseCase to Coordinator
        
        useCase.registerSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                BaseActivityIndicator.shared.hide()
                if $0 { self?.coordinator?.finish(to: .mainTab, completion: nil) }
            }.disposed(by: disposeBag)
        
        useCase.registerError
            .asDriver(onErrorJustReturn: .unknownError)
            .drive(onNext: { [weak self] err in
                BaseActivityIndicator.shared.hide()
                self?.coordinator?.pop(to: .nickname, completion: {
                    self?.coordinator?.toasting(message: err.description)
                })
            }).disposed(by: disposeBag)
        return output
    }
}
