//
//  UserSearchUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/10.
//

import Foundation
import RxRelay

final class UserSearchUseCase: HomeUseCase {
    
    let cancelSuccess = PublishRelay<Bool>()
    let cancelFail = PublishRelay<CancelQueueError>()
    
    func cancelQueue() {
        queueRepo?.cancelQueue(completion: { [weak self] result in
            switch result {
            case .success(let isCanceled):
                self?.cancelSuccess.accept(isCanceled)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.cancelQueue()
                    }
                default:
                    self?.cancelFail.accept(error)
                }
            }
        })
    }
}
