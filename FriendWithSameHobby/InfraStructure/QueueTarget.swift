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
    case postQueue(Parameters: Parameters)
}

extension QueueTarget: TargetType {
    var baseURL: URL {
        return URL(string: URLComponents.baseURL)!
    }
    
    var path: String {
        switch self {
        case .searchFriends:
            return "/queue/onqueue"
        case .postQueue:
            return "/queue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchFriends, .postQueue:
            return .post
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
        }
    }
    
    var validationType: ValidationType {
        return .customCodes([200])
    }
    
    var headers: [String: String]? {
        return URLComponents.header
    }
}
