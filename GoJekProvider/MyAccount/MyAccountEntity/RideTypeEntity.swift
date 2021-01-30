//
//  RideTypeEntity.swift
//  GoJekProvider
//
//  Created by CSS on 05/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetRideTypeEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [RideTypeData]?
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

struct RideTypeData : Mappable {
    var id : Int?
    var ride_name : String?
    var status : Int?
    var providerservice : TransportProviderservice?
    var servicelist : [Servicelist]?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        ride_name <- map["ride_name"]
        status <- map["status"]
        providerservice <- map["providerservice"]
        servicelist <- map["servicelist"]
    }
    
}
struct TransportProviderservice : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : Int?
    var ride_delivery_id : Int?
    var delivery_vehicle_id : Int?
    var service_id : String?
    var category_id : Int?
    var sub_category_id : String?
    var company_id : Int?
    var base_fare : String?
    var per_miles : String?
    var per_mins : String?
    var status : String?
    var providervehicle : TransportProvidervehicle?
    
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
        providervehicle <- map["providervehicle"]
        delivery_vehicle_id <- map["delivery_vehicle_id"]
    }
    
}
struct CourierProviderservice : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : Int?
    var ride_delivery_id : Int?
    var service_id : String?
    var category_id : Int?
    var sub_category_id : String?
    var company_id : Int?
    var base_fare : String?
    var per_miles : String?
    var per_mins : String?
    var status : String?
    var providervehicle : TransportProvidervehicle?
    
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
        providervehicle <- map["providervehicle"]
    }
    
}
struct TransportProvidervehicle : Mappable {
    
    
    var id : Int?
    var provider_id : Int?
    var vehicle_service_id : Int?
    var vehicle_year : Int?
    var vehicle_color : String?
    var vehicle_make : String?
    var company_id : Int?
    var vehicle_model : String?
    var vehicle_no : String?
    var vechile_image : String?
    var picture : String?
    var picture1 : String?
    var child_seat : Int?
    var wheel_chair : Int?

    
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
        vechile_image <- map["vechile_image"]
        picture <- map["picture"]
        picture1 <- map["picture1"]
        child_seat <- map["child_seat"]
        wheel_chair <- map["wheel_chair"]
    }
    
}
struct Servicelist : Mappable {
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
