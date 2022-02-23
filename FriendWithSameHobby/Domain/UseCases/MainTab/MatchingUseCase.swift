//
//  UserSearchUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/10.
//

import Foundation
import RxRelay

final class MatchingUseCase: MapUseCase {
    
    let cancelSuccess = PublishRelay<Bool>()
    let cancelFail = PublishRelay<CancelQueueError>()
    
    let requestMatchingSuccess = PublishRelay<Bool>()
    let requestMatchingFail = PublishRelay<RequestMatchingError>()
    
    let acceptMatchingSuccess = PublishRelay<Bool>()
    let acceptMatchingFail = PublishRelay<AcceptMatchingError>()
    
    func executeCancelQueue() {
        queueRepo.cancelQueue(completion: { [weak self] result in
            switch result {
            case .success(let isCanceled):
                UserMatchingStatus.matchingStatus = MatchingStatus.normal.rawValue
                self?.cancelSuccess.accept(isCanceled)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeCancelQueue()
                    }
                default:
                    self?.cancelFail.accept(error)
                }
            }
        })
    }
    
    func executeRequestMatching(uid: String) {
        let model = MatchingBodyModel(uid: uid)
        queueRepo.requestMatch(model: model, completion: { [weak self] result in
            switch result {
            case .success(let isRequested):
                self?.requestMatchingSuccess.accept(isRequested)
            case .failure(let error):
                switch error {
                case .requestedFromUser:
                    self?.executeAcceptMatching(uid: uid)
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeRequestMatching(uid: uid)
                    }
                default:
                    self?.requestMatchingFail.accept(error)
                }
            }
        })
    }
    
    func executeAcceptMatching(uid: String) {
        let model = MatchingBodyModel(uid: uid)
        queueRepo.acceptMatch(model: model, completion: { [weak self] result in
            switch result {
            case .success(let isAccepted):
                UserMatchingStatus.matchingStatus = MatchingStatus.matched.rawValue
                self?.acceptMatchingSuccess.accept(isAccepted)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeAcceptMatching(uid: uid)
                    }
                default:
                    self?.acceptMatchingFail.accept(error)
                }
            }
        })
    }
}
