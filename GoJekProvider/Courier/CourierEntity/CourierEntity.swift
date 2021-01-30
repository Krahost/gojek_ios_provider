//
//  CourierEntity.swift
//  GoJekProvider
//
//  Created by Chan Basha on 04/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper


struct CourierEntity: Mappable {
    
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : CourierCheckRequestData?
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

struct CourierCheckRequestData: Mappable {
    
    var sos : String?
    var emergency : [Emergency]?
    var accountStatus : String?
    var service_status : String?
    var providerDetails : ProviderDetail?
    var reasons : [Reason]?
    var waitingStatus : Bool?
    var waitingTime : Int?
    var referralAmount : String?
    var referralCount : String?
    var referralTotalAmount : Int?
    var referralTotalCount : String?
    var request : CourierRequest?
   
    var rideOtp : String?
    var serviceStatus : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sos <- map["sos"]
        emergency <- map["emergency"]
        accountStatus <- map["account_status"]
        service_status <- map["service_status"]
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
        serviceStatus <- map["service_status"]
    }
}


struct DeliveryEntity : Mappable {
  
    
    var id : Int?
    var deliveryRequestId : Int?
    var userId : Int?
    var providerId:Int?
    var geofenceId : Int?
    var packageTypeId : Int?
    var status : String?
    var adminService : String?
    var paid : Int?
    var providerRated : Int?
    var distance : Float?
    var weight : Int?
    var length : Int?
    var breadth : Int?
    var height : Int?
    var name : String?
    var mobile : String?
    var paymentMode  : String?
    var payment_by : String?
    var instruction : String?
    var sAddress : String?
    var sLatitude : Double?
    var sLongitude : Double?
    var dAddress : String?
    var dLatitude : Double?
    var dLongitude : Double?
    var trackDistance : Int?
    var unit : String?
    var isFragile : Int?
    var currency : String?
    var picture : String?
    var track_latitude : Double?
    var track_longitude : Double?
    var otp : String?
    var assigned_at : String?
    var schedule_at : String?
    var started_at : String?
    var finished_at : String?
    var surge : Int?
    var admin_id : Int?
    var payment : Payment?
    var package_type : PackageType?

    
       init?(map: Map) {
          
      }
      
      mutating func mapping(map: Map) {
        
         id <- map["id"]
         deliveryRequestId <- map["delivery_request_id"]
         userId <- map["user_id"]
         providerId <- map["provider_id"]
         geofenceId <- map["geofence_id"]
         packageTypeId <- map["package_type_id"]
         status <- map["status"]
         adminService <- map["admin_service"]
         paid <- map["paid"]
         providerRated <- map["provider_rated"]
         distance <- map["distance"]
         length <- map["length"]
         breadth <- map["breadth"]
         height <- map["height"]
         package_type <- map["package_type"]

        
         weight <- map["weight"]
         name <- map["name"]
         mobile <- map["mobile"]
         paymentMode <- map["payment_mode"]
         instruction <- map["instruction"]
         sAddress <- map["s_address"]
         sLatitude <- map["s_latitude"]
         sLongitude <- map["s_longitude"]
         dAddress <- map["d_address"]
         dLatitude <- map["d_latitude"]
         dLongitude <- map["d_longitude"]
        
        
         trackDistance <- map["track_distance"]
         unit <- map["unit"]
         isFragile <- map["is_fragile"]
         currency <- map["currency"]
         track_latitude <- map["track_latitude"]
         track_longitude <- map["track_longitude"]
         otp <- map["otp"]
         assigned_at <- map["assigned_at"]
         schedule_at <- map["schedule_at"]
         started_at <- map["started_at"]
         finished_at <- map["finished_at"]
         payment <- map["payment"]
         payment_by <- map["payment_by"]
      }
      

}



//MARK: - Request

struct CourierRequest: Mappable {
    
