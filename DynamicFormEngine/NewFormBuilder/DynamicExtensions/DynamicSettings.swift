//
//  DynamicSettings.swift
//  CERQEL
//
//  Created by hassan elshaer on 17/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
internal import MOLH
import Network
import Toast
import JGProgressHUD

func openAttachment(withURLString: String) {
    
    guard let url = URL(string: withURLString) else { return }
    UIApplication.shared.open(url)
}

let dateFormatterLocale_ar = Locale(identifier: "ar")
let dateFormatterLocal_en_US = Locale(identifier: "en_US")
let hijriCalendar = Calendar.init(identifier: .islamicUmmAlQura)
let hijriCalendarType: Calendar.Identifier = .islamicUmmAlQura

func delay(seconds: Double, completion: @escaping () -> ()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

func isArabic()-> Bool{
    return MOLHLanguage.isArabic()
}


func getTimeDifference(dt: Date, includeDays: Bool, includeDaysIfCurrentIsLess: Bool)-> (String?, String?, String?, String?){
    var cal = Calendar.current
    cal.timeZone = timeZone_UTC
    let comps = cal.dateComponents([.hour, .minute, .second, .day], from: dt)
    let hours = comps.hour
    let min = comps.minute
    let sec = comps.second
    let days = comps.day
    
    let currentComps = cal.dateComponents([.hour, .minute, .second, .day], from: Date())
    let currHours = currentComps.hour
    let currMin = currentComps.minute
    let currSec = currentComps.second
    let currDays = currentComps.day
    
    
    if includeDays {
        if let d = days, let cd = currDays, (cd - d) > 0{
            if (cd - d) == 1{
                return ( nil, nil, nil, "day ago".localized)
            }else{
                return (nil, nil, nil,String(format: "days ago".localized, "\(cd - d)"))
            }
        }
    }
    
    if includeDaysIfCurrentIsLess {
        if let d = days, let cd = currDays, (d - cd) >= 0 {
            if (d - cd) == 0 || (d - cd) == 1 {
                return ( nil, nil, nil, String(d - cd) + " " + "day".localized)
            }else{
                return ( nil, nil, nil, String(d - cd) + " " + "days".localized)
            }
        }
    }

    if let h = hours, let ch = currHours, (ch - h) > 0{
        if (ch - h) == 1{
            return ("hour ago".localized, nil, nil, nil)
        }
       return (String(format: "hours ago".localized, "\(ch - h)"), nil, nil, nil)
    }else if let m = min, let cm = currMin, (cm - m) > 0{
        if (cm - m) == 1{
            return ("minute ago".localized, nil, nil, nil)
        }
        return (nil, String(format: "minutes ago".localized, "\(cm - m)"), nil, nil)
    }else if let s = sec, let cs = currSec, (cs - s) > 0{
        return (nil, nil, "\(cs - s) \("seconds ago".localized)", nil )
    }else{
        return(nil, nil, nil, nil)
    }

}
