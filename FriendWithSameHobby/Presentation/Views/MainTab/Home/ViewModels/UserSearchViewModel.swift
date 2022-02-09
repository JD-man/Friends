//
//  UserSearchViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/10.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class UserSearchViewModel: ViewModelType {
    struct Input {
        // back button tap
        let backButtonTap: Driver<Void>
        // stop matching button tap
        let stopMatchingButtonTap: Driver<Void>
        // change hobby button tap
        let changeHobbyButtonTap: Driver<Void>
        // refresh button tap
        
    }
    
    struct Output {
        // refresh result
    
    }
    
    var useCase: UserSearchUseCase
    weak var coordinator: HomeCoordinator?
    
    init(useCase: UserSearchUseCase, coordinator: HomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        input.stopMatchingButtonTap
            .drive { [weak self] _ in
                self?.useCase.cancelQueue()
            }.disposed(by: disposeBag)
        
        // Input to Coordinator
        input.backButtonTap
            .drive { [weak self] _ in
                self?.coordinator?.navigationController.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
        
        input.changeHobbyButtonTap
            .drive { [weak self] _ in
                self?.coordinator?.navigationController.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        // UseCase to coordinator
        useCase.cancelSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                self?.coordinator?.navigationController.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        useCase.cancelFail
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        return output
    }
}
