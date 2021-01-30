//
//  XMapView.swift
//  CustomMapView
//
//  Created by apple on 05/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

public var routePolyline: GMSPolyline!
public var gmsPath = GMSPath()
typealias LocationCoordinate = CLLocationCoordinate2D

struct XCurrentLocation {
    
    static var shared = XCurrentLocation()
    
    var latitude: Double?
    var longitude: Double?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
    }
    
    var locationArray = ["13.058661"]
}

class XMapView: GMSMapView {
    
    var didUpdateLocation:(()->Void)?
    
    var locationManager: CLLocationManager?
    var placesClient: GMSPlacesClient!
    var currentAddress = String()
    var zoomLevel: Float = 15.0
    var currentLocation = CLLocation()
    
    var sourceMarker : GMSMarker!
    var destinationMarker: GMSMarker!
    var currentLocationMarker: GMSMarker!
    var isAPIProcessing:Bool  = false
    var pastCoordinate:CLLocationCoordinate2D!
    
    var carMovement: XCarMovement?
    
    var currentPolyLine:GMSPolyline!
    
    var currentLocationMarkerImage: UIImage!
    
    private var polyLineColor: UIColor!
    
    var didDragMap:((Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapViewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mapViewSetup()
    }
    
    //Map view setup
    private func mapViewSetup() {
        self.isVisibleCurrentLocation(visible: true)
        self.delegate = self
        self.backgroundColor = .whiteColor

        self.carMovement = XCarMovement()
        self.carMovement?.delegate = self
        setMapStyle()
        currentLocationViewSetup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         if #available(iOS 13.0, *) {
             if UITraitCollection.current.userInterfaceStyle == .dark {
                 isDarkMode = true
             }
             else {
                 isDarkMode = false
             }
         }
         else{
             isDarkMode = false
         }
         setMapStyle()
     }
    
    func setDestinationLocationMarker(destinationCoordinate: CLLocationCoordinate2D, address: String) {
        guard let _ = self.destinationMarker else {
            self.destinationMarker = GMSMarker(position: destinationCoordinate)
            let markerImageView = UIImageView(image: UIImage(named: "ic_destination_marker"))
            self.destinationMarker.iconView = markerImageView
            self.destinationMarker.map = self
            self.setZoomLevelBasedOnMarker(markers: [self.sourceMarker ?? GMSMarker(),self.destinationMarker ?? GMSMarker()])
            return
        }
        self.destinationMarker.position = destinationCoordinate
    }
    
    //MARK : Add Map Markers
    
    func setCurrentLocationMarkerPosition(coordinate:CLLocationCoordinate2D) {
        
        //        DispatchQueue.main.async {
        guard let _ = self.currentLocationMarker else {
            self.currentLocationMarker = GMSMarker(position: coordinate)
            let markerImageView = UIImageView(image: self.currentLocationMarkerImage)
            self.currentLocationMarker.iconView = markerImageView
            self.currentLocationMarker.tracksViewChanges = true
            self.currentLocationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            self.currentLocationMarker.map = self
            return
        }
        let markerImageView = UIImageView(image: self.currentLocationMarkerImage ?? UIImage())
        self.currentLocationMarker.iconView = markerImageView
        self.currentLocationMarker.position = coordinate
    }
    
