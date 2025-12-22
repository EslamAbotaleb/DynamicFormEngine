//
//  String+Extension.swift
//  CERQEL
//
//  Created by Omar Ibrahim on 11/11/25.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation

extension String {

    func toDate(timeZone: Bool = true, calendar: Calendar = .current) -> Date? {
        let cleanedString = self.replacingOccurrences(of: #" \(.+\)"#, with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone ? .current : TimeZone(abbreviation: "UTC")

        let dateFormats: [String] = [
            "dd-MM-yyyy",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd HH:mm:ss Z",
            "EEE MMM dd yyyy HH:mm:ss 'GMT'Z",
            "yyyy-MM-dd'T'HH:mm:ss.SSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SS",
            "yyyy-MM-dd HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "E, d MMM yyyy HH:mm:ss ZZ",
            "E, dd MMM yyyy HH:mm:ss zzz",
            "y-MM-dd'T'HH:mm:ssZ",
            "dd/M/yyyy HH:mm",
            "d/M/yyyy",
            "yyyy/M/d",
            "M/d/y",
            "yyyy/MM/dd",
            "y-MM-dd",
            "HH:mm:ssZ",
            "yyyy-MM-dd",
            "dd/MM/yyyy, HH:mm",
            "dd/MM/yyyy - HH:mm a",
            "dd/MM/yyyy",
            "MM/dd/y",
            "hh:mm a",
            "HH:mma",
            "HH:mm a",
            "HH:mm",
            "EEE MMM dd yyyy HH:mm:ss 'GMT'Z"
        ]

        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: cleanedString) {
                return date
            }
        }

        return nil
    }

    func parseTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let parsedDate = formatter.date(from: self) else { return nil }

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: parsedDate)

        guard let hour = timeComponents.hour,
            let minute = timeComponents.minute,
            let second = timeComponents.second else {
            return nil
        }

        let today = Date()
        return calendar.date(bySettingHour: hour, minute: minute, second: second, of: today)
    }
}
