//
//  ChatError.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation

enum ChatSendError: Int, CustomError {
    case unknownError = -1
    case cannotSend = 201
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다"
        case .cannotSend:
            return "약속이 종료되어 채팅을 보낼 수 없습니다."
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
