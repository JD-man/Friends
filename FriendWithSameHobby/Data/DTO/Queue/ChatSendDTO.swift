//
//  ChatSendDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation

struct ChatSendDTO {
    var chat: String
    
    init(model: ChatSendModel) {
        chat = model.chat
    }
}

extension ChatSendDTO {
    func toParameters() -> Parameters {
        return [
            "chat": chat
        ]
    }
}
