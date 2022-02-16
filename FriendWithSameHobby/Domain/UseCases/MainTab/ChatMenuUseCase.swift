//
//  ChatMenuUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation
import RxRelay

final class ChatMenuUseCase: UseCaseType {
    let firebaseRepo: FirebaseAuthRepositoryInterface
    let userRepo: UserRepositoryInterface
    let queueRepo: QueueRepositoryInterface
    
    let dodgeSuccess = PublishRelay<Bool>()
    let dodgeFail = PublishRelay<DodgeError>()
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        userRepo: UserRepositoryInterface,
        queueRepo: QueueRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.userRepo = userRepo
        self.queueRepo = queueRepo
    }
    
    func executeDodge() {
        let otherUID = UserChatManager.otherUID ?? ""
        let model = DodgeMatchingModel(otherUID: otherUID)
        queueRepo.dodgeMatching(model: model) { [weak self] result in
            switch result {
            case .success(let isDodged):
                UserChatManager.otherUID = nil
                UserMatchingStatus.matchingStatus = nil
                UserMatchingStatus.matchingStatus = MatchingStatus.normal.rawValue
                self?.dodgeSuccess.accept(isDodged)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeDodge()
                    }
                default:
                    self?.dodgeFail.accept(error)
                }
            }
        }
    }
    
    private func tokenErrorHandling(completion: @escaping () -> Void) {
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
