//
//  UserRegisterModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/27.
//

import Foundation

struct UserRegisterModel {
    let phoneNumber: String
    let fcmToken: String
    let nick: String
    let birth: Date
    let email: String
    let gender: Int
    
    init() {
        self.phoneNumber = UserInfoManager.phoneNumber ?? ""
        self.fcmToken = UserInfoManager.fcmToken ?? ""
        self.nick = UserInfoManager.nick ?? ""
        self.birth = UserInfoManager.birth ?? Date()
        self.email = UserInfoManager.email ?? ""
        self.gender = UserInfoManager.gender ?? -1
    }
}
