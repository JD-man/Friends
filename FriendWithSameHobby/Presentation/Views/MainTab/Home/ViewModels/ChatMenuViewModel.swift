//
//  ChatMenuViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class ChatMenuViewModel: ViewModelType {
    struct Input {
        let dodgeButtonTap: Driver<Void>
    }
    
    struct Output {
        
    }
    
    var useCase: ChatMenuUseCase
    weak var coordinator: HomeCoordinator?
    
    init(useCase: ChatMenuUseCase, coordinator: HomeCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to Usecase
        input.dodgeButtonTap
            .drive { [weak self] _ in
                let alert = BaseAlertView(message: .dodgeMatching) {
                    self?.useCase.executeDodge()
                }
                alert.show()
            }.disposed(by: disposeBag)
        
        // UseCase to Coordinator
        useCase.dodgeSuccess
            .asSignal()
            .emit { [weak self] _ in
                self?.coordinator?.show(view: .mapView, by: .backToFirst)
            }.disposed(by: disposeBag)
        
        useCase.dodgeFail
            .asSignal()
            .emit { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        return output
    }
}
