//
//  FormModelDefaultAnswer.swift
//  CERQEL
//
//  Created by hassan elshaer on 12/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

//
//  FormModelAnswers.swift
//  CHECK
//
//  Created by Yasser Osama on 09/05/2022.
//

import ObjectMapper

public class DefaultBaseAnswer: Mappable, Equatable {
    public static func == (lhs: DefaultBaseAnswer, rhs: DefaultBaseAnswer) -> Bool {
        return true
    }
    
    public var note: String?
    public var attachments: [Any?]?
    
    required public init?(map: Map) {
        //empty
    }
    
    public init(lNote: String? = nil, lAttachments: [Any]? = nil) {
        self.note = lNote
        self.attachments = lAttachments
    }
    
    public func mapping(map: Map) {
        note <- map["note"]
        attachments <- map["attachments"]
    }
}

public class DefaultBaseAnswerText: DefaultBaseAnswer {
    public var value: [String]?
    public var name: String = ""
    public var rowIndex: String?
    public var id: String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [String], lNote: String? = nil, lAttachmnets: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachmnets)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        rowIndex <- map["rowIndex"]
        id <- map["id"]
        
        var rawValue: Any?
        rawValue <- map["value"]
        
        if let singleArray = rawValue as? [String] {
            self.value = singleArray
        } else if let nestedArray = rawValue as? [[String]] {
            // Flatten the nested array
            self.value = nestedArray.flatMap { $0 }
        }
    }
}

public class DefaultBaseAnswerTextForNumberControl: DefaultBaseAnswer {
    public var value: Double?
    public var name: String = ""
    public var rowIndex: String?
    public var id: String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: Double, lNote: String? = nil, lAttachmnets: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachmnets)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        rowIndex <- map["rowIndex"]
        id <- map["id"]
        value <- map["value"]
    }
}

public class DefaultBaseAnswerTextNewFormat: DefaultBaseAnswer {
    public var value: String?
    public var name: String = ""
    public var rowIndex: String?
    public var id: String = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: String, lNote: String? = nil, lAttachmnets: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachmnets)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        rowIndex <- map["rowIndex"]
        id <- map["id"]
        
//        var rawValue: Any?
        value <- map["value"]
        
//        if let singleArray = rawValue as? [String] {
//            self.value = singleArray
//        } else if let nestedArray = rawValue as? [[String]] {
//            // Flatten the nested array
//            self.value = nestedArray.flatMap { $0 }
//        }  else if let val = rawValue as? String {
//            self.value = val
//        }
    }
}

public class DefaultTextboxAnswer: DefaultBaseAnswerText {
    public var prefix: String?
    public var suffix: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [String], lPrefix: String? = nil, lSuffix: String? = nil, lNote: String? = nil, lAttachments: [Any]?  = nil) {
        super.init(val: val, lNote: lNote, lAttachmnets: lAttachments)
        
        self.prefix = lPrefix
        self.suffix = lSuffix
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        prefix <- map["prefix"]
        suffix <- map["suffix"]
    }
}

public class DefaultTextboxAnswerNewFormat: DefaultBaseAnswerTextNewFormat {
    public var prefix: String?
    public var suffix: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: String, lPrefix: String? = nil, lSuffix: String? = nil, lNote: String? = nil, lAttachments: [Any]?  = nil) {
        super.init(val: val, lNote: lNote, lAttachmnets: lAttachments)
        
        self.prefix = lPrefix
        self.suffix = lSuffix
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        prefix <- map["prefix"]
        suffix <- map["suffix"]
    }
}

public class DefaultNumberBoxAnswer: DefaultBaseAnswerText {
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [String], lPrefix: String? = nil, lSuffix: String? = nil, lNote: String? = nil, lAttachments: [Any]?  = nil) {
        super.init(val: val, lNote: lNote, lAttachmnets: lAttachments)
    }
}

