//
//  UserRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxSwift
import Moya

final class UserRepository {
    
    func getUserInfo() -> Single<PostUserResponse> {
        return APIService().userRequest(of: UserTargets.getUserInfo)
    }
    
//    func getUserInfo() -> Single<PostUserResponse> {
//        return Single<PostUserResponse>.create { single in
//            let provider = MoyaProvider<UserTargets>()
//            provider.request(.getUserInfo) { result in
//                switch result {
//                case .success(let response):
//                    let data = response.data
//                    print(response.statusCode)
//                    if let decoded = try? JSONDecoder().decode(PostUserResponse.self, from: data) {
//                        single(.success(decoded))
//                    }
//                    else {
//                        print("decode error")
//                    }
//                case .failure(let error):
//                    let statusCode = error.response?.statusCode ?? 500
//                    // Error...
//                    print(statusCode)
//                    single(.failure(UserAPIError(rawValue: statusCode) ?? .unknownError))
//                }
//            }
//            return Disposables.create()
//        }
//    }
    
    func postUser() {
        
    }
}
