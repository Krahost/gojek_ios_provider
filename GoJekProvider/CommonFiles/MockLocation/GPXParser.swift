//
//  GPXParser.swift
//  LiveTrackingDemo
//
//  Created by Rajes on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import CoreLocation

struct Queue<T> {
    var list: [T] = []
    
    mutating func enqueue(_ element: T) {
        list.append(element)
    }
    mutating func dequeue() -> T? {
        if !list.isEmpty {
            return list.removeFirst()
        } else {
            return nil
        }
    }
    
    var isEmpty: Bool {
        return list.isEmpty
    }
    
    func peek() -> T? {
        if !list.isEmpty {
            return list[0]
        } else {
            return nil
        }
    }
}

protocol GpxParsing: NSObjectProtocol {
    func parser(_ parser: GpxParser, didCompleteParsing locations: Queue<CLLocation>)
}

class GpxParser: NSObject, XMLParserDelegate {
    private var locations: Queue<CLLocation>
    weak var delegate: GpxParsing?
    private var parser: XMLParser?
    
    init(forResource file: String, ofType typeName: String) {
        self.locations = Queue<CLLocation>()
        super.init()
        if let content = try? String(contentsOfFile: Bundle.main.path(forResource: file, ofType: typeName)!) {
            let data = content.data(using: .utf8)
            parser = XMLParser.init(data: data!)
            parser?.delegate = self
        }
    }
    
    func parse() {
        self.parser?.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
            
        case "wpt":
            if let latString =  attributeDict["lat"],
                let lat = Double.init(latString),
                let lonString = attributeDict["lon"],
                let lon = Double.init(lonString) {
                locations.enqueue(CLLocation(latitude: lat, longitude: lon))
            }
        default: break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parser(self, didCompleteParsing: locations)
    }
}


class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var locationCallback: ((CLLocation) -> ())? = nil
    var headingCallback: ((CLLocationDirection) -> ())? = nil
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingCallback?(newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Error while updating location " + error.localizedDescription)
    }
}
