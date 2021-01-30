//
//  OrdersConstant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum OrdersConstant {
    
    //String
    static let fareDetails = "Fare Details"
    static let paymentType = "Payment Type"
    static let instruction = "Instruction"
    static let paymentBy = "Payment By"
    static let cm = "CM"
    static let deliveryType = "Delivery Type"
    static let kg = "KG"
    static let height = "Height"
    static let breadth = "Breadth"
    static let packageType = "Package Type"
    static let commission = "Commission"
    static let length = "Length"
    static let weightFare = "Weight Fare"
    static let invoice = "Invoice"
    static let current = "Current"
    static let TOrder = "Orders"
    static let history = "History"
    static let source = "Source"
    static let status = "Status"
    static let destination = "Destination"
    static let paymentVia = "Payment Via"
    static let commentsfor = "Comments For"
    static let commentsforOrder = "Comments For Order"
    static let items = "Items"
    static let didyoulosesomething = "Did you lose something ?"
    static let presstheicon = "Press the icon to mention the lost item"
    static let dispute = "Dispute"
    static let disputeStatus = "Dispute Status"
    static let viewReceipt = "View Receipt"
    static let call = "Call"
    static let cancel = "Cancel"
    static let help = "Help"
    static let reset = "Reset"
    static let apply = "Apply"
    static let filterBy = "Filter By"
    static let trips = "Trips"
    static let orders = "Orders"
    static let delivery = "Delivery"
    static let service = "Services"
    static let selectType = "Please select one type"
    static let others = "Others"
    static let lostItem = "Lost Item"
    static let selectDispute = "Please select one dispute type"
    static let enterComment = "Enter your comment"
    static let you  = "You"
    static let receipt = "Receipt"
    static let baseFare = "Base Fare"
    static let discountFare = "Discount Fare"

    static let weight = "Weight"

    static let taxFare = "Tax Fare"
    static let cardSubTotalFare = "Card Subtotal"
    static let hourFare = "Hourly Fare"
    static let wallet = "Wallet"
    static let discountApplied = "Discount Applied"
    static let peakCharge = "Peak Charge"
    static let waitingFare = "Waiting Fare"
    static let itemTotal = "Item Total"
     static let taxAmount = "Tax Amount"
    static let tips = "Tips"
    static let total = "Total"
    static let submit = "Submit"
    static let historyempty = "No History to show"
    static let roundOff = "Round Off"
    static let waiting = "Waiting Time"
    static let distanceFare = "Distance Fare"
    static let extraCharge = "Extra Charges"
    static let noComments = "No Comments"
    static let packageCharge = "Package Charge"
    static let deliveryCharge = "Delivery Charge"
    static let tollCharge = "Toll Charge"
    static let disputeCreatedMsg = "Dispute created Successfully"
    static let lostItemCreatedMsg = "Lost item created Successfully"
    static let Pdispute = "/dispute"
    static let itemDiscount = "Item Discount"
    static let payableAmount = "Payable Amount"

    
    //Identifier
    static let VOrderTableViewCell = "OrderTableViewCell"
    static let VFilterCollectionViewCell = "FilterCollectionViewCell"
    static let VOrdersViewController = "OrdersController"
    static let VOrderDetailController  = "OrderDetailController"
    static let OrderOnGoingDetailController = "OrderOnGoingDetailController"
    static let DisputeLostItemView = "DisputeLostItemView"
    static let DisputeCell = "DisputeCell"
    static let DisputeReceiverCell = "DisputeReceiverCell"
    static let DisputeSenderCell = "DisputeSenderCell"
    static let DisputeStatusView = "DisputeStatusView"
    static let ReceiptView = "ReceiptView"
    static let VFilterView = "FilterView"
    static let SourceDestinationCell = "SourceDestinationCell"
       static let SourceTableViewCell = "SourceTableViewCell"
       static let ProfileCell = "ProfileCell"
       static let DetailOrderCell = "DetailOrderCell"
    
    //Image name
    static let icfilter = "filter_tool"
    static let alertImage = "ic_alert"
    static let helpImage = "ic_help"
    static let historyImage = "ic_no_history"
    static let appLogo = "ic_app_logo"
    
    
    //Parameter
    static let Plimit = "limit"
    static let PoffSet = "offset"
    static let Ptype = "type"
    static let Pid = "id"
    static let Pdispute_type = "dispute_type"
    static let Pprovider_id = "provider_id"
    static let Pdispute_name = "dispute_name"
    static let Plost_item_name = "lost_item_name"
    static let PDisputeId = "dispute_id"
    static let PuserId = "user_id"
    static let PStoreId = "store_id"
    static let PPage = "page"
    
    static let ic_dispute = "ic_dispute"
}

//MARK: - HistoryType

enum HistoryType: String {
    case past = "Past"
    case ongoing = "On Going"
    case upcoming = "Up Coming"
    
    var currentType: String {
        switch self {
        case .past:
            return "past"
        case .ongoing:
            return "ongoing"
        case .upcoming:
            return "upcoming"
        }
    }
}

//MARK: - ServiceTypes

enum ServiceTypes: String, CaseIterable {
    case trips = "Transport"
    case orders = "Orders"
    case service = "Services"
    case delivery = "Delivery"
    
    var currentType: String {
        switch self {
        case .trips:
            return "transport"
        case .orders:
            return "order"
        case .service:
            return "service"
        case .delivery:
            return "delivery"
        }
    }
}

//MARK: - ServiceTypes

enum OrderStatus: String {
    
    case COMPLETED = "COMPLETED"
    case CANCELLED = "CANCELLED"
    case None = ""
    
    var orderColor: UIColor {
        switch self {
        case .COMPLETED:
            return .systemGreen
        case .CANCELLED:
            return .red
        default:
            return .appPrimaryColor
        }
    }
    
    var statusStr: String {
        switch self {
        case .COMPLETED:
            return "Completed"
        case .CANCELLED:
            return "Cancelled"
        default:
            return String.Empty
        }
    }
}

//MARK: - DisputeStatus

enum DisputeStatus: String {
    
    case open = "open"
    case close  = "closed"
    
    var disputeColor: UIColor {
        switch self {
        case .open:
            return .appPrimaryColor
        case .close:
            return .systemGreen
        }
    }
}

//MARK: - DisputeStatus

enum TripStatus: String  {
    
    case SEARCHING = "SEARCHING"
    case CANCELLED = "CANCELLED"
    case ACCEPTED = "ACCEPTED"
    case STARTED = "STARTED"
    case ARRIVED = "ARRIVED"
    case PICKEDUP = "PICKEDUP"
    case DROPPED = "DROPPED"
    case COMPLETED = "COMPLETED"
    case SCHEDULED = "SCHEDULED"
    
    var statusString:String {
        switch self {
        case .SEARCHING:
            return "Searching"
        case .CANCELLED:
            return "Cancelled"
        case .ACCEPTED:
            return "Accepted"
        case .STARTED, .ARRIVED, .PICKEDUP, .DROPPED :
            return "On Trip"
        case .COMPLETED:
            return "Completed"
        default:
            return String.Empty
        }
    }
}
