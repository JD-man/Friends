//
//  BaseButton.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import UIKit

final class BaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(title: String, status: BaseButtonStatus, type: BaseButtonType) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        frame.size.height = type.height
        backgroundColor = status.backgroundColor
        setTitleColor(status.titleColor, for: .normal)
        addCorner(rad: 8,borderColor: status.cornerColor)
        titleLabel?.font = AssetsFonts.NotoSansKR.regular.font(size: 14)
    }
}

enum BaseButtonStatus {
    case inactive
    case fill
    case outline
    case cancel
    case disable
    
    var backgroundColor: UIColor {
        switch self {
        case .inactive, .outline:
            return AssetsColors.white.color
        case .fill:
            return AssetsColors.green.color
        case .cancel:
            return AssetsColors.gray2.color
        case .disable:
            return AssetsColors.gray6.color
        }
    }
    
    var cornerColor: UIColor {
        switch self {
        case .inactive:
            return AssetsColors.gray4.color
        case .fill:
            return AssetsColors.green.color
        case .outline:
            return AssetsColors.green.color
        case .cancel:
            return AssetsColors.gray2.color
        case .disable:
            return AssetsColors.gray6.color
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .inactive, .cancel:
            return AssetsColors.black.color
        case .fill:
            return AssetsColors.white.color
        case .outline:
            return AssetsColors.green.color
        case .disable:
            return AssetsColors.gray3.color
        }
    }
}

enum BaseButtonType {
    case h48
    case h40
    case h32
    
    var height: CGFloat {
        switch self {
        case .h48:
            return 48
        case .h40:
            return 40
        case .h32:
            return 32
        }
    }
    
    // different line height
    
//    var titleFont: UIFont {
//        switch self {
//        case .h48, .h40:
//            return AssetsFonts.NotoSansKR.regular.font(size: 14)
//        case .h32:
//            return AssetsFonts.NotoSansKR.regular.font(size: 14)
//        }
//    }
}
