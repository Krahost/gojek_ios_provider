//
//  MyAccountEntity.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

struct ProfileEntity: Mappable{
    
    var error: String?
    var message: String?
    var responseData: ProfileData?
    var statusCode: String?
    var title: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        responseData <- map["responseData"]
        statusCode <- map["statusCode"]
        title <- map["title"]
    }
}

struct ProfileData: Mappable {
    
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
    var stripe_acc_id : String?
    var wallet_balance : Double?
    var isOnline: Int?
    var rating : Int?
    var iso2 : String?
    var status : String?
    var admin_id : String?
    var payment_gateway_id : String?
    var otp : String?
    var language : String?
    var picture : String?
    var picture_draft:String?
    var referral_unique_id : String?
    var qrcode_url : String?
    var country_id : Int?
    var currency_symbol : String?
    var city_id : Int?
    var currency : String?
    var company_id : Int?
    var state_id : Int?
    var is_service: Int?
    var is_document: Int?
    var is_bankdetail: Int?
    var referral : Referral?
    var service : ServiceModel?
    var country : CountryData?
    var city : CityData?
    var airport_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        iso2 <- map["iso2"]
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
        isOnline <- map["is_online"]
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
        currency_symbol <- map["currency_symbol"]
        city_id <- map["city_id"]
        currency <- map["currency"]
        company_id <- map["company_id"]
        state_id <- map["state_id"]
        referral <- map["referral"]
        service <- map["service"]
        country <- map["country"]
        city <- map["city"]
        is_service <- map["is_service"]
        is_document <- map["is_document"]
        is_bankdetail <- map["is_bankdetail"]
        airport_at <- map["airport_at"]
        picture_draft <- map["picture_draft"]
    }
}
struct Referral : Mappable {
    var referral_code : String?
    var referral_amount : Double?
    var referral_count : Int?
    var user_referral_count : Int?
    var user_referral_amount : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        referral_code <- map["referral_code"]
        referral_amount <- map["referral_amount"]
        referral_count <- map["referral_count"]
        user_referral_count <- map["user_referral_count"]
        user_referral_amount <- map["user_referral_amount"]
    }
}

struct ServiceModel : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : Int?
    var ride_delivery_id : Int?
    var service_id : String?
    var company_id : Int?
    var status : String?
    var service_city : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        ride_delivery_id <- map["ride_delivery_id"]
        service_id <- map["service_id"]
        company_id <- map["company_id"]
        status <- map["status"]
        service_city <- map["service_city"]
    }
    
}
