//
//  DynamicUIString+Extensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 17/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

public typealias JSON2 = [String : Any]

extension String {
    
    func isValidRegex(regex: String) -> Bool {
        let pred = NSPredicate(format:"SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
    
    func getDateFromString(timeZone: Bool = true) -> Date? {
        let dateFormatter = DateFormatter()
//        if timeZone {
//            dateFormatter.timeZone = .current
//        } else {
            dateFormatter.timeZone = timeZone_UTC //TimeZone(abbreviation: "UTC") //TimeZone.current//
//        }
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let dateFormats = ["yyyy-MM-dd'T'HH:mm:ss.SSSZ", "yyyy-MM-dd'T'HH:mm:ss.SSZ", "yyyy-MM-dd'T'HH:mm:ss.SS", "yyyy-MM-dd HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "E, d MMM yyyy HH:mm:ss ZZ", "E, d MMM yyyy HH:mm:ss ZZ", "E, dd MMM yyyy HH:mm:ss zzz", "y-MM-dd'T'HH:mm:ssZ", "y-MM-dd", "HH:mm:ssZ", "yyyy-MM-dd", "dd/MM/yyyy, HH:mm", "dd/MM/yyyy - HH:mm a", "MM/dd/y", "hh:mm a", "HH:mma", "HH:mm a", "HH:mm", "dd-MM-yyyy","dd-MM-yyyy HH:mm"]
        
        for dateFormat in dateFormats {
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.date(from: self) {
                return date
            }
        }
        return nil
    }
}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}
extension String {
    
    
    var y_containsEmoji: Bool {
        
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var y_trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func y_replaceFirst(of pattern:String,
                             with replacement:String) -> String {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        }else{
            return self
        }
    }
    
    public func y_replaceFirst(of pattern:String,
                               with replacement:String, inRange: Range<String.Index>) -> String {
        if let range = self.range(of: pattern, options: [], range: inRange){
            return self.replacingCharacters(in: range, with: replacement)
        }else{
            return self
        }
    }
    
    func y_containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func y_containsNumbers() -> Bool{
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    func y_getonlyDateFromString() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone =  TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self)
        {
            return date
        }
        return dateFormatter.date(from: self)!
    }
    
    func y_getDateFromString() -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone_UTC//TimeZone(abbreviation: "UTC") //TimeZone.current//
        dateFormatter.locale = Locale(identifier: "en_US")
        
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
        return nil
    }
    func y_toJson() -> [String: Any]?
    {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json!
            } catch {
            }
        }
        return nil
    }
    func y_heightForWithFont() -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func y_countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var searchRange: Range<String.Index>?
        var count = 0
        while let foundRange = range(of: stringToFind, options: .diacriticInsensitive, range: searchRange) {
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
            count += 1
        }
        return count
    }
    
    func y_withLanguageDirectionInvisibleMarksAdded() -> String {
        
        var awardDescriptionWords = self.components(separatedBy: " ")
        var currentLangIsArabic = self.y_firstAlphabetIsArabic()
        for i in 0 ..< awardDescriptionWords.count {
            let word = awardDescriptionWords[i]
            if currentLangIsArabic != word.y_firstAlphabetIsArabic() {
                if word.y_firstAlphabetIsArabic() {
                    awardDescriptionWords[i] = "\u{202B}\(awardDescriptionWords[i])"
                    currentLangIsArabic = true
                }else{
                    
                    awardDescriptionWords[i] = "\u{200E}\(awardDescriptionWords[i])"
                    currentLangIsArabic = false
                }
            }
        }
        return awardDescriptionWords.joined(separator: " ")
    }
    
    mutating func y_removeLanguageDirectionInvisibleMarks() {
        self = self.y_replaceRegexMatches(pattern: "\u{202B}", replaceWith: "")
        self = self.y_replaceRegexMatches(pattern: "\u{200E}", replaceWith: "")
    }
    
    func y_firstAlphabetIsArabic() -> Bool! {
        if self.count > 0 {
            var charIndex : Int = 1
            var index = self.index(self.startIndex, offsetBy: 1)
            var isArabic = false
            if(self.range(of:"[ء-يa-zA-Z]", options: .regularExpression) != nil){
                while(self.prefix(upTo:index).range(of:"[ء-يa-zA-Z]", options: .regularExpression) == nil){
                    charIndex += 1
                    index = self.index(self.startIndex, offsetBy: charIndex)
                }
                
                //if(self.substring(to: index).range(of:"[ء-ي]", options: .regularExpression) != nil){
                if(self.prefix(upTo: index).range(of:"[ء-ي]", options: .regularExpression) != nil){
                    isArabic = true
                }
            }
            return isArabic
        }
        return false
    }
    
    func y_firstCharIsArabic() -> Bool! {
        if self.count > 0 {
//            var charIndex : Int = 1
            let index = self.index(self.startIndex, offsetBy: 1)
//            var isArabic = false
            if self.prefix(upTo:index).range(of:"[ء-ي]", options: .regularExpression) == nil {
                return true
            }
        }
        return false
    }
    
    func y_containsArabic() -> Bool! {
        if self.count > 0 {
            
            let index = self.index(self.startIndex, offsetBy: self.count)
            
            if self.prefix(upTo:index).range(of:"[ء-ي]", options: .regularExpression) == nil {
                return true
            }
        }
        return false
    }
    
    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return String(self[range])
    }
    
    func y_isAlphabet() -> Bool {
        let letters = CharacterSet.letters
        for uni in self.unicodeScalars {
            if letters.contains(uni) == false {
                return false
            }
        }
        return true
    }
    
    func y_trimmedLength() -> Int {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count//lengthOfBytes(using: .utf8)
    }
    
    func y_wordRangeAtIndex(_ index:Int, inString str:NSString) -> NSRange {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType], options: 0)
        var r : NSRange = NSMakeRange(0,0)
        tagger.string = str as String
        tagger.tag(at: index, scheme: NSLinguisticTagScheme.tokenType, tokenRange: &r, sentenceRange: nil )
        return r
    }
    
    func y_wordAtIndex(_ index:Int) -> String? {
        return self.substring(with: y_wordRangeAtIndex(index, inString: self as NSString))
    }
    
    func numbersToArabic() -> String {
        if isArabicCerqel() {
            let number = NSNumber(value: Int(self)!)
            let format = NumberFormatter()
            format.locale = Locale(identifier: "ar_SA")
            let arNumber = format.string(from: number)
            return arNumber!
        } else {
            return self
        }
    }
    
    func extractNumbers() -> [Int] {
        let regex = try! NSRegularExpression(pattern: "\\d+")
        let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return matches.map { Int((self as NSString).substring(with: $0.range)) ?? 0 }
    }

    
    func y_getLinesArrayOfString(in label: UILabel) -> [String] {
        
        /// An empty string's array
        var linesArray = [String]()
        
        guard let text = label.text, let font = label.font else {return linesArray}
        
        let rect = label.frame
        
        let myFont: CTFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: myFont, range: NSRange(location: 0, length: attStr.length))
        
        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path: CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100000), transform: .identity)
        
        let frame: CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [Any] else {return linesArray}
        
        for line in lines {
            let lineRef = line as! CTLine
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString: String = (text as NSString).substring(with: range)
            linesArray.append(lineString)
        }
        return linesArray
    }
    
    func y_getRegexMatches(pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSMakeRange(0, self.count)
            let matches = regex.matches(in: self, options: [], range: range).map {
                String(self[Range($0.range, in: self)!])}
            
            return matches
        } catch {
            return []
        }
    }
    
    func y_getRegexMatchesRanges(pattern: String) -> [NSRange] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            let matches = regex.matches(in: self, options: [], range: range).map {
                $0.range }
            
            return matches
        } catch {
            return []
        }
    }
    
    func y_replaceRegexMatches(pattern: String, replaceWith: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return self
        }
    }
    
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
    
    func CreateMediaURL()-> String{
        return self
        let fManager = "/filemanager"
        let strr = self.replacingOccurrences(of: "FileManager", with: "filemanager")

        let urlWithoutIP = strr.components(separatedBy: fManager).dropFirst().joined(separator: fManager)
        var myUrl = "file-manager" + urlWithoutIP
        var baseUrl = cerqel_Environment.EnvironmentConfig.CONTENT_Base_URL
        baseUrl = baseUrl.components(separatedBy: "ContentWebsite").dropLast().joined(separator: fManager)

        myUrl = baseUrl + myUrl
        myUrl = myUrl.replacingOccurrences(of: "filemanager", with: "FileManager")
        
        return myUrl
    }
}


