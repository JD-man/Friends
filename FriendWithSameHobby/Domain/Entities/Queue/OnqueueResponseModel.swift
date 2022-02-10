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
    let background: SeSACBackground
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

enum SeSACBackground: Int {
    case basic = 0
    case cityView
    case nightTrail
    case dayTrail
    case stage
    case livingRoom
    case hometrainingRoom
    case musicRoom
    
    var imageAsset: ImageAsset {
        switch self {
        case .basic:
            return AssetsImages.sesacBackground1
        case .cityView:
            return AssetsImages.sesacBackground2
        case .nightTrail:
            return AssetsImages.sesacBackground3
        case .dayTrail:
            return AssetsImages.sesacBackground4
        case .stage:
            return AssetsImages.sesacBackground5
        case .livingRoom:
            return AssetsImages.sesacBackground6
        case .hometrainingRoom:
            return AssetsImages.sesacBackground7
        case .musicRoom:
            return AssetsImages.sesacBackground8
        }
    }
}
