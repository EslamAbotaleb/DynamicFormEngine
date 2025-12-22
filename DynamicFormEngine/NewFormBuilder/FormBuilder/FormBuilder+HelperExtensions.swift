//
//  FormBuilder+HelperExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 24/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation



extension FormBuilder {

    /// Convert a Gregorian date string to a Hijri date string.
    /// - Parameters:
    ///   - stringDate: The Gregorian date string.
    ///   - item: The date component item.
    /// - Returns: The Hijri date string.
    func convertDateToHijriString(stringDate: String, item: FormViewModelItem) -> String {
        let gregorianFormatter = DateFormatter()
        gregorianFormatter.timeZone = timeZone_UTC
        gregorianFormatter.calendar = Calendar(identifier: .gregorian)

        let date = stringDate.getDateFromString(dateFormatter: gregorianFormatter) ?? Date()

        let hijriFormatter = DateFormatter()
        hijriFormatter.calendar = hijriCalendar
        hijriFormatter.dateFormat = (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat
        hijriFormatter.timeZone = timeZone_UTC

        return hijriFormatter.string(from: date)
    }

    /// Handle DateTime control answers and process them into a suitable format.
    /// - Parameters:
    ///   - answer: The DateTime answer object.
    ///   - item: The associated DateTime control item.
    /// - Returns: A processed representation of the DateTime answer.
    func handleDateTimeAnswers(answer: DateTimeAnswer, item: FormViewModelItem) -> Any {
        let dateValues = answer.value ?? []
        let timeValues = answer.timeValues ?? []

        var fromDate = dateValues.first ?? ""
        let fromTime = timeValues.first ?? ""
        var toDate = dateValues.last ?? ""
        let toTime = timeValues.last ?? ""

        if answer.type != .Gregorian {
            fromDate = convertDateToHijriString(stringDate: fromDate, item: item)
            toDate = convertDateToHijriString(stringDate: toDate, item: item)
        }

        if dateValues.isEmpty {
            return handleEmptyDates(fromTime: fromTime, toTime: toTime)
        }

        if dateValues.count > 1 {
            return handleMultipleDates(fromDate: fromDate, fromTime: fromTime, toDate: toDate, toTime: toTime)
        }

        return timeValues.isEmpty ? dateValues : ["\(fromDate) \(fromTime)"]
    }

    /// Process DateTime answers for submission.
    /// - Parameters:
    ///   - answer: The DateTime answer object.
    ///   - item: The associated DateTime control item.
    /// - Returns: A processed array representation of the DateTime answer.
    func handleDateTimeAnswersWhenSubmit(answer: DateTimeAnswer, item: FormViewModelItem) -> [Any] {
        let dateValues = answer.value ?? []
        let timeValues = answer.timeValues ?? []

        var fromDate = dateValues.first ?? ""
        let fromTime = timeValues.first ?? ""
        var toDate = dateValues.last ?? ""
        let toTime = timeValues.last ?? ""

        if answer.type != .Gregorian {
            fromDate = convertDateToHijriString(stringDate: fromDate, item: item)
            toDate = convertDateToHijriString(stringDate: toDate, item: item)
        }

        if dateValues.isEmpty {
            return handleEmptyDatesForSubmit(fromTime: fromTime, toTime: toTime)
        }

        if dateValues.count > 1 {
            return dateValues
        }

        return timeValues.isEmpty ? dateValues : ["\(fromDate) \(fromTime)"]
    }

    /// Convert an array of date strings to ISO 8601 format.
    /// - Parameters:
    ///   - array: The array of date strings to be converted.
    ///   - dateProperties: Optional date properties for additional processing.
    /// - Returns: An array of formatted date strings.
    func convertDates(array: [Any], dateProperties: DateTimeProperties?) -> [String] {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        let possibleFormats = [
            "yyyy-MM-dd HH:mm",
            "dd-MM-yyyy HH:mm",
            "MM-dd-yyyy HH:mm",
            "yyyy-MM-dd",
            "dd-MM-yyyy",
            "MM-dd-yyyy",
            "HH:mm",
            "yyyy-MM-dd'T'HH:mm:ss'Z'"
        ]

        return array.compactMap { item in
            guard let dateString = item as? String else { return nil }
            return parseDate(dateString, formats: possibleFormats).map { outputFormatter.string(from: $0) }
        }
    }

    // MARK: - Private Helper Methods

    private func parseDate(_ dateString: String, formats: [String]) -> Date? {
        let inputFormatter = DateFormatter()
        for format in formats {
            inputFormatter.dateFormat = format
            if let date = inputFormatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }

    private func handleEmptyDates(fromTime: String, toTime: String) -> Any {
        if fromTime.isEmpty {
            return [toTime]
        } else if toTime.isEmpty {
            return [fromTime]
        } else {
            return [["from": fromTime, "to": toTime]]
        }
    }

    private func handleEmptyDatesForSubmit(fromTime: String, toTime: String) -> [Any] {
        if fromTime.isEmpty {
            return [toTime]
        } else if toTime.isEmpty {
            return [fromTime]
        } else {
            return [fromTime, toTime]
        }
    }

    private func handleMultipleDates(fromDate: String, fromTime: String, toDate: String, toTime: String) -> Any {
        if fromTime.isEmpty && toTime.isEmpty {
            return [fromDate, toDate]
        } else if fromDate.isEmpty || fromTime.isEmpty {
            return ["\(toDate) \(toTime)"]
        } else if toDate.isEmpty || toTime.isEmpty {
            return ["\(fromDate) \(fromTime)"]
        } else {
            return [["from": "\(fromDate) \(fromTime)", "to": "\(toDate) \(toTime)"]]
        }
    }
    
    func parseDate(from dateString: String) -> Date? {
        // List of date formats to try
        let dateFormats = ["yyyy-MM-dd", "MM-dd-yyyy", "dd-MM-yyyy"]
        let dateWithTimeFormats = [
            "yyyy-MM-dd HH:mm", "MM-dd-yyyy HH:mm", "dd-MM-yyyy HH:mm",
        ]
        for format in dateFormats {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        for format in dateWithTimeFormats {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
    
    func convertDateFormat(
        originalDateString: String, originalFormat: String,
        desiredFormat: String
    ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originalFormat
        
        if let date = dateFormatter.date(from: originalDateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = desiredFormat
            return outputDateFormatter.string(from: date)
        } else {
            print("Failed to parse the date string")
            return nil
        }
    }
}

