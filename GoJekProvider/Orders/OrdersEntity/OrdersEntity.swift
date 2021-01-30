//
//  OrdersEntity.swift
//  GoJekUser
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

struct OrdersEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : HistoryResponseData?
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

struct HistoryResponseData : Mappable {
    var type : String?
    var total_records : Int?
    var transport : TransporterData?
    var service : TransporterData?
    var foodie: OrderData?
    var delivery : Courier?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        
        type <- map["type"]
        total_records <- map["total_records"]
        transport <- map["transport"]
        service <- map["service"]
        foodie <- map["order"]
        delivery <- map["delivery"]
        
    }

}

struct Courier : Mappable {
    var current_page : Int?
    var data : [CourierData]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
    var total : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        current_page <- map["current_page"]
        data <- map["data"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        last_page_url <- map["last_page_url"]
        next_page_url <- map["next_page_url"]
        path <- map["path"]
        per_page <- map["per_page"]
        prev_page_url <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total"]
    }

}

struct CourierProvider : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var rating : Double?
    var picture : String?
    var currency_symbol : String?
    var current_ride_vehicle : String?
    var current_store : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        rating <- map["rating"]
        picture <- map["picture"]
        currency_symbol <- map["currency_symbol"]
        current_ride_vehicle <- map["current_ride_vehicle"]
        current_store <- map["current_store"]
    }

}

struct CourierUser : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var rating : Double?
    var picture : String?
    var currency_symbol : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        rating <- map["rating"]
        picture <- map["picture"]
        currency_symbol <- map["currency_symbol"]
    }

}

struct CourierService : Mappable {
    var id : Int?
    var vehicle_name : String?
    var vehicle_image : String?
    var delivery_types_id : Int?
    var vehicle_type : String?
    var vehicle_marker : String?
    var capacity : Int?
    var status : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        vehicle_name <- map["vehicle_name"]
        vehicle_image <- map["vehicle_image"]
        vehicle_marker <- map["vehicle_marker"]
        capacity <- map["capacity"]
        status <- map["status"]
        delivery_types_id <- map["delivery_types_id"]
        vehicle_type <- map["vehicle_type"]
    }

}

struct CourierData : Mappable {
    var id : Int?
    var booking_id : String?
    var assigned_at : String?
    var s_address : String?
    var d_address : String?
    var provider_id : Int?
    var user_id : Int?
    var timezone : String?
    var delivery_vehicle_id : Int?
    var status : String?
    var provider_vehicle_id : String?
    var started_at : String?
    var static_map : String?
    var user : CourierUser?
    var provider : CourierProvider?
    var provider_vehicle : String?
    var payment : String?
    var service : CourierService?
    var service_type : Service_type?
    var assigned_time : String?
    var deliveries : [Deliveries]?

    var rating : Rating?


    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        booking_id <- map["booking_id"]
        assigned_at <- map["assigned_at"]
        s_address <- map["s_address"]
        d_address <- map["d_address"]
        provider_id <- map["provider_id"]
        user_id <- map["user_id"]
        timezone <- map["timezone"]
        delivery_vehicle_id <- map["delivery_vehicle_id"]
        status <- map["status"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        started_at <- map["started_at"]
        static_map <- map["static_map"]
        user <- map["user"]
        provider <- map["provider"]
        provider_vehicle <- map["provider_vehicle"]
        payment <- map["payment"]
        service <- map["service"]
        service_type <- map["service_type"]
        assigned_time <- map["assigned_time"]
        rating <- map["rating"]
        deliveries <- map["deliveries"]

    }

}


struct TransporterData : Mappable {
    var current_page : Int?
    var data : [TransportData]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
    var total : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        current_page <- map["current_page"]
        data <- map["data"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        last_page_url <- map["last_page_url"]
        next_page_url <- map["next_page_url"]
        path <- map["path"]
        per_page <- map["per_page"]
        prev_page_url <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total"]
    }

}

struct OrderData : Mappable {
    var current_page : Int?
    var data : [FoodieHistoryData]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
    var total : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        current_page <- map["current_page"]
        data <- map["data"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        last_page_url <- map["last_page_url"]
        next_page_url <- map["next_page_url"]
        path <- map["path"]
        per_page <- map["per_page"]
        prev_page_url <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total"]
    }

}




