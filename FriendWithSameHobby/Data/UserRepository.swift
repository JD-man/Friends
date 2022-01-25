//
//  UserRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import RxSwift
import Moya

final class UserRepository: UserRepositoryInterface {
    
    private var disposeBag = DisposeBag()
    
    func getUserInfo() -> Single<UserInfoResponse> {
        return Single<UserInfoResponse>.create { [unowned self] single in
            APIService().userRequest(of: UserTargets.getUserInfo)
                .subscribe { event in
                    switch event {
                    case .success(let data):
                        do {
                            let decoded = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                            print(decoded)
                            single(.success(decoded))
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
    
    func registerUser() -> Single<Bool> {
        
        return Single<Bool>.create { [unowned self] single in
            APIService().userRequest(of: UserTargets.postUser)
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
