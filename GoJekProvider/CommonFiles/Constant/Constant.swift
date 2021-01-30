//
//  Constant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum Constant {
    
    //MARK: - String
    static let empty = ""
    static let ok = "OK"
    static let cancel = "Cancel"
    static let openCamera = "Open Camera"
    static let openGalley = "Open Gallery"
    static let save = "Save"
    static let start = "start"
    static let dismiss = "Dismiss"

    static let arrived = "Arrived"
    static let submit = "Submit"
    static let add = "Add"
    static let change = "Change"
    static let confirm = "Confirm"
    static let confirmPayment = "Confirm Payment"
    static let waitingforPayment = "Waiting for payment"
    static let rateCustomer = "Rate your customer"
    static let rating = "Rating"
    static let leaveComment = "Leave your Comments"
    static let message = "message"
    static let statusCode = "statusCode"
    static let choose = "Choose"
    static let SYes = "Yes"
    static let SDone = "Done"
    static let SNo = "No"
    static let taxi = "Taxi"
    static let admin = "Admin"
    static let foodie = "Foodie"
    static let xuber = "Xuber"
    static let cash = "Cash"
    static let card = "Card"
    static let payPal = "Paypal"
    static let payTm = "PayTm"
    static let payUMoney = "PayUMoney"
    static let brainTree = "Braintree"
    static let enterAmount = "Enter Amount"
    static let email = "Email"
    static let wallet = "Wallet"
    static let savedCards = "Saved Cards"
    static let addCard = "Add Cards"
    static let addAmount = "Add amount"
    static let English = "English"
    static let Arabic = "Arabic"
    static let writingSomething = "Write Something"
    static let chooseReason = "Choose Reason"
    static let other = "Others"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let room = "room"
    
    //MARK: - Images
    static let home = "ic_home"
    static let order = "ic_orders"
    static let notification = "ic_notification"
    static let account = "ic_account"
    static let edit = "ic_edit"
    static let ratingunSelect = "ic_rating_unselect"
    static let ratingSelect = "ic_rating_select"
    static let back = "ic_back"
    static let profile = "profile"
    static let eyeOff = "ic_eye_off"
    static let eye = "ic_eye"
    static let userPlaceholderImage = "profile"
    static let shareImage = "ic_share"
    static let ic_empty_card = "ic_empty_card"
    static let payment = "ic_payment"
    static let ratingEmptyImage = "ic_rating_unselect"
    static let ratingFull = "ic_rating_select"
    static let circleImage = "ic_circle"
    static let circleFullImage = "ic_circle_full"
    static let phoneImage = "ic_phone"
    static let holderImage = "ImagePlaceHolder"
    static let closeRoundImage = "ic_close"
    static let moreMenuImage = "ic_threedotsmore"
    static let sourcePinImage = "ic_source_marker"
    static let destinationPinImage = "ic_destination_marker"
    static let sqaureEmpty = "ic_square_empty"
    static let squareFill = "ic_square_fill"
    static let chatImage = "ic_chat"
    static let RatingToast = "Rated Successfully"
    static let ic_creditCard = "ic_credit_card"
    static let ic_money = "money"
    
    //MARK: - Alert Mesage
    static let noNetwork = "Mobile network not available"
    static let noInterNetConnection = "Please Check your internet connection."
    static let requestTimeOut = "The request timed out."
    static let networkConnectionLost = "Your network Connection Lost"
    static let unknownError = "Unknown error"
    static let unacceptableStatusCode = "Response status code was unacceptable: "
    static let underlyingError = "Underlying error"
    static let failureError = "Failure Reason: "
    static let invalidURL = "Invalid URL: "
    static let parameterEncodingFailed = "parameterEncodingFailed Parameter encoding failed: "
    static let multipartEncodingFailed = "Multipart encoding failed: "
    static let responseValidationFailed = "Response validation failed: "
    static let dataFileNil = "Downloaded file could not be read"
    static let missingContentType = "Content Type Missing: "
    static let unacceptableContentType = " was unacceptable: "
    static let reponseContentTyep = "Response content type: "
    static let responseSerializationFailed = "Response serialization failed: "
    static let passwordChangesMsg = "Your password has been changed. Please login with new password"
    static let tollChargeMsg = "Do you have any Toll charges"
    static let cameraPermission = "Unable to open camera, Check your camera permission"
    
    static let detectingLowPower = "Detecting low power mode,Please plugin your phone"
    static let detectingBatteryPower = "Detecting low battery mode,Please plugin your phone"
    static let choosePicture = "Choose your picture"
    static let removePhoto = "Remove Photo"

    
    //Approval Details Screen
    static let addProfileDetails = "Add Profile Detail"
    static let addService = "Add Services"
    static let addDocument = "Add Documents"
    static let addBankDetails = "Add Bank Detail"
    static let completeSteps = "Please Complete below steps"
    static let waitAdminApproval = "Please wait for Admin Approval"
   // static let accountDisable = "Your account is disabled"
    static let pleasecontactAdmin = "Your account is disabled\nPlease contact the Admin"
    
    //MARK: - Placeholder sting
    static let PPassword = "Password"
    static let PPhoneNumber = "Phone Number"
    static let PCode = "Code"
    static let PEmail = "Email"
    static let PUserName = "User Name"
    static let firstName = "First Name"
    static let lastName = "Last Name"
    static let PEmailId = "Email Id (optional)"
    static let PCity = "City"
    static let PState = "State"
    static let PCountry = "Country"
    static let PService = "Service"
    static let adminService = "admin_service"
    static let adminServiceId = "admin_service"
    static let user = "user"
    static let provider = "provider"
    static let type = "type"
    static let id = "id"
    static let PUrl = "url"
    static let okay = "Okay"

    
    //IncommingRequest Screen
    static let incomingRequest = "Incoming Request"
    static let location = "Location"
    static let weight = "Weight"
    static let serviceType = "Service Type"
    static let Reject = "Reject"
    static let Accept = "Accept"

    
    //Content Type
    static let RequestType = "XRequested-With"
    static let RequestValue = "XMLHttpRequest"
    static let ContentType = "ContentType"
    static let ContentValue = "application/json"
    static let MultiPartValue = "multipart/formdata"
    static let Authorization = "Authorization"
    static let Bearer = "Bearer "
    static let saltkey = "salt_key"
    
    
    static let CustomTableView = "CustomTableView"
    static let CustomTableCell = "CustomTableCell"
    static let ChatUserCollectionViewCell = "ChatUserCollectionViewCell"
    
    
    //MARK: - Socket
    
    //Request
    static let CommonRoomKey = "joinCommonRoom"
    static let PrivateRoomKey = "joinPrivateRoom"
    static let SocketStatus = "socketStatus"
    static let NewRequest = "newRequest"
    static let PrivateRoomListener = "serveRequest"
    static let UpdateLocation = "update_location"
    static let LeaveRoom = "leaveRoom"
    static let CommonRoomProvider = "joinCommonProviderRoom"
    static let Approval = "approval"
    static let SettingUpdate = "settingUpdate"

    //Chat
    static let JoinPrivateChatRoom = "joinPrivateChatRoom"
    static let NewMessage = "new_message"
    static let SendMessage = "send_message"
    
    //Location
    static let SendLocation = "send_location"
}

