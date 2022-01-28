//
//  UserRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxSwift
import Moya

// DTO ---> Domain (toDomain function)
final class UserRepository: UserRepositoryInterface {
    private var disposeBag = DisposeBag()
    private let provider = MoyaProvider<UserTargets>()
    
    func getUserInfo() -> Single<UserInfoModel> {
        return Single<UserInfoModel>.create { [weak self] single in
            self?.provider.request(.getUserInfo) { result in
                switch result {
                case .success(let response):
                    guard let decoded = try? JSONDecoder().decode(UserInfoDTO.self, from: response.data) else {
                        print("decode fail")
                        return
                    }
                    single(.success(decoded.toDomain()))
                case .failure(let error):
                    let userInfoError = UserInfoError(rawValue: error.response?.statusCode ?? 502) ?? .unknownError
                    single(.failure(userInfoError))
                }
            }
            return Disposables.create()
        }
    }
    
    func registerUser(model: UserRegisterModel) -> Single<Bool> {
        let dto = UserRegisterDTO(model: model).toParameters()
        return Single<Bool>.create { [weak self] single in
            self?.provider.request(.postUser(parameters: dto)) { result in
                switch result {
                case .success(_):
                    single(.success(true))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
