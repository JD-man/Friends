//
//  OnqueueResponseModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/06.
//

import Foundation

struct OnqueueResponseModel {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDBModel]
    let fromRecommend: [String]
}

struct FromQueueDBModel {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender: UserGender
    let type: UserGender
    let sesac, background: Int
}
