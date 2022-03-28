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
    private let provider = MoyaProvider<UserTargets>(
        session: Session(interceptor: TokenRequestInterceptor())
    )
    
    func getUserInfo(completion: @escaping(Result<UserInfoModel, UserInfoError>) -> Void) {
        print("user info API Call")
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
        let parameters = UpdateFCMtokenDTO(model: model).toParameters()
        provider.request(.updateFCMtoken(parameters: parameters)) { result in
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
        let parameters = UserRegisterDTO(model: model).toParameters()
        provider.request(.postUser(parameters: parameters)) { result in
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
    
    func updateUserMyPage(model: UserMyPageModel, completion: @escaping (Result<Bool, UserMyPageError>) -> Void) {
        let parameters = UserMyPageDTO(model: model).toParameters()
        provider.request(.updateUserPage(parameters: parameters)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(UserMyPageError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func reportUser(model: ReportUserModel, completion: @escaping (Result<Bool, ReportUserError>) -> Void) {
        let parameters = ReportUserDTO(model: model).toParameters()
        provider.request(.reportUser(parameters: parameters)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(ReportUserError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func shopInfo(completion: @escaping (Result<UserShopInfoModel, UserShopError>) -> Void) {
        provider.request(.getShopInfo) { result in            
            switch result {
            case .success(let response):
                guard let decoded = try? JSONDecoder().decode(UserShopInfoDTO.self, from: response.data) else {
                    print("get shop info decode fail")
                    return
                }
                completion(.success(decoded.toDomain()))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(UserShopError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func saveImageProfile(model: UpdateImageModel, completion: @escaping (Result<Bool, UpdateImageError>) -> Void) {
        let parameters = UpdateImageDTO(model: model).toParameters()
        provider.request(.updateImage(parameters: parameters)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(UpdateImageError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
    
    func completePurchase(model: CompletePurchaseModel, completion: @escaping (Result<Bool, CompletePurchaseError>) -> Void) {
        let parameters = CompletePurchaseDTO(model: model).toParameters()
        provider.request(.completePurchase(parameters: parameters)) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                let statusCode = error.response?.statusCode ?? -1
                completion(.failure(CompletePurchaseError(rawValue: statusCode) ?? .unknownError))
            }
        }
    }
}