    func getAdressName(latitude: Double, longitude: Double,on completion : @escaping ((String)->()))  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placeMark, error) in
            
            if error != nil {
                
            } else {
                var address = ""
                let place = placeMark as [CLPlacemark]?
                if (place?.count ?? 0) > 0 {
                    let place = placeMark?[0]
                    if place?.thoroughfare != nil { // Street name
                        address = address + (place?.thoroughfare ?? "")
                    }
                    if place?.subThoroughfare != nil { // Street name
                        address = address + (place?.subThoroughfare ?? "")
                    }
                    if place?.locality != nil { // City Name
                        address = address + (place?.locality ?? "")
                    }
                    if place?.postalCode != nil { // Postal
                        address = address + (place?.postalCode ?? "")
                    }
                    if place?.subAdministrativeArea != nil { // State
                        address = address + (place?.subAdministrativeArea ?? "")
                    }
                    if place?.country != nil { // Country
                        address = address + (place?.country ?? "")
                    }
                }
                completion(address)
            }
        }
    }
    
    func setSourceLocationMarker(sourceCoordinate: CLLocationCoordinate2D, marker: UIImage) {
        guard let _ = self.sourceMarker else {
            //            DispatchQueue.main.async {
            self.sourceMarker = GMSMarker(position: sourceCoordinate)
            let markerImageView = UIImageView(image: marker)
            self.sourceMarker.iconView = markerImageView
            self.sourceMarker.map = self
            //            }
            return
        }
        self.sourceMarker.position = sourceCoordinate
    }
    
    func isVisibleCurrentLocation(visible:Bool) {
        self.isMyLocationEnabled = visible
    }
    
    func setDestinationLocationMarker(destinationCoordinate: CLLocationCoordinate2D, marker: UIImage) {
        
        DispatchQueue.main.async {
            guard let _ = self.destinationMarker else {
                self.destinationMarker = GMSMarker(position: destinationCoordinate)
                let markerImageView = UIImageView(image: marker)
                self.destinationMarker.iconView = markerImageView
                if let _ = self.currentPolyLine {
                    self.currentPolyLine.map = nil
                    self.currentPolyLine =  nil
                }
                
                self.destinationMarker.map = self
                self.setZoomLevelBasedOnMarker(markers: [self.currentLocationMarker ?? GMSMarker(),self.destinationMarker])
                return
            }
            self.destinationMarker.position = destinationCoordinate
            
        }
    }
    
    func setZoomLevelBasedOnMarker(markers:[GMSMarker]) {
        let bounds = markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }
        
        self.animate(with: .fit(bounds, withPadding: 100.0))
    }
    
    // Setting Map Style
    func currentLocationViewSetup() {
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startUpdatingLocation()
        locationManager?.startUpdatingHeading()
        locationManager?.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }
    
    func showCurrentLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        self.animate(to: camera)
    }
    
    
    func drawPolyLineCurrentFromDestination(destination:CLLocationCoordinate2D,lineColor: UIColor) {
        
        guard let _ = currentLocationMarker else {
                 print("No Current")
                 self.setCurrentLocationMarkerPosition(coordinate: XCurrentLocation.shared.coordinate)
                 return
             }
             print("Source marker passed")
             guard let _ = currentPolyLine else {
                 self.removePolylines()
                 self.polyLineColor = lineColor
                 print("start draw poly line")
                 if !self.isAPIProcessing {
                     self.isAPIProcessing = true
                     self.drawPolyline(from: destination, to: destination, color: self.polyLineColor) { [weak self] (polyline) in
                         guard let self = self else {
                             return
                         }
                         self.isAPIProcessing = false
                         self.currentPolyLine = polyline
                         self.currentPolyLine.map = self
                         print("polyline draw")
                     }
                 }
                 return
             }
    }
    
    func drawPolyLineFromSourceToDestination(source:CLLocationCoordinate2D, destination:CLLocationCoordinate2D,lineColor: UIColor) {
        
        guard let _ = sourceMarker else {
            print("No Source")
            self.setSourceLocationMarker(sourceCoordinate: source, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
            return
        }
        print("Source marker passed")
        guard let _ = currentPolyLine else {
            self.removePolylines()
            self.polyLineColor = lineColor
            print("start draw poly line")
            if !self.isAPIProcessing {
                self.isAPIProcessing = true
                self.drawPolyline(from: source, to: destination, color: self.polyLineColor) { [weak self] (polyline) in
                    guard let self = self else {
                        return
                    }
                    self.isAPIProcessing = false
                    self.currentPolyLine = polyline
                    self.currentPolyLine.map = self
                    print("polyline draw")
                }
            }
            return
        }
    }
    
    //Get current location address detail from lat & lon
    private func getCurrentLocationDetail(){
        
        let urlString: String = APPConstant.googleBaseUrl+"\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&key=\(APPConstant.googleKey)"
        
        guard let url = URL(string: urlString) else {
            print("Error in creating URL Geocoding")
            return
        }
        print("URL: \(urlString)")
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            if
                let responseData = data,
                let utf8Text = String(data: responseData, encoding: .utf8),
                let placeDetail = Place.init(JSONString: utf8Text) {
                
                print(placeDetail)
                if
                    let address = placeDetail.results?.first?.formatted_address {
                    self?.currentAddress = address
                }
            }
            
        }.resume()
    }
}

extension XMapView {
    