struct TransportData : Mappable {
    var id : Int?
    var booking_id : String?
    var store_order_invoice_id: String?
    var assigned_at : String?
    var s_address : String?
    var d_address : String?
    var provider_id : Int?
    var user_id : Int?
    var timezone : String?
    var ride_delivery_id : Int?
    var status : String?
    var provider_vehicle_id : String?
    var static_map : String?
    var assigned_time : String?
    var schedule_time : String?
    var started_time : String?
    var finished_time : String?
    var provider : Provider?
    var provider_vehicle : Provider_vehicle?
    var payment : PaymentData?
    var ride : RideDetail?
    var rideType : RideType?
    var service : ServiceDetail?
    var user : TansportUser?
    var rating: OrderRating?
    var dispute_count: Int?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        booking_id <- map["booking_id"]
        store_order_invoice_id <- map["store_order_invoice_id"]
        assigned_at <- map["assigned_at"]
        s_address <- map["s_address"]
        d_address <- map["d_address"]
        provider_id <- map["provider_id"]
        user_id <- map["user_id"]
        timezone <- map["timezone"]
        ride_delivery_id <- map["ride_delivery_id"]
        status <- map["status"]
        provider_vehicle_id <- map["provider_vehicle_id"]
        static_map <- map["static_map"]
        assigned_time <- map["assigned_time"]
        schedule_time <- map["schedule_time"]
        started_time <- map["started_time"]
        finished_time <- map["finished_time"]
        user <- map["user"]
        provider <- map["provider"]
        provider_vehicle <- map["provider_vehicle"]
        payment <- map["payment"]
        ride <- map["ride"]
        service <- map["service"]
        user <- map["user"]
        rating <- map["rating"]
        dispute_count <- map["dispute_count"]
    }
}

struct ServiceDetail : Mappable {
    
    var id : Int?
    var service_category_id : String?
    var service_name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        service_category_id <- map["service_category_id"]
        service_name <- map["service_name"]
    }
}

struct Provider_vehicle : Mappable {
    var provider_id : Int?
    var vehicle_make : String?
    var vehicle_model : String?
    var vehicle_no : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        provider_id <- map["provider_id"]
        vehicle_make <- map["vehicle_make"]
        vehicle_model <- map["vehicle_model"]
        vehicle_no <- map["vehicle_no"]
    }
    
}
struct PaymentData : Mappable {
    var id : Int?
    var ride_request_id : Int?
    var user_id : Int?
    var provider_id : Int?
    var fleet_id : String?
    var promocode_id : String?
    var payment_id : String?
    var company_id : Int?
    var payment_mode : String?
    var fixed : Double?
    var distance : Double?
    var minute : Double?
    var hour : Double?
    var commision : Double?
    var commision_percent : Double?
    var fleet : Int?
    var fleet_percent : Int?
    var discount : Double?
    var discount_percent : Double?
    var tax : Double?
    var tax_percent : Int?
    var wallet : Double?
    var is_partial : String?
    var cash : Double?
    var card : Double?
    var surge : Int?
    var peak_amount : Double?
    var peak_comm_amount : String?
    var total_waiting_time : Int?
    var waiting_amount : Double?
    var waiting_comm_amount : String?
    var tips : Double?
    var toll_charge : Double?
    var round_of : Double?
    var total : Double?
    var payable : Double?
    var provider_pay : Double?
    var extra_charges: Double?
    var base_fare_text: String?
    var distance_fare_text: String?
    var time_fare_text: String?
    var waiting_fare_text: String?
    var discount_fare_text: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        ride_request_id <- map["ride_request_id"]
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
        peak_amount <- map["peak_amount"]
        peak_comm_amount <- map["peak_comm_amount"]
        total_waiting_time <- map["total_waiting_time"]
        waiting_amount <- map["waiting_amount"]
        waiting_comm_amount <- map["waiting_comm_amount"]
        tips <- map["tips"]
        toll_charge <- map["toll_charge"]
        round_of <- map["round_of"]
        total <- map["total"]
        payable <- map["payable"]
        provider_pay <- map["provider_pay"]
        extra_charges <- map["extra_charges"]
        base_fare_text <- map["base_fare_text"]
              distance_fare_text <- map["distance_fare_text"]
              time_fare_text <- map["time_fare_text"]
    }
    
}

struct FoodieHistoryData : Mappable {
    var id : Int?
    var store_order_invoice_id : String?
    var store_id : Int?
    var user_id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var company_id : Int?
    var pickup_address : String?
    var delivery_address : String?
    var created_at : String?
    var assigned_time : String?
    var status : String?
    var total : String?
    var static_map : String?
    var delivery : Delivery?
    var pickup : Pickup?
    var user : HistoryFoodieUser?
    var rating: Rating?
    var created_time : String?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        store_order_invoice_id <- map["store_order_invoice_id"]
        store_id <- map["store_id"]
        user_id <- map["user_id"]
        provider_id <- map["provider_id"]
        admin_service_id <- map["admin_service"]
        company_id <- map["company_id"]
        pickup_address <- map["pickup_address"]
        delivery_address <- map["delivery_address"]
        created_at <- map["created_at"]
        status <- map["status"]
        total <- map["total"]
        static_map <- map["static_map"]
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        user <- map["user"]
        rating <- map["rating"]
        created_time <- map["created_time"]

    }
    
}
struct HistoryFoodieUser : Mappable {
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

struct OrderRating : Mappable {
    var request_id : Int?
    var user_rating : Int?
    var provider_rating : Int?
    var user_comment : String?
    var provider_comment: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        request_id <- map["request_id"]
        user_rating <- map["user_rating"]
        provider_rating <- map["provider_rating"]
        user_comment <- map["user_comment"]
        provider_comment <- map["provider_comment"]
    }
}
