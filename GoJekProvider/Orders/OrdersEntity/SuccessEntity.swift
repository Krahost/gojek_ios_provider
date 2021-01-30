//
//  SuccessEntity.swift
//  GoJekProvider
//
//  Created by CSS on 20/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct SuccessEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [String]?
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
