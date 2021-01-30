//
//  XMapEntity.swift
//  GoJekProvider
//
//  Created by apple on 10/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

struct Place: Mappable {
    
    var results: [Address]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        results <- map["results"]
    }
}

struct Address: Mappable {
    
    var address_components: [AddressComponent]?
    var formatted_address: String?
    var geometry: Geometry?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        address_components <- map["address_components"]
        formatted_address <- map["formatted_address"]
        geometry <- map["geometry"]
    }
}





struct AddressComponent: Mappable {
    
    var long_name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        long_name <- map["long_name"]
    }
}

struct Geometry: Mappable {
    
    var location: Location?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        location <- map["location"]
    }
}

struct Location: Mappable {
    
    var lat: Double?
    var lng: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}

struct MapPath: Mappable {
    
    var routes: [Route]?
    var errorMsg: String?
    var status: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        routes <- map["routes"]
        errorMsg <- map["error_message"]
        status <- map["status"]
    }
}

struct Route: Mappable {
    
    var overview_polyline: OverView?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        overview_polyline <- map["overview_polyline"]
    }
}

struct OverView: Mappable {
    
    var points: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        points <- map["points"]
    }
}
