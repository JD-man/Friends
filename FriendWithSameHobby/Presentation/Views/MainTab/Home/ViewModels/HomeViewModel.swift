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
        // matching button tap to push hobby VC
        let matchingButtonTap: Driver<Void>
        
        // gender button tap
        let allGenderButtonTap: Driver<Void>
        let maleButtonTap: Driver<Void>
        let femaleButtonTap: Driver<Void>
        
        // user location button tap
        let userLocationButtonTap: Driver<Void>
               
        // coord input relay
        
    }
    
    struct Output {
        // friends coord
        
        // center marker
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
