//
//  HomeViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class HomeViewModel: ViewModelType {
    struct Input {
        let matchingButtonTap: Driver<Void>
    }
    
    struct Output {
        
    }
    
    var useCase: HomeUseCase?
    weak var coordinator: HomeCoordinator?
    
    init(useCase: HomeUseCase?, coordinator: HomeCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.matchingButtonTap
            .drive { [weak self] _ in
                self?.coordinator?.pushHobbyVC()
            }.disposed(by: disposeBag)
        
        return output
    }
}
