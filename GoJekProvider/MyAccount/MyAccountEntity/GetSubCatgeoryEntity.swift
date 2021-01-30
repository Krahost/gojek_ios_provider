//
//  GetSubCatgeoryEntity.swift
//  GoJekProvider
//
//  Created by CSS on 06/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetSubCategoryEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [SubCategoryData]?
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


struct SubCategoryData : Mappable {
    var id : Int?
    var service_category_id : Int?
    var company_id : Int?
    var service_subcategory_name : String?
    var picture : String?
    var service_subcategory_order : Int?
    var service_subcategory_status : Int?
    var providerservicesubcategory : [Providerservicesubcategory]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_category_id <- map["service_category_id"]
        company_id <- map["company_id"]
        service_subcategory_name <- map["service_subcategory_name"]
        picture <- map["picture"]
        service_subcategory_order <- map["service_subcategory_order"]
        service_subcategory_status <- map["service_subcategory_status"]
        providerservicesubcategory <- map["providerservicesubcategory"]
    }
    
}
struct Providerservicesubcategory : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : String?
    var ride_delivery_id : String?
    var service_id : String?
    var category_id : Int?
    var sub_category_id : Int?
    var company_id : Int?
    var base_fare : Int?
    var per_miles : Int?
    var per_mins : Int?
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
