//
//  UpdateImageDTO.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/21.
//

import Foundation

struct UpdateImageDTO {
    let sesac: Int
    let background: Int
    
    init(model: UpdateImageModel) {
        self.sesac = model.sesac.rawValue
        self.background = model.background.rawValue
    }
}

extension UpdateImageDTO {
    func toParameters() -> Parameters {
        return [
            "sesac": sesac,
            "background": background
        ]
    }
}
