//
//  LoginData+CoreDataProperties.swift
//  GoJekProvider
//
//  Created by CSS on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//
//

import Foundation
import CoreData

extension LoginData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginData> {
        return NSFetchRequest<LoginData>(entityName: "LoginData")
    }

    @NSManaged public var access_token: String?

}
