//
//  DodgeMatchingDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation

struct DodgeMatchingDTO {
    var otherUID: String
    
    init(model: DodgeMatchingModel) {
        self.otherUID = model.otherUID
    }
}

extension DodgeMatchingDTO {
    func toParameters() -> Parameters {
        return [
            "otheruid": otherUID
        ]
    }
}
