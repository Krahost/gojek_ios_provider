//
//  BankTemplateEntity.swift
//  GoJekProvider
//
//  Created by CSS on 10/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct BankTemplateEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [BankResponseData]?
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

struct Bankdetails : Mappable {
    var id : Int?
    var bankform_id : Int?
    var keyvalue : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        bankform_id <- map["bankform_id"]
        keyvalue <- map["keyvalue"]
    }
    
}

struct BankResponseData : Mappable {
    var id : Int?
    var country_id : Int?
    var type : String?
    var label : String?
    var min : Int?
    var max : Int?
    var bankdetails : Bankdetails?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        country_id <- map["country_id"]
        type <- map["type"]
        label <- map["label"]
        min <- map["min"]
        max <- map["max"]
        bankdetails <- map["bankdetails"]
    }
    
}
