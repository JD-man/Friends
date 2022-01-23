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
    func userRequest<T: Codable, U: TargetType>(of target: U) -> Single<T> {
        return Single<T>.create { single in
            let provider = MoyaProvider<U>()
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    if statusCode == 200 {
                        let data = response.data
                        if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                            single(.success(decoded))
                        }
                        else {
                            print("decode error")
                        }
                    }
                    else {
                        single(.failure(UserAPIError(rawValue: statusCode) ?? .unknownError))
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            }            
            return Disposables.create()
        }
    }
}
