//
//  StringExtensions.swift
//  
//
//  Created by Yasser Osama on 10/01/2023.
//

import Foundation

public typealias CerqelJSON = [String : Any]
public typealias JSONArray = [CerqelJSON]

extension String {
//    func getDateFromString(timeZone: Bool = false) -> Date? {
//        let dateFormatter = DateFormatter()
//        if timeZone {
//            dateFormatter.timeZone = .current
//        } else {
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //TimeZone.current//
//        }
//        dateFormatter.locale = Locale(identifier: "en_US")
//
//        let dateFormats = ["yyyy-MM-dd'T'HH:mm:ss.SSSZ", "yyyy-MM-dd'T'HH:mm:ss.SSZ", "yyyy-MM-dd'T'HH:mm:ss.SS", "yyyy-MM-dd HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "E, d MMM yyyy HH:mm:ss ZZ", "E, d MMM yyyy HH:mm:ss ZZ", "E, dd MMM yyyy HH:mm:ss zzz", "y-MM-dd'T'HH:mm:ssZ", "y-MM-dd", "HH:mm:ssZ", "yyyy-MM-dd", "dd/MM/yyyy, HH:mm", "dd/MM/yyyy - HH:mm a", "MM/dd/y", "hh:mm a", "HH:mma", "HH:mm a", "HH:mm"]
//
//        for dateFormat in dateFormats {
//            dateFormatter.dateFormat = dateFormat
//            if let date = dateFormatter.date(from: self) {
//                return date
//            }
//        }
//        return nil
//    }
    
    var toEnglish: String {
        let arabicNumbers = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
        let englishNumbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var temp = self
        _ = arabicNumbers.enumerated().map({ (index, element) in
            if temp.replacingOccurrences(of: element, with: englishNumbers[index]) != temp {
                temp = temp.replacingOccurrences(of: element, with: englishNumbers[index])
            }
        })
        return temp
    }
    
    func changeFormat(fromFormat: String, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()

        // step 1
        dateFormatter.dateFormat = fromFormat // input format
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = toFormat // output format
            let string = dateFormatter.string(from: date)
            return string
        }
        
        // step 2
        return ""
    }
    
    var toArabic: String {
        let arabicNumbers = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
        let englishNumbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var temp = self
        _ = englishNumbers.enumerated().map({ (index, element) in
            if temp.replacingOccurrences(of: element, with: arabicNumbers[index]) != temp {
                temp = temp.replacingOccurrences(of: element, with: arabicNumbers[index])
            }
        })
        return temp
    }
    
    var getDay: Int? {
        if let date = self.cerqel_getDateFromString() {
            let day = date.get(.weekday)
            return day
        }
        return nil
    }
    
    var isMCQOtherID: Bool {
        return self == "00000000-0000-0000-0000-000000000000"
    }
    
    var isMCQNAID: Bool {
        return self == "00000000-0000-0000-0000-000000000001"
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func replaceValidationWith(_ value: Any?) -> String? {
        if let value = value {
            return self.replacingOccurrences(of: "{0}", with: "\(value)")
        } else {
            return self.replacingOccurrences(of: "{0}", with: "")
        }
    }
    /// Converts an HTML string to plain text.
     func htmlToPlainText() -> String {
         guard let data = self.data(using: .utf8) else {
             return self // Return the original string if encoding fails
         }
         do {
             let attributedString = try NSAttributedString(
                 data: data,
                 options: [
                     .documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue
                 ],
                 documentAttributes: nil
             )
             return attributedString.string // Extract plain text
         } catch {
             print("Error parsing HTML: \(error)")
             return self // Return the original string in case of an error
         }
     }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
