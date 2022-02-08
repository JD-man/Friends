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
    typealias OnqueueInput = (UserGender, Double, Double)
    
    struct Input {
        // matching button tap to push hobby VC
        let matchingButtonTap: Driver<(Double, Double)>
        
        // coord input relay
        let inputRelay: PublishRelay<OnqueueInput>        
    }
    
    struct Output {
        // friends coord
        let userCoord = PublishRelay<[FromQueueDBModel]>()
    }
    
    var useCase: HomeUseCase
    weak var coordinator: HomeCoordinator?
    private var disposeBag = DisposeBag()
    
    private var gender: UserGender = .unselected
    
    init(useCase: HomeUseCase, coordinator: HomeCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        
        input.inputRelay
            .skip(1)
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.gender = $0.0
                self?.useCase.excuteFriendsCoord(lat: $0.1, long: $0.2)
            }.disposed(by: disposeBag)
        
        input.matchingButtonTap
            .drive { [weak self] in
                self?.coordinator?.pushHobbyVC(lat: $0.0, long: $0.1)
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase.fromQueueSuccess
            .map { [weak self] in
                if self?.gender == UserGender.unselected { return $0.fromQueueDB }
                else { return $0.fromQueueDB.filter { $0.gender == self?.gender ?? .unselected } }
            }
            .bind(to: output.userCoord)
            .disposed(by: disposeBag)
        
        // UseCase to Coordinator
        
        return output
    }
}
