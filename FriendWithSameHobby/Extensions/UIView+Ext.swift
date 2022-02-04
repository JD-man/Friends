//
//  UIButton+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/21.
//

import UIKit

extension UIView {
    func addCorner(rad: CGFloat, borderColor: UIColor?) {
        layer.borderWidth = 1
        layer.cornerRadius = rad
        layer.borderColor = (borderColor ?? .clear).cgColor
    }
    
    func addshadow(rad: CGFloat, opacity: Float) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = rad
        layer.shadowOpacity = opacity        
    }
}
