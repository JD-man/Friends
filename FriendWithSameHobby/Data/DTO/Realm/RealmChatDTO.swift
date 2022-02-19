//
//  RealmChatDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/19.
//

import Foundation
import RealmSwift

final class RealmChatDTO: Object {
    // primaryKey = 상대방 uid
    @Persisted(primaryKey: true) var _id: String
    @Persisted var payload: List<RealmChatPayLoadDTO>
    
    convenience init(otheruid: String, chatHistory: [ChatResponseModel]) {
        self.init()
        self._id = otheruid
        
        let list = List<RealmChatPayLoadDTO>()
        chatHistory.forEach { list.append(RealmChatPayLoadDTO(model: $0)) }
        self.payload = list
    }
}

final class RealmChatPayLoadDTO: EmbeddedObject {
    @Persisted var id: String
    @Persisted var v: Int
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted var createdAt: String
    
    convenience init(model: ChatResponseModel) {
        self.init()
        self.id = model.id
        self.v = model.v
        self.to = model.to
        self.from = model.from
        self.chat = model.chat
        self.createdAt = model.createdAt.toString
    }
}

extension RealmChatDTO {
    func toDomain() -> [ChatResponseModel] {
        return Array(payload).map { $0.toDomain() }.sorted { $0.createdAt < $1.createdAt }
    }
}

extension RealmChatPayLoadDTO {
    func toDomain() -> ChatResponseModel {
        return ChatResponseModel(id: id,
                                 v: v,
                                 to: to,
                                 from: from,
                                 chat: chat,
                                 createdAt: createdAt.toDate)
    }
}
