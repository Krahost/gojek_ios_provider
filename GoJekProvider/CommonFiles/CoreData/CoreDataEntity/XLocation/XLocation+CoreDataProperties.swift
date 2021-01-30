//
//  XLocation+CoreDataProperties.swift
//  
//
//  Created by Sudar vizhi on 16/12/20.
//
//

import Foundation
import CoreData


extension XLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<XLocation> {
        return NSFetchRequest<XLocation>(entityName: "XLocation")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
