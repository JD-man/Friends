//
//  UserRegisterDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/27.
//

import Foundation

struct UserRegisterDTO: Codable {
    let phoneNumber: String
    let fcmToken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
    
    init(model: UserRegisterModel) {
        self.phoneNumber = model.phoneNumber
        self.fcmToken = model.fcmToken
        self.nick = model.nick
        self.birth = model.birth.toString
        self.email = model.email
        self.gender = model.gender
    }
}

extension UserRegisterDTO {
    func toParameters() -> [String: Any] {
        return ["phoneNumber": phoneNumber.removeHyphen(),
         "FCMtoken": fcmToken,
         "nick": nick,
         "birth": birth,
         "email": email,
         "gender": gender]
    }
}
