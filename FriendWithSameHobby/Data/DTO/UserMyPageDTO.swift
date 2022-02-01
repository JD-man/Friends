//
//  UserMyPageDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/02.
//

import Foundation

struct UserMyPageDTO: Codable {
    var gender: Int
    var hobby: String
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    
    init(model: UserMyPageModel) {
        self.gender = model.gender.rawValue
        self.hobby = model.hobby
        self.searchable = model.searchable ? 1 : 0
        self.ageMin = model.ageMin
        self.ageMax = model.ageMax
    }
}

extension UserMyPageDTO {
    func toParameters() -> [String: Any] {
        return ["gender": gender,
         "hobby": hobby,
         "searchable": searchable,
         "ageMin": ageMin,
         "ageMax": ageMax]
    }
}
