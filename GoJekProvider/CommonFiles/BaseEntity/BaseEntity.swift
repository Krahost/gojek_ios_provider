//
//  BaseEntity.swift
//  GoJekUser
//
//  Created by Sravani on 29/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : BaseResponseData?
    var error : [String]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
     func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        responseData <- map["responseData"]
        error <- map["error"]
    }
}

struct Services : Mappable {
    var id : Int?
    var admin_service_name : String?
    var base_url : String?
    var status : Int?
    var company_id : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        admin_service_name <- map["admin_service"]
        base_url <- map["base_url"]
        status <- map["status"]
        company_id <- map["company_id"]
    }
    
}

struct Supportdetails : Mappable {
    var contact_number : [Contact_number]?
    var contact_email : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        contact_number <- map["contact_number"]
        contact_email <- map["contact_email"]
    }
    
}

struct BaseResponseData : Mappable {
    var base_url : String?
    var services : [Services]?
    var appsetting : Appsetting?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        base_url <- map["base_url"]
        services <- map["services"]
        appsetting <- map["appsetting"]
    }
}

struct Appsetting : Mappable {
    var referral : Int?
    var provider_negative_balance : String?
    var social_login : Int?
    var otp_verify : Int?
    var payments : [Payments]?
    var cmspage : Cmspage?
    var supportdetails : Supportdetails?
    var languages : [Languages]?
    var ios_key: String?
    var demo_mode: Int?
    var ride_otp : Int?
    var order_otp : Int?
    var date_format: String?
    var service_otp : Int?
    var send_sms: Int?
    var send_email: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        referral <- map["referral"]
        social_login <- map["social_login"]
        provider_negative_balance <- map["provider_negative_balance"]
        otp_verify <- map["otp_verify"]
        payments <- map["payments"]
        cmspage <- map["cmspage"]
        supportdetails <- map["supportdetails"]
        languages <- map["languages"]
        ios_key <- map["ios_key"]
        demo_mode <- map["demo_mode"]
        ride_otp <- map["ride_otp"]
        order_otp <- map["order_otp"]
        date_format <- map["date_format"]
        service_otp <- map["service_otp"]
        send_sms <- map["send_sms"]
        send_email <- map["send_email"]
    }
    
}

struct Cmspage : Mappable {
    var privacypolicy : String?
    var help : String?
    var terms : String?
    var cancel : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        privacypolicy <- map["privacypolicy"]
        help <- map["help"]
        terms <- map["terms"]
        cancel <- map["cancel"]
    }
    
}

struct Contact_number : Mappable {
    var number : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        number <- map["number"]
    }
    
}

struct Languages : Mappable {
    var name : String?
    var key : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        key <- map["key"]
    }
    
}

struct Payments : Mappable {
    var name : String?
    var status : String?
    var credentials : [PaymentCredentials]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        status <- map["status"]
        credentials <- map["credentials"]
    }
}

struct PaymentCredentials: Mappable {
    var name : String?
    var value : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        value <- map["value"]
    }
}

