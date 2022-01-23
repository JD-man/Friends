//
//  UserModels.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import Moya

protocol APITarget {}

enum UserTargets {
    case getUserInfo
    case postUser
}

extension UserTargets: TargetType, APITarget {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .getUserInfo, .postUser:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .postUser:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .postUser:
            return .requestParameters(parameters:
                                        ["phoneNumber": UserDefaultsManager.phoneNumber ?? "",
                                         "FCMtoken": UserDefaultsManager.FCMtoken ?? "",
                                         "nick": UserDefaultsManager.nick ?? "",
                                         "birth": UserDefaultsManager.birth ?? "",
                                         "email": UserDefaultsManager.email ?? "",
                                         "gender": UserDefaultsManager.gender ?? ""],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "idToken": UserDefaultsManager.idToken ?? ""]
        }
    }
}
