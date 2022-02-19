//
//  ChatResponseDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation

struct ChatResponseDTO: Codable {
    let id: String
    let v: Int
    let to, from, chat, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case to, from, chat, createdAt
    }
}

extension ChatResponseDTO {
    func toDomain() -> ChatResponseModel {
        return ChatResponseModel(id: id,
                                 v: v,
                                 to: to,
                                 from: from,
                                 chat: chat,
                                 createdAt: createdAt.toDate)
    }
}
