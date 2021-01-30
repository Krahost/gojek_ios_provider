//
//  GetCategoryEntity.swift
//  GoJekProvider
//
//  Created by CSS on 06/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetCategoryEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [CategoryData]?
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

struct Providerservicecategory : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : Int?
    var ride_delivery_id : String?
    var service_id : String?
    var category_id : Int?
    var sub_category_id : String?
    var company_id : Int?
    var base_fare : String?
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

struct CategoryData : Mappable {
    var id : Int?
    var company_id : Int?
    var service_category_name : String?
    var picture : String?
    var price_choose : String?
    var service_category_order : Int?
    var service_category_status : Int?
    var providerservicecategory : [Providerservicecategory]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        service_category_name <- map["service_category_name"]
        picture <- map["picture"]
        price_choose <- map["price_choose"]
        service_category_order <- map["service_category_order"]
        service_category_status <- map["service_category_status"]
        providerservicecategory <- map["providerservicecategory"]
    }
    
}

