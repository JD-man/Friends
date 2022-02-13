//
//  UserInfoModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/27.
//

import Foundation

// DTO -> Model : birth, createdAt => Date Type
// gender, phoneNumber ??
struct UserInfoModel {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick: String
    let birth: Date
    let gender: UserGender
    let hobby: String
    let comment: [String]
    let reputation: [Int]
    let sesac: SeSACFace
    let sesacCollection: [Int]
    let background: SeSACBackground
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Bool
    let createdAt: Date
}
