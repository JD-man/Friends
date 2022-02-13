//
//  UserInfoResponse.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation

// MARK: - UserInfoResponse
struct UserInfoDTO: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
    let gender: Int
    let hobby: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, hobby, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}

extension UserInfoDTO  {
    func toDomain() -> UserInfoModel {
        return UserInfoModel(id: id,
                             v: v,
                             uid: uid,
                             phoneNumber: phoneNumber,
                             email: email,
                             fcMtoken: fcMtoken,
                             nick: nick,
                             birth: birth.toDate,
                             gender: UserGender(rawValue: gender) ?? .unselected,
                             hobby: hobby,
                             comment: comment,
                             reputation: reputation,
                             sesac: SeSACFace(rawValue: sesac) ?? .basic,
                             sesacCollection: sesacCollection,
                             background: SeSACBackground(rawValue: background) ?? .basic,
                             backgroundCollection: backgroundCollection,
                             purchaseToken: purchaseToken,
                             transactionID: transactionID,
                             reviewedBefore: reviewedBefore,
                             reportedNum: reportedNum,
                             reportedUser: reportedUser,
                             dodgepenalty: dodgepenalty,
                             dodgeNum: dodgeNum,
                             ageMin: ageMin,
                             ageMax: ageMax,
                             searchable: searchable == 1 ? true : false,
                             createdAt: createdAt.toDate)
    }
}
