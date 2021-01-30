//
//  CourierHomeController.swift
//  GoJekProvider
//
//  Created by Sudar on 03/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import CoreLocation
import SDWebImage

class CourierHomeController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var locationBGView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var labeldropLocation: UILabel!
    @IBOutlet weak var labeldropLocationValue: UILabel!
    @IBOutlet weak var buttonNavigation: UIButton!
    
    // MARK: - LocalVariable
    private var courierRequestStatusView: CourierRequestStatusView?
    private var courierInvoiceView: CourierInvoiceView?
    
    private var courierOTPView: CourierOTPView?
    private var courierInvoice : CourierFlowInvoiceView?
    private var courierRating: CourierRatingView?
    private var tableView: CustomTableView?
    private var courierCheckRquestData: CourierCheckRequestData?
    private var waitingTimeView : WaitingTimeView?
    
    private var xmapView: XMapView?
    var reasonData: [ReasonData]?
    var isInvoiceShowed = 1
    var isFromWaitingResponse = false
    
    var currentLocationImages = UIImageView()
    //push notification redirection
    var isChatAlreadyPresented:Bool = false
    var isAppFrom =  false
    var currentRequestId = 0
    var isInvoiceShown = false
    var currentDelivery : DeliveryEntity?
    
     var lat = 0.0
     var long = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidSetup()
        isAppFrom = true
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addMapView()
        navigationController?.navigationBar.isHidden = true
        hideTabBar()
        BackGroundRequestManager.share.resetBackGroudTask()
        isChatAlreadyPresented = false
        dotView.setCornerRadius()
        socketAndBgTaskSetUp()
    }
    
    @objc private func enterForeground() {
        
        if let _ = courierCheckRquestData {
            courierCheckRquestData = nil
        }
        isAppFrom = false
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        xmapView?.frame = mapView.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeMapView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension CourierHomeController
{
    private func viewDidSetup() {
        FLocationManager.shared.start { (info) in
                          print(info.longitude ?? 0.0)
                          print(info.latitude ?? 0.0)
                          self.lat = info.latitude ?? 0.0
                          self.long = info.longitude ?? 0.0
                      }
        
        currentLocationImages.image = UIImage(named: TaxiConstant.car_marker)?.resizeImage(newWidth: 30)
        currentLocationButton.setCornerRadius()
        if  CommonFunction.checkisRTL() {
            buttonNavigation.setImage(UIImage.init(named: Constant.back)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }else {
            buttonNavigation.setImage(UIImage.init(named: Constant.back), for: .normal)
        }
        buttonNavigation.tintColor = .blackColor
        courierPresenter?.getReasons(param: [XuberConstant.type: TaxiConstant.transport])
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonAction), for: .touchUpInside)
        buttonNavigation.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        currentLocationButton.setImage(UIImage.init(named: TaxiConstant.currentLocationImage), for: .normal)
        
        //For chat
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_transport.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat.rawValue), object: nil)
        mapView.backgroundColor = .backgroundColor
    }
    
    @objc private func isChatPushRedirection(){
        if isChatAlreadyPresented == false {
            if isAppFrom == true {
                self.navigateToChatView()
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.navigateToChatView()
                }
            }
            isChatAlreadyPresented = true
        }
    }
    
    @objc func currentLocationButtonAction(_ sender: UIButton) {
        xmapView?.showCurrentLocation()
    }
    
    private func navigateToChatView() {
        
        let providerDetail = courierCheckRquestData?.providerDetails
        let userDetail = courierCheckRquestData?.request?.user
        let chatView = ChatViewController()
        chatView.requestId = "\(tempRequestId ?? "0")"
        chatView.chatRequestFrom = DocumentType.delivery.rawValue
        chatView.userId = "\((userDetail?.id) ?? 0)"
        chatView.userName = "\( userDetail?.firstName ?? .Empty)" + " " + "\(userDetail?.lastName ?? .Empty)"
        chatView.providerId = "\((providerDetail?.id) ?? 0)"
        chatView.providerName = "\(providerDetail?.firstName ?? .Empty)" + " " +  "\(providerDetail?.lastName ?? .Empty)"
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    func socketAndBgTaskSetUp() {
        
        print("Try to Connect private room \(String(describing: XSocketIOManager.sharedInstance.connectedWithRoom))")
        if let requestData = courierCheckRquestData,requestData.request?.id ?? 0 > 0 {
            
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId:  SocketUtitils.construtRoomKey(requestID: "\(requestData.request?.id ?? 0)", serviceType: .delivery), listener: .Delivery)
            BackGroundRequestManager.share.requestCallback =  { [weak self] in
                guard let self = self else {
                    return
                }
                self.checkRequestApiCall()
            }
        }
        else {
            print("private room not connected")
            checkRequestApiCall()
        }
    }
    
    private func checkRequestApiCall(){
        courierPresenter?.checkRequest(param: nil)
    }
    
    private func updateRideDetails(rideDetails: CourierCheckRequestData) {
        
        let requestDetail = courierCheckRquestData?.request
        let destinationLocation = CLLocationCoordinate2D.init(latitude: requestDetail?.delivery?.dLatitude ?? 0.0, longitude: requestDetail?.delivery?.dLongitude ?? 0.0)
        let sourceLocation = CLLocationCoordinate2D(latitude: requestDetail?.sLatitude ?? 0, longitude: requestDetail?.sLongitude ?? 0)
        
        if courierCheckRquestData?.request == nil {
            navigationController?.popViewController(animated: true)
            return
        }
        if requestDetail?.payment?.tips != 0.0 {
            NotificationCenter.default.post(name: Notification.Name("InvoiceDetailUpdate"), object: nil, userInfo: ["data": courierCheckRquestData as Any])
        }
        
        //For location update
        tempRequestId = "\(courierCheckRquestData?.request?.id ?? 0)"

        let eachDeliveryRequest = courierCheckRquestData?.request?.delivery
        if (eachDeliveryRequest?.status != TravelState.completed.rawValue)
        {
            self.currentDelivery = eachDeliveryRequest
            
        }
        
        currentRequestId =  self.currentDelivery?.id ?? 0
        
        tempRequestType = .delivery
        
        //        let markerUrl = URL(string: courierCheckRquestData?.request?.rideDetail?.vehicle_marker ?? "")
        //        currentLocationImages.sd_setImage(with: markerUrl, placeholderImage: UIImage(named: TaxiConstant.car_marker)?.resizeImage(newWidth: 30),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        //            // Perform operation.
        //            if (error != nil) {
        //                // Failed to load image
        //                self.xmapView?.currentLocationMarkerImage = UIImage(named: TaxiConstant.car_marker)?.resizeImage(newWidth: 30)
        //
        //            } else {
        //                // Successful in loading image
        //                self.xmapView?.currentLocationMarkerImage = image?.resizeImage(newWidth: 30)
        //                self.xmapView?.setCurrentLocationMarkerPosition(coordinate: XCurrentLocation.shared.coordinate)
        //            }
        //        })
        
        xmapView?.isVisibleCurrentLocation(visible: false)
        let mainRequestStatus = (courierCheckRquestData?.request?.status)
        let currentDeliveryRequest = (courierCheckRquestData?.request?.delivery)
        
        
        switch mainRequestStatus {
            
        case TravelState.started.rawValue,TravelState.accepted.rawValue:
            
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: XCurrentLocation.shared.coordinate, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: sourceLocation, marker: UIImage(named: Constant.destinationPinImage) ?? UIImage())
                self.xmapView?.removePolylines()
                self.xmapView?.drawPolyLineFromSourceToDestination(source: XCurrentLocation.shared.coordinate, destination: sourceLocation, lineColor: .taxiColor)
            }
            showCourierHomeView()
            self.labeldropLocation.text = CourierConstant.pickupLocation
            self.labeldropLocationValue.text = courierCheckRquestData?.request?.sAddress
            break
        case TravelState.arrived.rawValue:
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: sourceLocation, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: destinationLocation, marker: UIImage(named: Constant.destinationPinImage) ?? UIImage())
                self.xmapView?.removePolylines()
                self.xmapView?.drawPolyLineFromSourceToDestination(source: sourceLocation, destination: destinationLocation, lineColor: .taxiColor)
            }
           
            self.labeldropLocation.text = CourierConstant.pickupLocation
            self.labeldropLocationValue.text = courierCheckRquestData?.request?.sAddress
            if let requestDetails = courierCheckRquestData?.request {
                if requestDetails.payment_by == "SENDER" {
                    if requestDetails.paid == nil || requestDetails.paid?.toString() == String.Empty {
                        showInvoicePage()
                    }else if let paid = requestDetails.paid, paid == 0 {
                        showInvoicePage()
                    } else if let useWallet = requestDetails.useWallet, useWallet == isInvoiceShowed {
                        showInvoicePage()
                        isInvoiceShowed = 0
                    }
                }else{
                    self.labeldropLocation.text = CourierConstant.dropLocation
                    self.labeldropLocationValue.text = currentDeliveryRequest?.dAddress
                    if requestDetails.delivery?.status ==  TravelState.droped.rawValue {
                        if requestDetails.paid == nil || requestDetails.paid?.toString() == String.Empty {
                            showInvoicePage()
                        }else if let paid = requestDetails.paid, paid == 0 {
                            showInvoicePage()
                        } else if let useWallet = requestDetails.useWallet, useWallet == isInvoiceShowed {
                            showInvoicePage()
                            isInvoiceShowed = 0
                        }
                    }else{
                        showCourierHomeView()
                    }
                }
            }
            
            break
        case TravelState.pickedup.rawValue:
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: sourceLocation, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: destinationLocation, marker: UIImage(named: Constant.destinationPinImage) ?? UIImage())
                self.xmapView?.removePolylines()
                self.xmapView?.drawPolyLineFromSourceToDestination(source: sourceLocation, destination: destinationLocation, lineColor: .taxiColor)
            }
            showCourierHomeView()
            self.labeldropLocation.text = CourierConstant.dropLocation
            self.labeldropLocationValue.text = currentDeliveryRequest?.dAddress
            
            break
        case TravelState.droped.rawValue:
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: sourceLocation, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: destinationLocation, marker: UIImage(named: Constant.destinationPinImage) ?? UIImage())
                self.xmapView?.removePolylines()
                self.xmapView?.drawPolyLineFromSourceToDestination(source: sourceLocation, destination: destinationLocation, lineColor: .taxiColor)
            }
            if let requestDetails = courierCheckRquestData?.request {
                
                if requestDetails.delivery?.status ==  TravelState.droped.rawValue {
                    if requestDetails.paid == nil || requestDetails.paid?.toString() == String.Empty {
                        showInvoicePage()
                    }else if let paid = requestDetails.paid, paid == 0 {
                        showInvoicePage()
                    } else if let useWallet = requestDetails.useWallet, useWallet == isInvoiceShowed {
                        showInvoicePage()
                        isInvoiceShowed = 0
                    }
                }
            }
            
            showCourierHomeView()
            
            self.labeldropLocation.text = CourierConstant.dropLocation
            self.labeldropLocationValue.text = currentDeliveryRequest?.dAddress
            
            break
            
        case TravelState.completed.rawValue:
            self.locationBGView.isHidden = true
            
            if let _ = courierRequestStatusView {
                courierRequestStatusView?.removeFromSuperview()
            }
            if let requestDetails = courierCheckRquestData?.request {
                if requestDetails.paid == nil || requestDetails.paid?.toString() == String.Empty {
                    showInvoicePage()
                }else if let paid = requestDetails.paid, paid == 0 {
                    showInvoicePage()
                } else if let useWallet = requestDetails.useWallet, useWallet == isInvoiceShowed {
                    showInvoicePage()
                    isInvoiceShowed = 0
                }
                else if let providerRate = requestDetails.providerRated, providerRate == 0  {
                    if mainRequestStatus == TravelState.completed.rawValue {
                        DispatchQueue.main.async {
                            self.showCourierRatingView()
                            DataBaseManager.shared.delete(entityName: CoreDataEntity.location.rawValue)
                        }
                    }
                }
            }
            
        default:
            self.locationBGView.isHidden = true
            if currentDeliveryRequest?.paid == 0 {
                showInvoicePage()
            }else {
                if !isInvoiceShown {
                    showInvoicePage()
                }else{
                    self.showCourierRatingView()
                }
            }
            DispatchQueue.main.async {
                // self.showCourierRatingView()
                self.updateCourierProviderDetail()
                DataBaseManager.shared.delete(entityName: CoreDataEntity.location.rawValue)
            }
            break
        }
    }
    
    private func addMapView() {
        xmapView = XMapView(frame: mapView.bounds)
        xmapView?.tag = 100
        guard let _ = xmapView else {
            return
        }
        mapView.addSubview(xmapView!)
        xmapView?.didDragMap = { [weak self] (isDrag) in
            guard let self = self else {
                return
            }
            self.courierRequestStatusView?.isHidden = isDrag
        }
//        self.xmapView?.currentLocationMarkerImage = self.currentLocationImages.image
    }
    
    private func removeMapView() {
        DispatchQueue.main.async {
            for subView in self.mapView.subviews where subView.tag == 100 {
                subView.removeFromSuperview()
                self.xmapView?.clearAll()
                self.xmapView = nil
            }
        }
    }
    
    //Navigation back button action
    @objc func tapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


