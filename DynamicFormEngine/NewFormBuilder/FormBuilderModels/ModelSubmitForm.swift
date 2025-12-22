//
//  ModelSubmitForm.swift
//
//
//  Created by iSlam AbdelAziz on 12/29/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
import ObjectMapper

struct ModelSubmitForm : Mappable {
    var payload : [SubmitFormPayload]?
    var formCode : String?
    var formVersion : String?
    var onBehalf : Bool?
    var createdForUsername : String?
    var roleType:String? = ""
    
    init(){}
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        payload <- map["payload"]
        formCode <- map["formCode"]
        formVersion <- map["formVersion"]
        createdForUsername <- map["createdForUsername"]
        onBehalf <- map["onBehalf"]
        roleType <- map["roleType"]
    }

}



//struct SubmitFormPayload : Mappable {
//    var id : String?
//    var name : String?
//    var value : [[String: Any]]?
//    var type : String?
//    var label : String?
//
//    init(){}
//    init(control: ModelControl){
//        id = control.id
//        name = control.name
//        type = control.type?.rawValue
//        label = control.label
//        if let val = control.value as? [Options]{
//            var json: [[String: Any]] = []
//            for item in val{
//                let obj: [String: Any] = [
//                    "key": item.key,
//                    "text": item.text
//                ]
//                json.append(obj)
//            }
//            value = json
//        }else{
//            value = nil
//        }
//    }
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        id <- map["id"]
//        name <- map["name"]
//        value <- map["value"]
//        type <- map["type"]
//        label <- map["label"]
//    }
//
//}


struct SubmitFormPayload : Mappable {
    var id : String?
    var name : String?
    var value : [[String: Any]]?
    var type : String?
    var label : String?
    var multipleValue: Bool?
    

    init(){}
    init(control: FormViewModelItem){
        id = control.fieldId
        
        if isArabic() {
            if let lbl = control.localization?["ar"]?.label, lbl != "" {
                label = lbl
            }else {
                label = control.label
            }
        }else {
            if let lbl = control.localization?["en"]?.label, lbl != "" {
                label = lbl
            }else {
                
                label = control.label
            }
        }
        name = control.label
        type = control.type?.rawValue
        multipleValue = (control.field?.properties as? DropdownProperties)?.multiSelect
        if let val = control.answer as? BaseAnswerMCQ {
                var json: [[String: Any]] = []
                    let values = val.value ?? []
                    for item in values {
                        let obj: [String: Any] = [
                            "key": item.id ?? "",
                            "text": item.name ?? "",
                            "selectedKey": item.id ?? ""
                        ]
                        json.append(obj)
                    }
                value = json
        }else{
            value = nil
        }
    }
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        value <- map["value"]
        type <- map["type"]
        label <- map["label"]
        multipleValue <- map["multipleValue"]
    }

}

