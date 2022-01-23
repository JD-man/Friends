//
//  UserModels.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/23.
//

import Foundation
import Moya

enum UserTargets {
    case getUserInfo(idToken: String)
    case postUser(idToken: String)
}

extension UserTargets: TargetType {
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
            return .requestParameters(parameters: ["phoneNumber": "test"],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUserInfo(let idToken):
            return ["Content-Type": "application/json",
                    "idToken": idToken
            ]
        case .postUser(idToken: let idToken):
            return ["Content-Type": "application/json",
                    "idToken": idToken
            ]
        }
    }
}
