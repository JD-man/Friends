//
//  UserModels.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import Moya

typealias Parameters = [String: Any]

enum UserTargets {
    case getUserInfo
    case postUser(parameters: Parameters )
    case updateFCMtoken(parameters: Parameters)
    case withdraw
    case updateUserPage(parameters: Parameters)
    case reportUser(parameters: Parameters)
}

extension UserTargets: TargetType {
    var baseURL: URL {
        return URL(string: URLComponents.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo, .postUser:
            return "/user"
        case .updateFCMtoken:
            return "/user/update_fcm_token"
        case .withdraw:
            return "/user/withdraw"
        case .updateUserPage:
            return "/user/update/mypage"
        case .reportUser:
            return "/user/report"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .postUser, .withdraw, .updateUserPage, .reportUser:
            return .post
        case .updateFCMtoken:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo, .withdraw:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .postUser(let parameters),
                .updateFCMtoken(let parameters),
                .updateUserPage(let parameters):
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        case.reportUser(parameters: let parameters):
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding(arrayEncoding: .noBrackets))            
        }
    }
    
    var validationType: ValidationType {
        return .customCodes([200])
    }
    
    var headers: [String: String]? {
        return URLComponents.header
    }
}
