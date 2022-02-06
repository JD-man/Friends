//
//  UpdateFCMtokenDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/29.
//

import Foundation

struct UpdateFCMtokenDTO: Codable {
    let fcmToken: String
    
    init(model: UpdateFCMtokenModel) {
        self.fcmToken = model.fcmToken
    }
}

extension UpdateFCMtokenDTO {
    func toParameters() -> [String: Any] {
        return ["FCMtoken": fcmToken]
    }
}
