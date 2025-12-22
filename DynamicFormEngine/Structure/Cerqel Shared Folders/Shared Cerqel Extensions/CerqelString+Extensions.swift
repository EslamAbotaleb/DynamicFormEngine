//
//  String+Extensions.swift
//  GAZT
//
//  Created by iSlam on 10/6/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit
import CryptoSwift
import Kingfisher
import Photos


extension String {
    
    func cerqel_toURL () -> URL {
        guard let fileURL = URL(string: self) else { return URL(fileURLWithPath: "") }
        return fileURL
    }
    
    func convertMinutesToHoursAndMinutes(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        let formattedHours = String(format: "%02d", hours)
        let formattedMinutes = String(format: "%02d", remainingMinutes)
        
        if hours > 0 {
            return "\(formattedHours):\(formattedMinutes) \("H".localized)"
        } else {
            return "\(formattedMinutes) \("M".localized)"
        }
    }
    
    func cerqel_getDateAsStringFromStringWithFormat(format: String) -> String {
        var returnedDate: String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = self.cerqel_getDateFromString(){
            let birthDatee = formatter.string(from: date)
            returnedDate = birthDatee
        }
        return returnedDate
    }
    func formattedDateStringToDayMonth(from dateString: String) -> String {
          let inputFormatter = DateFormatter()
          inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
          
          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = "dd MMM"
          
          if let date = inputFormatter.date(from: dateString) {
              return outputFormatter.string(from: date)
          } else {
              return ""
          }
      }
    func cerqel_getDateFromString(isGreenwich: Bool? = false, isCurrentTimeZone: Bool = false) -> Date? {
        
        let dateFormatter = DateFormatter()
//        if isGreenwich ?? false {
//            dateFormatter.timeZone = TimeZone(identifier: "GMT")
//        } else {
//            dateFormatter.timeZone = currentTimeZoneCerqel //TimeZone.current//
//        }
        dateFormatter.locale = dateFormatterLocal_en_USCerqel
        dateFormatter.timeZone = isCurrentTimeZone ? .current : utc_TimeZoneCerqel
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        if let date = dateFormatter.date(from: self) {
            return dateFormatter.date(from: dateFormatter.string(from: date))//date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "dd/mm/yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "hh:mm a"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
    
        return nil
    }
    
    func cerqel_getTimeFromString() -> Date? {
        var dateToReturn: Date?
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = currentTimeZoneCerqel
        dateFormatter.locale = dateFormatterLocal_en_USCerqel
        
        if let date = cerqel_getDateFromString() {
            dateFormatter.dateFormat = "h:mm a"
            let dateStr = dateFormatter.string(from: date)
            
            dateToReturn = dateStr.cerqel_getDateFromString()
        }
        
        return dateToReturn
    }
    
    func cerqel_getDateFromStr() -> Date? {
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = .current //TimeZone.current//
        dateFormatter.timeZone = currentTimeZoneCerqel
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
    func cerqel_getDateUseringFormat(format: String)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = currentTimeZoneCerqel
        dateFormatter.locale = dateFormatterLocal_en_USCerqel
        
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
  
    
    func cerqel_getDatePickerFormat(format: String)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: self) {
            return date
        }else {
            let date = handleISOFormat(format: format)
            return date
        }
    }
    
    func handleISOFormat(format: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate]
        guard let fullDate = isoFormatter.date(from: self) else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateOnlyString = formatter.string(from: fullDate)
        
        return formatter.date(from: dateOnlyString)
    }
    
    func convertStringDateFormatted() -> String? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
         if let date = dateFormatter.date(from: self) {
             dateFormatter.dateFormat = "dd MMM yyyy"
             return dateFormatter.string(from: date)
         }
         return nil
     }

    func convertStringDateDMY() -> String? {
       let date = self.cerqel_getDateFromString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        dateFormatter.locale = isArabicCerqel() ? dateFormatterLocale_arCerqel : Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = currentTimeZoneCerqel
        if let dateResult = date {
            return dateFormatter.string(from: dateResult )
        }
        else{
            return nil
        }
     }
        
    func cerqel_slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func cerqel_sliceStr(from: String, to: String) -> String? {
        return (from.isEmpty ? startIndex..<startIndex : range(of: from)).flatMap { fromRange in
            (to.isEmpty ? endIndex..<endIndex : range(of: to, range: fromRange.upperBound..<endIndex)).map({ toRange in
                String(self[fromRange.upperBound..<toRange.lowerBound])
            })
        }
    }
        
    func cerqel_widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func calculateWidthOfString(_ text: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
    
    func cerqel_isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}


extension String {
    var cerqel_htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString()}
        
        do {
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var cerqel_htmlToString: String {
        return cerqel_htmlToAttributedString?.string ?? ""
    }
}

