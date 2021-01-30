//
//  TransactionEntity.swift
//  GoJekUser
//
//  Created by  on 09/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import ObjectMapper


struct TransactionEntity : Mappable {
    var statusCode : String?
    var title : String?
    var message : String?
    var responseData : TransactionResponseData?
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

struct TransactionResponseData : Mappable {
    var total_records : Int?
    var data : [TransactionData]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        total_records <- map["total_records"]
        data <- map["data"]
    }
    
}

struct TransactionData : Mappable {

    var id : Int?
    var provider_id : Int?
    var transaction_id : Int?
    var transaction_alias : String?
    var amount : Double?
    var transaction_desc : String?
    var type : String?
    var created_at : String?
    var created_time : String?
    var transactions : [Transactions]?
    var payment_log : String?
    var provider : Provider?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
    
        id <- map["id"]
        provider_id <- map["provider_id"]
        transaction_id <- map["transaction_id"]
        transaction_alias <- map["transaction_alias"]
        amount <- map["amount"]
        transaction_desc <- map["transaction_desc"]
        type <- map["type"]
        created_at <- map["created_at"]
        created_time <- map["created_time"]
        transactions <- map["transactions"]
        payment_log <- map["payment_log"]
        provider <- map["provider"]
    }
    
}


struct Transactions : Mappable {
    var id : Int?
    var provider_id : Int?
    var company_id : Int?
    var admin_service : String?
    var transaction_id : Int?
    var transaction_alias : String?
    var transaction_desc : String?
    var type : String?
    var amount : Double?
    var open_balance : Int?
    var close_balance : Int?
    var created_at : String?
    var created_time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        provider_id <- map["provider_id"]
        company_id <- map["company_id"]
        admin_service <- map["admin_service"]
        transaction_id <- map["transaction_id"]
        transaction_alias <- map["transaction_alias"]
        transaction_desc <- map["transaction_desc"]
        type <- map["type"]
        amount <- map["amount"]
        open_balance <- map["open_balance"]
        close_balance <- map["close_balance"]
        created_at <- map["created_at"]
        created_time <- map["created_time"]
    }
    
}
