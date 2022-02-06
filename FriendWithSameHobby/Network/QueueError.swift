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