public class DefaultNumberBoxAnswerNewFormat: DefaultBaseAnswerTextForNumberControl {
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: Double, lPrefix: String? = nil, lSuffix: String? = nil, lNote: String? = nil, lAttachments: [Any]?  = nil) {
        super.init(val: val, lNote: lNote, lAttachmnets: lAttachments)
    }
}



public class DefaultTextAreaAnswer: DefaultBaseAnswerText {
    public var htmlValue: [String]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [String], htmlVal: [String], lNote: String? = nil, lAttachments: [Any]?  = nil) {
        super.init(val: val, lNote: lNote, lAttachmnets: lAttachments)
        
        self.htmlValue = htmlVal
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        htmlValue <- map["value"]
    }
}

public class DefaultTextAreaAnswerNewFormat: DefaultBaseAnswerTextNewFormat {
    public var htmlValue: String?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: String, htmlVal: String, lNote: String? = nil, lAttachments: [Any]?  = nil) {
        super.init(val: val, lNote: lNote, lAttachmnets: lAttachments)
        self.htmlValue = htmlVal
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        htmlValue <- map["value"]
    }
}

public class DefaultDateTimeAnswer: DefaultBaseAnswer {
    public var value: [DateRange]?
    public var name: String = ""
    public var rowIndex: String?
    public var id: String = ""
    public var timeValues: [String]?
    public var type: FormCalendarType?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [DateRange], timeValues: [String] = [], lNote: String? = nil, lAttachments: [Any]? = nil, type: FormCalendarType) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        self.value = val
        self.timeValues = timeValues
        self.type = type
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        rowIndex <- map["rowIndex"]
        id <- map["id"]
        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
            value <- (map["value"], DateStringToRangeTransform())
        } else {
            value <- map["value"]
        }
        type <- map["type"]
    }
}

public class DateRangeTransform: TransformType {
    public typealias Object = [DateRange]
    public typealias JSON = [[String: String]]
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> [DateRange]? {
        if let jsonArray = value as? JSON {
            return jsonArray.compactMap { DateRange(JSON: $0) }
        }
        return nil
    }
    
    public func transformToJSON(_ value: [DateRange]?) -> JSON? {
        if let dateRanges = value {
            return dateRanges.map { $0.toJSON() }
        }
        return nil
    }
}
public class DateStringToRangeTransform: TransformType {
    public typealias Object = [DateRange]
    public typealias JSON = [String]

    public init() {}

    public func transformFromJSON(_ value: Any?) -> [DateRange]? {
        guard let dateStrings = value as? [String] else { return nil }
        var dateRanges = [DateRange]()
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure UTC

        for i in stride(from: 0, to: dateStrings.count, by: 2) {
            let fromDateString = dateStrings[i]
            let fromDate = dateFormatter.date(from: fromDateString)
            
            if i + 1 < dateStrings.count {
                let toDateString = dateStrings[i + 1]
                let toDate = dateFormatter.date(from: toDateString)
                if let fromDate = fromDate, let toDate = toDate {
                    dateRanges.append(DateRange(from: fromDate, to: toDate))
                }
            } else if let fromDate = fromDate {
                dateRanges.append(DateRange(from: fromDate, to: nil))
            }
        }
        
        return dateRanges
    }

    public func transformToJSON(_ value: [DateRange]?) -> [String]? {
        guard let dateRanges = value else { return nil }
        var dateStrings = [String]()
        
        let dateFormatter = ISO8601DateFormatter()
        for dateRange in dateRanges {
            if let fromDate = dateRange.from {
                dateStrings.append(dateFormatter.string(from: fromDate))
            }
            if let toDate = dateRange.to {
                dateStrings.append(dateFormatter.string(from: toDate))
            }
        }
        
        return dateStrings
    }
}


public class DateRange: Mappable {
    public var to: Date?
    public var from: Date?
    
    required public init?(map: Map) {}
    
    public init(from: Date, to: Date? = nil) {
        self.from = from
        self.to = to
    }

