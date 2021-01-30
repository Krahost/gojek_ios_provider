//
//  OrderDetailEntity.swift
//  GoJekUser
//
//  Created by Ansar on 13/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrderDetailEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : OrderDetailReponseData?
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

struct OrderDetailReponseData : Mappable {
    var type : String?
    var transport : TransportHistoryDetail?
    var service: TransportHistoryDetail?
    var foodie: Order?
    var delivery : CourierOrderDetailData?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        type <- map["type"]
        transport <- map["transport"]
        service <- map["service"]
        foodie <- map["order"]
        delivery <- map["delivery"]

    }
    
}

struct CourierPayment : Mappable {
    var id : Int?
    var delivery_id : Int?
    var user_id : Int?
    var provider_id : Int?
    var fleet_id : String?
    var promocode_id : String?
    var payment_id : String?
    var payment_mode : String?
    var fixed : Int?
    var distance : Int?
    var weight : Int?
    var commision : Int?
    var commision_percent : Int?
    var fleet : Int?
    var fleet_percent : Int?
    var discount : Int?
    var discount_percent : Int?
    var tax : Int?
    var tax_percent : Int?
    var wallet : Int?
    var is_partial : String?
    var cash : Int?
    var card : Int?
    var peak_amount : Int?
    var peak_comm_amount : Int?
    var total_waiting_time : Int?
    var tips : Int?
    var round_of : Int?
    var total : Int?
    var payable : Int?
    var provider_pay : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        delivery_id <- map["delivery_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        fleet_id <- map["fleet_id"]
        promocode_id <- map["promocode_id"]
        payment_id <- map["payment_id"]
        payment_mode <- map["payment_mode"]
        fixed <- map["fixed"]
        distance <- map["distance"]
        weight <- map["weight"]
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
        peak_amount <- map["peak_amount"]
        peak_comm_amount <- map["peak_comm_amount"]
        total_waiting_time <- map["total_waiting_time"]
        tips <- map["tips"]
        round_of <- map["round_of"]
        total <- map["total"]
        payable <- map["payable"]
        provider_pay <- map["provider_pay"]

    }

}

