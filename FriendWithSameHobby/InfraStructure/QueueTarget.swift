//
//  QueueTarget.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//

import Foundation
import Moya

enum QueueTarget {
    case searchFriends(parameters: Parameters)
    case postQueue(parameters: Parameters)
    case cancelQueue
    case requestMatching(parameters: Parameters)
}

extension QueueTarget: TargetType {
    var baseURL: URL {
        return URL(string: URLComponents.baseURL)!
    }
    
    var path: String {
        switch self {
        case .searchFriends:
            return "/queue/onqueue"
        case .postQueue, .cancelQueue:
            return "/queue"
        case .requestMatching:
            return "/queue/hobbyrequest"
        }
    
    }
    
    var method: Moya.Method {
        switch self {
        case .searchFriends, .postQueue, .requestMatching:
            return .post
        case .cancelQueue:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .searchFriends(let parameters):
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        case .postQueue(let parameters):
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding(arrayEncoding: .noBrackets))
        case .cancelQueue:
            return .requestParameters(parameters: [:],
                                      encoding: URLEncoding.default)
        case .requestMatching(let parameters):
            return .requestParameters(parameters: parameters,
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
