//
//  ChatTarget.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation
import Moya

enum ChatTarget {
    case send(uid: String, parameters: Parameters)
    case chatHistory(uid: String, lastChatDate: String)
}

extension ChatTarget: TargetType {
    var baseURL: URL {
        return URL(string: URLComponents.baseURL)!
    }
    
    var path: String {
        switch self {
        case .send(let uid, _):
            return "/chat/\(uid)"
        case .chatHistory(let uid, _):
            return "/chat/\(uid)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .send:
            return .post
        case .chatHistory:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .chatHistory(_, _):
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .send(_, let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .customCodes([200])
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return URLComponents.header
        }
    }
}
