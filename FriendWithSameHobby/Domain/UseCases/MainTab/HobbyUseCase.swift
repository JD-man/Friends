//
//  HobbyUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/07.
//

import Foundation

final class HobbyUseCase: UseCaseType {
    private var firebaseRepo: FirebaseAuthRepositoryInterface?
    private var queueRepo: QueueRepositoryInterface?
    
    init(
        firebaseRepo: FirebaseAuthRepositoryInterface,
        queueRepo: QueueRepositoryInterface
    ) {
        self.firebaseRepo = firebaseRepo
        self.queueRepo = queueRepo
    }
    
    func execute() {
        
    }
}
