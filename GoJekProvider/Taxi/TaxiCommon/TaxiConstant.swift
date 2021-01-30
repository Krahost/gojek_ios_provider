//
//  TaxiConstant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum TaxiConstant {
    
    //Controller
    static let TaxiHomeViewController = "TaxiHomeViewController"
    static let TaxiHomeView = "TaxiHomeView"
    static let TaxiOTPView = "TaxiOTPView"
    static let TaxiTollChargeView = "TollChargeView"
    static let TaxiRatingView = "TaxiRatingView"
    static let TaxiInvoiceViewController = "TaxiInvoiceViewController"
    static let WaitingTimeView = "WaitingTimeView"

    //String
    static let enterOTP = "Enter OTP"
    static let chat = "Chat"
    static let call = "Call"
    static let startTrip = "Start Trip"
    static let pickup = "Picked up"
    static let tapWhenDrop = "Tap When Dropped"
    static let confirmPayment = "Confirm Payment"
    static let invoice = "Invoice"
    static let sourceDestination = "Source and Destination"
    static let bookingId = "Booking ID"
    static let distanceTravel = "Distance Travelled"
    static let timeTaken = "Waiting Charge"
    static let waitingFare = "Waiting Fare"
    static let distanceFare = "Distance Fare"
    static let tax = "Tax"
    static let tips = "Tips"
    static let subtotal = "SubTotal"
    static let peakCharge = "Peak Charge"
       //static let waitingFare = "Waiting Fare"
    static let totalfare = "Total Fare"
    static let total = "Total"
     static let totalbill = "Total Bill"
    static let paymentVia = "Payment Via"
    static let baseFare = "Base Fare"
    static let pickupLocation = "Pickup Location"
    static let dropLocation = "Drop Location"
    static let InvalidOTP = "Enter valid OTP"
    static let waitingTime = "Waiting Time"
    static let tollCharge = "Toll Charge"
    static let booksomeone = "Book some one user info"
    
    static let add = "ADD"
    static let submit = "Submit"
    static let sos = "SOS"
    static let menu = "MENU"
    static let time = "TIME"
    static let transport = "TRANSPORT"
    static let PLat = "lat"
    static let PLng = "lng"
    static let PTime = "time"
    static let waitingTimeError = "Please turn off waiting time"
    static let tollChargeEmpty = "Please enter Toll Charge"
    static let tollChargeValidation = "Please enter valid amount"
    static let discount = "Discount"
    static let walletDeduction = "Wallet Deduction"
    static let stop = "Stop"


    //Image
    static let pickupImage = "ic_location_small"
    static let dropImage = "ic_drive"
    static let truck = "ic_truck"
    static let navigationImage = "ic_navigation-arrow"
    static let finishImage = "ic_finish"
    static let currentLocationImage = "ic_current_location"
    static let invoiceImage = "ic_invoice"
   
    static let walletImage = "WalletCart"
    static let ic_pull_down = "ic_pull_down"
    static let car_marker = "car_marker"
    static let ic_airportQueue = "ic_airportQueue"
    
    //Parameter
    static let id = "id"
    static let status = "status"
    static let method = "_method"
    static let patch = "PATCH"
    static let rating = "rating"
    static let comment = "comment"
    static let adminServiceId = "admin_service"
    static let url = "url"
    static let GoogleMap = "GoogleMap"
    static let tollPrice = "toll_price"
    static let locationPoints = "location_points"
    static let distance = "distance"
    static let otp = "otp"
}

enum TravelState: String {
    
    case searching = "SEARCHING"
    case started = "STARTED"
    case accepted = "ACCEPTED"
    case payment = "PAYMENT"
    case arrived = "ARRIVED"
    case pickedup = "PICKEDUP"
    case droped = "DROPPED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case showInVoice = "SHOWINVOICE"
    case none =  ""
}


