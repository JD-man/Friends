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
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func registerUser(model: UserRegisterModel) -> Single<Bool> {
        let dto = UserRegisterDTO(model: model).toDict()
        return Single<Bool>.create { [weak self] single in
            self?.provider.request(.postUser(parameters: dto)) { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
}
