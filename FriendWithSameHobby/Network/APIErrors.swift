//
//  APIErrors.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import Moya

protocol CustomError: Error {
    var description: String { get }
}

// MARK: - Get User Info Error
enum UserInfoError: Int, CustomError {
    case unknownError = -1
    case unregistered = 201
    case tokenError = 401
    case serverError = 500
    case clientError = 501
    case tooManyRequest = 17010
    case invalidCode = 17044
    
    var description: String {
        switch self {
        case .unknownError:
            return "에러가 발생했습니다. 다시 시도해주세요."
        case .unregistered:
            return "미가입 유저"
        case .tokenError:
            return "토큰 에러"
        case .serverError:
            return "서버 에러"
        case .clientError:
            return "클라이언트 에러"
        case .tooManyRequest:
            return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        case .invalidCode:
            return "잘못된 인증코드가 입력됐습니다."
        }
    }
}

enum UserRegisterError: Int, CustomError {
    case unknownError = -1
    case userExisted = 201
    case invalidNickname = 202
    case tokenError = 401
    case serverError = 500
    case clientError = 501
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다. 다시 시도해 주세요."
        case .userExisted:
            return "이미 가입한 유저입니다."
        case .invalidNickname:
            return "사용할 수 없는 닉네임 입니다."
        case .tokenError:
            return "토큰 에러입니다."
        case .serverError:
            return "서버 에러입니다."
        case .clientError:
            return "오류가 발생했습니다."
        }
    }
}

enum UserWithdrawError: Int, CustomError {
    case unknownError = -1
    case tokenError = 401
    case withdrawed = 406
    case serverError = 500
    
    var description: String {
        switch self {
        case .unknownError:
            return "오류가 발생했습니다. 다시 시도해 주세요."
        case .tokenError:
            return "토큰 에러"
        case .withdrawed:
            return "이미 탈퇴한 회원입니다."
        case .serverError:
            return "서버 에러"
        }
    }
}
