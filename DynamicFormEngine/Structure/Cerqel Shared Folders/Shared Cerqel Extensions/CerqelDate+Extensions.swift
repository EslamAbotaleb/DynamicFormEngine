//
//  Date+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 4/8/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import Foundation

extension Date{
    
    public func setTimeCerqel(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }

    public func addingDaysCerqel(days: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = days

        return Calendar.current.date(byAdding: dateComponent, to: currentDate)

    }
    
    public func addingMonthsCerqel(months: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = months

        return Calendar.current.date(byAdding: dateComponent, to: currentDate)

    }
    
    public func addingMinutesCerqel(minutes: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.minute = minutes

        return Calendar.current.date(byAdding: dateComponent, to: currentDate)

    }
    
    public func dayDifferenceFromTodayCerqel() -> Int {
        let calendar = Calendar.current
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let days = components.day!
        let dayDifference = abs(days)
        return dayDifference
    }
    
    
    public func numberOfDaysBetweenCerqel(_ from: Date, and to: Date) -> Int? {
        let fromDate = Calendar.current.startOfDay(for: from)
        let toDate = Calendar.current.startOfDay(for: to)
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        return numberOfDays.day
    }
    
    public func startOfMonthCerqel() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonthCerqel() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonthCerqel())!
    }
    
    public func addMinTodateCerqel(minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }
    
    public func isEqualToCerqel(_ date: Date) -> Bool {
        return self == date
    }
    
    public func isGreaterThanCerqel(_ date: Date) -> Bool {
        return self > date
    }
    
    public func isSmallerThanCerqel(_ date: Date) -> Bool {
        return self < date
    }
    
}

extension Date {
    
    public var month_MMCerqel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        if isArabicCerqel() {
            dateFormatter.locale = Locale(identifier: "ar")
        } else {
            dateFormatter.locale = Locale(identifier: "en")
        }
        return dateFormatter.string(from: self)
    }

    public var monthCerqel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        if isArabicCerqel() {
            dateFormatter.locale = Locale(identifier: "ar")
        } else {
            dateFormatter.locale = Locale(identifier: "en")
        }
        return dateFormatter.string(from: self)
    }
    
    public var dayCerqel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
    
    public var fullMonthCerqel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        if isArabicCerqel()  {
            dateFormatter.locale = Locale(identifier: "ar")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        return dateFormatter.string(from: self)
    }

    public  var yearCerqel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        if isArabicCerqel() {
            dateFormatter.locale = Locale(identifier: "ar")
        } else {
            dateFormatter.locale = Locale(identifier: "en")
        }
        return dateFormatter.string(from: self)
    }
}

public class TimeCerqel: Comparable, Equatable {
    
    public init(_ dateCerqel: Date) {
        //get the current calender
        let calendar = Calendar.current
        
        //get just the minute and the hour of the day passed to it
        let dateComponents = calendar.dateComponents([.hour, .minute], from: dateCerqel)
        
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        
        //set the varibles
        secondsSinceBeginningOfDayCerqel = dateSeconds
        hourCerqel = dateComponents.hour!
        minuteCerqel = dateComponents.minute!
    }
    
    public init(_ hourCerqel: Int, _ minuteCerqel: Int) {
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = hourCerqel * 3600 + minuteCerqel * 60
        
        //set the varibles
        secondsSinceBeginningOfDayCerqel = dateSeconds
        self.hourCerqel = hourCerqel
        self.minuteCerqel = minuteCerqel
    }
    
    public var hourCerqel : Int
    public var minuteCerqel: Int
    
    public var dateCerqel: Date {
        //get the current calender
        let calendar = Calendar.current
        
        //create a new date components.
        var dateComponents = DateComponents()
        
        dateComponents.hour = hourCerqel
        dateComponents.minute = minuteCerqel
        
        return calendar.date(byAdding: dateComponents, to: Date())!
    }
    
    /// the number or seconds since the beggining of the day, this is used for comparisions
    private let secondsSinceBeginningOfDayCerqel: Int
    
    //comparisions so you can compare times
    static public func == (lhs: TimeCerqel, rhs: TimeCerqel) -> Bool {
        return lhs.secondsSinceBeginningOfDayCerqel == rhs.secondsSinceBeginningOfDayCerqel
    }
    
    static public func < (lhs: TimeCerqel, rhs: TimeCerqel) -> Bool {
        return lhs.secondsSinceBeginningOfDayCerqel < rhs.secondsSinceBeginningOfDayCerqel
    }
    
    static public func <= (lhs: TimeCerqel, rhs: TimeCerqel) -> Bool {
        return lhs.secondsSinceBeginningOfDayCerqel <= rhs.secondsSinceBeginningOfDayCerqel
    }
    
    
    static public func >= (lhs: TimeCerqel, rhs: TimeCerqel) -> Bool {
        return lhs.secondsSinceBeginningOfDayCerqel >= rhs.secondsSinceBeginningOfDayCerqel
    }
    
    
    static public func > (lhs: TimeCerqel, rhs: TimeCerqel) -> Bool {
        return lhs.secondsSinceBeginningOfDayCerqel > rhs.secondsSinceBeginningOfDayCerqel
    }
}

extension Date {
    public var timeCerqel: TimeCerqel {
        return TimeCerqel(self)
    }
}
