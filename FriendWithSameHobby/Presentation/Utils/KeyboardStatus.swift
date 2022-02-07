//
//  KeyboardStatus.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/08.
//

import UIKit

enum KeyboardStatus {
    case show(height: CGFloat, safeAreaBottom: CGFloat)
    case hide
    
    var height: CGFloat {
        switch self {
        case .show(let height, _):
            return height - 16
        case .hide:
            return 0
        }
    }
    
    var safeAreaBottom: CGFloat {
        switch self {
        case .show(_, let safeAreaBottom):
            return safeAreaBottom
        case .hide:
            return 0
        }
    }
    
    var sideInset: CGFloat {
        switch self {
        case .show:
            return 0
        case .hide:
            return 16
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .show:
            return 0
        case .hide:
            return 8
        }
    }
}
