//
//  RequestMatchingDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//

import Foundation

struct MatchingBodyDTO {
    var uid: String
    
    init(model: MatchingBodyModel) {
        self.uid = model.uid
    }
}

extension MatchingBodyDTO {
    func toParameters() -> Parameters {
        return [
            "otheruid" : uid
        ]
    }
}
