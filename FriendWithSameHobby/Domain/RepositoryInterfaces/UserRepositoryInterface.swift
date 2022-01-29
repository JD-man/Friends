//
//  UserRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift

protocol UserRepositoryInterface {
    func getUserInfo(completion: @escaping(Result<UserInfoModel, UserInfoError>) -> Void)
    func updateFCMtoken(model: UpdateFCMtokenModel,
                        completion: @escaping (Result<Bool, UserInfoError>) -> Void)
    func registerUser(model: UserRegisterModel, completion: @escaping (Result<Bool, UserRegisterError>) -> Void)
    
}
