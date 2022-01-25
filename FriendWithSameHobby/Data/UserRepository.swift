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
    
    func getUserInfo() -> Single<PostUserResponse> {
        return APIService().userRequest(of: UserTargets.getUserInfo)
    }
    
    func registerUser() -> Single<PostUserResponse> {
        
        print(UserDefaultsManager.phoneNumber)
        print(UserDefaultsManager.FCMtoken)
        print(UserDefaultsManager.nick)
        print(UserDefaultsManager.birth)
        print(UserDefaultsManager.email)
        print(UserDefaultsManager.gender)
        
        return APIService().userRequest(of: UserTargets.postUser)
    }
}
