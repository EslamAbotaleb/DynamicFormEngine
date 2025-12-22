//
//  DateTimeFunctionLibrary.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/10/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class DateTimeFunctionLibrary {

    func getFunctions() -> [String: ([Any]) throws -> Any] {
        return [
            "addDays": addDays,
            "addWeeks": addWeeks,
            "addMonths": addMonths,
            "addYears": addYears,
            "getDateTimeNow": { _ in self.getDateTimeNow() },  // This is different, as it doesn't take any arguments
            "formatDateTime": formatDateTime,
            "daysBetween": daysBetween,
            "weeksBetween": weeksBetween,
            "monthsBetween": monthsBetween,
            "yearsBetween": yearsBetween,
            "minDateTime": minDateTime,
            "maxDateTime": maxDateTime,
            "averageDateTime": averageDateTime
        ]
    }

    private func addDays(args: [Any]) throws -> Date {
        let date = try parseDateArgument(args[0])
        let days = try parseIntOrDoubleArgument(args[1])
        return Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
    }

    private func addWeeks(args: [Any]) throws -> Date {
        let date = try parseDateArgument(args[0])
        let weeks = try parseIntOrDoubleArgument(args[1])
        return Calendar.current.date(byAdding: .day, value: weeks * 7, to: date) ?? date
    }

    private func addMonths(args: [Any]) throws -> Date {
        let date = try parseDateArgument(args[0])
        let months = try parseIntOrDoubleArgument(args[1])
        return Calendar.current.date(byAdding: .month, value: months, to: date) ?? date
    }

    private func addYears(args: [Any]) throws -> Date {
        let date = try parseDateArgument(args[0])
        let years = try parseIntOrDoubleArgument(args[1])
        return Calendar.current.date(byAdding: .year, value: years, to: date) ?? date
    }

    private func getDateTimeNow() -> Date {
        return Date()
    }

    private func formatDateTime(args: [Any]) throws -> String {
        let date = try parseDateArgument(args[0])
        guard let format = args[1] as? String else {
            throw NSError(domain: "DateTimeError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Invalid format argument for formatDateTime"])
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    private func daysBetween(args: [Any]) throws -> Int {
        let startDate = try parseDateArgument(args[0])
        let endDate = try parseDateArgument(args[1])
        return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }

    private func weeksBetween(args: [Any]) throws -> Int {
        return try daysBetween(args: args) / 7
    }

    private func monthsBetween(args: [Any]) throws -> Int {
        let startDate = try parseDateArgument(args[0])
        let endDate = try parseDateArgument(args[1])
        return Calendar.current.dateComponents([.month], from: startDate, to: endDate).month ?? 0
    }

    private func yearsBetween(args: [Any]) throws -> Int {
        let startDate = try parseDateArgument(args[0])
        let endDate = try parseDateArgument(args[1])
        return Calendar.current.dateComponents([.year], from: startDate, to: endDate).year ?? 0
    }

    private func minDateTime(args: [Any]) throws -> Date {
        let dates = try parseDateArrayArgument(args)
        return dates.min() ?? Date()
    }

    private func maxDateTime(args: [Any]) throws -> Date {
        let dates = try parseDateArrayArgument(args)
        return dates.max() ?? Date()
    }

    private func averageDateTime(args: [Any]) throws -> Date {
        let dates = try parseDateArrayArgument(args)
        let totalMilliseconds = dates.map { $0.timeIntervalSince1970 }.reduce(0, +)
        return Date(timeIntervalSince1970: totalMilliseconds / Double(dates.count))
    }
    
    // Helper function to parse a date argument (String or Date)
    private func parseDateArgument(_ arg: Any) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateString = arg as? String, let parsedDate = dateFormatter.date(from: dateString) {
            return parsedDate
        } else if let date = arg as? Date {
            return date
        } else {
            throw NSError(domain: "DateTimeError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid date argument"])
        }
    }

    // Helper function to parse an Int or Double argument
    private func parseIntOrDoubleArgument(_ arg: Any) throws -> Int {
        if let intValue = arg as? Int {
            return intValue
        } else if let doubleValue = arg as? Double {
            return Int(doubleValue)
        } else {
            throw NSError(domain: "DateTimeError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid number argument"])
        }
    }

    // Helper function to parse an array of dates
    private func parseDateArrayArgument(_ args: [Any]) throws -> [Date] {
        return try args.map { try parseDateArgument($0) }
    }

}
