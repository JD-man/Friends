//
//  RealmRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/19.
//

import Foundation

protocol RealmRepositoryInterface {
    func getLastChatDate(of otheruid: String) -> String?
    func saveChatHistory(of otheruid: String, with chatHistory: [ChatResponseModel])
    func loadChat(otheruid: String) -> [ChatResponseModel]
}
