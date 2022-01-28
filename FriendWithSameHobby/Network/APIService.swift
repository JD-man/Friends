//
//  APIService.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxSwift
import Moya

final class APIService {
    // decode o
    func userRequest<U: TargetType>(of target: U) -> Single<Data> {
        return Single<Data>.create { single in
            let provider = MoyaProvider<U>()
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print("API Service Status code : \(response.statusCode)")
                    single(.success(response.data))
                case .failure(let error):
                    let statusCode = error.response?.statusCode ?? 500
                    // Error...
                    print(statusCode)
                    single(.failure(CommonAPIError(rawValue: statusCode) ?? .unknownError))
                }
            }
            return Disposables.create()
        }
    }
    
    // decode x
    
}
