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
    let provider = MoyaProvider<QueueTarget>()
    
    func requestOnqueue(model: OnqueueBodyModel, completion: @escaping (OnqueueResult) -> Void) {
        print("onqueue request")
        let parameters = OnqueueBodyDTO(model: model).toParamteres()
        provider.request(.searchFriends(parameters: parameters)) { result in
            switch result {
            case .success(let response):                
                guard let decoded = try? JSONDecoder().decode(OnqueueResponseDTO.self,
                                                              from: response.data) else {
                    print("decoded fail")
                    return
                }
                print(decoded)
                completion(.success(decoded.toDomain()))                
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(OnqueueError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
}
