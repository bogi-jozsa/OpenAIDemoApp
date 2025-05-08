//
//  DateFormatter.swift
//
//  Created by Vica Cotoarba on 17.09.2021.
//

import Foundation

extension DateFormatter {
    
    static var iso: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    static var dayMonth: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ro")
        formatter.dateFormat = "d MMMM"
        return formatter
    }
    
    private static var dayMonthYearShort: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ro")
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }
    
    /// Use this to remove the dot from the short date formatting
    static func getDayMonthYearString(from date: Date) -> String {
        return dayMonthYearShort.string(from: date).replacingOccurrences(of: ".", with: "")
    }
}
