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
        let viewWillAppear: Driver<Void>
        let viewWillDisappear: Driver<Void>
        let backButtonTap: Driver<Void>
        let stopMatchingButtonTap: Driver<Void>
        let changeHobbyButtonTap: Driver<Void>
        let aroundButtonTap: Driver<Void>
        let requestedButtonTap: Driver<Void>
        let matchingButtonTap: PublishRelay<Int>
        let refreshingButtonTap: Driver<Void>
        let commentButtonTap: PublishRelay<Int>
        
        //let toggleButtonTap: PublishRelay<Int>
    }
    
    struct Output {
        // refresh result
        let queueItems = BehaviorRelay<[SectionOfMatchingItemViewModel]>(value: [])
        
        // user queue exist
        let isQueueExist = PublishRelay<Bool>()
        let selectedTap = BehaviorRelay<Bool>(value: true)
    }
    
    private var lat: Double
    private var long: Double
    
    var useCase: MatchingUseCase
    weak var coordinator: HomeCoordinator?
    private var timer: Disposable?
    fileprivate var disposeBag = DisposeBag()
    
    
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
                self?.useCase.executeCancelQueue()
            }.disposed(by: disposeBag)
        
        input.changeHobbyButtonTap
            .drive { [weak self] _ in
                self?.useCase.executeCancelQueue()
            }.disposed(by: disposeBag)
        
        input.aroundButtonTap
            .drive { [weak self] _ in
                output.selectedTap.accept(true)
                self?.useCase.excuteFriendsCoord(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0)
            }.disposed(by: disposeBag)
        
        input.requestedButtonTap
            .drive { [weak self] _ in
                output.selectedTap.accept(false)
                self?.useCase.excuteFriendsCoord(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0)
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .drive { [weak self] _ in
                self?.startTimer()
                self?.useCase.excuteFriendsCoord(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0)
            }.disposed(by: disposeBag)
        
        input.viewWillDisappear
            .asDriver()
            .drive { [weak self] _ in
                print("view will disappear")
                self?.timer?.dispose()
            }.disposed(by: disposeBag)
        
        input.refreshingButtonTap
            .throttle(.seconds(5))
            .drive { [weak self] _ in
                print("refreshing button tap")
                self?.useCase.excuteFriendsCoord(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0)
            }.disposed(by: disposeBag)
        
//        input.toggleButtonTap
//            .bind {
//                var queue = output.aroundQueue.value[0]
//                let item = queue.items[$0]
//                let currExpanding = !(item.expanding)
//                queue.items[$0].expanding = currExpanding
//                output.aroundQueue.accept([queue])
//            }.disposed(by: disposeBag)
        
        input.matchingButtonTap
            .asDriver(onErrorJustReturn: 0)
            .drive { [weak self] idx in                
                let uid = output.queueItems.value[0].items[idx].identity
                if output.selectedTap.value {
                    let alert = BaseAlertView(message: .matchingRequest, confirm: {
                        self?.useCase.executeRequestMatching(uid: uid)
                    })
                    alert.show()
                } else {
                    let alert = BaseAlertView(message: .matchingAllow, confirm: {
                        self?.useCase.executeAcceptMatching(uid: uid)
                    })
                    alert.show()
                }
            }.disposed(by: disposeBag)
        
        // Input to Coordinator
        input.backButtonTap
            .drive { [weak self] _ in
                self?.coordinator?.show(view: .mapView, by: .backToFirst)
            }.disposed(by: disposeBag)
        
        input.commentButtonTap
            .asDriver(onErrorJustReturn: 0)
            .drive { [weak self] in
                let comment = output.queueItems.value[0].items[$0].review
                self?.coordinator?.show(view: .commentView(review: comment), by: .push)
            }.disposed(by: disposeBag)
        
        // UseCase to Output
        let queueSuccess: Observable<[SectionOfMatchingItemViewModel]> = useCase.fromQueueSuccess
            .map {
                let queue = output.selectedTap.value ? $0.fromQueueDB : $0.fromQueueDBRequested
                return [SectionOfMatchingItemViewModel.init(items: queue.map {
                    MatchingItemViewModel(identity: $0.uid,
                                          sesac: $0.sesac,
                                          background: $0.background,
                                          nick: $0.nick,
                                          reputation: $0.reputation.map { $0 == 0 ? .inactive : .fill },
                                          hf: $0.hf,
                                          review: $0.reviews,
                                          matchingButtonStatus: output.selectedTap.value ? .request : .allow,
                                          expanding: false) })]
            }
        
        queueSuccess
            .bind(to: output.queueItems)
            .disposed(by: disposeBag)
        
        queueSuccess
            .map { $0[0].items.count > 0 }
            .bind(to: output.isQueueExist)
            .disposed(by: disposeBag)
        
        // UseCase to coordinator
        useCase.cancelSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                self?.coordinator?.show(
                    view: .hobbyView(lat: self?.lat ?? 0.0, long: self?.long ?? 0.0),
                    by: .backToFirst)
            }.disposed(by: disposeBag)
        
        useCase.cancelFail
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        useCase.requestMatchingSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                self?.coordinator?.toasting(message: "취미 함께 하기 요청을 보냈습니다.")
            }.disposed(by: disposeBag)
        
        useCase.requestMatchingFail
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        useCase.acceptMatchingSuccess
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] _ in
                self?.coordinator?.toasting(message: "취미 함께 하기 요청을 보냈습니다.")
                self?.coordinator?.show(view: .chatView, by: .push)
            }.disposed(by: disposeBag)
        
        useCase.acceptMatchingFail
            .asDriver(onErrorJustReturn: .unknownError)
            .drive { [weak self] in
                self?.coordinator?.toasting(message: $0.description)
            }.disposed(by: disposeBag)
        
        useCase.checkMatchingSuccess
            .asSignal()
            .emit { /*[weak self] in*/
                print($0)
            }.disposed(by: disposeBag)
        
        useCase.checkMatchingFail
            .asSignal()
            .emit { [weak self] in
                switch $0 {
                case .matchingStopped:
                    self?.startTimer()
                    self?.coordinator?.toasting(message: $0.description)
                default:
                    self?.coordinator?.toasting(message: $0.description)
                }
            }.disposed(by: disposeBag)
        
        return output
    }
}

extension MatchingViewModel {
    // MARK: - Check Matching Timer
    private func startTimer() {
        if let timer = timer { timer.dispose() }

        timer = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.useCase.executeCheckMatchingStatus()
            }
    }
}
