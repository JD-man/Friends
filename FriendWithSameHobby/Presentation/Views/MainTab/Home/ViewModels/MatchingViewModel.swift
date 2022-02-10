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

final class MatchingViewModel: ViewModelType {
    struct Input {
        // back button tap
        let backButtonTap: Driver<Void>
        // stop matching button tap
        let stopMatchingButtonTap: Driver<Void>
        // change hobby button tap
        let changeHobbyButtonTap: Driver<Void>
        // refresh button tap
        
        // around button tap
        let aroundButtonTap: Driver<Void>
        // requested button tap
        let requestedButtonTap: Driver<Void>
    }
    
    struct Output {
        // refresh result
        
        // fromQueueDB result
        let aroundQueue = PublishRelay<[SectionOfMatchingItemViewModel]>()
        // fromQueueDBRequested result
    
    }
    
    private var lat: Double
    private var long: Double
    var useCase: MatchingUseCase
    weak var coordinator: HomeCoordinator?
    
    init(
        useCase: MatchingUseCase,
        coordinator: HomeCoordinator,
        lat: Double,
        long: Double
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.lat = lat
        self.long = long
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // Input to UseCase
        input.stopMatchingButtonTap
            .drive { [weak self] _ in
                self?.useCase.cancelQueue()
            }.disposed(by: disposeBag)
        
        input.changeHobbyButtonTap
            .drive { [weak self] _ in
                self?.useCase.cancelQueue()
            }.disposed(by: disposeBag)
        
        input.aroundButtonTap
            .drive { [weak self] _ in
                self?.useCase.excuteFriendsCoord(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0)
            }.disposed(by: disposeBag)
        
        // Input to Coordinator
        input.backButtonTap
            .drive { [weak self] _ in
                self?.coordinator?.navigationController.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        useCase.fromQueueSuccess
            .map {
                [SectionOfMatchingItemViewModel.init(items: $0.fromQueueDB.map {
                    MatchingItemViewModel(identity: $0.uid,
                                          sesac: $0.sesac,
                                          background: $0.background,
                                          nick: $0.nick,
                                          reputation: $0.reputation.map { $0 == 0 ? .inactive : .fill },
                                          hf: $0.hf,
                                          review: $0.reviews,
                                          expanding: false) })]
            }.bind(to: output.aroundQueue)
            .disposed(by: disposeBag)
        
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
