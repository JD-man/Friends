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

enum SeSACFace: Int, CaseIterable {
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
    
    var productName: String {
        switch self {
        case .basic:
            return "기본 새싹"
        case .wink:
            return "튼튼 새싹"
        case .mint:
            return "민트 새싹"
        case .purple:
            return "퍼플 새싹"
        case .gold:
            return "골드 새싹"
        }
    }
    
    var description: String {
        switch self {
        case .basic:
            return "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        case .wink:
            return "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다."
        case .mint:
            return "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다."
        case .purple:
            return "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다."
        case .gold:
            return "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."
        }
    }
    
    var price: Int {
        switch self {
        case .basic:
            return 0
        case .wink:
            return 1200
        case .mint:
            return 2500
        case .purple:
            return 2500
        case .gold:
            return 2500
        }
    }
}

enum SeSACBackground: Int, CaseIterable {
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
    
    var productName: String {
        switch self {
        case .basic:
            return "하늘 공원"
        case .cityView:
            return "씨티 뷰"
        case .nightTrail:
            return "밤의 산책로"
        case .dayTrail:
            return "낮의 산책로"
        case .stage:
            return "연극 무대"
        case .livingRoom:
            return "라틴 거실"
        case .hometrainingRoom:
            return "홈트방"
        case .musicRoom:
            return "뮤지션 작업실"
        }
    }
    
    var description: String {
        switch self {
        case .basic:
            return "새싹들을 많이 마주치는 매력적인 하늘 공원입니다."
        case .cityView:
            return "창밖으로 보이는 도시 야경이 아름다운 공간입니다."
        case .nightTrail:
            return "어둡지만 무섭지 않은 조용한 산책로입니다."
        case .dayTrail:
            return "즐겁고 가볍게 걸을 수 있는 산책로입니다."
        case .stage:
            return "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다."
        case .livingRoom:
            return "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다."
        case .hometrainingRoom:
            return "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다."
        case .musicRoom:
            return "여러가지 음악 작업을 할 수 있는 작업실입니다."
        }
    }
    
    var price: Int {
        switch self {
        case .basic:
            return 0
        case .cityView:
            return 1200
        case .nightTrail:
            return 1200
        case .dayTrail:
            return 1200
        case .stage:
            return 2500
        case .livingRoom:
            return 2500
        case .hometrainingRoom:
            return 2500
        case .musicRoom:
            return 2500
        }
    }
}
