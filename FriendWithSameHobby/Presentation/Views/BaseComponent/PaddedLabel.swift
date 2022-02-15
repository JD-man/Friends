//
//  PaddedLabel.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/10.
//

import UIKit

final class PaddedLabel: UILabel {
    var padding: UIEdgeInsets
    
    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
