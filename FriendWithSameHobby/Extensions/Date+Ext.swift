//
//  Date+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/24.
//

import Foundation

//extension String {
//    var toDate: String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
//        formatter.timeZone = TimeZone(abbreviation: "UTC")
//        
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let date = formatter.date(from: self) ?? Date()
//        return date.toString
//    }
//}

extension Date {
    var toString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: self)
    }
}
