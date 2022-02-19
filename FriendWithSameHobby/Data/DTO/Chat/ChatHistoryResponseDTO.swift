//
//  ChatHistoryDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/19.
//

import Foundation

struct ChatHistoryResponseDTO: Codable {
    var payload: [ChatResponseDTO]
}

extension ChatHistoryResponseDTO {
    func toDomain() -> [ChatResponseModel] {
        return payload.map { $0.toDomain() }
    }
}