    //Create route source to destination
    func createRoute(to destination: CLLocationCoordinate2D, with address: String,color: UIColor) {
        self.removePolylines()
        if !self.isAPIProcessing {
            self.isAPIProcessing = true
            self.drawPolyline(from: currentLocation.coordinate, to: destination, color: color) { (polyline) in
                self.currentPolyLine = polyline
                self.isAPIProcessing = false
            }
        }
        self.setDestinationLocationMarker(destinationCoordinate: destination, address: address)
        self.setCurrentLocationMarkerPosition(coordinate: currentLocation.coordinate)
    }
    
    //Clear mapview
    func clearMap() {
        
        if destinationMarker != nil {
            destinationMarker.map = nil
        }
        
        if routePolyline != nil {
            routePolyline = nil
        }
    }
    
    func removePolylines() {
        
        if let _ = self.currentPolyLine {
            currentPolyLine?.map = nil
            currentPolyLine = nil
        }
        
        if let _ = routePolyline {
            routePolyline.map = nil
            routePolyline = nil
        }
        if let _  = animationPolyline {
            animationPolyline?.map = nil
            animationPolyline = nil
        }
    }
    
    func clearAll() {
        
        removePolylines()
        removeLocationMarkers()
        self.clear()
        self.removePolylineAnimateTimer()
        
    }
    
    func removeLocationMarkers() {
        if sourceMarker != nil {
            sourceMarker.map = nil
            sourceMarker = nil
        }
        if destinationMarker != nil {
            destinationMarker.map = nil
            destinationMarker = nil
        }
    }
    
