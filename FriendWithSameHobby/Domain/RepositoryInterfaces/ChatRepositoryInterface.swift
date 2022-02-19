//
//  ChatRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/16.
//

import Foundation

protocol ChatRepositoryInterface {
    func sendMessage(
        model: ChatSendModel,
        completion: @escaping (Result<ChatResponseModel, ChatSendError>) -> Void
    )
    
    func requestChatHistory(
        otheruid: String,
        lastChatDate: String,
        completion: @escaping (Result<[ChatResponseModel], RequestChatHistoryError>) -> Void
    )
    
    func socketConfig(idToken: String, callback: @escaping (ChatResponseModel) -> Void)
}
