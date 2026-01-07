//
//  FormModelAnswers.swift
//  CHECK
//
//  Created by Yasser Osama on 09/05/2022.
//



class BaseAnswer: Mappable, Equatable {
    public static func == (lhs: BaseAnswer, rhs: BaseAnswer) -> Bool {
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

class BaseAnswerText: BaseAnswer {
    public var value: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: String, lNote: String? = nil, lAttachmnets: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachmnets)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
    }
}


class TextboxAnswer: BaseAnswerText {
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

class TextAreaAnswer: BaseAnswerText {
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
        
        htmlValue <- map["htmlValue"]
    }
}

class DateTimeAnswer: BaseAnswer {
    public var value: [String]?
    public var timeValues: [String]?
    public var type: FormCalendarType?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [String], timeValues: [String] = [], lNote: String? = nil, lAttachments: [Any]? = nil, type: FormCalendarType) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
        self.timeValues = timeValues
        self.type = type
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
        type <- map["type"]
    }
}

class LocationAnswer: BaseAnswer {
    public var value: [Place]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [Place], lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
    }
}

class FileUploadAnswer: BaseAnswer {
    public var value: [ModelUploadedMedia]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [ModelUploadedMedia], lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
    }
}

class SwitchAnswer: BaseAnswer {
    public var value: Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: Bool, lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
    }
}


class SliderAnswer: BaseAnswer {
    public var value: [Double]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [Double], lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
    }
}

class BaseAnswerMCQ: BaseAnswer {
    public var value: [MCQOption]?
    public var otherAnswer: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [MCQOption], otherAnswer: String? = nil, lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
        self.otherAnswer = otherAnswer
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
        otherAnswer <- map["otherAnswer"]
    }
}
class BaseAnswerMCQGUID: BaseAnswer {
    public var value: [String]?
    public var otherAnswer: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: [String], otherAnswer: String? = nil, lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
        self.otherAnswer = otherAnswer
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
        otherAnswer <- map["otherAnswer"]
    }
}

class ParagraphAnswer: BaseAnswer {
    public var value: String?
    public var htmlValue: String?
    public var rowIndex: String?
    public var name: String?
    public var id: String?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: String?, htmlValue: String? = nil, lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
        self.htmlValue = htmlValue
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
        htmlValue <- map["htmlValue"]
        rowIndex <- map["rowIndex"]
        id <- map["Id"]
        name <- map["name"]
    }
}
class ParagraphAnswerWithBoolValue: BaseAnswer {
    public var value: Bool?
    public var htmlValue: String?
    public var rowIndex: String?
    public var name: String?
    public var id: String?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    public init(val: Bool?, htmlValue: String? = nil, lNote: String? = nil, lAttachments: [Any]? = nil) {
        super.init(lNote: lNote, lAttachments: lAttachments)
        
        self.value = val
        self.htmlValue = htmlValue
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        value <- map["value"]
        htmlValue <- map["htmlValue"]
        rowIndex <- map["rowIndex"]
        id <- map["Id"]
        name <- map["name"]
    }
}
