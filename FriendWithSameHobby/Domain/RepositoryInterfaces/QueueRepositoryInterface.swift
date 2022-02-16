//
//  QueueRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/06.
//

import Foundation

protocol QueueRepositoryInterface {
    func requestOnqueue(
        model: OnqueueBodyModel,
        completion: @escaping (Result<OnqueueResponseModel, OnqueueError>) -> Void
    )
    
    func postQueue(
        model: PostQueueBodyModel,
        completion: @escaping (Result<Bool, PostQueueError>) -> Void
    )
    
    func cancelQueue(
        completion: @escaping (Result<Bool, CancelQueueError>) -> Void
    )
    
    func requestMatch(
        model: MatchingBodyModel,
        completion: @escaping (Result<Bool, RequestMatchingError>) -> Void
    )
    
    func acceptMatch(
        model: MatchingBodyModel,
        completion: @escaping (Result<Bool, AcceptMatchingError>) -> Void
    )
    
    func checkMatchingStatus(
        model: MatchingBodyModel,
        completion: @escaping (Result<MatchingStateModel, CheckMatchingError>) -> Void
    )
    
    func dodgeMatching(
        model: DodgeMatchingModel,
        completion: @escaping (Result<Bool, DodgeError>) -> Void
    )
}
