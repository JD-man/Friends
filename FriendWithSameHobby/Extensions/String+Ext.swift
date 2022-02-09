//
//  String+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/22.
//

import UIKit

extension String {
    func highlightText(range: String) -> NSMutableAttributedString {
        let mutableAtt = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: range)
        
        mutableAtt.addAttribute(.foregroundColor,
                                value: UIColor.systemGreen,
                                range: range)
        mutableAtt.addAttribute(.font,
                                value: UIFont.systemFont(ofSize: 24, weight: .bold),
                                range: range)
        return mutableAtt
    }
    
    func removeHyphen() -> String {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
//    func addSideSpace() -> String {
//        return "    \(self)    "
//    }
}
