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
                    let data = response.data
                    print(response.statusCode)
                    if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                        single(.success(decoded))
                    }
                    else {
                        print("decode error")
                    }
                case .failure(let error):
                    let statusCode = error.response?.statusCode ?? 500
                    // Error...
                    print(statusCode)
                    single(.failure(UserAPIError(rawValue: statusCode) ?? .unknownError))
                }
            }
            return Disposables.create()
        }
    }
}
