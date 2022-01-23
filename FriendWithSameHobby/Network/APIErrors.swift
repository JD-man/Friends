//
//  APIErrors.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation

enum UserAPIError: Int, Error {
    case exitedUser = 201
    case invalidNick = 202
    case tokenError = 401
    case serverError = 500
    case clientError = 501 // Header Body is invalid
    case unknownError
    
    var description: String {
        switch self {
        case .exitedUser:
            return "이미 존재하는 유저입니다."
        case .invalidNick:
            return "부적절한 닉네임입니다."
        case .tokenError:
            return "토큰 오류입니다."
        case .serverError:
            return "서버 오류입니다."
        case .clientError:
            return "클라이언트 오류입니다."
        case .unknownError:
            return "알 수 없는 오류입니다."
        }
    }
}
