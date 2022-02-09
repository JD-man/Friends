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
        // item selected
        let itemSelected: PublishRelay<(Int,String)>
        // find button
        let findButtonTap: Driver<Void>
    }
    struct Output {
        // collection view section
        let aroundHobby = PublishRelay<[SectionOfHobbyCellModel]>()        
    }
    
    private var disposeBag = DisposeBag()
    var useCase: HobbyUseCase
    weak var coordinator: HomeCoordinator?
    
    private var lat: Double
    private var long: Double
    private var searchTextRelay = BehaviorRelay<[String]>(value: [])
    
    init(useCase: HobbyUseCase, coordinator: HomeCoordinator, lat: Double, long: Double) {
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
        
        input.findButtonTap
            .drive { [weak self] _ in
                self?.useCase.excutePostQueue(lat: self?.lat ?? 0.0,
                                              long: self?.long ?? 0.0,
                                              hf: self?.searchTextRelay.value ?? [])
            }.disposed(by: disposeBag)
        
        // usecase to cooodinator
        useCase.postQueueSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] in
                if $0 { self?.coordinator?.pushUserSearchVC() }
            }.disposed(by: disposeBag)
        
        useCase.postQueueError
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        // input to search text relay
        input.searchBarText
            .map { [weak self] in
                self?.makeTagFromSearchbar(text: $0) ?? []
            }.drive(searchTextRelay)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .asDriver(onErrorJustReturn: (0, ""))
            .drive { [weak self] in
                self?.makeTagFromButton(section: $0.0, title: $0.1)
            }.disposed(by: disposeBag)
        
        // usecase to output
        let fromRequestedHF = useCase.fromQueueSuccess
            .map {
                Set($0.fromQueueDBRequested.flatMap { $0.hf })
                    .map { HobbyCellModel(identity: "hf\($0)", cellTitle: $0, status: .around) }
            }
        
        let fromRecommend = useCase.fromQueueSuccess
            .map {
                Set($0.fromRecommend)
                    .map { HobbyCellModel(identity: "recommend\($0)", cellTitle: $0, status: .recommend) }
            }
        
        let fromSearchText = searchTextRelay
            .map {
                $0.map { HobbyCellModel(identity: "search\($0)", cellTitle: $0, status: .added) }
            }
        
        Observable.combineLatest(fromRecommend, fromRequestedHF, fromSearchText)
            .map {
                return [SectionOfHobbyCellModel.init(headerTitle: "지금 주변에는", items: $0 + $1),
                        SectionOfHobbyCellModel.init(headerTitle: "내가 하고 싶은", items: $2)] }
            .bind(to: output.aroundHobby)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func makeTagFromSearchbar(text: String) -> [String] {
        var value = searchTextRelay.value
        let newArr = text.components(separatedBy: " ").filter { $0.count != 0 }
        newArr.forEach {
            if value.contains($0) == false, value.count < 8 {
                value.append($0)
            } else if value.count >= 8 {
                coordinator?.toasting(message: "취미를 더 이상 추가할 수 없습니다")
            }
        }
        return value
    }
    
    private func makeTagFromButton(section: Int, title: String) {
        var value = searchTextRelay.value
        if section == 0, value.contains(title) == false {
            value.append(title)
            searchTextRelay.accept(value)
        } else if section == 1 {
            let idx = value.firstIndex(of: title) ?? 0            
            value.remove(at: idx)
            searchTextRelay.accept(value)
        }
    }
}
