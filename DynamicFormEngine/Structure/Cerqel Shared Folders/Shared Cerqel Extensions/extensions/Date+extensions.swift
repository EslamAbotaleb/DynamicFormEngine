//
//  Date+extensions.swift
//  CERQEL
//
//  Created by mac on 7/27/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

extension Date {
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let diff = Calendar.current.dateComponents([.day, .month, .hour, .minute, .second], from: previous, to: recent)
        return (month: diff.month, day: diff.day, hour: diff.hour, minute: diff.minute, second: diff.second)
    }

}
