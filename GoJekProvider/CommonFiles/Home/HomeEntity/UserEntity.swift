//
//  UserEntity.swift
//  GoJekProvider
//
//  Created by apple on 21/06/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import ObjectMapper

//MARK: - UserDetail

struct User: Mappable {
    
    var cityId: Int?
    var countryCode: String?
    var countryId: Int?
    var createdAt: String?
    var currency: AnyObject?
    var currencySymbol: String?
    var email: String?
    var firstName: String?
    var gender: String?
    var id: Int?
    var language: AnyObject?
    var lastName: String?
    var latitude: AnyObject?
    var loginBy: String?
    var longitude: AnyObject?
    var mobile: String?
    var paymentMode: String?
    var picture: String?
    var rating: Double?
    var stateId: Int?
    var status: Int?
    var userType: String?
    var walletBalance: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        cityId <- map["city_id"]
        countryCode <- map["country_code"]
        countryId <- map["country_id"]
        createdAt <- map["created_at"]
        currency <- map["currency"]
        currencySymbol <- map["currency_symbol"]
        email <- map["email"]
        firstName <- map["first_name"]
        gender <- map["gender"]
        id <- map["id"]
        language <- map["language"]
        lastName <- map["last_name"]
        latitude <- map["latitude"]
        loginBy <- map["login_by"]
        longitude <- map["longitude"]
        mobile <- map["mobile"]
        paymentMode <- map["payment_mode"]
        picture <- map["picture"]
        rating <- map["rating"]
        stateId <- map["state_id"]
        status <- map["status"]
        userType <- map["user_type"]
        walletBalance <- map["wallet_balance"]
    }
}

//MARK: - ProviderDetail

struct ProviderDetail: Mappable {
    
    var activationStatus: Int?
    var adminId: AnyObject?
    var cityId: Int?
    var countryCode: String?
    var countryId: Int?
    var currency: String?
    var currencySymbol: String?
    var deviceId: AnyObject?
    var deviceToken: AnyObject?
    var deviceType: AnyObject?
    var email: String?
    var firstName: String?
    var gender: String?
    var id: Int?
    var isBankdetail: Int?
    var isDocument: Int?
    var isOnline: Int?
    var isService: Int?
    var language: AnyObject?
    var lastName: String?
    var latitude: String?
    var loginBy: String?
    var longitude: String?
    var mobile: String?
    var otp: AnyObject?
    var paymentGatewayId: AnyObject?
    var paymentMode: String?
    var picture: String?
    var qrcodeUrl: String?
    var rating: Int?
    var referralUniqueId: String?
    var service: AdminService?
    var socialUniqueId: String?
    var stateId: Int?
    var status: String?
    var stripeCustId: String?
    var walletBalance: Int?
    var isProfile: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        activationStatus <- map["activation_status"]
        adminId <- map["admin_id"]
        cityId <- map["city_id"]
        countryCode <- map["country_code"]
        countryId <- map["country_id"]
        currency <- map["currency"]
        currencySymbol <- map["currency_symbol"]
        deviceId <- map["device_id"]
        deviceToken <- map["device_token"]
        deviceType <- map["device_type"]
        email <- map["email"]
        firstName <- map["first_name"]
        gender <- map["gender"]
        id <- map["id"]
        isBankdetail <- map["is_bankdetail"]
        isDocument <- map["is_document"]
        isOnline <- map["is_online"]
        isService <- map["is_service"]
        language <- map["language"]
        lastName <- map["last_name"]
        latitude <- map["latitude"]
        loginBy <- map["login_by"]
        longitude <- map["longitude"]
        mobile <- map["mobile"]
        otp <- map["otp"]
        paymentGatewayId <- map["payment_gateway_id"]
        paymentMode <- map["payment_mode"]
        picture <- map["picture"]
        qrcodeUrl <- map["qrcode_url"]
        rating <- map["rating"]
        referralUniqueId <- map["referral_unique_id"]
        service <- map["service"]
        socialUniqueId <- map["social_unique_id"]
        stateId <- map["state_id"]
        status <- map["status"]
        stripeCustId <- map["stripe_cust_id"]
        walletBalance <- map["wallet_balance"]
        isProfile <- map["is_profile"]
    }
}

