//
//  XuberEntity.swift
//  GoJekProvider
//
//  Created by CSS on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct XuberCheckRequest : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : XuberCheckResponseData?
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

struct XuberProviderdetails : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var payment_mode : String?
    var email : String?
    var country_code : String?
    var currency : String?
    var currency_symbol : String?
    var mobile : String?
    var gender : String?
    var device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var latitude : String?
    var longitude : String?
    var stripe_cust_id : String?
    var wallet_balance : Int?
    var is_online : Int?
    var is_assigned : Int?
    var rating : Double?
    var status : String?
    var is_service : Int?
    var is_document : Int?
    var is_bankdetail : Int?
    var admin_id : String?
    var payment_gateway_id : String?
    var otp : String?
    var language : String?
    var picture : String?
    var qrcode_url : String?
    var referral_unique_id : String?
    var referal_count : Int?
    var country_id : Int?
    var state_id : Int?
    var city_id : Int?
    var zone_id : String?
    var activation_status : Int?
    var service : XuberService?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        payment_mode <- map["payment_mode"]
        email <- map["email"]
        country_code <- map["country_code"]
        currency <- map["currency"]
        currency_symbol <- map["currency_symbol"]
        mobile <- map["mobile"]
        gender <- map["gender"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        stripe_cust_id <- map["stripe_cust_id"]
        wallet_balance <- map["wallet_balance"]
        is_online <- map["is_online"]
        is_assigned <- map["is_assigned"]
        rating <- map["rating"]
        status <- map["status"]
        is_service <- map["is_service"]
        is_document <- map["is_document"]
        is_bankdetail <- map["is_bankdetail"]
        admin_id <- map["admin_id"]
        payment_gateway_id <- map["payment_gateway_id"]
        otp <- map["otp"]
        language <- map["language"]
        picture <- map["picture"]
        qrcode_url <- map["qrcode_url"]
        referral_unique_id <- map["referral_unique_id"]
        referal_count <- map["referal_count"]
        country_id <- map["country_id"]
        state_id <- map["state_id"]
        city_id <- map["city_id"]
        zone_id <- map["zone_id"]
        activation_status <- map["activation_status"]
        service <- map["service"]
    }
    
}




struct XuberServicedetails : Mappable {
    var id : Int?
    var service_category_id : Int?
    var service_subcategory_id : Int?
    var company_id : Int?
    var service_name : String?
    var picture : String?
    var allow_desc : Int?
    var allow_before_image : Int?
    var allow_after_image : Int?
    var is_professional : Int?
    var service_status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_category_id <- map["service_category_id"]
        service_subcategory_id <- map["service_subcategory_id"]
        company_id <- map["company_id"]
        service_name <- map["service_name"]
        picture <- map["picture"]
        allow_desc <- map["allow_desc"]
        allow_before_image <- map["allow_before_image"]
        allow_after_image <- map["allow_after_image"]
        is_professional <- map["is_professional"]
        service_status <- map["service_status"]
    }
    
}




struct XuberReasons : Mappable {
    var id : Int?
    var service : String?
    var type : String?
    var reason : String?
    var status : String?
    var created_type : String?
    var created_by : Int?
    var modified_type : String?
    var modified_by : Int?
    var deleted_type : String?
    var deleted_by : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service <- map["service"]
        type <- map["type"]
        reason <- map["reason"]
        status <- map["status"]
        created_type <- map["created_type"]
        created_by <- map["created_by"]
        modified_type <- map["modified_type"]
        modified_by <- map["modified_by"]
        deleted_type <- map["deleted_type"]
        deleted_by <- map["deleted_by"]
    }
    
}