// push notifications type

enum pushNotificationType: String {
    
    case transport = "transport"
    case service = "service"
    case order = "order"
    case chat = "chat"
    case chat_order = "chat_order"
    case chat_transport = "chat_transport"
    case chat_service = "chat_service"
}


enum PaymentType: String {
    
    case CASH = "CASH"
    case CARD = "CARD"
    case WALLET = "WALLET"
    case NONE = ""
    
    var image : UIImage? {
        var name = "ic_error"
        switch self {
        case .CARD:
            name = "ic_credit_card"
        case .CASH:
            name = "money"
        case .WALLET:
            name = "WalletCart"
        case .NONE :
            name = "ic_error"
        }
        return UIImage(named: name)
    }
}

enum RoomListener: String {
    
    case Transport = "rideRequest"
    case Delivery = "deliveryRequest"
    case Service = "serveRequest"
    case Order = "orderRequest"
    case common = "newRequest"
    case PaymentMode = "paymentMode"
}

struct DateFormat {
    
    static let yyyy_mm_dd_HH_MM_ss = "yyyy-MM-dd HH:mm:ss"
    static let dd_mm_yyyy_hh_mm_ss = "dd-MM-yyyy HH:mm:ss"
    static let dd_mm_yyyy_hh_mm_ss_a = "dd-MM-yyyy hh:mm a"
    static let ddmmyyyy = "dd-MM-yyyy"
    static let ddMMMyy12 = "dd MMM yyyy, hh:mm a"
    static let ddMMMyy24 = "dd MMM yyyy, HH:mm:ss"
    
}

enum StripeCredentialKey: String {
    
    case stripe_secret_key = "stripe_secret_key"
    case stripe_publishable_key = "stripe_publishable_key"
    case stripe_currency = "stripe_currency"
}
