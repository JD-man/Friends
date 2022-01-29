//
//  UserModels.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import Moya

enum UserTargets {
    case getUserInfo
    case postUser(dto: UserRegisterDTO)
    case updateFCMtoken(dto: UpdateFCMtokenDTO)
}

extension UserTargets: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .getUserInfo, .postUser:
            return "/user"
        case .updateFCMtoken:
            return "/user/update_fcm_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .postUser:
            return .post
        case .updateFCMtoken:
            return .put            
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .postUser(let dto):
            return .requestParameters(parameters: dto.toParameters(),
                                      encoding: URLEncoding.default)
        case .updateFCMtoken(let dto):
            return .requestParameters(parameters: dto.toParameters(),
                                      encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .customCodes([200])
    }
    
    var headers: [String: String]? {
        return URLComponents.header
    }
}
