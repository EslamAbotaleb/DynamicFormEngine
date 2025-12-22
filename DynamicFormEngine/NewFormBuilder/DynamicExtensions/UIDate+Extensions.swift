//
//  UIDate+Extensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 17/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

extension Date {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int? {
        let fromDate = Calendar.current.startOfDay(for: from)
        let toDate = Calendar.current.startOfDay(for: to)
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        return numberOfDays.day
    }
    
}

extension Date {
 
        var calendar: Calendar { Calendar.current }

        var weekday: Int {
            calendar.component(.weekday, from: self)
        }
    
}
