//
//  HelperFunctions.swift
//  CERQEL
//
//  Created by Youxel on 21/11/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
class HelperFunctions {
    
    //This function Hide the section if All fields has no answer and not required and hideIfEmptyInDetails
    static func isHiddenSection(items: [FormViewModelItem]) ->Bool{
        for item in items{
            if !(!(item.field?.properties?.required ?? false) && item.answer == nil) {
                return false
            }
        }
        return true
    }
    
    static func isHiddenSectionInSummary(items: [FormViewModelItem]) -> Bool {
        for item in items {
            if item.answer != nil {
                return false
            }
        }
        return true
    }
    
    static func isHiddenSectionInForm(items: [FormViewModelItem]) -> Bool {
        for item in items {
            if let permissions = item.field?.visibilityPermissions {
                if !permissions.contains("Hide") {
                    return false
                }
            }else {
                return false
            }
        }
        return true
    }
    
    
    /// convert hijri string date to gregorian date
    /// - Parameter stringDate: hijiri string date
    /// - Returns: gregorian date
    static func convertDateToGregorianDate(stringDate: String, format: String?, presentedFormat: String?) -> Date {
        let hijri = hijriCalendar
        let formatter = DateFormatter()
        formatter.calendar = hijri
        formatter.dateFormat = format
        //(item as? FormViewModelDateItem)?.dateFormat?.swiftFormat
        formatter.timeZone = timeZone_UTC
        let hijriDate = formatter.date(from: stringDate) ?? Date()
        
        let gregorianFormatter = DateFormatter()
        gregorianFormatter.calendar = Calendar.init(identifier: .gregorian)
        gregorianFormatter.dateFormat = presentedFormat
        let gregorianString = gregorianFormatter.string(from: hijriDate)
        return gregorianFormatter.date(from: gregorianString) ?? Date()
    }
    
    /// convert hijri string date to gregorian string
    /// - Parameter stringDate: hijiri string date
    /// - Returns: gregorian string date
    static func convertDateToGregorianString(stringDate: String, format: String?, presentedFormat: String?) -> String {
        let hijri = hijriCalendar
        let formatter = DateFormatter()
        formatter.calendar = hijri
        formatter.dateFormat = format
        //(item as? FormViewModelDateItem)?.dateFormat?.swiftFormat
        formatter.timeZone = timeZone_UTC
        let hijriDate = formatter.date(from: stringDate) ?? Date()
        
        let gregorianFormatter = DateFormatter()
        gregorianFormatter.calendar = Calendar.init(identifier: .gregorian)
        gregorianFormatter.dateFormat = presentedFormat
        return gregorianFormatter.string(from: hijriDate)
    }
    
    
    /// convert gregorian string date to hijri date
    /// - Parameter stringDate: gregorian string date
    /// - Returns: hijri date
    static func convertDateToHijriDate(stringDate: String, presentedFormat: String?) -> Date {
        let format = DateFormatter()
        format.timeZone = timeZone_UTC
        format.calendar = Calendar.init(identifier: .gregorian)
        let date = stringDate.getDateFromString(dateFormatter: format) ?? Date()
        
        let hijri = hijriCalendar
        let formatter = DateFormatter()
        formatter.calendar = hijri
        formatter.dateFormat = presentedFormat
        formatter.timeZone = timeZone_UTC
        let hijriString = formatter.string(from: date)
        return formatter.date(from: hijriString) ?? Date()
    }

    
    
    /// convert gregorian string date to hijri string date
    /// - Parameter stringDate: gregorian string date
    /// - Returns: hijri string date
    static func convertDateToHijriString(stringDate: String, presentedFormat: String?) -> String {
        var stringDates = [String]()
        
        let dateArray = stringDate.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        
        for dateString in dateArray {
            let format = DateFormatter()
            format.timeZone = timeZone_UTC
            format.calendar = Calendar.init(identifier: .gregorian)
            let date = dateString.getDateFromString(dateFormatter: format) ?? Date()
            
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .islamicUmmAlQura) // Use the appropriate Hijri calendar
            formatter.dateFormat = presentedFormat
            formatter.timeZone = timeZone_UTC
            let stringDate = formatter.string(from: date)
            stringDates.append(stringDate)
        }
        return stringDates.joined(separator: ", ")
    }
}

