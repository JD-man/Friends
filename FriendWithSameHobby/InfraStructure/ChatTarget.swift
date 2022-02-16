//
//  ChatTarget.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation
import Moya

enum ChatTarget {
    case connect
    case send(uid: String, parameters: Parameters)
}

extension ChatTarget: TargetType {
    var baseURL: URL {
        return URL(string: URLComponents.baseURL)!
    }
    
    var path: String {
        switch self {
        case .connect:
            return ""
        case .send(let uid, _):
            return "/chat/\(uid)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .connect:
            return .get
        case .send:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .connect:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .send(_, let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .connect:
            return URLComponents.chatHeader
        default:
            return URLComponents.header
        }
    }
}
