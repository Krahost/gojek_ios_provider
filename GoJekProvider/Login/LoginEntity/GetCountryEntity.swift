//
//  GetCountryEntity.swift
//  GoJekProvider
//
//  Created by CSS on 24/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper


//get country Entity
struct CountryEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var countryData : [CountryData]?
    var error : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        statusCode <- map["statusCode"]
        title <- map["title"]
        message <- map["message"]
        countryData <- map["responseData"]
        error <- map["error"]
    }
    
}

struct CountryData : Mappable {
    var id : Int?
    var country_name : String?
    var country_code : String?
    var country_phonecode : String?
    var country_currency : String?
    var country_symbol : String?
    var status : String?
    var timezone : String?
    var city : [CityData]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        country_name <- map["country_name"]
        country_code <- map["country_code"]
        country_phonecode <- map["country_phonecode"]
        country_currency <- map["country_currency"]
        country_symbol <- map["country_symbol"]
        status <- map["status"]
        timezone <- map["timezone"]
        city <- map["city"]
    }
    
}

struct CityData : Mappable {
    var id : Int?
    var country_id : Int?
    var state_id : Int?
    var city_name : String?
    var status : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        country_id <- map["country_id"]
        state_id <- map["state_id"]
        city_name <- map["city_name"]
        status <- map["status"]
    }
    
}

