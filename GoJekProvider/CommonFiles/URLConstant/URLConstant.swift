//
//  URLConstant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum URLConstant {
    
    //Login
    static let KLogin = "/provider/login"
    static let KSignUp = "/provider/signup"
    static let KCountry = "/provider/countries"
    static let KState = "/states/"
    static let KCity = "/cities/"
    static let KSocialLogin = "/provider/social/login"
    static let KForgotPassword = "/provider/forgot/otp"
    static let KResetPassword = "/provider/reset/otp"
    static let verify = "/provider/verify"
    static let sendOtp = "/user/send-otp"
    static let verifyOtp = "/user/verify-otp"
    
    //Profile
    static let KProfiledetail = "/provider/profile"
    static let KProviderStatusUpdate = "/provider/services_status/"
    static let KChangePassword = "/provider/password"

    //Taxi
    static let KCancelTaxiRequest = "/provider/cancel/ride/request"
    static let KUpdateTaxiRequest = "/provider/update/ride/request"
    static let KPaymentRequest = "/provider/transport/payment"
    static let KGetReasons = "/provider/reasons"
    static let KProviderRate = "/provider/rate/ride"
    static let KAvailablity = "/provider/available"
    static let KTaxiCheckRequest = "/provider/check/ride/request"
    static let KWaitingTime = "/provider/waiting"
    static let KAirportQueueRequest = "/provider/updatelocation/airport"

    
    
    //Courier
    
    static let KCourierCheckRequest = "/provider/check/delivery/request"
     static let KUpdateCourierRequest = "/provider/update/delivery/request"
     static let KCourierPaymentRequest = "/provider/delivery/payment"
     static let KCourierProviderRate = "/provider/rate/delivery"

    //MyAccount
    static let KGetService = "/provider/services/list"
    static let KDocument = "/provider/listdocuments"
    static let KAddDocument = "/provider/documents"
    static let KAddVehicle = "/provider/vechile/add"
    static let KEditVehicle = "/provider/vehicle/edit"
    static let KEarnings = "/provider/earnings"

    static let KAdminService = "/provider/adminservices"
    static let KRideType = "/provider/ridetype"
    
    static let KDeliveryType = "/provider/deliverytype"
    static let KGetCategory = "/provider/providerservice/categories"
    
    static let KGetCategoryservice = "provider/totalservices"
    static let KGetSubCategory = "/provider/providerservice/subcategories"
    static let KGetxuberService = "/provider/providerservice/service"
    static let KFoodieType = "/provider/shoptype"
    static let KLogout = "/provider/logout"
    static let KUpdateLanguage = "/provider/updatelanguage"
    static let KBankTemplate = "/provider/bankdetails/template"
    static let KAddBankDetails = "/provider/addbankdetails"
    static let KEditBankDetails = "/provider/editbankdetails"
    static let KNotification = "/provider/notification"
    static let kAppSettings = "/provider/appsettings"
    
    //payment
    static let KAddCard = "/provider/card"
    static let KGetCard = "/provider/card"
    static let KDeleteCard = "/provider/card"
    static let KAddMoney = "/provider/add/money"
    static let KTransaction = "/provider/wallet"
    static let KQRCodeTransfer = "/provider/wallet/transfer"
    
    //Home
    static let KAcceptRequest = "/provider/accept/request"
    static let KCancelRequest = "/provider/cancel/request"
    static let KCheckRequest = "/provider/check/request"
    static let KOnlineStatus = "/provider/onlinestatus/"
    
    //Order
    static let KOrderHistory = "/provider/history"
    static let getDisputeList = "/provider/"
    static let addDispute = "/provider/history-dispute"
    
    //Xuber
    static let KXuberCheckRequest = "/provider/check/serve/request"
    static let KXuberAcceptRequest = "/provider/accept/request"
    static let KXuberUpdateRequest = "/provider/update/serve/request"
    static let KXuberRateUser = "/provider/rate/serve"
    static let KXuberCancelRequest = "/provider/cancel/serve/request"
    static let KReason = "/provider/reasons"
    
    //Chat
    static let KUserChat = "/provider/chat"
    static let KChat = "/chat"
}
