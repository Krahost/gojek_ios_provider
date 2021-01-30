//
//  LoginEntity.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

//MARK: - LoginEntity

struct LoginEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : LoginResponseData?
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

//MARK: - Login Response data

struct LoginResponseData: Mappable {
    
    var accessToken : String?
    var expiresIn : Int?
    var tokenType : String?
    var user : LoginUser?
    var otp: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        accessToken <- map["access_token"]
        expiresIn <- map["expires_in"]
        tokenType <- map["token_type"]
        user <- map["user"]
        otp <- map["otp"]
    }
}

//MARK: - User Entity

struct LoginUser: Mappable{
    
    var id : Int?
    var first_name : String?
    var last_name : String?
    var payment_mode : String?
    var email : String?
    var country_code : String?
    var mobile : String?
    var gender : String?
    var device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var latitude : Double?
    var longitude : Double?
    var stripe_acc_id : Int?
    var wallet_balance : Int?
    var rating : Int?
    var status : String?
    var admin_id : String?
    var payment_gateway_id : String?
    var otp : String?
    var language : String?
    var picture : String?
    var referral_unique_id : String?
    var qrcode_url : String?
    var country_id : Int?
    var city_id : Int?
    var email_verified_at : String?
    var created_type : String?
    var created_by : String?
    var modified_type : String?
    var modified_by : String?
    var deleted_type : String?
    var deleted_by : String?
    var company_id : Int?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var state_id : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        payment_mode <- map["payment_mode"]
        email <- map["email"]
        country_code <- map["country_code"]
        mobile <- map["mobile"]
        gender <- map["gender"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        stripe_acc_id <- map["stripe_acc_id"]
        wallet_balance <- map["wallet_balance"]
        rating <- map["rating"]
        status <- map["status"]
        admin_id <- map["admin_id"]
        payment_gateway_id <- map["payment_gateway_id"]
        otp <- map["otp"]
        language <- map["language"]
        picture <- map["picture"]
        referral_unique_id <- map["referral_unique_id"]
        qrcode_url <- map["qrcode_url"]
        country_id <- map["country_id"]
        city_id <- map["city_id"]
        email_verified_at <- map["email_verified_at"]
        created_type <- map["created_type"]
        created_by <- map["created_by"]
        modified_type <- map["modified_type"]
        modified_by <- map["modified_by"]
        deleted_type <- map["deleted_type"]
        deleted_by <- map["deleted_by"]
        company_id <- map["company_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        state_id <- map["state_id"]
    }
}
