//
//  TaxiHomeViewController.swift
//  GoJekProvider
//
//  Created by apple on 06/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import CoreLocation
import SDWebImage

class TaxiHomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var airportQueueBtn: UIButton!
    
    // MARK: - LocalVariable
    private var taxiHomeView: TaxiHomeView?
    private var taxiOTPView: TaxiOTPView?
    private var taxiRatingView: TaxiRatingView?
    private var taxiTollChargeView: TollChargeView?
    private var tableView: CustomTableView?
    private var taxiCheckRquestData: TaxiCheckRequestData?
    private var waitingTimeView : WaitingTimeView?
    
    private var xmapView: XMapView?
    
    var watingTimeTimer: Timer?
    private var sosButton: UIButton?
    private var floatyButton: FloatyButton?
    
    var reasonData: [ReasonData]?
    var isWaitingTimeOn = true
    var waitingTime = 0
    var isInvoiceShowed = 1
    var isFromWaitingResponse = false
    var currentLocationImage = UIImageView()
    var currentLocationImages = UIImageView()
    
    //push notification redirection
      var isChatAlreadyPresented:Bool = false
    var isAppFrom =  false
    var otpStr:String = ""
    var lat = 0.0
    var long = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewDidSetup()
        isAppFrom = true
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addMapView()
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.async {
            self.hideTabBar()
        }
        BackGroundRequestManager.share.resetBackGroudTask()
        isChatAlreadyPresented = false

        socketAndBgTaskSetUp()
    }
    
    @objc private func enterForeground() {
        
        if let _ = taxiCheckRquestData {
            taxiCheckRquestData = nil
        }
        isAppFrom = false
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        xmapView?.frame = mapView.bounds
        DispatchQueue.main.async {
            self.sosButton?.setCornerRadius()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeMapView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - LocalMethod

extension TaxiHomeViewController {
    
    private func viewDidSetup() {
        backButton.isHidden = true
        backButton.setCornerRadius()
        locationButton.setCornerRadius()
        if  CommonFunction.checkisRTL() {
            backButton.setImage(UIImage.init(named: Constant.back)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }else {
            backButton.setImage(UIImage.init(named: Constant.back), for: .normal)
        }
        locationButton.setImage(UIImage.init(named: TaxiConstant.currentLocationImage), for: .normal)
        
        locationButton.addTarget(self, action: #selector(currentLocationButtonAction(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        airportQueueBtn.addTarget(self, action:  #selector(airportQueueAction(_:)), for: .touchUpInside)
        airportQueueBtn.setCornorRadius()
        airportQueueBtn.backgroundColor = .red
        airportQueueBtn.setImage(UIImage.init(named: TaxiConstant.ic_airportQueue), for: .normal)
        currentLocationImages.image = UIImage(named: TaxiConstant.car_marker)?.resizeImage(newWidth: 30)
        taxiPresenter?.getReasons(param: [XuberConstant.type: TaxiConstant.transport])
        setCustomColor()
        floatyButton?.isHidden = true
        sosButton?.isHidden = true
        //For chat
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_transport.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat.rawValue), object: nil)
        
        currentLocationImage.image = UIImage(named: TaxiConstant.car_marker)?.resizeImage(newWidth: 25)
        FLocationManager.shared.start { (info) in
                   print(info.longitude ?? 0.0)
                   print(info.latitude ?? 0.0)
                   self.lat = info.latitude ?? 0.0
                   self.long = info.longitude ?? 0.0
               }
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
    
    private func setCustomColor() {
        locationButton.imageView?.setImageColor(color: .black)
        locationButton.backgroundColor = .white
        backButton.backgroundColor = .white
        backButton.imageView?.setImageColor(color: .black)
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
            self.taxiHomeView?.isHidden = isDrag
        }
        self.xmapView?.currentLocationMarkerImage = self.currentLocationImage.image
        mapView.bringSubviewToFront(floatyButton ?? UIButton()) // bring to front view if goes to chat and come back in between flow
        mapView.bringSubviewToFront(sosButton ?? UIButton())
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
    
    private func setMenuButton() {
        if let _ = getSosButton() {
            sosButton?.accessibilityIdentifier = "SOS"
            sosButton?.setTitle(TaxiConstant.sos, for: .normal)
            sosButton?.addTarget(self, action: #selector(sosButtonAction(_:)), for: .touchUpInside)
            
            sosButton?.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x14)
            sosButton?.setTitleColor(.white, for: .normal)
            sosButton?.backgroundColor = .black
        }
        if let _ = getFloatyView() {
            floatyButton?.buttonOneImage = UIImage(named: Constant.phoneImage)?.imageTintColor(color: .white) ?? UIImage()
            floatyButton?.buttonTwoImage = UIImage(named: Constant.chatImage)?.imageTintColor(color: .white) ?? UIImage()
            floatyButton?.bgColor = .taxiColor
            floatyButton?.backgroundColor = .black
            floatyButton?.onTapButtonOne = { [weak self] in //Phone
                guard let self = self else {
                    return
                }
                if let phoneNumber = self.taxiCheckRquestData?.request?.user?.mobile {
                    AppUtils.shared.call(to: phoneNumber)
                }
            }
            floatyButton?.onTapButtonTwo = { [weak self] in //Chat
                guard let self = self else {
                    return
                }
                self.navigateToChatView()
            }
        }
    }
    
    private func navigateToChatView() {
        
        let providerDetail = taxiCheckRquestData?.providerDetails
        let userDetail = taxiCheckRquestData?.request?.user
        let chatView = ChatViewController()
        chatView.requestId = "\(tempRequestId ?? "0")"
        chatView.chatRequestFrom = DocumentType.transport.rawValue
        chatView.userId = "\((userDetail?.id) ?? 0)"
        chatView.userName = "\( userDetail?.firstName ?? .Empty)" + " " + "\(userDetail?.lastName ?? .Empty)"
        chatView.providerId = "\((providerDetail?.id) ?? 0)"
        chatView.providerName = "\(providerDetail?.firstName ?? .Empty)" + " " +  "\(providerDetail?.lastName ?? .Empty)"
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    private func getFloatyView() -> FloatyButton? {
        guard let _ = floatyButton else {
            floatyButton = FloatyButton()
            mapView.addSubview(floatyButton ?? UIView())
            if  let taxiView = taxiHomeView {
                floatyButton?.translatesAutoresizingMaskIntoConstraints = false
                floatyButton?.bottomAnchor.constraint(equalTo: taxiView.topAnchor, constant: -10).isActive = true
                floatyButton?.rightAnchor.constraint(equalTo: taxiView.rightAnchor, constant: -10).isActive = true
                floatyButton?.heightAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
                floatyButton?.widthAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
            }
            return floatyButton
        }
        return floatyButton
    }
    
    private func getSosButton() -> UIButton? {
        guard let _ = sosButton else {
            sosButton = UIButton()
            mapView.addSubview(sosButton ?? UIButton())
            if  let taxiView = taxiHomeView {
                sosButton?.translatesAutoresizingMaskIntoConstraints = false
                sosButton?.bottomAnchor.constraint(equalTo: taxiView.topAnchor, constant: -10).isActive = true
                sosButton?.leftAnchor.constraint(equalTo: taxiView.leftAnchor, constant: 10).isActive = true
                sosButton?.heightAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
                sosButton?.widthAnchor.constraint(equalTo: taxiView.widthAnchor, multiplier: 0.12).isActive = true
            }
            
            return sosButton
        }
        return sosButton
    }
    
    func socketAndBgTaskSetUp() {
        
        print("Try to Connect private room \(String(describing: XSocketIOManager.sharedInstance.connectedWithRoom))")
        if let requestData = taxiCheckRquestData,requestData.request?.id ?? 0 > 0 {
            
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId:  SocketUtitils.construtRoomKey(requestID: "\(requestData.request?.id ?? 0)", serviceType: .transport), listener: .Transport)
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
    
    private func checkRequestApiCall() {
        
        taxiPresenter?.checkRequest(param: nil)
    }
    
    private func updateRideDetails(rideDetails: TaxiCheckRequestData) {
        
        let requestDetail = taxiCheckRquestData?.request
        let destinationLocation = CLLocationCoordinate2D.init(latitude: requestDetail?.dLatitude ?? 0.0, longitude: requestDetail?.dLongitude ?? 0.0)
        let sourceLocation = CLLocationCoordinate2D(latitude: requestDetail?.sLatitude ?? 0, longitude: requestDetail?.sLongitude ?? 0)
        
   // let locationDetail = self.taxiCheckRquestData?.request
        
        if taxiCheckRquestData?.request == nil {
            navigationController?.popViewController(animated: true)
            return
        }
        if requestDetail?.payment?.tips != 0.0 {
            NotificationCenter.default.post(name: Notification.Name("InvoiceDetailUpdate"), object: nil, userInfo: ["data": taxiCheckRquestData as Any])
        }

        self.xmapView?.currentLocationMarkerImage = self.currentLocationImage.image
        
        //For location update
        tempRequestId = "\(taxiCheckRquestData?.request?.id ?? 0)"
        tempRequestType = .transport
        
        xmapView?.isVisibleCurrentLocation(visible: false)
        let currentTravelState = (taxiCheckRquestData?.request?.status)
        switch currentTravelState {
        case TravelState.started.rawValue:
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: XCurrentLocation.shared.coordinate, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: sourceLocation, marker: UIImage(named: Constant.destinationPinImage) ?? UIImage())
                self.xmapView?.drawPolyLineFromSourceToDestination(source: XCurrentLocation.shared.coordinate, destination: sourceLocation, lineColor: .taxiColor)
            }
            showTaxiHomeView()
            floatyButton?.isHidden = false
            sosButton?.isHidden = false
            break
        case TravelState.arrived.rawValue:
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: sourceLocation, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: destinationLocation, marker: UIImage(named: Constant.destinationPinImage) ?? UIImage())
                self.xmapView?.drawPolyLineFromSourceToDestination(source: sourceLocation, destination: destinationLocation, lineColor: .taxiColor)
            }
            showTaxiHomeView()
            floatyButton?.isHidden = false
            sosButton?.isHidden = false
            break
        case TravelState.pickedup.rawValue:
            floatyButton?.removeFromSuperview()
            floatyButton = nil
            floatyButton?.isHidden = true
            DispatchQueue.main.async {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: sourceLocation, marker: UIImage(named: Constant.sourcePinImage) ?? UIImage())
                self.xmapView?.setDestinationLocationMarker(destinationCoordinate: destinationLocation, marker: UIImage(named: Constant.destinationPinImage) ?? UIImage())
                self.xmapView?.drawPolyLineFromSourceToDestination(source: sourceLocation, destination: destinationLocation, lineColor: .taxiColor)
            }
            showTaxiHomeView()
            sosButton?.isHidden = false
            floatyButton?.removeFromSuperview()
            floatyButton = nil
            break
        case TravelState.droped.rawValue:
            floatyButton?.removeFromSuperview()
            floatyButton = nil
            sosButton?.removeFromSuperview()
            sosButton = nil
            xmapView?.clearAll()
            xmapView?.clearMap()
            showInvoicePage()
            break
        default:
            if let requestDetails = taxiCheckRquestData?.request {

                if requestDetails.paid == nil || requestDetails.paid?.toString() == String.Empty {
                showInvoicePage()
                }else if let paid = requestDetails.paid, paid == 0 {
                showInvoicePage()
                } else if let useWallet = requestDetails.useWallet, useWallet == isInvoiceShowed {
                showInvoicePage()
                isInvoiceShowed = 0
            }
                else if let providerRate = requestDetails.providerRated, providerRate == 0  {
                if currentTravelState == "COMPLETED" {
                DispatchQueue.main.async {
                    self.showTaxiRatingView()
                    self.updateTaxiProviderDetail()
                    DataBaseManager.shared.delete(entityName: CoreDataEntity.location.rawValue)
                }
                }
            }
            }
            break
        }
    }
    
    //Cancel request
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
            
            if let rideDetail = self.taxiCheckRquestData {
                self.updateRideDetails(rideDetails: rideDetail)
            }
        }
        
        tableView?.selectedItem = { [weak self] selectedReason in
            guard let self = self else {
                return
            }
            self.cancelTaxiRequest(reason: selectedReason)
        }
    }
    
    
    //Show invoice view
    private func showInvoicePage() {
        
        if let _ = taxiHomeView {
            taxiHomeView?.removeFromSuperview()
        }
        if UIApplication.topViewController() is TaxiInvoiceViewController {
            guard taxiCheckRquestData != nil else {
                return
            }
            NotificationCenter.default.post(name: Notification.Name("InvoiceDetailUpdate"), object: nil, userInfo: ["data": taxiCheckRquestData as Any])
            return
        }
        let taxiInvoiceViewController = TaxiRouter.taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.TaxiInvoiceViewController) as! TaxiInvoiceViewController
        taxiInvoiceViewController.modalPresentationStyle = .overCurrentContext
        taxiInvoiceViewController.taxiCheckRquestData = taxiCheckRquestData
        taxiInvoiceViewController.delegate = self
        //Call back closure
       
        present(taxiInvoiceViewController, animated: true, completion: nil)
    }
    
    //Show taxi rating view
    private func showTaxiRatingView() {
        
        if taxiRatingView == nil, let taxiRatingView = Bundle.main.loadNibNamed(TaxiConstant.TaxiRatingView, owner: self, options: [:])?.first as? TaxiRatingView {
            
            taxiRatingView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.taxiRatingView = taxiRatingView
            self.view.addTransparent(with: taxiRatingView)
            taxiRatingView.show(with: .bottom, completion: nil)
        }
        taxiRatingView?.setValues(values: taxiCheckRquestData?.request)
        taxiRatingView?.onClickSubmit = { [weak self] in
            guard let self = self else {
                return
            }
            self.taxiRatingView?.superview?.removeFromSuperview()
            self.taxiRatingView?.dismissView(onCompletion: {
                //Update rating and comments API
                let comments = self.taxiRatingView?.leaveCommentTextView.text
                let requestDetail = self.taxiCheckRquestData?.request
                let param: Parameters = [TaxiConstant.id: requestDetail?.id ?? 0,
                                        TaxiConstant.rating: Int(self.taxiRatingView?.ratingView.rating ?? 1),
                                         TaxiConstant.comment: comments == Constant.leaveComment ? String.Empty : (comments ?? String.Empty),
                                         TaxiConstant.adminServiceId: TaxiConstant.transport]
                self.taxiPresenter?.providerRating(param: param)
            })
        }
    }
    
    // show the waiting time view
    private func showWaitingTimeView() {
        if self.waitingTimeView == nil, let waitingTimeView = Bundle.main.loadNibNamed(TaxiConstant.WaitingTimeView, owner: self, options: [:])?.first as? WaitingTimeView {
            waitingTimeView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.waitingTimeView = waitingTimeView
            self.view.addTransparent(with: waitingTimeView)
            waitingTimeView.show(with: .bottom, completion: nil)
        }
        waitingTimeView?.onClickStopWaitingTime = { [weak self] in
            self?.waitingTimeView?.superview?.removeFromSuperview()
            self?.watingTimeTimer?.invalidate()
            self?.watingTimeTimer = nil
            self?.waitingTimeView?.dismissView(onCompletion: {
                self?.waitingTimeView = nil
            })
            self?.waitingTimeUpdate(isResume: true)
        }
    }
    
    //Show the request detail to view
    private func updateTaxiProviderDetail() {
        
        //Show taxi home view detail
        let userDetail = taxiCheckRquestData?.request?.user
        let requestDetail = taxiCheckRquestData?.request
        
        if requestDetail?.someone_name != nil {
            taxiHomeView?.someoneName.text = requestDetail?.someone_name
            taxiHomeView?.someOneBgVw.isHidden = false
            
            // taxiHomeView?.bookSomeTitleLbl.text = TaxiConstant.booksomeone.localized
            if requestDetail?.someone_mobile != nil && requestDetail?.someone_mobile != 0 {
                let reg = String(requestDetail?.someone_mobile ?? 0)
                taxiHomeView?.someOneMbl.text = reg
                taxiHomeView?.someoneCallBtn?.addTarget(self, action: #selector(someOneButtonAction(_:)), for: .touchUpInside)
                taxiHomeView?.someoneCallBtn.isHidden = false
                
            }else{
                let email = String(requestDetail?.someone_email ?? "")
                taxiHomeView?.someOneMbl.text = email
                taxiHomeView?.someoneCallBtn.isHidden = true
            }
        }else{
            taxiHomeView?.someOneBgVw.isHidden = true
        }
        
        
        if taxiCheckRquestData?.request?.status == TravelState.pickedup.rawValue || taxiCheckRquestData?.request?.status == TravelState.arrived.rawValue {
            taxiHomeView?.waitingTimeButton.isHidden = false
            taxiHomeView?.waitingTimeLabel.isHidden = false
            if !isFromWaitingResponse {
                isWaitingTimeOn = taxiCheckRquestData?.waitingStatus ?? false
                waitingTime = taxiCheckRquestData?.waitingTime ?? 0
            }
            
            taxiHomeView?.waitingTimeLabel.text = AppUtils.shared.secondsToHoursMinutesSeconds(time: waitingTime)
            waitingTimeUpdate(isResume: false)
            taxiHomeView?.pickupLocationTitleLabel.text = TaxiConstant.dropLocation.localized
            taxiHomeView?.pickupLocationDetailLabel.text = requestDetail?.dAddress
        }
        else {
            taxiHomeView?.waitingTimeButton.isHidden = true
            taxiHomeView?.waitingTimeLabel.isHidden = true
            taxiHomeView?.pickupLocationTitleLabel.text = TaxiConstant.pickupLocation.localized
            taxiHomeView?.pickupLocationDetailLabel.text = requestDetail?.sAddress
        }
        
        DispatchQueue.main.async {
            
            self.taxiHomeView?.driverName.text = "\(userDetail?.firstName ?? String.Empty) \(userDetail?.lastName ?? String.Empty)"
            self.taxiHomeView?.driverRatingView.rating = Double(userDetail?.rating ?? 0.0).rounded(.awayFromZero)
            
        }
        taxiHomeView?.driverRatingView.rating = (userDetail?.rating ?? 0.0).rounded(.awayFromZero)
        
        
        let userImage = URL(string: userDetail?.picture ?? "")
        
        taxiHomeView?.userImageView.sd_setImage(with: userImage, placeholderImage: UIImage(named: Constant.profile),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.taxiHomeView?.userImageView.image = UIImage(named: Constant.profile)
            } else {
                // Successful in loading image
                self.taxiHomeView?.userImageView.image = image
            }
        })
        
    }
    
    //Show the taxi home view with all request detail
    private func showTaxiHomeView() {
        
        guard let rideStatus = taxiCheckRquestData?.request?.status else { return }
        DispatchQueue.main.async {
            self.changeTaxiUIBasedOnStatus(status: rideStatus)
            self.updateTaxiProviderDetail()
        }
    }
    
    private func changeTaxiUIBasedOnStatus(status: String){
        
        providerDetailsViewInitalSetup()
        
        if status == TravelState.pickedup.rawValue {
            floatyButton?.removeFromSuperview()
            floatyButton = nil
            floatyButton?.isHidden = true
        }
        
        guard let taxiHomeView = taxiHomeView else { return}
        
        switch status {
        case TravelState.started.rawValue:
            
            taxiHomeView.cancelButton.isHidden = false
            taxiHomeView.arrivedButton.isHidden = false
            taxiHomeView.dropButton.isHidden = true
            taxiHomeView.pickupButton.isHidden = true
            taxiHomeView.pickupLocationView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
            
        case TravelState.arrived.rawValue:
            
            taxiHomeView.cancelButton.isHidden = false
            taxiHomeView.arrivedButton.isHidden = true
            taxiHomeView.dropButton.isHidden = true
            taxiHomeView.pickupButton.isHidden = false
            
            taxiHomeView.pickupLocationView.setBorderWith(color: .taxiColor, width: 1.5)
            taxiHomeView.pickupImageView?.setImageColor(color: .taxiColor)
            taxiHomeView.pickupLocationView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
            taxiHomeView.dropDashView.addSingleLineDash(color: .taxiColor, width: 1)
            
        default:
            
            taxiHomeView.cancelButton.isHidden = true
            taxiHomeView.arrivedButton.isHidden = true
            taxiHomeView.dropButton.isHidden = false
            taxiHomeView.pickupButton.isHidden = true
            
            taxiHomeView.pickupLocationView.setBorderWith(color: .taxiColor, width: 1.5)
            taxiHomeView.dropLocationView.setBorderWith(color: .taxiColor, width: 1.5)
            
            taxiHomeView.pickupImageView?.setImageColor(color: .taxiColor)
            taxiHomeView.dropImageView?.setImageColor(color: .taxiColor)
            
            taxiHomeView.pickupLocationView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
            taxiHomeView.dropLocationView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
            taxiHomeView.dropDashView.addSingleLineDash(color: .taxiColor, width: 2)
        }
    }
    
    private func providerDetailsViewInitalSetup() {
        
        let checkTaxiViewExists = view.subviews.filter({$0.tag == 111})
        if checkTaxiViewExists.count > 0 { return }
        if let _ = getTaxiHomeView() {
            if(sosButton?.accessibilityIdentifier != "sos"){
                setMenuButton()
            }
            taxiHomeView?.onClickHideTaxiHome = { [weak self] ishide in
                self?.floatyButton?.layoutSubviews()
                if let taxiView = self?.taxiHomeView {
                    self?.sosButton?.bottomAnchor.constraint(equalTo: taxiView.topAnchor, constant: -10).isActive = true
                    self?.floatyButton?.bottomAnchor.constraint(equalTo: taxiView.topAnchor, constant: -10).isActive = true
                }
                self?.floatyButton?.layoutSubviews()
                
            }
            taxiHomeView?.onClickButton = { [weak self] status in
                guard let self = self else {
                    return
                }
                guard let actionState = status else {
                    return
                }
                self.taxiHomeSubViewButtonAction(status: actionState)
            }
        }
    }
    
    private func getTaxiHomeView() -> TaxiHomeView? {
        guard let _ = taxiHomeView else{
            if let taxiHomeView = Bundle.main.loadNibNamed(TaxiConstant.TaxiHomeView, owner: self, options: [:])?.first as? TaxiHomeView {
                taxiHomeView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(taxiHomeView)
                self.taxiHomeView = taxiHomeView
                taxiHomeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                taxiHomeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                taxiHomeView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                taxiHomeView.show(with: .right, completion: nil)
                taxiHomeView.layoutIfNeeded()
            }
            return taxiHomeView
        }
        return taxiHomeView
    }
    
    private func taxiHomeSubViewButtonAction(status: String) {
        
        switch status {
        case TravelState.arrived.rawValue:
            updateTaxiStatus(with: TravelState.arrived.rawValue)
            break
        case TravelState.pickedup.rawValue:
            if isWaitingTimeOn {
                ToastManager.show(title: TaxiConstant.waitingTimeError.localized, state: .warning)
            }else{
                watingTimeTimer?.invalidate()
                watingTimeTimer = nil
                showTaxiOTPView()
            }
            break
        case TravelState.droped.rawValue:
            if isWaitingTimeOn {
                ToastManager.show(title: TaxiConstant.waitingTimeError.localized, state: .warning)
            }else{
                watingTimeTimer?.invalidate()
                watingTimeTimer = nil
                showTollAlertView()
            }
            break
        case TravelState.cancelled.rawValue:
            showCancelTable()
            break
        case TaxiConstant.GoogleMap:
            redirectToGoogleMap()
            break
        case TaxiConstant.time:
            waitingTimeUpdate(isResume: true)
            break
        default:
            break
        }
    }
    
    //Show toll charge alert view
    private func showTollAlertView() {
        
        simpleAlert(view: self, title: String.Empty, message: Constant.tollChargeMsg.localized, buttonOneTitle: Constant.SYes.localized, buttonTwoTitle: Constant.SNo.localized)
        onTapAlert = { [weak self] tag in
            guard let self = self else {
                return
            }
            if tag == 1 {
                self.dismiss(animated: true, completion: nil)
                self.showTollChargeView()
            } else if tag == 2 {
                self.updateDropStatusWithLocationDetail(amount: String.Empty)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //Show toll charge view
    private func showTollChargeView() {
        
        if taxiTollChargeView == nil, let taxiTollChargeView = Bundle.main.loadNibNamed(TaxiConstant.TaxiTollChargeView, owner: self, options: [:])?.first as? TollChargeView {
            
            taxiTollChargeView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: view.frame.height))
            self.taxiTollChargeView = taxiTollChargeView
            view.addTransparent(with: taxiTollChargeView)
            taxiTollChargeView.show(with: .bottom, completion: nil)
        }
        
        
        //Taxi view dismiss closure
        taxiTollChargeView?.onClickCancel = { [weak self] in
            guard let self = self else {
                return
            }
            self.taxiTollChargeView?.superview?.removeFromSuperview()
            self.taxiTollChargeView?.dismissView(onCompletion: {
                self.taxiTollChargeView = nil
                
            })
        }
        
        //Taxi view dismiss closure
        taxiTollChargeView?.onClickSubmit = { [weak self] tollCharge in
            guard let self = self else {
                return
            }
            self.taxiTollChargeView?.superview?.removeFromSuperview()
            self.taxiTollChargeView?.dismissView(onCompletion: {
                self.taxiTollChargeView = nil
                if tollCharge == "" {

                }else{
                    if let tollAmount = tollCharge {
                        self.updateDropStatusWithLocationDetail(amount: tollAmount)
                    }
                    else {
                        self.updateTaxiStatus(with: TravelState.droped.rawValue)
                    }
                }
            })
        }
        // cancel closure
        taxiTollChargeView?.onClickCancel = { [weak self] in
            guard let self = self else {
                return
            }
            self.taxiTollChargeView?.superview?.removeFromSuperview()
            self.taxiTollChargeView = nil
        }
    }
    
    private func updateDropStatusWithLocationDetail(amount: String) {
        
        var totalDistance = 0.0
        let locationList = try!DataBaseManager.shared.context.fetch(XLocation.fetchRequest()) as? [XLocation] ?? []
        if locationList.count != 0 {
            let list = [Int](1..<locationList.count)
            for (index, element) in list.enumerated() {
                let distance1 = locationList[index]
                let distance2 = locationList[element]
                let oldLocation: CLLocation = CLLocation.init(latitude: distance1.latitude, longitude: distance1.longitude)
                let newLocation: CLLocation = CLLocation.init(latitude: distance2.latitude, longitude: distance2.longitude)
                let tempDistance = oldLocation.distance(from: newLocation)
                print("Total \(totalDistance)")
                if !tempDistance.isNaN {
                    totalDistance = totalDistance + tempDistance
                }
            }
        }
        
        var locationArrayParam: [Parameters]? = []
        for locationDetail in locationList {
            let locationParam: Parameters = [TaxiConstant.PLat: locationDetail.latitude,
                                             TaxiConstant.PLng: locationDetail.longitude,
                                             TaxiConstant.PTime: String.Empty]
            locationArrayParam?.append(locationParam)
        }
            if tempRequestId != "0" {
        
        var param: Parameters = [TaxiConstant.id: tempRequestId ?? 0,
                                 TaxiConstant.status: TravelState.droped.rawValue,
                                 TaxiConstant.method: TaxiConstant.patch,
                                 TaxiConstant.locationPoints: locationArrayParam ?? [],
                                 TaxiConstant.distance: (totalDistance)]//convert to meter
        if amount != String.Empty {
            param[TaxiConstant.tollPrice] = amount
        }
        taxiPresenter?.updateRequest(param: param)
        //checkRequestApiCall()
        }
    }
    
    //Cancel API Request call
    private func cancelTaxiRequest(reason: String) {
            if tempRequestId != "0" {
        let param: Parameters = [HomeConstant.id: tempRequestId ?? 0,
                                 HomeConstant.serviceId: TaxiConstant.transport,
                                 HomeConstant.reason: reason]
        taxiPresenter?.cancelRequest(param: param)
        }
    }
    
    //Waiting time start and stop API
    private func waitingTimeRequest() {
        if tempRequestId != "0" {
        let param: Parameters = [HomeConstant.id: tempRequestId ?? 0,
                                 HomeConstant.status: !isWaitingTimeOn ? "0" : "1"]
        taxiPresenter?.providerWaitingTime(param: param)
        // checkRequestApiCall()
        }
    }
    
    private func waitingTimeUpdate(isResume: Bool) { //isResume used to when waiting time resume from API
        
        DispatchQueue.main.async {
            if self.isWaitingTimeOn {
                if self.watingTimeTimer == nil {
                    self.showWaitingTimeView()
                    self.watingTimeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateWatingTime) , userInfo: nil, repeats: true)
                }
            }
            else {
                self.watingTimeTimer?.invalidate()
                self.watingTimeTimer = nil
                self.updateWatingTime()
            }
            if isResume {
                self.isWaitingTimeOn = !self.isWaitingTimeOn
                self.waitingTimeRequest()
            }
        }
    }
    
    //Show OTP View
    private func showTaxiOTPView() {
        
       // print("otp>>>>>>>>",taxiCheckRquestData?.request)
        //OTP verify enable or not
        if   taxiCheckRquestData?.ride_otp == "0"  || taxiCheckRquestData?.request?.created_type?.uppercased() == Constant.admin.uppercased(){
            updateTaxiStatus(with: TravelState.pickedup.rawValue)
        }
        else {

             if self.taxiOTPView == nil, let taxiOTPView = Bundle.main.loadNibNamed(TaxiConstant.TaxiOTPView, owner: self, options: [:])?.first as? TaxiOTPView {
                           
                           taxiOTPView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
                           self.taxiOTPView = taxiOTPView
                           self.taxiOTPView?.responseOTP =  "\(taxiCheckRquestData?.request?.otp ?? String.Empty)"
                           view.addTransparent(with: taxiOTPView)
                           taxiOTPView.show(with: .bottom, completion: nil)
                       }else{
                           self.taxiOTPView?.responseOTP =  "\(taxiCheckRquestData?.request?.otp ?? String.Empty)"
                       }
            
            //Taxi view dismiss closure
            taxiOTPView?.onClickStartTripButton = { [weak self] otp in
                guard let self = self else {
                    return
                }
                self.otpStr = otp
                self.taxiOTPView?.superview?.removeFromSuperview()
                self.taxiOTPView?.dismissView(onCompletion: {
                    self.taxiOTPView = nil
                    self.updateTaxiStatus(with: TravelState.pickedup.rawValue)
                })
            }
            
            taxiOTPView?.onClickCloseButton = { [weak self] otp in
                      guard let self = self else {
                          return
                      }
                      self.taxiOTPView?.superview?.removeFromSuperview()
                      self.taxiOTPView?.dismissView(onCompletion: {
                          self.taxiOTPView = nil
                      })
                  }
        }
    }
    
    //Update taxi request status
    private func updateTaxiStatus(with status: String) {
        if tempRequestId != "0" {

            var param: Parameters = [TaxiConstant.id: tempRequestId ?? 0,
                                 TaxiConstant.status: status,
                                 TaxiConstant.method: TaxiConstant.patch]
            
            if taxiCheckRquestData?.request?.otp != nil {
                if taxiCheckRquestData?.request?.otp != "" {
                    param[TaxiConstant.otp] = otpStr
                }
               
            }
        taxiPresenter?.updateRequest(param: param)
        }
    }
    
    //Redirect to google map
    private func redirectToGoogleMap() {
      
        print(self.lat)
         print(self.long)
        let locationDetail = self.taxiCheckRquestData?.request
        
        let baseUrl = "comgooglemaps-x-callback://"
        if UIApplication.shared.canOpenURL(URL(string: baseUrl)!) {
         //   let locationDetail = taxiCheckRquestData?.request
            var sourceAddress = ""
            
            
            var destinationAddr = ""
            if let response = taxiCheckRquestData?.request?.status, response == TravelState.started.rawValue {
                self.xmapView?.getAdressName(latitude: self.lat, longitude: self.long , on: { (addr) in
                                   sourceAddress = addr
                               })
                destinationAddr = (locationDetail?.sAddress ?? "").replacingOccurrences(of: " ", with: "+")

            }else{
                sourceAddress = (locationDetail?.sAddress ?? "").replacingOccurrences(of: " ", with: "+")
                destinationAddr = (locationDetail?.dAddress ?? "").replacingOccurrences(of: " ", with: "+")
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
}

// MARK: - IBAction

extension TaxiHomeViewController {
    
    //Curent location button action
    @objc func currentLocationButtonAction(_ sender: UIButton) {
        xmapView?.showCurrentLocation()
    }
    
    //Navigation back button action
    @objc func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @objc func airportQueueAction(_ sender: UIButton) {
        taxiPresenter?.airportQueueRequest()

       }
    
    //Update Waiting Timer
    @objc func updateWatingTime() {
        DispatchQueue.main.async {
            if self.isWaitingTimeOn {
                self.waitingTime += 1
                self.taxiHomeView?.waitingTimeButton.setTitleColor(.white, for: .normal)
                self.taxiHomeView?.waitingTimeButton.backgroundColor = .taxiColor
            }
            else {
                self.taxiHomeView?.waitingTimeLabel.text = AppUtils.shared.secondsToHoursMinutesSeconds(time: self.waitingTime)
                self.taxiHomeView?.waitingTimeButton.setTitleColor(.black, for: .normal)
                self.taxiHomeView?.waitingTimeButton.backgroundColor = .white
            }
            let timeVal = AppUtils.shared.secondsToHoursMinutesSeconds(time: self.waitingTime)
            self.waitingTimeView?.TimerLabel.text = timeVal
        }
    }
    
    @objc func sosButtonAction(_ sender: UIButton) {
        if let phoneNumber = taxiCheckRquestData?.sos {
            AppUtils.shared.call(to: phoneNumber)
        }
    }
    @objc func someOneButtonAction(_ sender: UIButton) {
          if let phoneNumber = taxiCheckRquestData?.request?.someone_mobile {
              AppUtils.shared.call(to: String(phoneNumber))
          }
      }
}

// MARK: - TaxiPresenterToTaxiViewProtocol

extension TaxiHomeViewController: TaxiPresenterToTaxiViewProtocol {
    
    func cancelRequestResponse(taxiEntity: TaxiEntity) {
        if let _ = taxiCheckRquestData {
            taxiCheckRquestData =  nil
        }
        DispatchQueue.main.async {
            BackGroundRequestManager.share.resetBackGroudTask()
            self.xmapView?.clearAll()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateRequestResponse(taxiEntity: TaxiEntity) {
        if let response = taxiCheckRquestData?.request?.status, response == TravelState.started.rawValue {
            DispatchQueue.main.async {
                self.xmapView?.clearAll()
            }
        }
        checkRequestApiCall()
    }
    
    func paymentRequestResponse(taxiEntity: PaidEntity) {
        self.showTaxiRatingView()

    }
    
    func providerRatingResponse(taxiEntity: TaxiEntity) {
        
        if let _ = taxiRatingView {
            taxiRatingView =  nil
        }
        xmapView?.clearAll()
        BackGroundRequestManager.share.resetBackGroudTask()
        ToastManager.show(title: Constant.RatingToast, state: .success)
        taxiCheckRquestData = taxiEntity.responseData
        navigationController?.popViewController(animated: true)
    }
    
    // get cancel reasons
    func getReasonsResponse(reasonEntity: ReasonEntity) {
        reasonData = reasonEntity.responseData ?? []
    }
    
    func checkRequestResponse(taxiEntity: TaxiEntity) {
        DispatchQueue.main.async {
            if let response = taxiEntity.responseData {
                self.taxiCheckRquestData = response
                self.updateRideDetails(rideDetails: response)
                if let _ = response.request {
                    self.socketAndBgTaskSetUp()
                }
            }
        }
    }
    
    func providerWaitingTimeResponse(waitTimeEntity: WaitTimeEntity){
        isWaitingTimeOn = waitTimeEntity.waitingStatus ?? false
        waitingTime = waitTimeEntity.waitingTime ?? 0
        isFromWaitingResponse = true
        updateTaxiProviderDetail()
    }
}

extension TaxiHomeViewController: InVoiceDelegate {
    func Confirm() {
        self.sosButton?.removeFromSuperview()
        self.sosButton = nil
        //Update taxi completed status
        if let response = self.taxiCheckRquestData?.request?.status, response == TravelState.started.rawValue {
            DispatchQueue.main.async {
                self.xmapView?.clearAll()
            }
        }
        self.checkRequestApiCall()
    }
    
    func showRating() {
        self.sosButton?.removeFromSuperview()
        self.sosButton = nil
        showTaxiRatingView()
    }
       
    func showCash(){
        self.sosButton?.removeFromSuperview()
        self.sosButton = nil
        if tempRequestId != "0" {
            let param: Parameters = [TaxiConstant.id: tempRequestId ?? 0,
                                     TaxiConstant.status: TravelState.completed.rawValue,
                                     TaxiConstant.method: TaxiConstant.patch]
            taxiPresenter?.updateRequest(param: param)
        }
    }
    
    
}

protocol InVoiceDelegate {
   func showCash()
    func Confirm()
    func showRating()
}
