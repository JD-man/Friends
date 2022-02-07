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
    let sesac: SeSACFace
    let background: Int
}

enum SeSACFace: Int {
    case basic = 0
    case wink
    case mint
    case purple
    case gold
    
    var imageAsset: ImageAsset {
        switch self {
        case .basic:
            return AssetsImages.sesacFace1
        case .wink:
            return AssetsImages.sesacFace2
        case .mint:
            return AssetsImages.sesacFace3
        case .purple:
            return AssetsImages.sesacFace4
        case .gold:
            return AssetsImages.sesacFace5
        }
    }
}
