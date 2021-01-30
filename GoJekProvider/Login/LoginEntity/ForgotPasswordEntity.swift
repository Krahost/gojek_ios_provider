//
//  ForgotPasswordEntity.swift
//  GoJekProvider
//
//  Created by CSS on 29/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct ForgotPasswordEntity : Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var forgotPasswordData : ForgotPasswordData?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        forgotPasswordData <- map["responseData"]
        error <- map["error"]
    }
}


struct ForgotPasswordData : Mappable {
    
    var username : String?
    var account_type : String?
    var otp : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        username <- map["username"]
        account_type <- map["account_type"]
        otp <- map["otp"]
    }
    
}