extension CourierHomeController {
    
    private func getCourierRequestView() -> CourierRequestStatusView? {
        guard let _ = courierRequestStatusView else{
            if let courierRequestView = Bundle.main.loadNibNamed(CourierConstant.CourierRequestStatusView, owner: self, options: [:])?.first as? CourierRequestStatusView {
                courierRequestView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(courierRequestView)
                self.courierRequestStatusView = courierRequestView
                courierRequestView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                courierRequestView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                courierRequestView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                courierRequestView.show(with: .right, completion: nil)
                courierRequestView.layoutIfNeeded()
            }
            return courierRequestStatusView
        }
        return courierRequestStatusView
    }
    
    private func getCourierInvoiceView() -> CourierInvoiceView? {
        guard let _ = courierInvoiceView else{
            if let courierInvoice = Bundle.main.loadNibNamed(CourierConstant.CourierInvoiceView, owner: self, options: [:])?.first as? CourierInvoiceView {
                courierInvoice.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(courierInvoice)
                self.courierInvoiceView = courierInvoice
                courierInvoice.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                courierInvoice.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                courierInvoice.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                courierInvoice.show(with: .right, completion: nil)
                courierInvoice.layoutIfNeeded()
            }
            return courierInvoiceView
        }
        return courierInvoiceView
    }
    
