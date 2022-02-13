//
//  ProfileItemViewModel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/13.
//

import Foundation

struct ProfileItemViewModel {
    let background: SeSACBackground
    let sesac: SeSACFace
    let nick: String
    let reputation: [BaseButtonStatus]
    let comment: [String]
    let isExpanding = false
    
    init(model: UserInfoModel) {
        self.nick = model.nick
        self.reputation = model.reputation[0 ..< 6].map { $0 == 1 ? .fill : .inactive }
        self.comment = model.comment
        self.sesac = model.sesac
        self.background = model.background
    }
}

struct ProfileFooterViewModel {
    var gender: UserGender
    var hobby: String
    var searchable: Bool
    var minAge: Int
    var maxAge: Int
    
    init(model: UserInfoModel) {
        self.gender = model.gender
        self.hobby = model.hobby
        self.searchable = model.searchable
        self.minAge = model.ageMin
        self.maxAge = model.ageMax
    }
}