extension String {
     var cerqel_convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public var cerqel_replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    func cerqel_initialsFromString(string: String) -> String {
        var nameComponents = string.uppercased().components(separatedBy: CharacterSet.letters.inverted)
        nameComponents.removeAll(where: {$0.isEmpty})
        
        let firstInitial = nameComponents.first?.first
        let lastInitial  = nameComponents.count > 1 ? nameComponents[1].first : nil
        var isAr: Bool?
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        predicate.evaluate(with: string)
        if predicate.evaluate(with: string) {
            isAr = true
        } else {
            isAr = false
        }
        
        if isAr ?? false {
            return (firstInitial != nil ? "\(firstInitial!) " : "") + (lastInitial != nil ? "\(lastInitial!)" : "")
        } else {
            return (firstInitial != nil ? "\(firstInitial!)" : "") + (lastInitial != nil ? "\(lastInitial!)" : "")
        }
    }
    
    public func cerqel_convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return cerqel_convertHtmlToNSAttributedString
        }
        let modifiedString = """
         <style>
             body {
                 font-family: '\(font.fontName)';
                 font-size: \(font.pointSize)px;
                 color: \(csscolor); 
                 line-height: \(lineheight)px; 
                 text-align: \(csstextalign);
                 white-space: pre-wrap;  /* Preserve spaces and line breaks */
                 word-wrap: break-word;  /* Ensure long words break correctly */
             }
         </style>
         \(self)
         """
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    public func cerqel_convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: UIColor? , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return cerqel_convertHtmlToNSAttributedString
        }
        let modifiedString = """
         <style>
             body {
                 font-family: '\(font.fontName)';
                 font-size: \(font.pointSize)px;
                 color: \((csscolor)!.toHexStringCerqel()); 
                 line-height: \(lineheight)px; 
                 text-align: \(csstextalign);
                 white-space: pre-wrap;  /* Preserve spaces and line breaks */
                 word-wrap: break-word;  /* Ensure long words break correctly */
             }
         </style>
         \(self)
         """
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print(error)
            return nil
        }

    }
    
    
    public func cerqel_convertHtmlToAttributedStringWithCSSDetails(
        font: UIFont?,
        csscolor: UIColor?,
        lineheight: Int,
        csstextalign: String
    ) -> NSAttributedString? {
        guard let font = font, let csscolor = csscolor else {
            return nil
        }
        
        let cssColorHex = csscolor.toHexStringCerqel()
        let fontFamily = font.fontName
        let fontSize = font.pointSize
        
        // Use "dir=auto" and include "unicode-bidi" in CSS for mixed content
        let modifiedString = """
        <style>
            body {
                font-family: '\(fontFamily)';
                font-size: \(fontSize)px;
                color: \(cssColorHex);
                line-height: \(lineheight)px;
                text-align: \(csstextalign);
                white-space: pre-wrap; /* Preserve spaces and line breaks */
                word-wrap: break-word; /* Prevent overflow of long words */
                direction: auto; /* Automatically adjust text direction */
                unicode-bidi: embed; /* Ensure proper bidi handling for mixed content */
            }
        </style>
        <body dir="auto">
            \(self)
        </body>
        """
        
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print("Error creating attributed string: \(error)")
            return nil
        }
    }
    
    func cerqel_aesEncrypt(_ key: String) throws -> String? {
//        do {
//            let keyByteArr = Array(hex: key.lowercased())
//            let ivByteArr = Array(hex: cerqel_Environment.loginIV)
//            let passByteArr = Array(self.utf8)
//            
//
//            let aes = try AES(key: keyByteArr, blockMode: CBC(iv: ivByteArr), padding: .pkcs5)
//            
//
//            let ciphertext = try aes.encrypt(passByteArr)
//            return ciphertext.toHexString()
//
//        }catch {
//            print("error \(error)")
//            return "\(error.localizedDescription)"
//        }

        return ""
    }
    
    func cerqel_replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }

    func cerqel_CreateMediaURL()-> String{
        return self
        print("CreateMediaURL Old --> \(self)")
        let fManager = "/filemanager"
        let strr = self.replacingOccurrences(of: "FileManager", with: "filemanager")

        let urlWithoutIP = strr.components(separatedBy: fManager).dropFirst().joined(separator: fManager)
        var myUrl = "file-manager" + urlWithoutIP
        var baseUrl = cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.content.rawValue
        baseUrl = baseUrl.components(separatedBy: "ContentWebsite").dropLast().joined(separator: fManager)

        myUrl = baseUrl + myUrl
        myUrl = myUrl.replacingOccurrences(of: "filemanager", with: "FileManager")

        print("CreateMediaURL New -->\(myUrl)")

        return myUrl
    }

    func cerqel_separate(every stride: Int = 1, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
}


extension UISwitch {

    func cerqel_set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}


extension String {
    private static let cerqel_formatter = NumberFormatter()

    func cerqel_clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func cerqel_convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(cerqel_clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.cerqel_formatter.locale = locale

        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.cerqel_formatter.number(from: original)!
            let localized = Self.cerqel_formatter.string(from: digit)!
            return (original, localized)
        }

        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
    
    var cerqel_isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var cerqel_fullRange:Range<String.Index> { return startIndex..<endIndex }

}
