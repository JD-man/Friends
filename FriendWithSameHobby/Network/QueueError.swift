//
//  QueueError.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/06.
//

import Foundation

enum OnqueueError: Int, CustomError {
    case unknownError = -1
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."
        case .unregistered:
            return "미가입회원"
        case .tokenError:
            return "토큰 에러"
        case .serverError:
            return "서버에러"
        case .clientError:
            return "클라이언트 에러"
        }
    }
}

enum PostQueueError: Int, CustomError {
    case unknownError = -1
    case reportThreeTime = 201
    case cancelPanelty1 = 203
    case cancelPanelty2 = 204
    case cancelPanelty3 = 205
    case unselectedGender = 206
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."
        case .reportThreeTime:
            return "신고하기 3번 이상 받았습니다."
        case .cancelPanelty1:
            return "약속 취소 페널티 1단계"
        case .cancelPanelty2:
            return "약속 취소 페널티 2단계"
        case .cancelPanelty3:
            return "약속 취소 페널티 3단계"
        case .unselectedGender:
            return "성별 없음"
        case .tokenError:
            return "토큰 에러"
        case .unregistered:
            return "미가입 회원"
        case .serverError:
            return "서버 에러"
        case .clientError:
            return "클라이언트 에러"
        }
    }
}
