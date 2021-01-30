//
//  MockCLLocationManager.swift
//  LiveTrackingDemo
//
//  Created by Rajes on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase

struct MockLocationConfiguration {
    static var updateInterval = 0.5
    static var GpxFileName: String?
}

class MockCLLocationManager: CLLocationManager {
    private var parser: GpxParser?
    private var timer: Timer?
    private var locations: Queue<CLLocation>?
    private var _isRunning:Bool = false
    var updateInterval: TimeInterval = 10.0//0.5
    var isRunning: Bool {
        get {
            return _isRunning
        }
    }
    static let shared = MockCLLocationManager()
    var ref: DatabaseReference!
    private override init() {
        locations = Queue<CLLocation>()
    }
    func startMocks(usingGpx fileName: String) {
        if let fileName = MockLocationConfiguration.GpxFileName {
            parser = GpxParser(forResource: fileName, ofType: "gpx")
            parser?.delegate = self
            parser?.parse()
        }
    }
    func stopMocking() {
        self.stopUpdatingLocation()
    }
    private func updateLocation() {
        if let location = locations?.dequeue() {
            _isRunning = true
            print("locations \(location.coordinate)")
//            updateCurrentLocation(with:"41", coordinates: location.coordinate)
            delegate?.locationManager?(self, didUpdateLocations: [location])
            //delegate?.locationManager(self, didUpdateHeading: CLHeading)
            if let isEmpty = locations?.isEmpty, isEmpty {
                print("stopping at: \(location.coordinate)")
                stopUpdatingLocation()
            }
        }
    }
    override func startUpdatingLocation() {
        timer = Timer(timeInterval: updateInterval, repeats: true, block: {
            [unowned self](_) in
            self.updateLocation()
        })
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .default)
        }
    }
    override func stopUpdatingLocation() {
        timer?.invalidate()
        _isRunning = false
    }
    override func requestLocation() {
        if let location = locations?.peek() {
            delegate?.locationManager?(self, didUpdateLocations: [location])
        }
    }
    
//    func updateCurrentLocation(with providerId: String,coordinates:CLLocationCoordinate2D) {
//        ref = Database.database().reference()
//        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
//        print(timestamp)
//
//
//            let location = ["lng":  coordinates.longitude ,
//                            "lat": coordinates.latitude ,
//                            "time":timestamp] as [String : Any]
//
//            let key = ref?.child("providerId\(providerId)").key ?? String.Empty
//            ref?.child(key).setValue(location) //.child("loc_p_\(providerID!)")
//
//
//
//    }
}

extension MockCLLocationManager: GpxParsing {
    func parser(_ parser: GpxParser, didCompleteParsing locations: Queue<CLLocation>) {
        self.locations = locations
        self.startUpdatingLocation()
    }
}



