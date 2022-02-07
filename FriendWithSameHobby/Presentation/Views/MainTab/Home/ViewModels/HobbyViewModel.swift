//
//  HobbyViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/07.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class HobbyViewModel: ViewModelType {
    struct Input {
        // view will appear
        let viewWillAppear: Driver<Void>        
    }
    struct Output {
        let aroundTag = PublishRelay<[String]>()
        let fromRecommend = PublishRelay<[String]>()
    }
    
    private var disposeBag = DisposeBag()
    var useCase: HomeUseCase?
    weak var coordinator: HomeCoordinator?
    
    private var lat: Double
    private var long: Double
    
    init(useCase: HomeUseCase?, coordinator: HomeCoordinator?, lat: Double, long: Double) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.lat = lat
        self.long = long
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // input to usecase
        input.viewWillAppear
            .drive { [weak self] _ in
                self?.useCase?.excuteFriendsCoord(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0)
            }.disposed(by: disposeBag)
        
        // usecase to output
        useCase?.fromQueueSuccess
            .map { $0.fromQueueDBRequested.flatMap { $0.hf } }
            .bind(to: output.aroundTag)
            .disposed(by: disposeBag)
        
        useCase?.fromQueueSuccess
            .map{ $0.fromRecommend }
            .bind(to: output.fromRecommend)
            .disposed(by: disposeBag)
        
        return output
    }
}