struct CourierOrderDetailData : Mappable {
    var id : Int?
    var booking_id : String?
    var admin_service : String?
    var user_id : Int?
    var provider_id : Int?
    var provider_vehicle_id : String?
    var provider_service_id : Int?
    var delivery_type_id : Int?
    var delivery_mode : String?
    var geofence_id : Int?
    var delivery_vehicle_id : Int?
    var city_id : Int?
    var country_id : Int?
    var promocode_id : Int?
    var status : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var payment_mode : String?
    var paid : Int?
    var calculator : String?
    var distance : Double?
    var weight : Int?
    var location_points : String?
    var timezone : String?
    var travel_time : String?
    var s_address : String?
    var s_latitude : Double?
    var s_longitude : Double?
    var d_address : String?
    var d_latitude : Int?
    var d_longitude : Int?
    var track_distance : Int?
    var is_drop_location : Int?
    var destination_log : String?
    var unit : String?
    var currency : String?
    var track_latitude : Double?
    var track_longitude : Double?
    var total_amount : Double?
    var payable_amount : Int?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var return_date : String?
    var is_scheduled : String?
    var request_type : String?
    var peak_hour_id : String?
    var user_rated : Int?
    var provider_rated : Int?
    var use_wallet : Int?
    var surge : Int?
    var route_key : String?
    var admin_id : String?
    var created_at : String?
    var static_map : String?
    var created_time : String?
    var assigned_time : String?
    var schedule_time : String?
    var started_time : String?
    var finished_time : String?
    var payment : CourierPayment?
    var service : CourierService?
    var user : User?
    var service_type : Service_type?
    var dispute : Dispute?
    var rating : Rating?
    var deliveries : [Deliveries]?
    var fixed_amount : Double?
    var weight_amount : Double?
    var distance_amount : Double?
    var tax_amount : Double?
    var discount_amount : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        
        id <- map["id"]
        booking_id <- map["booking_id"]
        admin_service <- map["admin_service"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        provider_service_id <- map["provider_service_id"]
        delivery_type_id <- map["delivery_type_id"]
        delivery_mode <- map["delivery_mode"]
        geofence_id <- map["geofence_id"]
        delivery_vehicle_id <- map["delivery_vehicle_id"]
        city_id <- map["city_id"]
        country_id <- map["country_id"]
        promocode_id <- map["promocode_id"]
        status <- map["status"]
        cancelled_by <- map["cancelled_by"]
        cancel_reason <- map["cancel_reason"]
        payment_mode <- map["payment_mode"]
        paid <- map["paid"]
        calculator <- map["calculator"]
        distance <- map["distance"]
        weight <- map["weight"]
        location_points <- map["location_points"]
        timezone <- map["timezone"]
        travel_time <- map["travel_time"]
        s_address <- map["s_address"]
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        d_address <- map["d_address"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        track_distance <- map["track_distance"]
        is_drop_location <- map["is_drop_location"]
        destination_log <- map["destination_log"]
        unit <- map["unit"]
        currency <- map["currency"]
        track_latitude <- map["track_latitude"]
        track_longitude <- map["track_longitude"]
        total_amount <- map["total_amount"]
        payable_amount <- map["payable_amount"]
        otp <- map["otp"]
        assigned_at <- map["assigned_at"]
        schedule_at <- map["schedule_at"]
        started_at <- map["started_at"]
        finished_at <- map["finished_at"]
        return_date <- map["return_date"]
        is_scheduled <- map["is_scheduled"]
        request_type <- map["request_type"]
        peak_hour_id <- map["peak_hour_id"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        use_wallet <- map["use_wallet"]
        surge <- map["surge"]
        route_key <- map["route_key"]
        admin_id <- map["admin_id"]
        created_at <- map["created_at"]
        static_map <- map["static_map"]
        created_time <- map["created_time"]
        assigned_time <- map["assigned_time"]
        schedule_time <- map["schedule_time"]
        started_time <- map["started_time"]
        finished_time <- map["finished_time"]
        payment <- map["payment"]
        service <- map["service"]
        user <- map["user"]
        service_type <- map["service_type"]
        dispute <- map["dispute"]
        rating <- map["rating"]
        deliveries <- map["deliveries"]
        fixed_amount <- map["fixed_amount"]
        weight_amount <- map["weight_amount"]
        distance_amount <- map["distance_amount"]
        tax_amount <- map["tax_amount"]
        discount_amount <- map["discount_amount"]
        
        
    }

}

struct Deliveries : Mappable {
    var id : Int?
    var d_address : String?
    var d_latitude : Double?
    var d_longitude : Double?
    var delivery_request_id : Int?
    var status : String?
    var paid : Int?
    var name : String?
    var mobile : String?
    var weight : Int?
    var payment : Payment?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        d_address <- map["d_address"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        delivery_request_id <- map["delivery_request_id"]
        status <- map["status"]
        paid <- map["paid"]
        name <- map["name"]
        mobile <- map["mobile"]
        weight <- map["weight"]
        payment <- map["payment"]
    }

}

struct TransportHistoryDetail : Mappable {
    var id : Int?
    var vehicle_type : String?
    var booking_id : String?
    var user_id : Int?
    var provider_id : Int?
    var provider_vehicle_id : String?
    var provider_service_id : Int?
    var ride_delivery_id : Int?
    var city_id : Int?
    var country_id : String?
    var promocode_id : Int?
    var company_id : Int?
    var status : String?
    var cancelled_by : String?
    var cancel_reason : String?
    var payment_mode : String?
    var paid : Int?
    var is_track : String?
    var distance : Int?
    var timezone : String?
    var travel_time : String?
    var s_address : String?
    var s_latitude : Double?
    var s_longitude : Double?
    var d_address : String?
    var d_latitude : Double?
    var d_longitude : Double?
    var track_distance : Int?
    var destination_log : String?
    var unit : String?
    var currency : String?
    var track_latitude : Double?
    var track_longitude : Double?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var is_scheduled : String?
    var request_type : String?
    var peak_hour_id : String?
    var user_rated : Int?
    var provider_rated : Int?
    var use_wallet : Int?
    var surge : Int?
    var route_key : String?
    var created_at : String?
    var static_map : String?
    var assigned_time : String?
    var schedule_time : String?
    var started_time : String?
    var finished_time : String?
    var provider : Provider?
    var payment : PaymentData?
    var ride : Ride?
    var dispute : Dispute?
    var lost_item : Lost_item?
    var service_type : Service_type?
    var provider_vehicle: Provider_vehicle?
    var user : TansportUser?
    var service : ServiceDetail?
    var rating : Rating?
    var created_time : String?
    var calculator : String?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        vehicle_type <- map["vehicle_type"]
        booking_id <- map["booking_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        provider_service_id <- map["provider_service_id"]
        ride_delivery_id <- map["ride_delivery_id"]
        city_id <- map["city_id"]
        country_id <- map["country_id"]
        promocode_id <- map["promocode_id"]
        company_id <- map["company_id"]
        status <- map["status"]
        cancelled_by <- map["cancelled_by"]
        cancel_reason <- map["cancel_reason"]
        payment_mode <- map["payment_mode"]
        paid <- map["paid"]
        is_track <- map["is_track"]
        distance <- map["distance"]
        timezone <- map["timezone"]
        travel_time <- map["travel_time"]
        s_address <- map["s_address"]
        s_latitude <- map["s_latitude"]
        s_longitude <- map["s_longitude"]
        d_address <- map["d_address"]
        d_latitude <- map["d_latitude"]
        d_longitude <- map["d_longitude"]
        track_distance <- map["track_distance"]
        destination_log <- map["destination_log"]
        unit <- map["unit"]
        currency <- map["currency"]
        track_latitude <- map["track_latitude"]
        track_longitude <- map["track_longitude"]
        otp <- map["otp"]
        assigned_at <- map["assigned_at"]
        schedule_at <- map["schedule_at"]
        started_at <- map["started_at"]
        finished_at <- map["finished_at"]
        is_scheduled <- map["is_scheduled"]
        request_type <- map["request_type"]
        peak_hour_id <- map["peak_hour_id"]
        user_rated <- map["user_rated"]
        provider_rated <- map["provider_rated"]
        use_wallet <- map["use_wallet"]
        surge <- map["surge"]
        route_key <- map["route_key"]
        created_at <- map["created_at"]
        static_map <- map["static_map"]
        assigned_time <- map["assigned_time"]
        schedule_time <- map["schedule_time"]
        started_time <- map["started_time"]
        finished_time <- map["finished_time"]
        provider <- map["provider"]
        payment <- map["payment"]
        ride <- map["ride"]
        dispute <- map["dispute"]
        lost_item <- map["lost_item"]
        service_type <- map["service_type"]
        provider_vehicle <- map["provider_vehicle"]
        user <- map["user"]
        service <- map["service"]
        rating <- map["rating"]
        created_time <- map["created_time"]
        calculator <- map["calculator"]
    }
    
}

struct TansportUser : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var rating : Double?
    var picture : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        rating <- map["rating"]
        picture <- map["picture"]
    }
    
}