extension String {
    
    func getDateFromString(dateFormatter: DateFormatter) -> Date? {
        
//        let dateFormatter = DateFormatter()
        
        if dateFormatter.dateFormat != "" {
            if let date = dateFormatter.date(from: self) {
                return date
            }
        }
        
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
            return dateFormatter.date(from: dateFormatter.string(from: date))
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "hh:mm"
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
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        if let date = dateFormatter.date(from: self) {
//            return date
//        }
        
        dateFormatter.dateFormat = "hh:mm a"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat =  "dd-MM-yyyy HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat =  "MM-dd-yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
    
        return nil
    }
    
    func getTimeFromString() -> Date? {
        var dateToReturn: Date?
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone_UTC
        dateFormatter.locale = dateFormatterLocal_en_US
        
        if let date = getDateFromString() {
            dateFormatter.dateFormat = "h:mm a"
            let dateStr = dateFormatter.string(from: date)
            
            dateToReturn = dateStr.getDateFromString()
        }
        
        return dateToReturn
    }
    
    func getDateUseringFormat(format: String)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone_UTC
        dateFormatter.locale = isArabicCerqel() ? dateFormatterLocale_ar : dateFormatterLocal_en_US
        
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil

    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func sliceStr(from: String, to: String) -> String? {
        return (from.isEmpty ? startIndex..<startIndex : range(of: from)).flatMap { fromRange in
            (to.isEmpty ? endIndex..<endIndex : range(of: to, range: fromRange.upperBound..<endIndex)).map({ toRange in
                String(self[fromRange.upperBound..<toRange.lowerBound])
            })
        }
    }

    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func getStringWithinTwoBrackets(_ fromBracket: String,_ toBracket: String) -> String? {
        return self.sliceStr(from: fromBracket, to: toBracket)
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

extension UINavigationController {
    func removeBackButtonTitle() {
        self.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back".localized, style: .plain, target: nil, action: nil)
    }
}

