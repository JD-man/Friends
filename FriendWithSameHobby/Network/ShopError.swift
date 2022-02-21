//
//  ShopError.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/22.
//

import Foundation

enum ShopError: CustomError {
    case purchaseError
    
    var description: String {
        switch self {
        case .purchaseError:
            return "인앱구매에 실패했습니다."
        }
    }
}
