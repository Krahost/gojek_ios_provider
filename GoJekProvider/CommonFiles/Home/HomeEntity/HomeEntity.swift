//
//  HomeEntity.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

//MARK: - HomeEntity

struct HomeEntity: Mappable {
    
    var statusCode: String?
    var title: String?
    var message: String?
    var responseData: CheckResponseData?
    var error: [String]?
    
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

//MARK: - Check Responsee Data

struct CheckResponseData: Mappable {
 
    var accountStatus: String?
    var providerDetails: ProviderDetail?
    var reasons: [Reason]?
    var referralAmount: String?
    var referralCount: String?
    var referralTotalAmount: Int?
    var referralTotalCount: String?
    var requests: [RquestList]?
    var rideOtp: String?
    var serviceStatus: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        accountStatus <- map["account_status"]
        providerDetails <- map["provider_details"]
        reasons <- map["reasons"]
        referralAmount <- map["referral_amount"]
        referralCount <- map["referral_count"]
        referralTotalAmount <- map["referral_total_amount"]
        referralTotalCount <- map["referral_total_count"]
        requests <- map["requests"]
        rideOtp <- map["ride_otp"]
        serviceStatus <- map["service_status"]
    }
}

//MARK: - Rquest List

struct RquestList: Mappable {
    
    var id: Int?
    var requestId: Int?
    var userId: Int?
    var providerId: Int?
    var adminServiceId: String?
    var companyId: Int?
    var status: String?
    var createdAt: String?
    var timeLeftToRespond: Int?
    var request: Request?
    var service: AdminService?
    var user: User?
    var payment: Payment?
    var delivery :[DeliveryEntity]?
    var total_amount : Double?

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
        request <- map["request"]
        service <- map["service"]
        user <- map["user"]
        payment <- map["payment"]
        delivery <- map["delivery"]
        total_amount <- map["total_amount"]
    }
}

//MARK: - Request

struct Request: Mappable {
    
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
    var delivery: HomeDelivery?
    var pickup: OrderPickup?
    var rideType: RideType?
    var rideDetail: RideDetail?
    var created_type: String?
    var weight : Int?
    var admin_service : String?
    var deliveryArr : [DeliveryEntity]?
    var ride_otp : String?
    var someone_mobile : Int?
    var someone_email : String?
    var someone_name : String?
    var total_distance : Double?
    var calculator : String?

   
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
        admin_service <- map["admin_service"]
        deliveryArr <- map["delivery"]
        ride_otp <- map["ride_otp"]
        someone_mobile <- map["someone_mobile"]
        someone_name <- map["someone_name"]
        someone_email <- map["someone_email"]
        total_distance <- map["total_distance"]
        calculator <- map["calculator"]

    }
}

//MARK: - Reason

struct Reason: Mappable {
    
    var createdBy: Int?
    var createdType: String?
    var deletedBy: AnyObject?
    var deletedType: AnyObject?
    var id: Int?
    var modifiedBy: Int?
    var modifiedType: String?
    var reason: String?
    var service: String?
    var status: String?
    var type: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        createdBy <- map["created_by"]
        createdType <- map["created_type"]
        deletedBy <- map["deleted_by"]
        deletedType <- map["deleted_type"]
        id <- map["id"]
        modifiedBy <- map["modified_by"]
        modifiedType <- map["modified_type"]
        reason <- map["reason"]
        service <- map["service"]
        status <- map["status"]
        type <- map["type"]
    }
}

//MARK: - Service

struct Service: Mappable {
    
    var service_name: String?
    var allow_before_image: Int?
    var allow_after_image: Int?
    var is_professional: Int?
    var service_category: ServiceCategory?
    var ServiceSubCategory: ServiceSubCategory?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        service_name <- map["service_name"]
        allow_before_image <- map["allow_before_image"]
        allow_after_image <- map["allow_after_image"]
        is_professional <- map["is_professional"]
        service_category <- map["service_category"]
        ServiceSubCategory <- map["servicesub_category"]
    }
}

//MARK: - AdminService

struct AdminService: Mappable {
    
