//
//  Date+Helpers.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation


extension String {
    
    
    var to24Hours: String {
        if let date = Formatter.Hours12.date(from: self) {
            let outputTime = Formatter.Hours24.string(from: date)
            return  outputTime
        }
        return ""
    }
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        return dateFormatter.date(from: self)
    }
    
    func formatToLocalizedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        if let inputDate = dateFormatter.date(from: self) {
            dateFormatter.locale = Locale(identifier: "ar")
            dateFormatter.dateFormat = "dd MMMM yyyy, الساعة h:mm a"
            return dateFormatter.string(from: inputDate)
        } else {
            return "Invalid date format."
        }
    }
    
    func formatToLocalizedDateString(formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        if let inputDate = dateFormatter.date(from: self) {
            dateFormatter.locale = Locale(identifier: isArabic() ? "ar" : "en")
            dateFormatter.dateFormat = formate
            return dateFormatter.string(from: inputDate)
        } else {
            return "Invalid date format."
        }
    }
    
    func formatDateString(currentFormat: DateFormatter,desiredFormat: DateFormatter) -> String? {
        if let date = currentFormat.date(from: self) {
            let formattedDate = desiredFormat.string(from: date)
            return formattedDate
        }
        return nil
    }
    
    func formatDateString(desiredFormat: DateFormatter) -> String? {
        if let date = DateFormatter.parseIsoDate(self) {
            let formattedDate = desiredFormat.string(from: date)
            return formattedDate
        }
        return nil
    }
    
}

extension Date {
    
    func toString() -> String {
        return Formatter.IsoDate.string(from: self)
    }
    func toString2() -> String {
        return Formatter.IsoDate2.string(from: self)
    }
    
    static func convertTimeToDate(_ timeString: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Combine the timeString with the current date
        let combinedString = "\(currentDateToString(dateFormatter: "yyyy-MM-dd")) \(timeString):00"
        
        if let combinedDate = dateFormatter.date(from: combinedString) {
            // Format the combinedDate to the desired format
            //  return dateFormatter.string(from: combinedDate)
            return combinedDate
        }
        
        return nil
    }
    
    static func currentDateToString(dateFormatter format: String) -> String {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let previousDay = calendar.date(byAdding: .day, value: +1, to: currentDate) ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: previousDay)
    }
    
    static func getCurrentIslamDate() -> String {
        let currentDate = Date()
        return Formatter.islamicFormat.string(from: currentDate)
        
    }
    static func getCurrentDateWithSpecificFormat() -> String {
        let currentDate = Date()
        return Formatter.specificDate.string(from: currentDate)
    }
    
    static func getCurrentTime() -> String {
        let currentTime = Date()
        return Formatter.Hours24.string(from: currentTime)
        
    }
    static func getCurrentTimeWithDate() -> String {
        let currentTime = Date()
        return Formatter.Hours24WithDate.string(from: currentTime)
        
    }
    
    
    static func getTimeDifference(firstTime: String, secondtime: String) -> String {
        
        
        guard let date1 = Formatter.Hours24.date(from: firstTime),
              let date2 = Formatter.Hours24.date(from: secondtime) else {
            return ""
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date1, to: date2)
        
        
        let hourDifference = components.hour ?? 0
        let minuteDifference = components.minute ?? 0
        let secondsDifference = components.second ?? 0
        
        
        return String(format: "%02d:%02d:%02d", hourDifference, minuteDifference,secondsDifference)
    }
    
    static func getHourAndMinutes(time: String) -> DateComponents {
        
        if  let date = Formatter.Hours12.date(from: time) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            
            return components
        }
        return DateComponents()
    }
    
    func cerqel_addIntervalToSpecificDate(years: Int? = nil, months: Int? = nil, weeks: Int? = nil, days: Int? = nil, hours: Int? = nil, minutes: Int? = nil, seconds: Int? = nil) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.year = years
        dateComponent.month = months
        dateComponent.weekday = weeks
        dateComponent.day = days
        dateComponent.hour = hours
        dateComponent.minute = minutes
        dateComponent.second = seconds
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
    
    
    
    
}

extension Formatter {
    static let islamicFormat: DateFormatter = {
        let calendar = Calendar(identifier: .islamicCivil)
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "ar")
        formatter.setLocalizedDateFormatFromTemplate("dd MMMM yyyy")
        return formatter
    }()
    
    static let Hours24: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let IsoDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let IsoDate2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // Match the input date string format
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let shortIsoData: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static func parseIsoDate(_ dateString: String) -> Date? {
        let formatters = [IsoDate, IsoDate2,shortIsoData,shortFormat,FileDateFormat]
        for formatter in formatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    static let Hours24WithDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let specificDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateFormat = ("EEEE, d MMMM yyyy")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let Hours12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    
    
    static let FileISoFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        //  formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.locale =  Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let FileISoFormat2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // Adjusted format
        formatter.locale =  Locale(identifier: "en_US_POSIX")
        //  formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let FileDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let shortFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    
}