struct Dispute : Mappable {
    var id : Int?
    var company_id : Int?
    var ride_request_id : Int?
    var dispute_type : String?
    var user_id : Int?
    var provider_id : Int?
    var dispute_name : String?
    var dispute_title : String?
    var comments : String?
    var refund_amount : Int?
    var comments_by : String?
    var status : String?
    var is_admin : Int?
    var created_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        ride_request_id <- map["ride_request_id"]
        dispute_type <- map["dispute_type"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        dispute_name <- map["dispute_name"]
        dispute_title <- map["dispute_title"]
        comments <- map["comments"]
        refund_amount <- map["refund_amount"]
        comments_by <- map["comments_by"]
        status <- map["status"]
        is_admin <- map["is_admin"]
        created_at <- map["created_at"]
    }
    
}


struct Lost_item : Mappable {
    var id : Int?
    var ride_request_id : Int?
    var user_id : Int?
    var lost_item_name : String?
    var comments : String?
    var comments_by : String?
    var status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        ride_request_id <- map["ride_request_id"]
        user_id <- map["user_id"]
        lost_item_name <- map["lost_item_name"]
        comments <- map["comments"]
        comments_by <- map["comments_by"]
        status <- map["status"]
    }
    
}


struct Service_type : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : Int?
    var ride_delivery_id : Int?
    var delivery_vehicle_id : Int?
    var service_id : String?
    var company_id : Int?
    var base_fare : String?
    var per_miles : String?
    var per_mins : String?
    var status : String?
    var vehicle : Vehicle?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        ride_delivery_id <- map["ride_delivery_id"]
        delivery_vehicle_id <- map["delivery_vehicle_id"]
        service_id <- map["service_id"]
        company_id <- map["company_id"]
        base_fare <- map["base_fare"]
        per_miles <- map["per_miles"]
        per_mins <- map["per_mins"]
        status <- map["status"]
        vehicle <- map["vehicle"]
    }
    
}
struct Vehicle : Mappable {
    var id : Int?
    var provider_id : Int?
    var vehicle_service_id : Int?
    var vehicle_year : Int?
    var vehicle_color : String?
    var vehicle_make : String?
    var company_id : Int?
    var vehicle_model : String?
    var vehicle_no : String?
    var picture : String?
    var picture1 : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        vehicle_service_id <- map["vehicle_service_id"]
        vehicle_year <- map["vehicle_year"]
        vehicle_color <- map["vehicle_color"]
        vehicle_make <- map["vehicle_make"]
        company_id <- map["company_id"]
        vehicle_model <- map["vehicle_model"]
        vehicle_no <- map["vehicle_no"]
        picture <- map["picture"]
        picture1 <- map["picture1"]
    }
    
}
struct Provider : Mappable {
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
    var wallet_balance : Int?
    var rating : Double?
    var status : String?
    var admin_id : String?
    var payment_gateway_id : String?
    var otp : String?
    var language : String?
    var picture : String?
    var referral_unique_id : String?
    var qrcode_url : String?
    var country_id : Int?
    var currency_symbol : String?
    var city_id : Int?
    var currency : String?
    var activation_status : Int?
    var company_id : Int?
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
        currency_symbol <- map["currency_symbol"]
        city_id <- map["city_id"]
        currency <- map["currency"]
        activation_status <- map["activation_status"]
        company_id <- map["company_id"]
        state_id <- map["state_id"]
    }
    
}
struct Ride : Mappable {
    var id : Int?
    var company_id : Int?
    var ride_type_id : Int?
    var vehicle_type : String?
    var vehicle_name : String?
    var vehicle_image : String?
    var vehicle_marker : String?
    var capacity : Int?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        ride_type_id <- map["ride_type_id"]
        vehicle_type <- map["vehicle_type"]
        vehicle_name <- map["vehicle_name"]
        vehicle_image <- map["vehicle_image"]
        vehicle_marker <- map["vehicle_marker"]
        capacity <- map["capacity"]
        status <- map["status"]
    }
}