    //Show the taxi home view with all request detail
    private func showCourierHomeView() {
        if let _ = courierInvoice {
            courierInvoice?.removeFromSuperview()
        }
        
        
        
        
        guard var rideStatus = courierCheckRquestData?.request?.status else { return }
        guard let deliveryStatus = self.currentDelivery?.status else { return }
        
        if deliveryStatus == TravelState.droped.rawValue{
            rideStatus = deliveryStatus
        }
        DispatchQueue.main.async {
            self.changeCourierUIBasedOnStatus(status: rideStatus)
            self.updateCourierProviderDetail()
        }
    }
    
    private func changeCourierUIBasedOnStatus(status: String){
        
        providerDetailsViewInitalSetup()
        guard let courierRequestView = courierRequestStatusView else { return}
        
        let isFirstRequest = courierCheckRquestData?.request?.delivery?.paid == 0
        
        switch status {
        case TravelState.started.rawValue:
            courierRequestView.pickupImage.image = UIImage.init(named: CourierConstant.locatorImage)
            courierRequestView.dropImage.image = UIImage.init(named: CourierConstant.carImage)
            courierRequestView.finishImage.image = UIImage.init(named: CourierConstant.flagImage)
            courierRequestView.buttonArrived.isHidden = false
            courierRequestView.buttonRecieved.isHidden = true
            courierRequestView.buttonDelivered.isHidden = true
            courierRequestView.buttonStart.isHidden = true
            courierRequestView.buttonReached.isHidden = true
        case TravelState.arrived.rawValue:
            courierRequestView.buttonArrived.isHidden = true
            courierRequestView.buttonRecieved.isHidden = true
            courierRequestView.buttonDelivered.isHidden = true
            courierRequestView.buttonStart.isHidden = true
            courierRequestView.buttonReached.isHidden = false
            courierRequestView.pickupImage.image = UIImage.init(named: CourierConstant.darkLocatorImage)
            courierRequestView.dropImage.image = UIImage.init(named: CourierConstant.carImage)
            courierRequestView.finishImage.image = UIImage.init(named: CourierConstant.flagImage)
            
        case TravelState.pickedup.rawValue:
            courierRequestView.pickupImage.image = UIImage.init(named: CourierConstant.darkLocatorImage)
            courierRequestView.dropImage.image = UIImage.init(named: CourierConstant.carImage)
            courierRequestView.finishImage.image = UIImage.init(named: CourierConstant.flagImage)
            if ((courierCheckRquestData?.request?.delivery) != nil)
            {
                if (status == TravelState.pickedup.rawValue && currentDelivery?.status == "PROCESSING")
                {
                    
                    courierRequestView.buttonRecieved.isHidden = true
                    courierRequestView.buttonArrived.isHidden = true
                    courierRequestView.buttonDelivered.isHidden = true
                    courierRequestView.buttonStart.isHidden = false
                    courierRequestView.buttonReached.isHidden = true
                    
                }else if (status == TravelState.pickedup.rawValue && currentDelivery?.status == "STARTED")
                {
                    courierRequestView.buttonRecieved.isHidden = isFirstRequest == true ? false : true
                    courierRequestView.buttonArrived.isHidden = true
                    courierRequestView.buttonDelivered.isHidden = true
                    courierRequestView.buttonStart.isHidden = true
                    courierRequestView.buttonReached.isHidden = isFirstRequest == true ? true : false
                }
            }else{
                courierRequestView.buttonRecieved.isHidden = false
                courierRequestView.buttonArrived.isHidden = true
                courierRequestView.buttonDelivered.isHidden = true
                courierRequestView.buttonReached.isHidden = true
                courierRequestView.buttonStart.isHidden = true
            }
            
        case TravelState.droped.rawValue:
            courierRequestView.pickupImage.image = UIImage.init(named: CourierConstant.darkLocatorImage)
            courierRequestView.dropImage.image = UIImage.init(named: CourierConstant.darkCarImage)
            courierRequestView.finishImage.image = UIImage.init(named: CourierConstant.flagImage)
            courierRequestView.buttonArrived.isHidden = true
            courierRequestView.buttonRecieved.isHidden = true
            courierRequestView.buttonDelivered.isHidden = false
            courierRequestView.buttonReached.isHidden = true
            courierRequestView.buttonStart.isHidden = true
        default:
            courierRequestView.buttonArrived.isHidden = true
            courierRequestView.buttonRecieved.isHidden = true
            courierRequestView.buttonDelivered.isHidden = false
            courierRequestView.buttonReached.isHidden = true
            courierRequestView.buttonStart.isHidden = true
            
            courierRequestView.pickupImage.image = UIImage.init(named: CourierConstant.darkLocatorImage)
            courierRequestView.dropImage.image = UIImage.init(named: CourierConstant.darkCarImage)
            courierRequestView.finishImage.image = UIImage.init(named: CourierConstant.flagImage)
            
            
        }
    }
    
