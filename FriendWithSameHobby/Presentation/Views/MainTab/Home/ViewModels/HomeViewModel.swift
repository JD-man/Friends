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
        let matchingButtonTap: Driver<Void>
        
        // coord input relay
        let inputRelay: PublishRelay<OnqueueInput>        
    }
    
    struct Output {
        // friends coord
        let userCoord = PublishRelay<[(Double, Double, SeSACFace)]>()
    }
    
    var useCase: HomeUseCase?
    weak var coordinator: HomeCoordinator?
    private var disposeBag = DisposeBag()
    
    init(useCase: HomeUseCase?, coordinator: HomeCoordinator?) {
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
                self?.useCase?.excuteFriendsCoord(gender: $0.0, lat: $0.1, long: $0.2)
            }.disposed(by: disposeBag)
        
        input.matchingButtonTap
            .drive { [weak self] _ in
                self?.coordinator?.pushHobbyVC()
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase?.fromQueueSuccess
            .map {
                $0.map { ($0.lat, $0.long, $0.sesac) }
            }.bind(to: output.userCoord)
            .disposed(by: disposeBag)
        
        // UseCase to Coordinator
        
        return output
    }
}
