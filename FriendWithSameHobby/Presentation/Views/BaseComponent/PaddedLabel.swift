//
//  PaddedLabel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/10.
//

import UIKit

final class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
