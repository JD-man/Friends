//
//  UpdateFCMtokenModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/29.
//

import Foundation

struct UpdateFCMtokenModel {
    let fcmToken: String
    
    init() {
        self.fcmToken = UserInfoManager.fcmToken ?? ""
    }
}
