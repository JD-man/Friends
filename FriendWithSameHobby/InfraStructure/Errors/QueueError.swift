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

enum CancelQueueError: Int, CustomError {
    case unknownError = -1
    case alreadyMatched = 201
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."
        case .alreadyMatched:
            return "이미 매칭된 상태입니다."
        case .tokenError:
            return "토큰 에러"
        case .unregistered:
            return "미가입 유저"
        case .serverError:
            return "서버 에러"
        }
    }
}

enum RequestMatchingError: Int, CustomError {
    case unknownError = -1
    case requestedFromUser = 201
    case stopMatchingUser = 202
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."
        case .requestedFromUser:
            return "상대가 이미 나에게 취미 함께하기 요청한 상태입니다."
        case .stopMatchingUser:
            return "상대가 취미 함께할 친구 찾기 중단한 상태입니다."
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

enum AcceptMatchingError: Int, CustomError {
    case unknownError = -1
    case otherMatched = 201
    case otherStopped = 202
    case userMatched = 203
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."
        case .otherMatched:
            return "상대가 다른 사람과 매칭된 상태입니다."
        case .otherStopped:
            return "상대가 친구 찾기를 중단한 상태입니다."
        case .userMatched:
            return "이미 다른 사람과 매칭된 상태입니다,"
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

enum CheckMatchingError: Int, CustomError {
    case unknownError = -1
    case matchingStopped = 201
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."
        case .matchingStopped:
            return "친구 찾기가 중단이 된 상태입니다."
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

enum DodgeError: Int, CustomError {
    case unknownError = -1
    case wrongUID = 201
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."
        case .wrongUID:
            return "잘못된 UID"
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

enum CommentError: Int, CustomError {
    case unknownError = -1
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다."        
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