    //Show the request detail to view
    private func updateCourierProviderDetail() {
        
        //Show taxi home view detail
        let userDetail = courierCheckRquestData?.request?.user
        DispatchQueue.main.async {
            self.courierRequestStatusView?.labelCustomerName.text = "\(userDetail?.firstName ?? String.Empty) \(userDetail?.lastName ?? String.Empty)"
        }
        self.courierRequestStatusView?.callOrChat = { sender in
            if sender == 1{
                if let phoneNumber = self.courierCheckRquestData?.request?.user?.mobile{
                    AppUtils.shared.call(to: phoneNumber)
                }
            }
            else if sender == 2{
                self.navigateToChatView()
            }
        }
        
        let userImage = URL(string: userDetail?.picture ?? "")
        
        self.courierRequestStatusView?.userImageView.sd_setImage(with: userImage, placeholderImage: UIImage(named: Constant.profile),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.courierRequestStatusView?.userImageView.image = UIImage(named: Constant.profile)
            } else {
                // Successful in loading image
                self.courierRequestStatusView?.userImageView.image = image
            }
        })
        
    }
    private func providerDetailsViewInitalSetup() {
        
        let checkTaxiViewExists = view.subviews.filter({$0.tag == 111})
        if checkTaxiViewExists.count > 0 { return }
        if let _ = getCourierRequestView() {
            courierRequestStatusView?.onClickButton = { [weak self] status in
                guard let self = self else {
                    return
                }
                guard let actionState = status else {
                    return
                }
                self.courierRequestViewButtonAction(status: actionState)
            }
        }
    }
    
    private func courierRequestViewButtonAction(status: String) {
        
        switch status {
        // show invoice Action
        case TravelState.showInVoice.rawValue:
            print("Invoice Clicked")
        case TravelState.arrived.rawValue:
            updateCourierRequestStatus(with: TravelState.arrived.rawValue)
            break
        case TravelState.pickedup.rawValue:
            // updateCourierRequestStatus(with: TravelState.pickedup.rawValue)
            
            //           showCourierOTPView()
            
            break
        case TravelState.droped.rawValue:
            updateCourierRequestStatus(with: TravelState.droped.rawValue)
            break
        case TravelState.completed.rawValue:
            updateCourierRequestStatus(with: TravelState.completed.rawValue)
        case TravelState.cancelled.rawValue:
            showCancelTable()
            break
        case TaxiConstant.GoogleMap:
            redirectToGoogleMap()
            break
        default:
            break
        }
    }
    
    //Update taxi request status
    private func updateCourierRequestStatus(with status: String) {
        if tempRequestId != "0" {
            let param: Parameters = [TaxiConstant.id: currentRequestId ,
                                     TaxiConstant.status: status,
                                     TaxiConstant.method: TaxiConstant.patch]
            courierPresenter?.updateRequest(param: param)
            //Cancel request
        }
    }
    
    private func showCancelTable() {
        if tableView == nil, let tableView = Bundle.main.loadNibNamed(Constant.CustomTableView, owner: self, options: [:])?.first as? CustomTableView {
            
            let height = (self.view.frame.height/100)*35
            tableView.frame = CGRect(x: 20, y: (self.view.frame.height/2)-(height/2), width: self.view.frame.width-40, height: height)
            tableView.heading = Constant.chooseReason.localized
            self.tableView = tableView
            self.tableView?.setCornerRadiuswithValue(value: 10.0)
            var reasonArr:[String] = []
            for reason in reasonData ?? [] {
                reasonArr.append(reason.reason ?? String.Empty)
            }
            if !reasonArr.contains(Constant.other) {
                reasonArr.append(Constant.other)
            }
            tableView.values = reasonArr
            tableView.show(with: .bottom, completion: nil)
            showDimView(view: tableView)
        }
        tableView?.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView?.superview?.dismissView(onCompletion: {
                self.tableView = nil
            })
            
            if let rideDetail = self.courierCheckRquestData {
                self.updateRideDetails(rideDetails: rideDetail)
            }
        }
        
        tableView?.selectedItem = { [weak self] selectedReason in
            guard let self = self else {
                return
            }
            self.cancelCourierRequest(reason: selectedReason)
        }
    }
    
    //Cancel API Request call
    private func cancelCourierRequest(reason: String) {
        if tempRequestId != "0" {
            let param: Parameters = [HomeConstant.id: tempRequestId ?? 0,
                                     HomeConstant.serviceId: TaxiConstant.transport,
                                     HomeConstant.reason: reason]
            courierPresenter?.cancelRequest(param: param)
        }
    }
    
    //Redirect to google map
    private func redirectToGoogleMap()
    {
        print(self.lat)
         print(self.long)
        let locationDetail = self.courierCheckRquestData?.request
        
        let baseUrl = "comgooglemaps-x-callback://"
        if UIApplication.shared.canOpenURL(URL(string: baseUrl)!) {
         //   let locationDetail = taxiCheckRquestData?.request
            var sourceAddress = ""
            
            var destinationAddr = ""
            if let response = courierCheckRquestData?.request?.status, response == TravelState.started.rawValue {
                self.xmapView?.getAdressName(latitude: self.lat, longitude: self.long , on: { (addr) in
                                   sourceAddress = addr
                               })
                destinationAddr = (locationDetail?.sAddress ?? "").replacingOccurrences(of: " ", with: "+")

            }else{
                sourceAddress = (locationDetail?.sAddress ?? "").replacingOccurrences(of: " ", with: "+")
                destinationAddr = (locationDetail?.delivery?.dAddress ?? "").replacingOccurrences(of: " ", with: "+")
            }
            
            let directionsRequest = "comgooglemaps://?saddr=\(sourceAddress)&daddr=\(destinationAddr)&directionsmode=driving"
            if let url = URL(string: directionsRequest) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        else {
            checkRequestApiCall()
            simpleAlert(view: self, title: String.Empty, message: "Can't open GoogleMap Application.", state: .error)
        }
    }
    
    //Show OTP View
    private func showCourierOTPView() {
        //OTP verify enable or not
        if self.currentDelivery?.otp == "0" || courierCheckRquestData?.request?.created_type?.uppercased() == Constant.admin.uppercased(){
            updateCourierRequestStatus(with: TravelState.droped.rawValue)
        }
        else {
            
            if self.courierOTPView == nil, let courierOTPView = Bundle.main.loadNibNamed(CourierConstant.CourierOTPView, owner: self, options: [:])?.first as? CourierOTPView {
                
                courierOTPView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
                self.courierOTPView = courierOTPView
                view.addTransparent(with: courierOTPView)
                self.courierOTPView?.responseOTP =  "\(courierCheckRquestData?.request?.delivery?.otp ?? String.Empty)"
                courierOTPView.show(with: .bottom, completion: nil)
            }
            
            //Taxi view dismiss closure
            courierOTPView?.onClickStartTripButton = { [weak self] in
                guard let self = self else {
                    return
                }
                self.courierOTPView?.superview?.removeFromSuperview()
                self.courierOTPView?.dismissView(onCompletion: {
                    self.courierOTPView = nil
                    self.updateCourierRequestStatus(with: TravelState.droped.rawValue)
                })
            }
        }
    }
    
    //Show invoice view
    
    
    private func getInvoiceView() -> CourierFlowInvoiceView?{
        guard let _ = self.courierInvoice else {
            if let courierInvoice = Bundle.main.loadNibNamed(CourierConstant.CourierFlowInvoiceView, owner: self, options: [:])?.first as? CourierFlowInvoiceView {
                self.view.addSubview(courierInvoice)
                courierInvoice.translatesAutoresizingMaskIntoConstraints = false
                courierInvoice.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
                courierInvoice.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                courierInvoice.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                courierInvoice.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                courierInvoice.show(with: .bottom, completion: nil)
                courierInvoice.layoutIfNeeded()
                self.courierInvoice = courierInvoice
            }
            return courierInvoice
        }
        return self.courierInvoice
}
    
    private func showInvoicePage() {
        
        if let _ = self.getInvoiceView() {
            
            self.courierInvoice?.requestData = self.courierCheckRquestData
            let requestDetail = self.courierCheckRquestData?.request
//            self.courierInvoice?.setValues(values: self.courierCheckRquestData,data: requestDetail?.payment_by != "RECEIVER")
            if let data = requestDetail?.delivery,let request = self.courierCheckRquestData {
            self.courierInvoice?.setValues(values: request, data: data, isSenderPay: true)
            }
            self.courierInvoice?.onClickConfirm = {
                self.courierRating?.superview?.removeFromSuperview()
                
                self.courierInvoice?.dismissView(onCompletion: {
                    self.courierInvoice?.removeFromSuperview()
                    self.courierInvoice = nil
                    let requestDetail = self.courierCheckRquestData?.request
                    if requestDetail?.payment_by != "RECEIVER"{
                        self.showCourierHomeView()
                    }
                })
                
                if requestDetail?.payment_by == "RECEIVER"{
                    self.updateCourierRequestStatus(with: TravelState.completed.rawValue)
                    
                }else{
                    if requestDetail?.payment?.paymentMode == "CARD" {
                        print("dfdngfhdf")
                    }else{
                        self.updateCourierRequestStatus(with: TravelState.payment.rawValue)

                    }
                }
            }
        }
    }
    
    //Show Courier rating view
    private func showCourierRatingView() {
        self.locationBGView.isHidden = true
        if let _ = courierInvoice {
            courierInvoice?.removeFromSuperview()
        }
        
        let requestDetail = self.courierCheckRquestData?.request
        
        if requestDetail?.payment_by != "RECEIVER"{
            
            if let _ = courierRequestStatusView {
                courierRequestStatusView?.removeFromSuperview()
            }
        }
        if courierRating == nil, let courierRatingView = Bundle.main.loadNibNamed(CourierConstant.CourierRatingView, owner: self, options: [:])?.first as? CourierRatingView {
            
            courierRatingView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.courierRating = courierRatingView
            self.view.addTransparent(with: courierRatingView)
            courierRatingView.show(with: .bottom, completion: nil)
        }
        
        courierRating?.setValues(values: courierCheckRquestData?.request)
        courierRating?.onClickSubmit = { [weak self] in
            guard let self = self else {
                return
            }
            self.courierRating?.superview?.removeFromSuperview()
            self.courierRating?.dismissView(onCompletion: {
                //Update rating and comments API
                let comments = self.courierRating?.commentsTextView.text
                let requestDetail = self.courierCheckRquestData?.request
                let param: Parameters = [TaxiConstant.id: requestDetail?.id ?? 0,
                                         TaxiConstant.rating: Int(self.courierRating?.ratingView.rating ?? 1),
                                         TaxiConstant.comment: comments == Constant.leaveComment ? String.Empty : (comments ?? String.Empty),
                                         TaxiConstant.adminServiceId: TaxiConstant.transport]
                self.courierPresenter?.providerRating(param: param)
            })
        }
    }
}

