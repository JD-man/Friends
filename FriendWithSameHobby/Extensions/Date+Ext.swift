//
//  Date+Ext.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/24.
//

import Foundation

extension DateFormatter {
    static var DateFormatterKR: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        return formatter
    }
}

extension String {
    var toDate: Date {
        let formatter = DateFormatter.DateFormatterKR
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: self) ?? Date()
        return date
    }
}

extension Date {
    var toString: String {
        let formatter = DateFormatter.DateFormatterKR
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: self)
    }
    
    var currentDate: String {
        let formatter = DateFormatter.DateFormatterKR        
        formatter.dateFormat = "MM'월' dd'일' EEEE"
        
        return formatter.string(from: self)
    }
}
