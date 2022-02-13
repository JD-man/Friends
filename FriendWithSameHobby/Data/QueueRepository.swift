//
//  QueueRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//

import Foundation
import Moya

final class QueueRepository: QueueRepositoryInterface {
    typealias OnqueueResult = Result<OnqueueResponseModel, OnqueueError>
    typealias PostQueueResult = Result<Bool, PostQueueError>
    typealias CancelQueueResult = Result<Bool, CancelQueueError>
    typealias RequestMatchingResult = Result<Bool, RequestMatchingError>
    typealias AccetpMatchingResult = Result<Bool, AcceptMatchingError>
    
    let provider = MoyaProvider<QueueTarget>()
    
    func requestOnqueue(model: OnqueueBodyModel, completion: @escaping (OnqueueResult) -> Void) {
        let parameters = OnqueueBodyDTO(model: model).toParamteres()
        provider.request(.searchFriends(parameters: parameters)) { result in
            switch result {
            case .success(let response):                
                guard let decoded = try? JSONDecoder().decode(OnqueueResponseDTO.self,
                                                              from: response.data) else {                    
                    return
                }                
                completion(.success(decoded.toDomain()))                
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(OnqueueError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func postQueue(model: PostQueueBodyModel, completion: @escaping (PostQueueResult) -> Void) {
        let parameters = PostQueueBodyDTO(model: model).toParameters()
        provider.request(.postQueue(parameters: parameters)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                print(error)
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(PostQueueError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func cancelQueue(completion: @escaping (CancelQueueResult) -> Void) {
        provider.request(.cancelQueue) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(CancelQueueError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func requestMatch(model: MatchingBodyModel, completion: @escaping (RequestMatchingResult) -> Void) {
        let parameters = MatchingBodyDTO(model: model).toParameters()
        provider.request(.requestMatching(parameters: parameters)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(RequestMatchingError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func acceptMatch(model: MatchingBodyModel, completion: @escaping (AccetpMatchingResult) -> Void) {
        let parameters = MatchingBodyDTO(model: model).toParameters()
        provider.request(.requestMatching(parameters: parameters)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(AcceptMatchingError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
}