    public func mapping(map: Map) {
        to <- (map["to"], CustomDateFormatTransform(formatString: "dd-MM-yyyy HH:mm"))
        from <- (map["from"], CustomDateFormatTransform(formatString: "dd-MM-yyyy HH:mm"))
    }

    public func toJSON() -> [String: String] {
        var json = [String: String]()
        if let to = to, let from = from {
            json["to"] = CustomDateFormatTransform(formatString: "dd-MM-yyyy HH:mm").transformToJSON(to)
            json["from"] = CustomDateFormatTransform(formatString: "dd-MM-yyyy HH:mm").transformToJSON(from)
        }
        return json
    }
}


public class CustomDateFormatTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    private let dateFormatter: DateFormatter
    
    public init(formatString: String) {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
    }
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}


//public class LocationAnswer: DefaultBaseAnswer {
//    public var value: [Place]?
//    
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//    
//    public init(val: [Place], lNote: String? = nil, lAttachments: [Any]? = nil) {
//        super.init(lNote: lNote, lAttachments: lAttachments)
//        
//        self.value = val
//    }
//    
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//        
//        value <- map["value"]
//    }
//}

//public class DefaultFileUploadAnswer: DefaultBaseAnswer {
//    public var value: [AttachmentForDefault]?
//    public var name: String?
//    public var rowIndex: String? // Assuming this is Int
//    public var id: String?
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//    
//    public init(val: [AttachmentForDefault], lNote: String? = nil, lAttachments: [Any]? = nil) {
//        super.init(lNote: lNote, lAttachments: lAttachments)
//        self.value = val
//    }
//    
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//        name <- map["name"]
//        rowIndex <- map["rowIndex"]
//        id <- map["id"]
//        value <- map["value"]
//    }
//}

public class DefaultFileUploadAnswer: DefaultBaseAnswer {
    public var value: [AttachmentForDefault]?
    public var name: String = ""
    public var rowIndex: String?
    public var id: String = ""
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [AttachmentForDefault], lNote: String? = nil, lAttachmnets: [AttachmentForDefault]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachmnets)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        rowIndex <- map["rowIndex"]
        id <- map["id"]
        value <- map["value"]
    }
}

//public class SwitchAnswer: DefaultBaseAnswer {
//    public var value: Bool = false
//
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//
//    public init(val: Bool, lNote: String? = nil, lAttachments: [Any]? = nil) {
//        super.init(lNote: lNote, lAttachments: lAttachments)
//
//        self.value = val
//    }
//
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//
//        value <- map["value"]
//    }
//}


//public class SliderAnswer: DefaultBaseAnswer {
//    public var value: [Double]?
//
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//
//    public init(val: [Double], lNote: String? = nil, lAttachments: [Any]? = nil) {
//        super.init(lNote: lNote, lAttachments: lAttachments)
//
//        self.value = val
//    }
//
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//
//        value <- map["value"]
//    }
//}

//public class BaseAnswerMCQ: DefaultBaseAnswer {
//    public var value: [MCQOption]?
//    public var otherAnswer: String?
//
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//
//    public init(val: [MCQOption], otherAnswer: String? = nil, lNote: String? = nil, lAttachments: [Any]? = nil) {
//        super.init(lNote: lNote, lAttachments: lAttachments)
//
//        self.value = val
//        self.otherAnswer = otherAnswer
//    }
//
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//
//        value <- map["value"]
//        otherAnswer <- map["otherAnswer"]
//    }
//}

//public class ParagraphAnswer: DefaultBaseAnswer {
//    public var value: String?
//    public var htmlValue: String?
//
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//
//    public init(val: String?, htmlValue: String? = nil, lNote: String? = nil, lAttachments: [Any]? = nil) {
//        super.init(lNote: lNote, lAttachments: lAttachments)
//
//        self.value = val
//        self.htmlValue = htmlValue
//    }
//
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//
//        value <- map["value"]
//        htmlValue <- map["htmlValue"]
//    }
//}
