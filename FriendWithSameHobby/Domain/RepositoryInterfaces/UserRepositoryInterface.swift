//
//  UserRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift

protocol UserRepositoryInterface {
    func getUserInfo() -> Single<UserInfoModel>
    func registerUser(model: UserRegisterModel) -> Single<Bool>
}
