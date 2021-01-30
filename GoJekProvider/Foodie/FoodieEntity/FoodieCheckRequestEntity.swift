//
//  FoodieCheckRequestEntity.swift
//  GoJekProvider
//
//  Created by Ansar on 05/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct FoodieCheckRequestEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : FoodieRequestResponse?
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

struct FoodieRequestResponse : Mappable {
    var account_status : String?
    var service_status : String?
    var requests : FoodieUpdateResponseData?
    var provider_details : Provider_details?
    var reasons : [Reasons]?
    var referral_count : String?
    var referral_amount : String?
    var serve_otp : Int?
    var order_otp : String?
    var referral_total_count : String?
    var referral_total_amount : Int?
    
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
        order_otp <- map["order_otp"]
    }
    
}

struct Requests : Mappable {
    var id : Int?
    var request_id : Int?
    var user_id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var company_id : Int?
    var status : String?
    var schedule_at : String?
    var created_at : String?
    var store_orders : String?
    var time_left_to_respond : Int?
    var request : FoodieRequest?
    var user : User?
    var service : Service?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        request_id <- map["request_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        company_id <- map["company_id"]
        status <- map["status"]
        schedule_at <- map["schedule_at"]
        created_at <- map["created_at"]
        store_orders <- map["store_orders"]
        time_left_to_respond <- map["time_left_to_respond"]
        request <- map["request"]
        user <- map["user"]
        service <- map["service"]
    }
    
}


struct FoodieRequest : Mappable {
    var id : Int?
    var store_order_invoice_id : String?
    var admin_service_id : Int?
    var user_id : Int?
    var user_address_id : Int?
    var promocode_id : Int?
    var store_id : Int?
    var provider_id : Int?
    var provider_vehicle_id : String?
    var company_id : Int?
    var note : String?
    var route_key : String?
    var delivery_date : String?
    var pickup_address : String?
    var delivery_address : String?
    var order_type : String?
    var order_otp : String?
    var order_ready_time : Int?
    var order_ready_status : String?
    var paid : String?
    var status : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var user_rated : Int?
    var provider_rated : Int?
    var schedule_status : Int?
    var request_type : String?
    var created_at : String?
    var delivery : Delivery?
    var pickup : Pickup?
    var user : User?
    var order_invoice : Order_invoice?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_order_invoice_id <- map["store_order_invoice_id"]
        admin_service_id <- map["admin_service"]
        user_id <- map["user_id"]
        user_address_id <- map["user_address_id"]
        promocode_id <- map["promocode_id"]
        store_id <- map["store_id"]
        provider_id <- map["provider_id"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        company_id <- map["company_id"]
        note <- map["note"]
        route_key <- map["route_key"]
        delivery_date <- map["delivery_date"]
        pickup_address <- map["pickup_address"]
        delivery_address <- map["delivery_address"]
        order_type <- map["order_type"]
        order_otp <- map["order_otp"]
        order_ready_time <- map["order_ready_time"]
        order_ready_status <- map["order_ready_status"]
        paid <- map["paid"]
        status <- map["status"]
        cancelled_by <- map["cancelled_by"]
        cancel_reason <- map["cancel_reason"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        schedule_status <- map["schedule_status"]
        request_type <- map["request_type"]
        created_at <- map["created_at"]
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        user <- map["user"]
        order_invoice <- map["order_invoice"]
    }
    
}

struct Reasons : Mappable {
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


struct Provider_details : Mappable {
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
    var current_location : String?
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
        current_location <- map["current_location"]
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
    }
    
}
