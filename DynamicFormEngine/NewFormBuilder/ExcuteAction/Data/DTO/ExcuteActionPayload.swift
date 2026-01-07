//
//  DelegateDTO.swift
//  CERQEL
//
//  Created by Youxel on 27/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation


struct ExcuteActionPayload : Codable,Mappable {
    var actionId : String?
    var taskId : String?
    var pendingOnEmail : String?
    var payload : ExcuteActionInternalPayload? = ExcuteActionInternalPayload()
    var attachments : [String]?

 
    
    init(actionId : String?,taskId : String?,pendingOnEmail : String?,payload : ExcuteActionInternalPayload?,attachments : [String]?){
        self.actionId = actionId
        self.taskId = taskId
        self.pendingOnEmail = pendingOnEmail
        self.payload = payload
        self.attachments = attachments
    }
    init?(map: Map) {
        
    }
    init(){
        
    }
    
    mutating func mapping(map: Map) {
     actionId <- map["actionId"]
     taskId <- map["taskId"]
     pendingOnEmail <- map["pendingOnEmail"]
     payload <- map["payload"]
     attachments <- map["attachments"]
    }

}

struct ExcuteActionInternalPayload : Codable ,Mappable{
    var payload : [String]?
    var comment : String?

    enum CodingKeys: String, CodingKey {

        case payload = "payload"
        case comment = "comment"
    }
    init(payload : [String]?,comment : String?){
        self.payload = payload
        self.comment = comment
        
    }
    init?(map: Map) {
        
    }
    init(){
        
    }
    
    mutating func mapping(map: Map) {
     payload <- map["payload"]
     comment <- map["comment"]
   
    }

}
