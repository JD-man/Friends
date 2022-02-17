//
//  MenuCommentUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/17.
//

import Foundation

final class MenuCommentUseCase: UseCaseType {
    let firebaseRepo: FirebaseAuthRepositoryInterface
    let queueRepo: QueueRepositoryInterface
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        queueRepo: QueueRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.queueRepo = queueRepo
    }
    
    func executeComment() {
        
    }
}
