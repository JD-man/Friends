//
//  CommentBodyDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/17.
//

import Foundation

struct CommentBodyDTO {
    let otheruid: String
    let reputation: [Int]
    let comment: String
    
    init(model: CommentBodyModel) {
        self.otheruid = model.otheruid
        self.reputation = model.reputation.map { $0 == .fill ? 1 : 0 } + [0, 0]
        self.comment = model.comment
    }
}

extension CommentBodyDTO {
    func toParameters() -> Parameters {
        return [
            "otheruid": otheruid,
            "reputation": reputation,
            "comment": comment
        ]
    }
}

/*
 {
   "otheruid" : "NuK12cdVaDVcc9e4ctxsLMNCrHQ2",
   "reputation": [1, 1, 1, 1, 1, 1, 0, 0, 0],
   "comment" : "약속 시간을 잘 지키고 친절해요!"
 }
 */
