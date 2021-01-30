//
//  EarningEntity.swift
//  GoJekProvider
//
//  Created by CSS on 09/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct EarningEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : EarningResponseData?
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

struct EarningResponseData : Mappable {
    var today : String?
    var week : String?
    var month : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        today <- map["today"]
        week <- map["week"]
        month <- map["month"]
    }
    
}
