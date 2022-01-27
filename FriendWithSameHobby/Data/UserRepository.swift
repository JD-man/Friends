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
    
    func getUserInfo() -> Single<UserInfoModel> {
        return Single<UserInfoModel>.create { [unowned self] single in
            APIService().userRequest(of: UserTargets.getUserInfo)
                .subscribe { event in
                    switch event {
                    case .success(let data):
                        do {
                            let decoded = try JSONDecoder().decode(UserInfoDTO.self, from: data)
                            print(decoded)
                            single(.success(decoded.toDomain()))
                        }
                        catch {
                            print("decode fail")
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                        single(.failure(error))
                    }
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func registerUser(model: UserRegisterModel) -> Single<Bool> {
        let dto = UserRegisterDTO(model: model).toDict()
        return Single<Bool>.create { [unowned self] single in
            APIService().userRequest(of: UserTargets.postUser(parameters: dto))
                .subscribe { event in
                    switch event {
                    case .success(_):
                        single(.success(true))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
