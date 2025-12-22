//
//  Date+Extension.swift
//  CERQEL
//
//  Created by Omar Ibrahim on 11/11/25.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation

extension Date {

    func toFormattedString(format: String, calendar: Calendar = Calendar.current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar

        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
