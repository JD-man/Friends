//
//  HobbyUseCase.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/07.
//

import Foundation
import RxRelay

final class HobbyUseCase: MapUseCase {
    
    let postQueueSuccess = PublishRelay<Bool>()
    let postQueueError = PublishRelay<PostQueueError>()
    
    func excutePostQueue(type: Int = 2 , lat: Double, long: Double, hf: [String]) {
        let model = PostQueueBodyModel(lat: lat, long: long, hf: hf)
        queueRepo.postQueue(model: model, completion: { [weak self] result in
            switch result {
            case .success(let isPosted):
                UserMatchingStatus.matchingStatus = MatchingStatus.waiting.rawValue
                self?.postQueueSuccess.accept(isPosted)
            case .failure(let error):
                self?.postQueueError.accept(error)
//                switch error {
//                case .tokenError:
//                    self?.tokenErrorHandling {
//                        self?.excutePostQueue(lat: lat, long: long, hf: hf)
//                    }
//                default:
//                    self?.postQueueError.accept(error)
//                }
            }
        })
    }
}
