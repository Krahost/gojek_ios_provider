//
//  ServiceEntity.swift
//  GoJekProvider
//
//  Created by CSS on 27/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetServiceEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : ServiceResponseData?
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


struct ServiceResponseData : Mappable {
    var transport : [Transport]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        transport <- map["transport"]
    }
    
}

struct Transport : Mappable {
    var id : Int?
    var vehicle_name : String?
    var estimated_time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        vehicle_name <- map["vehicle_name"]
        estimated_time <- map["estimated_time"]
    }
    
}