    var adminServiceId: Int?
    var baseFare: String?
    var categoryId: AnyObject?
    var companyId: Int?
    var id: Int?
    var perMiles: String?
    var perMins: String?
    var providerId: Int?
    var providerVehicleId: Int?
    var rideDeliveryId: Int?
    var serviceCity: AnyObject?
    var serviceId: AnyObject?
    var status: String?
    var subCategoryId: AnyObject?
    var adminServiceName: String?
    var baseUrl: String?
    var displayName: String?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        adminServiceId <- map["admin_service"]
        baseFare <- map["base_fare"]
        categoryId <- map["category_id"]
        companyId <- map["company_id"]
        id <- map["id"]
        perMiles <- map["per_miles"]
        perMins <- map["per_mins"]
        providerId <- map["provider_id"]
        providerVehicleId <- map["provider_vehicle_id"]
        rideDeliveryId <- map["ride_delivery_id"]
        serviceCity <- map["service_city"]
        serviceId <- map["admin_service"]
        status <- map["status"]
        subCategoryId <- map["sub_category_id"]
        adminServiceName <- map["admin_service"]
        baseUrl <- map["base_url"]
        displayName <- map["display_name"]
    }
}

//MARK: - ServiceCategory

struct ServiceCategory: Mappable {
    
    var id: Int?
    var service_category_name: String?
    var price_choose: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id  <- map["id"]
        service_category_name <- map["service_category_name"]
        price_choose <- map["price_choose"]
    }
}

//MARK: - ServiceSubCategory

struct ServiceSubCategory: Mappable {
    
    var id: Int?
    var service_subcategory_name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id  <- map["id"]
        service_subcategory_name <- map["service_subcategory_name"]
    }
}

//MARK: - RideType

struct RideType: Mappable {
    
    var id: Int?
    var ride_name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id  <- map["id"]
        ride_name <- map["ride_name"]
    }
}

//MARK: - RideDetail

struct RideDetail: Mappable {
    
    var id: Int?
    var vehicle_name: String?
    var vehicle_marker: String?
    var vehicle_image: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id  <- map["id"]
        vehicle_name <- map["vehicle_name"]
        vehicle_marker <- map["vehicle_marker"]
        vehicle_image <- map["vehicle_image"]
    }
}




//MARK: - Payment

struct Payment: Mappable {
    
    var card: Int?
    var cash: Int?
    var commision: Double?
    var commisionPercent: Int?
    var companyId: Int?
    var discount: Double?
    var discountPercent: Int?
    var distance: Double?
    var fixed: Double?
    var fleet: Int?
    var fleetId: String?
    var fleetPercent: Int?
    var hour: Double?
    var id: Int?
    var isPartial: Bool?
    var minute: Int?
    var payable: Double?
    var paymentId: Int?
    var paymentMode: String?
    var peakAmount: Double?
    var peakCommAmount: String?
    var promocodeId: String?
    var providerId: Int?
    var providerPay: Double?
    var rideRequestId: Int?
    var roundOf: Double?
    var surge: Int?
    var tax: Double?
    var taxPercent: Int?
    var tips: Double?
    var tollCharge: Double?
    var total: Double?
    var totalWaitingTime: Int?
    var userId: Int?
    var waitingAmount: Double?
    var waitingCommAmount: String?
    var wallet: Double?
    var deliveryId : Int?
    var weight : Int?
    var sub_total: Double?
    var total_fare: Double?
    var base_fare_text: String?
    var distance_fare_text: String?
    var time_fare_text: String?
    var waiting_fare_text: String?
       var discount_fare_text: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        card <- map["card"]
        cash <- map["cash"]
        commision <- map["commision"]
        commisionPercent <- map["commision_percent"]
        companyId <- map["company_id"]
        discount <- map["discount"]
        discountPercent <- map["discount_percent"]
        distance <- map["distance"]
        fixed <- map["fixed"]
        fleet <- map["fleet"]
        fleetId <- map["fleet_id"]
        fleetPercent <- map["fleet_percent"]
        hour <- map["hour"]
        id <- map["id"]
        isPartial <- map["is_partial"]
        minute <- map["minute"]
        payable <- map["payable"]
        paymentId <- map["payment_id"]
        paymentMode <- map["payment_mode"]
        peakAmount <- map["peak_amount"]
        peakCommAmount <- map["peak_comm_amount"]
        promocodeId <- map["promocode_id"]
        providerId <- map["provider_id"]
        providerPay <- map["provider_pay"]
        rideRequestId <- map["ride_request_id"]
        roundOf <- map["round_of"]
        surge <- map["surge"]
        tax <- map["tax"]
        taxPercent <- map["tax_percent"]
        tips <- map["tips"]
        tollCharge <- map["toll_charge"]
        total <- map["total"]
        totalWaitingTime <- map["total_waiting_time"]
        userId <- map["user_id"]
        waitingAmount <- map["waiting_amount"]
        waitingCommAmount <- map["waiting_comm_amount"]
        wallet <- map["wallet"]
        deliveryId <- map["delivery_id"]
        weight <- map["weight"]
        base_fare_text <- map["base_fare_text"]
        distance_fare_text <- map["distance_fare_text"]
        time_fare_text <- map["time_fare_text"]
        total_fare <- map["total_fare"]
        sub_total <- map["sub_total"]
        waiting_fare_text <- map["waiting_fare_text"]
             discount_fare_text <- map["discount_fare_text"]
    }
}

