//
//  UserMyPageModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//

import Foundation

enum UserGender: Int {
    case unselected = -1
    case female = 0
    case male = 1
}

struct UserMyPageModel {
    var gender: UserGender
    var hobby: String
    var searchable: Bool
    var minAge: Int
    var maxAge: Int
}
