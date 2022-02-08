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
        // search bar text
        let searchBarText: Driver<String>
    }
    struct Output {
        // collection view section
        let aroundHobby = PublishRelay<[SectionOfHobbyCellModel]>()        
    }
    
    private var disposeBag = DisposeBag()
    var useCase: HomeUseCase
    weak var coordinator: HomeCoordinator?
    
    private var lat: Double
    private var long: Double
    private var searchTextRelay = BehaviorRelay<[String]>(value: [])
    
    init(useCase: HomeUseCase, coordinator: HomeCoordinator, lat: Double, long: Double) {
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
                self?.useCase.excuteFriendsCoord(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0)
            }.disposed(by: disposeBag)
        
        // input to search text relay
        input.searchBarText
            .map { $0.components(separatedBy: " ") }
            .drive(searchTextRelay)
            .disposed(by: disposeBag)
        
        // usecase to output
        let fromRequestedHF = useCase.fromQueueSuccess
            .map {
                Set($0.fromQueueDBRequested.flatMap { $0.hf })
                    .map { HobbyCell(identity: $0, cellTitle: $0.addSideSpace(), status: .around) }
            }
        
        let fromRecommend = useCase.fromQueueSuccess
            .map {
                Set($0.fromRecommend)
                    .map { HobbyCell(identity: $0, cellTitle: $0.addSideSpace(), status: .recommend) }
            }
        
        let fromSearchText = searchTextRelay
            .map {
                Set($0).map { HobbyCell(identity: $0, cellTitle: $0.addSideSpace(), status: .added) }
            }
        
        Observable.combineLatest(fromRequestedHF, fromRecommend, fromSearchText)            
            .map {
                return [SectionOfHobbyCellModel.init(headerTitle: "지금 주변에는", items: $0 + $1),
                        SectionOfHobbyCellModel.init(headerTitle: "내가 하고 싶은", items: $2)] }
            .bind(to: output.aroundHobby)
            .disposed(by: disposeBag)
        
        return output
    }
}
