//
//  XFirebaseManager.swift
//  GoJekProvider
//
//  Created by apple on 26/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import FirebaseDatabase


class XFirebaseManager: NSObject {
    
    static let shared = XFirebaseManager()
    var ref: DatabaseReference!
    let locationId = "CurrentLocation"
    
    func updateCurrentLocation(with providerId: String) {
        ref = Database.database().reference()
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        print(timestamp)
        
        let location = ["lng": XCurrentLocation.shared.longitude ?? 0.0 ,
                        "lat": XCurrentLocation.shared.latitude ?? 0.0,
                        "time":timestamp] as [String : Any]
        
        let key = ref?.child("providerId\(providerId)").key ?? String.Empty
        ref?.child(key).setValue(location) //.child("loc_p_\(providerID!)")
    }
    
    func getCurrentLocation(with childId: String, completionHandler: @escaping (_ response: [String: Any]?) -> Void) {
        ref = Database.database().reference()
        ref.child(locationId).child(childId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value
            completionHandler(value as? [String : Any])
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
