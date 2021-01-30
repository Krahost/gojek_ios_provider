//
//  AdminServiceEntity.swift
//  GoJekProvider
//
//  Created by CSS on 05/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetAdminServiceEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : [AdminServiceData]?
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

struct AdminServiceData : Mappable {
    var id : Int?
    var admin_service: String?
    var display_name : String?
    var base_url : String?
    var status : Int?
    var company_id : Int?
    var documents: [DocumentData]?
    var providerservices : Providerservices?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        admin_service <- map["admin_service"]
        display_name <- map["display_name"]
        base_url <- map["base_url"]
        status <- map["status"]
        company_id <- map["company_id"]
        documents <- map["documents"]
        providerservices <- map["providerservices"]
    }
}

struct Providerservices : Mappable {
    var id : Int?
    var provider_id : Int?
    var admin_service_id : Int?
    var provider_vehicle_id : Int?
    var ride_delivery_id : Int?
    var service_id : String?
    var category_id : String?
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

struct DocumentData : Mappable {
    var id : Int?
    var company_id : Int?
    var service : String?
    var name : String?
    var type : String?
    var file_type : String?
    var is_backside : String?
    var is_expire : Int?
    var status : Int?
    var provider_document : Provider_document?
    var service_category : service_category?
    var servicesub_category : servicesub_category?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        company_id <- map["company_id"]
        service <- map["service"]
        name <- map["name"]
        type <- map["type"]
        file_type <- map["file_type"]
        is_backside <- map["is_backside"]
        is_expire <- map["is_expire"]
        status <- map["status"]
        provider_document <- map["provider_document"]
        service_category <- map["service_category"]
        servicesub_category <- map["servicesub_category"]
    }
}

struct service_category : Mappable {
     var id : Int?
     var service_category_name : String?
     var alias_name : String?
     var service_category_order : String?
     var service_category_status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_category_name <- map["service_category_name"]
        alias_name <- map["alias_name"]
        service_category_order <- map["service_category_order"]
        service_category_status <- map["service_category_status"]
    }
}


struct servicesub_category : Mappable {
     var id : Int?
     var service_subcategory_name : String?
     var alias_name : String?
     var service_subcategory_order : String?
     var service_subcategory_status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_subcategory_name <- map["service_subcategory_name"]
        alias_name <- map["alias_name"]
        service_subcategory_order <- map["service_subcategory_order"]
        service_subcategory_status <- map["service_subcategory_status"]
    }
}




struct Provider_document : Mappable {
    var id : Int?
    var provider_id : Int?
    var document_id : Int?
    var company_id : Int?
    var url : [Url]?
    var unique_id : String?
    var status : String?
    var expires_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        document_id <- map["document_id"]
        company_id <- map["company_id"]
        url <- map["url"]
        unique_id <- map["unique_id"]
        status <- map["status"]
        expires_at <- map["expires_at"]
    }
}

struct Url : Mappable {
    var url : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        url <- map["url"]
    }
}


