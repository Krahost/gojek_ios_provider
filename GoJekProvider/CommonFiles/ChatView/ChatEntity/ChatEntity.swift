//
//  ChatEntity.swift
//  GoJekUser
//
//  Created by apple on 30/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

struct ChatEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [ChatResponseEntity]?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
}

struct ChatResponseEntity: Mappable {
    
    var id : String?
    var requestId : String?
    var adminServiceId : String?
    var data : [ChatDataEntity]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        requestId <- map["request_id"]
        adminServiceId <- map["admin_service"]
        data <- map["data"]
    }
}

struct ChatDataEntity: Mappable {
    
    var type : String?
    var user : String?
    var provider : String?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        type <- map["type"]
        user <- map["user"]
        provider <- map["provider"]
        message <- map["message"]
    }
}