//MARK: - Invoice

struct Invoice: Mappable {
    
    var commision: Float?
    var commisionPercent: String?
    var companyId: Int?
    var discount: Int?
    var discountPercent: Int?
    var distance: Int?
    var fixed: Float?
    var fleetId: AnyObject?
    var hour: Int?
    var id: Int?
    var minute: Int?
    var payable: Int?
    var peakAmount: Int?
    var peakCommAmount: Int?
    var providerId: Int?
    var providerPay: Int?
    var rideRequestId: Int?
    var roundOf: Float?
    var tax: Float?
    var taxPercent: String?
    var tollCharge: Int?
    var total: Float?
    var totalWaitingTime: Int?
    var userId: Int?
    var waitingAmount: Int?
    var waitingCommAmount: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        commision <- map["commision"]
        commisionPercent <- map["commision_percent"]
        companyId <- map["company_id"]
        discount <- map["discount"]
        discountPercent <- map["discount_percent"]
        distance <- map["distance"]
        fixed <- map["fixed"]
        fleetId <- map["fleet_id"]
        hour <- map["hour"]
        id <- map["id"]
        minute <- map["minute"]
        payable <- map["payable"]
        peakAmount <- map["peak_amount"]
        peakCommAmount <- map["peak_comm_amount"]
        providerId <- map["provider_id"]
        providerPay <- map["provider_pay"]
        rideRequestId <- map["ride_request_id"]
        roundOf <- map["round_of"]
        tax <- map["tax"]
        taxPercent <- map["tax_percent"]
        tollCharge <- map["toll_charge"]
        total <- map["total"]
        totalWaitingTime <- map["total_waiting_time"]
        userId <- map["user_id"]
        waitingAmount <- map["waiting_amount"]
        waitingCommAmount <- map["waiting_comm_amount"]
    }
}

//MARK: - ProviderEntity

struct ProviderEntity: Mappable {
    
    var statusCode: String?
    var title: String?
    var message: String?
    var responseData: ProviderStatus?
    var error: [String]?
    
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

//MARK: - ProviderStatus

struct ProviderStatus: Mappable {
    
    var providerStatus: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        providerStatus <- map["provider_status"]
    }
}

//MARK: - OrderPickup

struct OrderPickup: Mappable {
    var id: Int?
    var latitude: Double?
    var longitude: Double?
    var store_location: String?
    var store_name: String?
    var contact_number: String?
    var picture:String?
    var storeType: StoreType?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        store_location <- map["store_location"]
        store_name <- map["store_name"]
        contact_number <- map["contact_number"]
        picture <- map["picture"]
        storeType <- map["storetype"]
    }
}

//MARK: - HomeDelivery

struct HomeDelivery: Mappable {
    
    var id: Int?
    var latitude: Double?
    var longitude: Double?
    var map_address: String?
    var flat_no: String?
    var street: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        map_address <- map["map_address"]
        flat_no <- map["flat_no"]
        street <- map["street"]
    }
}

//MARK: - StoreYType

struct StoreType: Mappable {
    
    var id: Int?
    var name: String?
    var category: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id  <- map["id"]
        name <- map["name"]
        category <- map["category"]
    }
}
