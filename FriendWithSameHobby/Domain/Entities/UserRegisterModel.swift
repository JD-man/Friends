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
        self.phoneNumber = UserDefaultsManager.phoneNumber ?? ""
        self.fcmToken = UserDefaultsManager.fcmToken ?? ""
        self.nick = UserDefaultsManager.nick ?? ""
        self.birth = UserDefaultsManager.birth ?? Date()
        self.email = UserDefaultsManager.email ?? ""
        self.gender = UserDefaultsManager.gender ?? -1
    }
}
