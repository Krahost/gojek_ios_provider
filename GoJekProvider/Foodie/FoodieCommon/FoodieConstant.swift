//
//  FoodieConstant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum FoodieConstant {
    
    //XIB
    static let ItemListCell = "ItemListCell"
    static let FoodieLiveTaskFooterView = "FoodieLiveTaskFooterView"
    static let FilterView = "FilterView"
    static let FoodieRatingView = "FoodieRatingView"
    
    //View itentifier
    static let ItemWithoutAddOnsTableViewCell = "ItemWithoutAddOnsTableViewCell"
    static let ItemListTableViewCell = "ItemListTableViewCell"
    static let FeedBackPopViewViewController = "FeedBackPopViewViewController"
    static let AmountPopViewViewController = "AmountPopViewViewController"
    static let FoodieLiveTaskController = "FoodieLiveTaskController"
    
    //String
    static let startedTowardsRestaurant = "STARTED TOWARDS SHOP"
    static let orderPreparing = "PREPARING FOOD"
    static let reachedRestaurent = "REACHED SHOP"
    static let orderPickedUp = "ORDER PICKED UP"
    static let completeOrder = "COMPLETE ORDER"
    static let orderDelivered = "ORDER DELIVERED"
    static let completed = "COMPLETED"
    static let submit = "SUBMIT"
    static let waitingNewTask = "WAITING FOR THE NEW TASK"
    static let disputeTitle = "Are you sure you want to dispute this order?"
    static let dispute = "Dispute"
    static let total = "Total"
    static let cash = "CASH"
    static let wallet = "Wallet"
    static let paymentMode = "Payment Mode"
    static let orderDeliveredSucess = "Order Delivered Successfully"
    static let orderCancelled = "Order Cancelled"
    static let home = "HOME"
    static let ongoingRequest = "Ongoing Request"
    static let liveTasks = "LIVE TASKS"
    static let itemTotal = "Item Total"
    static let itemDiscount = "Item Discount"
    static let counpon = "Coupon Amount"
    static let serviceTax = "Service Tax"
    static let deliveryCharge = "Delivery Charge"
    static let discount = "Shop Discount"
    static let walletDeduction = "Wallet Deduction"
    static let terrible = "Terrrible"
    static let bad = "Bad"
    static let good = "Good"
    static let superb = "Superb"
    static let feedback = "Feedback"
    static let howdelivery = "How was the delivery?"
    static let feedbackwords = "Give some feedback in words"
    static let enterOTP = "Enter the OTP"
    static let amountToPaid = "Amount to pay"
    static let enterAmountPaid = "Enter the amount paid"
    static let balance = "Balance"
    static let paid = "Paid"
    static let paymentConfirmationMsg = "** Make sure your payment from customer"
    static let enterValidOtp = "Please enter valid OTP"
    static let storePackage = "Shop Package Charge"
    static let doorStepMsg = "Please place at DoorStep"

    
    static let patch = "PATCH"
    static let liveTask = "Live Task"
    static let otpImage = "ic_otp_verify"
    
    
    //Image sting
    static let process_1 = "process_1"
    static let process_2 = "process_2"
    static let process_3 = "process_3"
    static let process_4 = "process_4"
    static let process_5 = "process_5"
    static let ratingUnselect = "ic_rating_unselect"
    static let phoneCall = "phone-call"
    static let compass = "compass"
    static let ic_delivery_boy = "ic_delivery_boy"
}

struct FoodieAPI {
    static let updateRequest = "/provider/update/order/request"
    static let checkRequest = "/provider/check/order/request"
    static let rating = "/provider/rate/order"
}

struct FoodieInput {
    
    static let id = "id"
    static let status = "status"
    static let _method = "_method"
    static let otp = "otp"
    static let admin_service_id = "admin_service"
    static let rating = "rating"
    static let comment = "comment"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let service_id = "service_id"
}

enum FoodieOrderStatus: String {
    
    case ORDERED = "ORDERED"
    case RECEIVED = "RECEIVED"
    case CANCELLED = "CANCELLED"
    case ASSIGNED = "ASSIGNED"
    case PROCESSING = "PROCESSING"
    case STARTED = "STARTED"
    case REACHED = "REACHED"
    case PICKEDUP = "PICKEDUP"
    case ARRIVED = "ARRIVED"
    case COMPLETED = "COMPLETED"
    case SEARCHING = "SEARCHING"
    case STORECANCELLED = "STORECANCELLED"
    case PAYMENT = "PAYMENT"
    case none = ""
    
    var statusStr: String {
        switch self {
        case .PROCESSING:
            return FoodieConstant.startedTowardsRestaurant.localized
        case .STARTED:
            return FoodieConstant.reachedRestaurent.localized
        case .REACHED:
            return FoodieConstant.orderPickedUp.localized
        case .ARRIVED, .PICKEDUP:
            return FoodieConstant.orderDelivered.localized
        case .COMPLETED:
            return Constant.SDone.localized.uppercased()
        default:
            return String.Empty
        }
    }
    
    var imageTag:Int {
        switch self {
        case .STARTED:
            return 1
        case .REACHED:
            return 2
        case .PICKEDUP:
            return 3
        case .ARRIVED:
            return 4
        case .COMPLETED:
            return 5
        default:
            return 0
        }
    }
        
}


// MARK: - CustomProtocol
protocol FeedBackViewDelegate: class {
    func feedBackNextScreen()
}

protocol AmountPopUpDelegate: class {
    func popUpDelegate(otp:String)
}
