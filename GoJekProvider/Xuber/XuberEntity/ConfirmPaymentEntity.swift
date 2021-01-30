//
//  ConfirmPaymentEntity.swift
//  GoJekProvider
//
//  Created by CSS on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct ConfirmPaymentEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : ConfirmPayemntResponse?
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

struct ConfirmPayemntResponse : Mappable {
    var id : Int?
    var booking_id : String?
    var user_id : Int?
    var provider_id : Int?
    var current_provider_id : String?
    var provider_service_id : Int?
    var service_id : Int?
    var city_id : Int?
    var country_id : String?
    var promocode_id : Int?
    var company_id : Int?
    var before_image : String?
    var before_comment : String?
    var after_image : String?
    var after_comment : String?
    var status : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var payment_mode : String?
    var paid : Int?
    var distance : Int?
    var travel_time : String?
    var s_address : String?
    var s_latitude : Double?
    var s_longitude : Double?
    var unit : String?
    var timezone : String?
    var currency : String?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var is_scheduled : String?
    var user_rated : Int?
    var provider_rated : Int?
    var use_wallet : Int?
    var surge : Int?
    var route_key : String?
    var user : User?
    var payment : ConfirmPaymentData?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        booking_id <- map["booking_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        current_provider_id <- map["current_provider_id"]
        provider_service_id <- map["provider_service_id"]
        service_id <- map["service_id"]
        city_id <- map["city_id"]
        country_id <- map["country_id"]
        promocode_id <- map["promocode_id"]
        company_id <- map["company_id"]
        before_image <- map["before_image"]
        before_comment <- map["before_comment"]
        after_image <- map["after_image"]
        after_comment <- map["after_comment"]
        status <- map["status"]
        cancelled_by <- map["cancelled_by"]
        cancel_reason <- map["cancel_reason"]
        payment_mode <- map["payment_mode"]
        paid <- map["paid"]
        distance <- map["distance"]
        travel_time <- map["travel_time"]
        s_address <- map["s_address"]
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        unit <- map["unit"]
        timezone <- map["timezone"]
        currency <- map["currency"]
        otp <- map["otp"]
        assigned_at <- map["assigned_at"]
        schedule_at <- map["schedule_at"]
        started_at <- map["started_at"]
        finished_at <- map["finished_at"]
        is_scheduled <- map["is_scheduled"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        use_wallet <- map["use_wallet"]
        surge <- map["surge"]
        route_key <- map["route_key"]
        user <- map["user"]
        payment <- map["payment"]
    }
    
}

struct ConfirmPaymentData : Mappable {
    var id : Int?
    var service_request_id : Int?
    var user_id : Int?
    var provider_id : Int?
    var fleet_id : String?
    var promocode_id : String?
    var payment_id : String?
    var company_id : Int?
    var payment_mode : String?
    var fixed : Double?
    var distance : Int?
    var minute : Int?
    var hour : Int?
    var commision : Double?
    var commision_percent : Int?
    var fleet : Double?
    var fleet_percent : Int?
    var discount : Int?
    var discount_percent : Int?
    var tax : Double?
    var tax_percent : Int?
    var wallet : Int?
    var is_partial : String?
    var cash : Double?
    var card : Int?
    var surge : Int?
    var tips : Int?
    var extra_charges : Double?
    var total : Double?
    var payable : Double?
    var provider_pay : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_request_id <- map["service_request_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        fleet_id <- map["fleet_id"]
        promocode_id <- map["promocode_id"]
        payment_id <- map["payment_id"]
        company_id <- map["company_id"]
        payment_mode <- map["payment_mode"]
        fixed <- map["fixed"]
        distance <- map["distance"]
        minute <- map["minute"]
        hour <- map["hour"]
        commision <- map["commision"]
        commision_percent <- map["commision_percent"]
        fleet <- map["fleet"]
        fleet_percent <- map["fleet_percent"]
        discount <- map["discount"]
        discount_percent <- map["discount_percent"]
        tax <- map["tax"]
        tax_percent <- map["tax_percent"]
        wallet <- map["wallet"]
        is_partial <- map["is_partial"]
        cash <- map["cash"]
        card <- map["card"]
        surge <- map["surge"]
        tips <- map["tips"]
        extra_charges <- map["extra_charges"]
        total <- map["total"]
        payable <- map["payable"]
        provider_pay <- map["provider_pay"]
    }
    
}
