//
//  RequestMatchingDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//

import Foundation

struct RequestMatchingDTO {
    var uid: String
    
    init(model: RequestMatchingModel) {
        self.uid = model.uid
    }
}

extension RequestMatchingDTO {
    func toParameters() -> Parameters {
        return [
            "otheruid" : uid
        ]
    }
}
