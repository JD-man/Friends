//
//  UserRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import Moya

// DTO ---> Domain (toDomain function)
final class UserRepository: UserRepositoryInterface {
    private let provider = MoyaProvider<UserTargets>()
    
    func getUserInfo(completion: @escaping(Result<UserInfoModel, UserInfoError>) -> Void) {
        provider.request(.getUserInfo) { result in
            switch result {
            case .success(let response):
                guard let decoded = try? JSONDecoder().decode(UserInfoDTO.self, from: response.data) else {
                    print("decode fail")
                    return
                }
                completion(.success(decoded.toDomain()))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(UserInfoError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func updateFCMtoken(model: UpdateFCMtokenModel,
                        completion: @escaping (Result<Bool, UserInfoError>) -> Void) {
        let dto = UpdateFCMtokenDTO(model: model)
        provider.request(.updateFCMtoken(dto: dto)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(UserInfoError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func registerUser(model: UserRegisterModel,
                      completion: @escaping (Result<Bool, UserRegisterError>) -> Void) {
        let dto = UserRegisterDTO(model: model)
        provider.request(.postUser(dto: dto)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1                
                completion(.failure(UserRegisterError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func withdrawUser(completion: @escaping (Result<Bool, UserWithdrawError>) -> Void) {
        provider.request(.withdraw) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(UserWithdrawError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
}
