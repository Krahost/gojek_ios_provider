//
//  HomeConstant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum HomeConstant {
    
    //Viewcontroller Identifier
    static let VHomeViewController  = "HomeViewController"
    static let VTaxiTableViewCell = "TaxiTableViewCell"
    static let VXuberTableViewCell = "XuberTableViewCell"
    static let VFoodieTableViewCell = "FoodieTableViewCell"
    static let VCallAdminAlertView = "CallAdminAlertView"
    static let ApprovalViewController = "ApprovalViewController"
    static let IncomingViewController = "IncomingRequestController"
    static let ApprovalView = "ApprovalView"
    static let MinimiumBalanceView = "MinimiumBalanceView"

    
    //Viewcontrolle Title
    static let THome = "Home"
    
    
    //Sting
    static let pickupLocation = "Pickup Location"
    static let deliveryLocation = "Delivery Location"
    static let reject = "Reject"
    static let accept = "Accept"
    static let taxiApp = "Taxi App"
    static let foodie = "Foodie"
    static let service = "Service"
    static let serviceType = "Serive Type"
    static let scheduleDate = "Schedule Date"
    static let goOnline = "Go Online"
    static let goOffline = "Go Offline"
    static let callAdmin = "Call Admin"
    static let admin = "Admin"
    static let Alert = "Alert"
    static let lowWallet = "Your wallet is at low balance, \n Please Recharge"
    static let callAdminAlert = "Please call admin to get clarified"
    static let rechargeWallet = "Recharge Wallet"
    static let contactAdmin = "Contact Admin"

    
    //image name
    static let applogo = "ic_app_logo"
    static let ratingunSelect = "ic_rating_unselect"
    static let ratingSelect = "ic_rating_select"
    
    //Parameter
    static let requestid = "request_id"
    static let id = "id"
    static let serviceId = "admin_service"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let status = "status"
    static let PCancel = "cancel"
    static let reason = "reason"
}

//Pending Type
enum PendingType {
    
    case Service
    case Document
    case BankDetails
    case adminApproval
    case profile
}

//Account Status
enum AccountStatus: String {
    
    case document = "DOCUMENT"
    case card = "CARD"
    case onboarding = "ONBOARDING"
    case approved = "APPROVED"
    case banned = "BANNED"
}

//Active status
enum ActiveStatus: String {
    
    case active = "ACTIVE"
    case transport = "TRANSPORT"
    case service = "SERVICE"
    case order = "ORDER"
    case delivery = "DELIVERY"
    case none = ""
}
