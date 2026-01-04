//
//  ModelSubmitFormCerqel.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/29/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import ObjectMapper

struct ModelSubmitFormCerqel : Mappable {
    var payload : [SubmitFormPayloadCerqel]?
    var formCode : String?
    var formVersion : Int?
    var onBehalf : Bool?
    var createdForUsername : String?

    public init(){}
    public init?(map: Map) {

    }

    mutating public func mapping(map: Map) {

        payload <- map["payload"]
        formCode <- map["formCode"]
        formVersion <- map["formVersion"]
        onBehalf <- map["onBehalf"]
        createdForUsername <- map["createdForUsername"]
    }

}


struct SubmitFormPayloadCerqel : Mappable {
    var id : String?
    var name : String?
    var value : [[String: Any]]?
    var type : String?
    var label : String?

    public init(){}
    public init(control: ModelControlCerqel){
        id = control.id
        name = control.name
        type = control.type?.rawValue
        label = control.label
        if let val = control.value as? [OptionsCerqel]{
            var json: [[String: Any]] = []
            for item in val{
                let obj: [String: Any] = [
                    "key": item.key,
                    "text": item.text
                ]
                json.append(obj)
            }
            value = json
        }else{
            value = nil
        }
    }
    public init?(map: Map) {

    }

    mutating public func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        value <- map["value"]
        type <- map["type"]
        label <- map["label"]
    }

}