extension CourierHomeController : CourierPresenterToCourierViewProtocol {
    
    func cancelRequestResponse(taxiEntity: CourierEntity) {
        if let _ = courierCheckRquestData {
            courierCheckRquestData =  nil
        }
        DispatchQueue.main.async {
            BackGroundRequestManager.share.resetBackGroudTask()
            self.xmapView?.clearAll()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateRequestResponse(taxiEntity: CourierEntity) {
        if let response = courierCheckRquestData?.request?.status, response == TravelState.started.rawValue {
            DispatchQueue.main.async {
                self.xmapView?.clearAll()
            }
        }
        checkRequestApiCall()
    }
    
    func paymentRequestResponse(taxiEntity: PaidEntity) {
        self.showCourierRatingView()
    }
    
    func providerRatingResponse(taxiEntity: CourierEntity) {
        if let _ = courierRating {
            courierRating =  nil
        }
        xmapView?.clearAll()
        BackGroundRequestManager.share.resetBackGroudTask()
        ToastManager.show(title: Constant.RatingToast, state: .success)
        courierCheckRquestData = taxiEntity.responseData
        navigationController?.popViewController(animated: true)
    }
    
    // get cancel reasons
    func getReasonsResponse(reasonEntity: ReasonEntity) {
        reasonData = reasonEntity.responseData ?? []
    }
    
    func checkRequestResponse(taxiEntity: CourierEntity) {
        DispatchQueue.main.async {
            if let response = taxiEntity.responseData {
                self.courierCheckRquestData = response
                self.updateRideDetails(rideDetails: response)
                if let _ = response.request {
                    self.socketAndBgTaskSetUp()
                }
            }
        }
    }
    
}