    var id: Int?
    var requestId: Int?
    var userId: Int?
    var providerId: Int?
    var adminServiceId: Int?
    var companyId: Int?
    var status: String?
    var createdAt: String?
    var timeLeftToRespond: Int?
    var service: Service?
    var assignedAt: String?
    var assignedTime: String?
    var bookingId: String?
    var cityId: Int?
    var currency: String?
    var dAddress: String?
    var dLatitude: Double?
    var dLongitude: Double?
    var destinationLog: String?
    var distance: Double?
    var travelTime: Int?
    var finishedTime: String?
    var paid: Int?
    var isTrack: String?
    var otp: String?
    var paymentMode: String?
    var payment_by: String?
    var promocodeId: Int?
    var providerServiceId: String?
    var rideDeliveryId: String?
    var routeKey: String?
    var sAddress: String?
    var sLatitude: Double?
    var sLongitude: Double?
    var scheduleTime: String?
    var startedTime: String?
    var timezone: AnyObject?
    var trackDistance: Int?
    var trackLatitude: String?
    var trackLongitude: String?
    var unit: String?
    var useWallet: Int?
    var providerRated: Int?
    var user: User?
    var payment: Payment?
    var pickup: OrderPickup?
    var rideType: RideType?
    var rideDetail: RideDetail?
    var created_type: String?
    var weight : Int?
    var delivery : DeliveryEntity?
    var total_amount : Double?
    var payable_amount : Double?
    var fixed_amount : Double?
    var weight_amount : Double?
    var distance_amount : Double?
    var tax_amount : Double?
    var discount_amount : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        requestId <- map["request_id"]
        userId <- map["user_id"]
        providerId <- map["provider_id"]
        adminServiceId <- map["admin_service"]
        companyId <- map["company_id"]
        status <- map["status"]
        createdAt <- map["created_at"]
        timeLeftToRespond <- map["time_left_to_respond"]
        service <- map["service"]
        assignedAt <- map["assigned_at"]
        assignedTime <- map["assigned_time"]
        bookingId <- map["booking_id"]
        cityId <- map["city_id"]
        currency <- map["currency"]
        dAddress <- map["d_address"]
        dLatitude <- map["d_latitude"]
        dLongitude <- map["d_longitude"]
        destinationLog <- map["destination_log"]
        distance <- map["distance"]
        travelTime <- map["travel_Time"]
        finishedTime <- map["finished_time"]
        paid <- map["paid"]
        isTrack <- map["is_track"]
        otp <- map["otp"]
        paymentMode <- map["payment_mode"]
        promocodeId <- map["promocode_id"]
        providerServiceId <- map["provider_service_id"]
        rideDeliveryId <- map["ride_delivery_id"]
        routeKey <- map["route_key"]
        sAddress <- map["s_address"]
        sLatitude <- map["s_latitude"]
        sLongitude <- map["s_longitude"]
        scheduleTime <- map["schedule_time"]
        startedTime <- map["started_time"]
        timezone <- map["timezone"]
        trackDistance <- map["track_distance"]
        trackLatitude <- map["track_latitude"]
        trackLongitude <- map["track_longitude"]
        unit <- map["unit"]
        useWallet <- map["use_wallet"]
        providerRated <- map["provider_rated"]
        user <- map["user"]
        payment <- map["payment"]
        delivery <- map["delivery"]
        pickup <- map["pickup"]
        rideType <- map["ride_type"]
        rideDetail <- map["ride"]
        created_type <- map["created_type"]
        weight <- map["weight"]
        delivery <- map["delivery"]
        total_amount <- map["total_amount"]
        payable_amount <- map["payable_amount"]
        fixed_amount <- map["fixed_amount"]
        weight_amount <- map["weight_amount"]
        distance_amount <- map["distance_amount"]
        tax_amount <- map["tax_amount"]
        discount_amount <- map["discount_amount"]
        payment_by <- map["payment_by"]
    }
}

struct Emergency : Mappable {
    var number : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        number <- map["number"]
    }

}

struct PackageType : Mappable {
    var id : Int?
    var package_name : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        status <- map["status"]
        package_name <- map["package_name"]
    }

}
