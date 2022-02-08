//
//  OnqueueResponseDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/06.
//

import Foundation

// MARK: - OnqueueResponseDTO
struct OnqueueResponseDTO: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

extension OnqueueResponseDTO {
    func toDomain() -> OnqueueResponseModel {
        return OnqueueResponseModel(fromQueueDB: fromQueueDB.map { $0.toDomain() },
                                    fromQueueDBRequested: fromQueueDBRequested.map { $0.toDomain() },
                                    fromRecommend: fromRecommend)
    }
}

extension FromQueueDB {
    func toDomain() -> FromQueueDBModel {
        return FromQueueDBModel(uid: uid,
                                nick: nick,
                                lat: lat,
                                long: long,
                                reputation: reputation,
                                hf: hf,
                                reviews: reviews,
                                gender: UserGender(rawValue: gender) ?? .unselected,
                                type: UserGender(rawValue: type) ?? .unselected,
                                sesac: SeSACFace(rawValue: sesac) ?? .basic,
                                background: background)
    }
}
