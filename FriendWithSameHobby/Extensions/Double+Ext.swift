//
//  Int+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/02/07.
//

import Foundation

extension Double {
    var setRegion: String {
        let str = String(self * 10000)
        let convert = str[str.startIndex ..< str.index(str.startIndex, offsetBy: 5)]
        return String(convert)
    }
}