struct Rating : Mappable {
    var id : Int?
    var request_id : Int?
    var user_comment : String?
    var provider_comment : String?
    var user_rating:Double?
    var provider_rating:Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        request_id <- map["request_id"]
        user_comment <- map["user_comment"]
        provider_comment <- map["provider_comment"]
        user_rating <- map["user_rating"]
        provider_rating <- map["provider_rating"]
    }
    
}



struct Order : Mappable {
    var id : Int?
    var store_order_invoice_id : String?
    var user_id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var company_id : Int?
    var pickup_address : String?
    var delivery_address : String?
    var created_at : String?
    var status : String?
    var rating : Rating?
    var static_map : String?
    var dispute : Dispute?
    var delivery : Delivery?
    var pickup : Pickup?
    var order_invoice : Order_invoice?
    var user : User?
    var created_time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_order_invoice_id <- map["store_order_invoice_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        company_id <- map["company_id"]
        pickup_address <- map["pickup_address"]
        delivery_address <- map["delivery_address"]
        created_at <- map["created_at"]
        status <- map["status"]
        rating <- map["rating"]
        static_map <- map["static_map"]
        dispute <- map["dispute"]
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        order_invoice <- map["order_invoice"]
        user <- map["user"]
        created_time <- map["created_time"]
    }
    
}

