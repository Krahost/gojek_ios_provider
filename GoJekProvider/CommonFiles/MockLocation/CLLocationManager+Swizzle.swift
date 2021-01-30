//
//  CLLocationManager+Swizzle.swift
//  LiveTrackingDemo
//
//  Created by Rajes on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import MapKit

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    if let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

extension CLLocationManager {
    static let classInit: Void = {
        let originalSelector = #selector(CLLocationManager.startUpdatingLocation)
        let swizzledSelector = #selector(swizzledStartLocation)
        swizzling(CLLocationManager.self, originalSelector, swizzledSelector)
        
        let originalStopSelector = #selector(CLLocationManager.stopUpdatingLocation)
        let swizzledStopSelector = #selector(swizzledStopLocation)
        swizzling(CLLocationManager.self, originalStopSelector, swizzledStopSelector)
    }()
    
    @objc func swizzledStartLocation() {
        print("swizzled start location")
        if !MockCLLocationManager.shared.isRunning {
            MockCLLocationManager.shared.startMocks(usingGpx: "LocationTrack")
        }
        MockCLLocationManager.shared.delegate = self.delegate
        MockCLLocationManager.shared.startUpdatingLocation()
    }
    
    @objc func swizzledStopLocation() {
        print("swizzled stop location")
        MockCLLocationManager.shared.stopUpdatingLocation()
    }
    
    @objc func swizzedRequestLocation() {
        print("swizzled request location")
        MockCLLocationManager.shared.requestLocation()
    }
}
