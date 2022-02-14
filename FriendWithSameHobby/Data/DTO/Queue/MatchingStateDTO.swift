//
//  QueueStateDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/14.
//

import Foundation

struct MatchingStateDTO: Codable {
    var dodged: Int
    var matched: Int
    var reviewed: Int
    var matchedNick: String?
    var matchedUid: String?
}

extension MatchingStateDTO {
    func toDomain() -> MatchingStateModel {
        return MatchingStateModel(dodged: dodged,
                               matched: matched == 1 ? true : false,
                               reviewed: reviewed,
                               matchedNick: matchedNick,
                               matchedUid: matchedUid)
    }
}
