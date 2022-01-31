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
    init(useCase: RegisterUseCase?, coordinator: AuthCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    struct Input {        
        // merged gender tap
        let mergedTap: Driver<Int>
        // register button tap
        let registerTap: Driver<Void>
    }
    
    struct Output {
        // male button status
        let maleButtonColor = PublishRelay<Bool>()
        // female button status
        let femaleButtonColor = PublishRelay<Bool>()
    }
    
    var useCase: RegisterUseCase?
    weak var coordinator: AuthCoordinator?
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        input.registerTap
            .drive { [weak self] _ in
                BaseActivityIndicator.shared.show()
                self?.useCase?.executeWithdraw()
            }.disposed(by: disposeBag)
        
        input.mergedTap
            .drive { [weak self] in
                self?.useCase?.updateButtonStatus(gender: $0)
            }.disposed(by: disposeBag)
        
        // Usecase to Output
        useCase?.maleButtonStatus
            .bind(to: output.maleButtonColor)
            .disposed(by: disposeBag)
        
        useCase?.femaleButtonStatus            
            .bind(to: output.femaleButtonColor)
            .disposed(by: disposeBag)
                
        // UseCase to Coordinator
        
        useCase?.registerSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                BaseActivityIndicator.shared.hide()
                if $0 { self?.coordinator?.finish(to: .mainTab, completion: nil) }
            }.disposed(by: disposeBag)
        
        useCase?.registerError
            .asDriver(onErrorJustReturn: .unknownError)
            .drive(onNext: { [weak self] err in
                BaseActivityIndicator.shared.hide()
                self?.coordinator?.pop(to: .nickname, completion: {
                    self?.coordinator?.toasting(message: err.localizedDescription)
                })
            }).disposed(by: disposeBag)
        return output
    }
}