struct XuberRequests : Mappable {
    var id : Int?
    var booking_id : String?
    var admin_service_id: String?
    var user_id : Int?
    var provider_id : Int?
    var service_id : Int?
    var city_id : Int?
    var country_id : String?
    var promocode_id : Int?
    var company_id : Int?
    var before_image : String?
    var allow_description : String?
    var allow_image : String?
    var quantity : String?
    var price : String?
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
    var currency : String?
    var timezone : String?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var is_scheduled : String?
    var request_type : String?
    var user_rated : Int?
    var provider_rated : Int?
    var use_wallet : Int?
    var surge : Int?
    var route_key : String?
    var admin_id : String?
    var time_left_to_respond : Int?
    var user : XuberUser?
    var payment : XuberPayment?
    var service : XuberServicedetails?
    var created_type: String?


    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        booking_id <- map["booking_id"]
        admin_service_id <- map["admin_service"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        service_id <- map["service_id"]
        city_id <- map["city_id"]
        country_id <- map["country_id"]
        promocode_id <- map["promocode_id"]
        company_id <- map["company_id"]
        before_image <- map["before_image"]
        allow_description <- map["allow_description"]
        allow_image <- map["allow_image"]
        quantity <- map["quantity"]
        price <- map["price"]
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
        timezone <- map["timezone"]
        otp <- map["otp"]
        assigned_at <- map["assigned_at"]
        schedule_at <- map["schedule_at"]
        started_at <- map["started_at"]
        finished_at <- map["finished_at"]
        is_scheduled <- map["is_scheduled"]
        request_type <- map["request_type"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        use_wallet <- map["use_wallet"]
        surge <- map["surge"]
        route_key <- map["route_key"]
        admin_id <- map["admin_id"]
        time_left_to_respond <- map["time_left_to_respond"]
        user <- map["user"]
        payment <- map["payment"]
        service <- map["service"]
        created_type <- map["created_type"]

    }
    
}

struct XuberCheckResponseData : Mappable {
    var account_status : String?
    var service_status : String?
    var requests : XuberRequests?
    var provider_details : XuberProviderdetails?
    var reasons : [XuberReasons]?
    var referral_count : String?
    var referral_amount : String?
    var referral_total_count : String?
    var referral_total_amount : Int?
    var serve_otp: String?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        account_status <- map["account_status"]
        service_status <- map["service_status"]
        requests <- map["requests"]
        provider_details <- map["provider_details"]
        reasons <- map["reasons"]
        referral_count <- map["referral_count"]
        referral_amount <- map["referral_amount"]
        serve_otp <- map["serve_otp"]
        referral_total_count <- map["referral_total_count"]
        referral_total_amount <- map["referral_total_amount"]

    }
    
}


struct XuberService : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : String?
    var ride_delivery_id : String?
    var service_id : Int?
    var category_id : Int?
    var sub_category_id : Int?
    var company_id : Int?
    var base_fare : Double?
    var per_miles : String?
    var per_mins : String?
    var status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        ride_delivery_id <- map["ride_delivery_id"]
        service_id <- map["service_id"]
        category_id <- map["category_id"]
        sub_category_id <- map["sub_category_id"]
        company_id <- map["company_id"]
        base_fare <- map["base_fare"]
        per_miles <- map["per_miles"]
        per_mins <- map["per_mins"]
        status <- map["status"]
    }
    
}


struct XuberUser : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var payment_mode : String?
    var user_type : String?
    var email : String?
    var mobile : String?
    var gender : String?
    var country_code : String?
    var currency_symbol : String?
    var picture : String?
    var login_by : String?
    var latitude : String?
    var longitude : String?
    var wallet_balance : Int?
    var rating : Double?
    var language : String?
    var country_id : Int?
    var state_id : Int?
    var city_id : Int?
    var status : Int?
    var created_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        payment_mode <- map["payment_mode"]
        user_type <- map["user_type"]
        email <- map["email"]
        mobile <- map["mobile"]
        gender <- map["gender"]
        country_code <- map["country_code"]
        currency_symbol <- map["currency_symbol"]
        picture <- map["picture"]
        login_by <- map["login_by"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        wallet_balance <- map["wallet_balance"]
        rating <- map["rating"]
        language <- map["language"]
        country_id <- map["country_id"]
        state_id <- map["state_id"]
        city_id <- map["city_id"]
        status <- map["status"]
        created_at <- map["created_at"]
    }
    
}

struct XuberPayment : Mappable {
    var id : Int?
    var service_request_id : Int?
    var user_id : Int?
    var provider_id : Int?
    var fleet_id : Int?
    var promocode_id : Int?
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
    var cash : Int?
    var card : Int?
    var surge : Int?
    var extra_charges : Double?
    var extra_charges_notes : String?
    var tips : Int?
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
        extra_charges <- map["extra_charges"]
        extra_charges_notes <- map["extra_charges_notes"]
        tips <- map["tips"]
        total <- map["total"]
        payable <- map["payable"]
        provider_pay <- map["provider_pay"]
    }
    
}
