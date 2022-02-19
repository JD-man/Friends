//
//  RealmRepositoryInterface.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/19.
//

import Foundation

protocol RealmRepositoryInterface {
    func loadChat(of otheruid: String) -> [ChatResponseModel]
}
