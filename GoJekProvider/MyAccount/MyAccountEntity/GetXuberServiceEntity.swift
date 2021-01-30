//
//  GetXuberServiceEntity.swift
//  GoJekProvider
//
//  Created by CSS on 07/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetXuberServiceEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [XuberServiceData]?
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
struct XuberServiceData : Mappable {
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
    var providerservices : [Providerservicesubcategory]?
    var service_city : service_city?
    
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
        providerservices <- map["providerservices"]
        service_city <- map["service_city"]
    }
    
}
struct service_city : Mappable {
    var id : Int?
    var service_id : Int?
    var country_id : Int?
    var city_id : Int?
    var company_id : Int?
    var fare_type : String?
    var base_fare : Double?
    var base_distance : String?
    var per_miles : Double?
    var per_mins : Double?
    var minimum_fare : Double?
    var commission : Double?
    var fleet_commission : Double?
    var tax : Double?
    var cancellation_time : String?
    var cancellation_charge : Double?
    var waiting_time : String?
    var waiting_charges : Double?
    var allow_quantity : Int?
    var max_quantity : Int?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_id <- map["service_id"]
        country_id <- map["country_id"]
        city_id <- map["city_id"]
        company_id <- map["company_id"]
        fare_type <- map["fare_type"]
        base_fare <- map["base_fare"]
        base_distance <- map["base_distance"]
        per_miles <- map["per_miles"]
        per_mins <- map["per_mins"]
        minimum_fare <- map["minimum_fare"]
        commission <- map["commission"]
        fleet_commission <- map["fleet_commission"]
        tax <- map["tax"]
        cancellation_time <- map["cancellation_time"]
        cancellation_charge <- map["cancellation_charge"]
        waiting_time <- map["waiting_time"]
        waiting_charges <- map["waiting_charges"]
        allow_quantity <- map["allow_quantity"]
        max_quantity <- map["max_quantity"]
        status <- map["status"]
    }
    
}

