//
//  HomeUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//

import Foundation
import RxRelay

final class HomeUseCase: UseCaseType {
    var firebaseRepo: FirebaseAuthRepositoryInterface?
    var queueRepo: QueueRepositoryInterface?
    
    let fromQueueSuccess = PublishRelay<OnqueueResponseModel>()
    let fromQueueFail = PublishRelay<OnqueueError>()
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        queueRepo: QueueRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.queueRepo = queueRepo
    }
    
    func excuteFriendsCoord(lat: Double, long: Double) {
        let model = OnqueueBodyModel(lat: lat, long: long)
        queueRepo?.requestOnqueue(model: model, completion: { [weak self] result in
            switch result {
            case .success(let model):
                self?.fromQueueSuccess.accept(model)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.excuteFriendsCoord(lat: lat, long: long)
                    }
                default:
                    self?.fromQueueFail.accept(error)
                }
            }
        })
    }
    
    private func tokenErrorHandling(completion: @escaping () -> Void) {
        firebaseRepo?.refreshingIDtoken(completion: { result in
            switch result {
            case .success(let idToken):
                UserInfoManager.idToken = idToken
                completion()
            case .failure(let error):
                print(error)
                break
            }
        })
    }
}
