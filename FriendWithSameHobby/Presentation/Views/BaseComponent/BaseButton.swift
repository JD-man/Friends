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
    
    var status: BaseButtonStatus = .disable {
        didSet {            
            statusUpdate(status: status)
        }
    }
    
    convenience init(title: String, status: BaseButtonStatus, type: BaseButtonType) {
        self.init(type: .system)
        self.status = status
        statusUpdate(status: status)
        setTitle(title, for: .normal)
        frame.size.height = type.height
        titleLabel?.font = AssetsFonts.NotoSansKR.regular.font(size: 14)        
    }
    
    private func statusUpdate(status: BaseButtonStatus) {
        backgroundColor = status.backgroundColor
        setTitleColor(status.titleColor, for: .normal)
        addCorner(rad: 8,borderColor: status.cornerColor)
    }
}

enum BaseButtonStatus: Equatable {    
    case fill
    case cancel
    case outline(color: UIColor)
    case disable
    case inactive
    
    var backgroundColor: UIColor {
        switch self {
        case .inactive, .outline:
            return .systemBackground
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
        case .outline(let color):
            return color
        case .cancel:
            return AssetsColors.gray2.color
        case .disable:
            return AssetsColors.gray6.color
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .inactive, .cancel:
            return .label
        case .fill:
            return .systemBackground
        case .outline(let color):
            return color
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
