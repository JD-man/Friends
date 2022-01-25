//
//  UserRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/25.
//

import Foundation
import RxSwift

protocol UserRepositoryInterface {
    func getUserInfo() -> Single<PostUserResponse>
    func registerUser() -> Single<PostUserResponse>
}