    //Setting Map Style
    private func setMapStyle(){
        if(isDarkMode){
          self.alpha = 0
        }
        else{
          self.alpha = 1
        }
        do {
            var style = "style"
            if(isDarkMode){
                style = "Dark_Map_style"
            }
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: style, withExtension: "json") {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    //MARK: Rerouting Map Functions
    func checkPolyLineBounds(currentLocation:CLLocationCoordinate2D) {
        
        guard let currentPath = self.currentPolyLine else { return}
        if locationOutOfRoute(drawnPolyLine: currentPath, location: currentLocation) {
            updateTravelledPath(currentLoc: currentLocation)
        } else {
            let lastCoordinate = getLastLocation()
            if lastCoordinate.latitude > 0 {
                self.currentPolyLine.map = nil
                self.currentPolyLine =  nil
                
                drawPolyLineFromDestination(destination: lastCoordinate, lineColor: polyLineColor ?? .darkGray)
            }
        }
    }
    
    func drawPolyLineFromDestination(destination:CLLocationCoordinate2D,lineColor: UIColor) {
        
        guard let _ = sourceMarker else { return }
        guard let _ = currentPolyLine else {
            self.polyLineColor = lineColor
            print("start darw poly line")
            if !self.isAPIProcessing {
                self.isAPIProcessing = true
                self.drawPolyline(from: currentLocation.coordinate, to: destination, color: lineColor) { (polyline) in
                    self.currentPolyLine = polyline
                    self.currentPolyLine.map = self
                    self.isAPIProcessing = false
                    print("Polyline draw")
                }
            }
            return
        }
    }
    
    func getLastLocation() -> CLLocationCoordinate2D {
        
        guard let currentPath = self.currentPolyLine.path else { return CLLocationCoordinate2D() }
        if currentPath.count() < 1 { return CLLocationCoordinate2D() }
        let index = currentPath.count() - 1
        let pathLat = Double(currentPath.coordinate(at: index).latitude).rounded(toPlaces: 3)
        let pathLong = Double(currentPath.coordinate(at: index).longitude).rounded(toPlaces: 3)
        return CLLocationCoordinate2D(latitude: pathLat, longitude: pathLong)
    }
    
    func updateTravelledPath(currentLoc: CLLocationCoordinate2D){
        
        var index = 0
        let oldPath =  self.currentPolyLine.path ?? GMSPath()
        
        for i in 0..<oldPath.count(){
            let pathLat = Double(oldPath.coordinate(at: i).latitude).rounded(toPlaces: 3)
            let pathLong = Double(oldPath.coordinate(at: i).longitude).rounded(toPlaces: 3)
            
            let currentLat = Double(currentLoc.latitude).rounded(toPlaces: 3)
            let currentLong = Double(currentLoc.longitude).rounded(toPlaces: 3)
            
            if currentLat == pathLat && currentLong == pathLong{
                index = Int(i)
                break   //Breaking the loop when the index found
            }
        }
        
        //Creating new path from the current location to the destination
        let newPath = GMSMutablePath()
        for i in index..<Int(oldPath.count()){
            newPath.add(oldPath.coordinate(at: UInt(i)))
        }
        
        currentPolyLine.map = nil
        currentPolyLine = nil
        self.currentPolyLine = GMSPolyline(path: newPath)
        self.currentPolyLine.strokeColor = polyLineColor ?? .darkGray
        self.currentPolyLine.strokeWidth = 3.0
        self.currentPolyLine.map = self
    }
    
    
    func locationOutOfRoute(drawnPolyLine:GMSPolyline,location:CLLocationCoordinate2D) -> Bool {
        
        if GMSGeometryIsLocationOnPathTolerance(location, drawnPolyLine.path ?? GMSPath(), true, 150) {
            print("Inside polyline")
            return true
        } else {
            print("Outside polyline")
            return false
        }
    }
    
    func saveLocationDataToDB(location: CLLocationCoordinate2D) { //for Distance calculation
    
        let locationDetail = XLocation(context: DataBaseManager.shared.persistentContainer.viewContext)
        locationDetail.latitude  = location.latitude
        locationDetail.longitude = location.longitude
        DataBaseManager.shared.saveContext()
    }
    
    func sendDataToSocket(location: CLLocationCoordinate2D) {  //for sending data location data to socket
        guard let providerDetail = AppManager.share.getUserDetails() else {
            return
        }
        //room_{COMPANY_ID}_R{REQUEST_ID}_{TRANSPORT}
        guard let requestId = tempRequestId else {
            return
        }
        guard let compayId = providerDetail.service?.company_id else {
            return
        }
        let room = "room_\(compayId)_R\(requestId)_\(tempRequestType?.rawValue ?? String.Empty)"
        let inputDic = [Constant.latitude: location.latitude,
                        Constant.longitude: location.longitude,
                        Constant.room: room] as [String : Any]
        XSocketIOManager.sharedInstance.sendCurrentLocationToSocket(input: inputDic)
    }
    
    //MARK: Marker Bearing
    func currentLocationMarkerMovement(location:CLLocationCoordinate2D) {
        if location.latitude == 0 || location.longitude == 0 {
            return
        }
        print("Moving \(location)")
        if let _ = currentLocationMarker {
//          currentLocationMarker.position = currentLocation.coordinate
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0)
            currentLocationMarker.position = currentLocation.coordinate
            CATransaction.commit()
            if let oldCoordinate = pastCoordinate{
                self.carMovement?.arCarMovement(marker: currentLocationMarker, oldCoordinate: oldCoordinate, newCoordinate: currentLocation.coordinate, mapView: self, bearing: 0)

                
            }
            pastCoordinate = currentLocation.coordinate
        } else {
            self.setCurrentLocationMarkerPosition(coordinate: currentLocation.coordinate)
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension XMapView: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        print("Location: \(currentLocation)")
         CATransaction.begin()
         CATransaction.setAnimationDuration(2.0)
         if currentLocationMarker != nil {
         currentLocationMarker.position = currentLocation.coordinate
        }
         CATransaction.commit()
        //Location update to storyboard
        XCurrentLocation.shared.latitude = currentLocation.coordinate.latitude
        XCurrentLocation.shared.longitude = currentLocation.coordinate.longitude
        
        checkPolyLineBounds(currentLocation: currentLocation.coordinate)
        currentLocationMarkerMovement(location: currentLocation.coordinate)
        
        DispatchQueue.main.async {
            self.showCurrentLocation()
        }
        
        if self.sourceMarker != nil || self.currentLocationMarker != nil {
            self.sendDataToSocket(location: currentLocation.coordinate)
        }
        if let _ = self.destinationMarker {
            self.saveLocationDataToDB(location: currentLocation.coordinate)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            ToastManager.show(title: "Based on the current location we will fetch the nearby providers please enable the location to proceed further", state: .error)
        case .denied:
            ToastManager.show(title: "Based on the current location we will fetch the nearby providers please enable the location to proceed further", state: .error)
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            print("unknown")
        }
    }
}

//MARK:- GMSMapViewDelegate

extension XMapView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        self.didDragMap?(gesture)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.didDragMap?(false)
    }
    
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        print("Tilt Loaded")
//        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
//        })
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        print("Snapshot Loaded")

    }
}

//MARK: - XCarMovementDelegate

extension XMapView: XCarMovementDelegate {
    
    func arCarMovementMoved(_ marker: GMSMarker) {
        self.currentLocationMarker = marker
    }
}
