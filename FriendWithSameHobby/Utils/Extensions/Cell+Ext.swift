//
//  Cell+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/30.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
}

//extension UICollectionViewCell {
//    static var identifier: String {
//        return String(describing: self)
//    }
//}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
