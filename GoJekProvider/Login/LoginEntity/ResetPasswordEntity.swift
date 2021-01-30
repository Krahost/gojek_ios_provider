//
//  ResetPasswordEntity.swift
//  GoJekProvider
//
//  Created by CSS on 29/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct ResetPasswordEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var resetPasswordData : ResetPasswordData?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        resetPasswordData <- map["responseData"]
        error <- map["error"]
    }
    
}

struct ResetPasswordData : Mappable {
    var account_type : String?
    var username : String?
    var otp : String?
    var salt_key : String?
    var password : String?
    var password_confirmation : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        account_type <- map["account_type"]
        username <- map["username"]
        otp <- map["otp"]
        salt_key <- map["salt_key"]
        password <- map["password"]
        password_confirmation <- map["password_confirmation"]
    }
    
}
