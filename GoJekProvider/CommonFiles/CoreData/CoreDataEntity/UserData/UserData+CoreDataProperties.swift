//
//  UserData+CoreDataProperties.swift
//  GoJekProvider
//
//  Created by CSS on 28/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var admin_id: String?
    @NSManaged public var city_id: Int16
    @NSManaged public var company_id: Int16
    @NSManaged public var country_code: String?
    @NSManaged public var country_id: Int16
    @NSManaged public var created_at: String?
    @NSManaged public var created_by: String?
    @NSManaged public var created_type: String?
    @NSManaged public var deleted_at: String?
    @NSManaged public var deleted_by: String?
    @NSManaged public var deleted_type: String?
    @NSManaged public var device_id: String?
    @NSManaged public var device_token: String?
    @NSManaged public var device_type: String?
    @NSManaged public var email: String?
    @NSManaged public var email_verified_at: String?
    @NSManaged public var first_name: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int16
    @NSManaged public var language: String?
    @NSManaged public var last_name: String?
    @NSManaged public var latitude: Float
    @NSManaged public var login_by: String?
    @NSManaged public var longitude: Float
    @NSManaged public var mobile: String?
    @NSManaged public var modified_by: String?
    @NSManaged public var modified_type: String?
    @NSManaged public var otp: Int16
    @NSManaged public var payment_gateway_id: Int16
    @NSManaged public var payment_mode: String?
    @NSManaged public var picture: String?
    @NSManaged public var qrcode_url: String?
    @NSManaged public var rating: Int16
    @NSManaged public var referral_unique_id: String?
    @NSManaged public var social_unique_id: Int16
    @NSManaged public var state_id: Int16
    @NSManaged public var status: String?
    @NSManaged public var stripe_acc_id: Int16
    @NSManaged public var updated_at: String?
    @NSManaged public var wallet_balance: Int16
    @NSManaged public var access_token: String?
    @NSManaged public var token_type: String?

}
