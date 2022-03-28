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

final class MapViewModel: ViewModelType {
    typealias OnqueueInput = (UserGender, Double, Double)
    
    struct Input {
        let matchingButtonTap: Driver<(MatchingStatus, Double, Double)>
        let inputRelay: PublishRelay<OnqueueInput>
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        let userCoord = PublishRelay<[FromQueueDBModel]>()
        let isUserMatched = PublishRelay<Void>()
    }
    
    var useCase: MapUseCase
    weak var coordinator: HomeCoordinator?
    private var disposeBag = DisposeBag()
    
    private var gender: UserGender = .unselected    
    
    init(useCase: MapUseCase, coordinator: HomeCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.useCase.updateFCMtoken()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        //Input to UseCase        
        input.inputRelay
            .skip(1)
            .throttle(.milliseconds(800), latest: true, scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.gender = $0.0
                self?.useCase.excuteFriendsCoord(lat: $0.1, long: $0.2)
            }.disposed(by: disposeBag)

        input.matchingButtonTap
            .drive { [weak self] in
                if UserInfoManager.gender == -1 {
                    self?.coordinator?.show(view: .profileView, by: .push)
                } else {
                    switch $0.0 {
                    case .normal:
                        self?.coordinator?.show(view: .hobbyView(lat: $0.1, long: $0.2), by: .push)
                    case .waiting:
                        self?.coordinator?.show(view: .matchingView(lat: $0.1, long: $0.2), by: .push)
                    case .matched:
                        self?.coordinator?.show(view: .chatView, by: .push)
                    }
                }
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .asSignal()
            .emit { [weak self] _ in
                self?.useCase.executeCheckMatchingStatus()
            }.disposed(by: disposeBag)
        
        //UseCase to Output
        useCase.fromQueueSuccess
            .map { [weak self] in
                if self?.gender == UserGender.unselected { return $0.fromQueueDB }
                else { return $0.fromQueueDB.filter { $0.gender == self?.gender ?? .unselected } }
            }
            .bind(to: output.userCoord)
            .disposed(by: disposeBag)
        
        Observable.merge(
            useCase.checkMatchingSuccess.map { _ in () },
            useCase.checkMatchingFail.map { _ in () }
            ).bind(to: output.isUserMatched)
            .disposed(by: disposeBag)
        
        return output
    }
}
