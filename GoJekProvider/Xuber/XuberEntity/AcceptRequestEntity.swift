//
//  AcceptRequestEntity.swift
//  GoJekProvider
//
//  Created by CSS on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct AcceptRequestEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : Message?
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

struct Message : Mappable {
    var id : Int?
    var booking_id : String?
    var user_id : Int?
    var provider_id : Int?
    var current_provider_id : Int?
    var service_id : Int?
    var city_id : Int?
    var country_id : Int?
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
    var s_latitude : Int?
    var s_longitude : Double?
    var unit : String?
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
    var user : XuberUser?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        booking_id <- map["booking_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        current_provider_id <- map["current_provider_id"]
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
    }
    
}

