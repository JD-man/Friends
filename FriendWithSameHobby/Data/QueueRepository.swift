//
//  QueueRepository.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/04.
//

import Foundation
import Moya

final class QueueRepository/*: QueueRepositoryInterface */ {
    let provider = MoyaProvider<QueueTarget>()
    
    func searchFriends() {
        let parameter = [
            "region" : "1274830692",
            "lat" : "37.482733667903865",
            "long" : "126.92983890550006"
        ]
        provider.request(.searchFriends(parameters: parameter)) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
