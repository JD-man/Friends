//
//  ChatItemViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/15.
//

import Foundation

enum ChatUserType {
    case me
    case you
}

struct ChatItemViewModel {
    var userType: ChatUserType
    var message: String
    var time: String
}
