//
//  TaxiEntity.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

struct TaxiEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : TaxiCheckRequestData?
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

struct TaxiCheckRequestData: Mappable {
    
    var sos : String?
    var accountStatus : String?
    var providerDetails : ProviderDetail?
    var reasons : [Reason]?
    var waitingStatus : Bool?
    var waitingTime : Int?
    var referralAmount : String?
    var referralCount : String?
    var referralTotalAmount : Int?
    var referralTotalCount : String?
    var request : Request?
    var rideOtp : String?
    var ride_otp : String?
    var serviceStatus : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sos <- map["sos"]
        accountStatus <- map["account_status"]
        providerDetails <- map["provider_details"]
        reasons <- map["reasons"]
        waitingStatus <- map["waitingStatus"]
        waitingTime <- map["waitingTime"]
        referralAmount <- map["referral_amount"]
        referralCount <- map["referral_count"]
        referralTotalAmount <- map["referral_total_amount"]
        referralTotalCount <- map["referral_total_count"]
        request <- map["request"]
        rideOtp <- map["ride_otp"]
        ride_otp <- map["ride_otp"]
        serviceStatus <- map["service_status"]
    }
}

struct WaitTimeEntity: Mappable {
    
    var waitingTime: Int?
    var waitingStatus: Bool?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        waitingTime <- map["waitingTime"]
        waitingStatus <- map["waitingStatus"]
    }
}



// request invoice calculation

enum invoiceCalculator: String {
    case distance = "DISTANCE"
    case min = "MIN"
    case hour = "HOUR"
    case distancemin = "DISTANCEMIN"
    case distancehour = "DISTANCEHOUR"
}
