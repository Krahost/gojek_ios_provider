//
//  XuberConstant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum XuberConstant {
    
    //Image
    static let iphone = "ic_phone"
    static let ichat = "chat"
    static let icamera = "ic_photo_camera"
    static let iclock = "ic_clock"
    static let ihelp = "ic_info"
    
    //String
    static let call = "Call"
    static let chat = "Chat"
    static let start = "START"
    static let startService = "start"
    static let endService = "completed"
    static let takeSnap = "Take Snap"
    static let confirmPayment = "Confirm Payment"
    static let invoice = "Invoice"
    static let amounttopaid = "Amount to be paid"
    static let enterOTP = "Enter OTP here"
    static let completed = "completed"
    static let plusadditionalCharge = "Additional charge"
    static let instructions = "Instructions"
    static let amount = "Amount"
    static let description = "Description"
    static let additionalCharges = "Additional charges"
    static let beforeService = "Before services"
    static let afterService = "After services"
    static let uploadImage = "Upload the Image"
    static let rateDeliver = "Rate your service with "
    static let type = "type"
    static let service = "Service"
    static let cancelImage = "ic_cancel"
    static let timeTaken = "Time Taken"
    static let serviceLocation = "Service Location"
    
    static let otpEmpty = "Please enter otp"
    static let otpValid = "Please enter valid otp"
    static let beforeImageEmpty = "Please upload Before Service Image"
    static let afterImageEmpty = "Please upload After Service Image"
    static let additionalChargeMsg = "Do you want to add additional charges?"
    static let additionalChargePriceMsg = "Please enter valid additional charges amount"
    static let deleteCard = "Are you sure want to delete card?"

    //MARK: - Viewcontroller Identifier
    static let XuberInVoiceController = "XuberInVoiceController"
    static let XuberAditionalChargesViewController = "XuberAditionalChargesViewController"
    static let xuberArriveView = "XuberArriveView"
    static let xuberHomeViewController = "XuberHomeViewController"
    static let xuberRatingView = "XuberRatingView"
    static let XuberServiceImageUploadController = "XuberServiceImageUploadController"
    static let xuberHelpView = "XuberHelpView"
    static let serviceInvoiceDetail = "ServiceInvoiceDetailUpdate"
    
    static let PStatus = "status"
    static let PMethod = "_method"
    static let PPatch = "PATCH"
    static let PPost = "POST"
    static let POtp = "otp"
    static let PBeforeService = "before_picture"
    static let PAfterPicture = "after_picture"
    static let PExtraCharge = "extra_charge"
    static let PExtraChargeDes = "extra_charge_notes"
    static let PAdminServiceId = "admin_service"
    static let PRating = "rating"
    static let PComment = "comment"
    static let SDone = "Done"
}

enum ServiceState: String {
    case arrive = "ARRIVED"
    case start = "PICKEDUP"
    case end = "DROPPED"
    case payment = "COMPLETED"
    case cancel = "CANCELLED"
    case additionalCharge = "ADDITIONAL CHARGE"
    case accepted = "ACCEPTED"
}
