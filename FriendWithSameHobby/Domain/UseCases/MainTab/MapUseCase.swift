//
//  HomeUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//

import Foundation
import RxRelay

class MapUseCase: UseCaseType {
    var firebaseRepo: FirebaseAuthRepositoryInterface
    var queueRepo: QueueRepositoryInterface
    var userRepo: UserRepositoryInterface
    
    let fromQueueSuccess = PublishRelay<OnqueueResponseModel>()
    let fromQueueFail = PublishRelay<OnqueueError>()
    
    let checkMatchingSuccess = PublishRelay<MatchingStateModel>()
    let checkMatchingFail = PublishRelay<CheckMatchingError>()
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        queueRepo: QueueRepositoryInterface,
        userRepo: UserRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.queueRepo = queueRepo
        self.userRepo = userRepo
    }
    
    func excuteFriendsCoord(lat: Double, long: Double) {
        let model = OnqueueBodyModel(lat: lat, long: long)
        queueRepo.requestOnqueue(model: model, completion: { [weak self] result in
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
    
    func executeCheckMatchingStatus() {
        let model = MatchingBodyModel(uid: UserInfoManager.uid ?? "")        
        queueRepo.checkMatchingStatus(model: model, completion: { [weak self] result in
            switch result {
            case .success(let model):                
                UserChatManager.otherUID = model.matchedUid
                UserChatManager.otherNickname = model.matchedNick
                if model.matched {
                    UserMatchingStatus.matchingStatus = MatchingStatus.matched.rawValue
                }
                self?.checkMatchingSuccess.accept(model)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeCheckMatchingStatus()
                    }
                default:
                    self?.checkMatchingFail.accept(error)
                }
            }
        })
    }
    
    func updateFCMtoken() {
        let model = UpdateFCMtokenModel()
        userRepo.updateFCMtoken(model: model) { [weak self] result in
            switch result {
            case .success(_):
                print("updated FCM Token")
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.updateFCMtoken()
                default:
                    print("FCM Token update error")
                }
            }
        }
    }
    
    func tokenErrorHandling(completion: @escaping () -> Void) {
        firebaseRepo.refreshingIDtoken(completion: { result in
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
