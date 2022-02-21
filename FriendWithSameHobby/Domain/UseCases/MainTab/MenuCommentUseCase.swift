//
//  MenuCommentUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/17.
//

import Foundation
import RxRelay

final class MenuCommentUseCase: UseCaseType {
    let firebaseRepo: FirebaseAuthRepositoryInterface
    let queueRepo: QueueRepositoryInterface
    
    let commentSuccess = PublishRelay<Bool>()
    let commentFail = PublishRelay<CommentError>()
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        queueRepo: QueueRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.queueRepo = queueRepo
    }
    
    func executeComment(reputation: [BaseButtonStatus], comment: String) {
        let otheruid = UserChatManager.otherUID ?? ""
        let model = CommentBodyModel(otheruid: otheruid, reputation: reputation, comment: comment)
        queueRepo.commentUser(model: model) { [weak self] result in
            switch result {
            case .success(let isCommented):
                UserChatManager.otherUID = nil
                UserChatManager.otherNickname = nil
                UserMatchingStatus.matchingStatus = MatchingStatus.normal.rawValue
                self?.commentSuccess.accept(isCommented)
            case .failure(let error):
                switch error {
                case .tokenError:
                    self?.tokenErrorHandling {
                        self?.executeComment(reputation: reputation, comment: comment)
                    }
                default:
                    self?.commentFail.accept(error)
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
