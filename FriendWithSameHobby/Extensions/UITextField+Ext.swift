//
//  UITextField+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/22.
//
import UIKit

extension UITextField {
    func basicConfig() {
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    func placeHolderConfig(text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.font : AssetsFonts.NotoSansKR.regular.font(size: 14),
                         .foregroundColor : AssetsColors.gray7.color])
    }
}
