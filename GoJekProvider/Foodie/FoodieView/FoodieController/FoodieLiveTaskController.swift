//
//  FoodieLiveTaskController.swift
//  GoJekProvider
//
//  Created by Ansar on 04/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SDWebImage
var isleaveDoor = true

class FoodieLiveTaskController: UIViewController {
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var ordersListTableView: UITableView!
    
    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var orderNumberView: UIView!
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var shopImageView: UIImageView!
    
    @IBOutlet weak var shadowViewOne: UIView!
    @IBOutlet weak var shadowViewtwo: UIView!
    @IBOutlet weak var shadowViewthree: UIView!
    @IBOutlet weak var shadowViewfour: UIView!
    @IBOutlet weak var shadowViewfive: UIView!
    
    var footerView: FoodieLiveTaskFooterView?
    
    var currentStatus: FoodieOrderStatus = .none
    
    var checkRequestData: FoodieRequestResponse? {
        didSet {
            ordersListTableView.reloadInMainThread()
        }
    }
    
    var phoneNumber: String? = String.Empty //Phone number for user and restaurent
    var locationDetails: CLLocationCoordinate2D?
    var ratingView: FoodieRatingView?
    var foodieCheckRequest: FoodieCheckRequestEntity?
    
    private var xmapView: XMapView?
    
    //push redirection
    var isChatAlreadyPresented:Bool = false
    var isAppFrom =  false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
        setFont()
        isAppFrom = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
        addMapView()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeMapView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for imageSubview in trackingView.subviews {
            if let image = imageSubview.subviews.first {
                image.addShadow(radius: 0, color: .lightGray)
            }
        }
        
    }
    
}

extension FoodieLiveTaskController  {
    
    private func initialLoads() {
        
        orderNumberView.isHidden = true
        trackingView.isHidden = true
        ordersListTableView.register(nibName: FoodieConstant.ItemListCell)
        callButton.tintColor = .foodieColor
        navigationButton.tintColor = .foodieColor
        chatButton.tintColor = .foodieColor
        
        orderNumberLabel.textColor = .white
        orderIDLabel.textColor = .foodieColor
        statusButton.setCornerRadiuswithValue(value: 5.0)
        statusButton.backgroundColor = .foodieColor
        shopNameLabel.textColor = .foodieColor
        orderNumberView.backgroundColor = .foodieColor
        navigationButton.setImage(UIImage(named: FoodieConstant.compass), for: .normal)
        callButton.setImage(UIImage(named: FoodieConstant.phoneCall), for: .normal)
        chatButton.setImage(UIImage(named: Constant.chatImage), for: .normal)
        statusButton.addTarget(self, action: #selector(tapStatus), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(tapCall), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(tapChatMsg), for: .touchUpInside)
        
        navigationButton.addTarget(self, action: #selector(tapNavigation), for: .touchUpInside)
        
        title = FoodieConstant.liveTask.localized
        setNavigationTitle()
        hideTabBar()
        DispatchQueue.main.async {
            self.shopImageView.setCornerRadiuswithValue(value: 5)
        }
        
        //For chat_order
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_order.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        xmapView?.backgroundColor = .backgroundColor
        self.view.backgroundColor = .backgroundColor
    }
    
    @objc private func isChatPushRedirection(){
        
        if isChatAlreadyPresented == false {
            
            if isAppFrom == true {
                self.chatNotificationSetup()
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.chatNotificationSetup()
                }
            }
            isChatAlreadyPresented = true
        }else {
            
        }
    }
    
    @objc func chatNotificationSetup(){
       
        navigateChatView()
    }
    @objc func navigateChatView() {
           
           let providerDetail = foodieCheckRequest?.responseData?.provider_details
           let userDetail = foodieCheckRequest?.responseData?.requests?.user
           let chatView = ChatViewController()
           chatView.requestId = "\((foodieCheckRequest?.responseData?.requests?.id ?? 0))"
           chatView.chatRequestFrom = DocumentType.order.rawValue
           chatView.userId = "\((userDetail?.id ?? 0))"
           chatView.userName = "\( userDetail?.firstName ?? String.Empty)" + " " + "\(userDetail?.lastName ?? String.Empty)"
           chatView.providerId = "\((providerDetail?.id ?? 0))"
           chatView.providerName = "\(providerDetail?.first_name ?? String.Empty)" + " " + "\(providerDetail?.last_name ?? String.Empty)"
           navigationController?.pushViewController(chatView, animated: true)
       }
    
    @objc private func enterForeground() {
        if let _ = foodieCheckRequest {
            foodieCheckRequest = nil
        }
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
        isAppFrom = false
    }

    func socketAndBgTaskSetUp() {
        
        if let requestData = foodieCheckRequest {
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId:  SocketUtitils.construtRoomKey(requestID: "\(requestData.responseData?.requests?.id ?? 0)", serviceType: .order), listener: .Order)
            BackGroundRequestManager.share.requestCallback =  { [weak self] in
                guard let self = self else {
                    return
                }
                self.getRequestAPI()
            }
        } else {
            getRequestAPI()
        }
    }
    
    func getRequestAPI() {
        foodiePresenter?.getRequest(param: nil)
    }
    
    func setFooter() {
        if let footerView = Bundle.main.loadNibNamed(FoodieConstant.FoodieLiveTaskFooterView, owner: self, options: [:])?.first as? FoodieLiveTaskFooterView {
            self.footerView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.footerView?.frame.height ?? 400)+30)
            self.footerView = footerView
            if let invoice = self.checkRequestData?.requests?.order_invoice {
                self.footerView?.setValues(values: invoice)
            }
            self.ordersListTableView.tableFooterView = footerView
        }
    }
    
    private func addMapView() {
        xmapView = XMapView(frame: self.view.bounds)
        xmapView?.tag = 100
        xmapView?.currentLocationMarkerImage = UIImage(named: FoodieConstant.ic_delivery_boy)?.resizeImage(newWidth: 40)
    }
    
    private func removeMapView() {
        DispatchQueue.main.async {
            for subView in self.view.subviews where subView.tag == 100 {
                subView.removeFromSuperview()
                self.xmapView?.clearAll()
                self.xmapView = nil
            }
        }
    }
    
    private func setFont() {
        shopNameLabel.font = .setCustomFont(name: .medium, size: .x16)
        shopAddressLabel.font = .setCustomFont(name: .medium, size: .x14)
        statusButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        orderNumberLabel.font = .setCustomFont(name: .medium, size: .x14)
        orderTimeLabel.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    func handleRequest(status: FoodieOrderStatus) {
        switch status {
        case .PROCESSING:
            statusButton.setTitle(status.statusStr, for: .normal)
        case .STARTED:
            statusButton.setTitle(status.statusStr, for: .normal)
        case .REACHED:
            statusButton.setTitle(status.statusStr, for: .normal)
        case .PICKEDUP:
            if checkRequestData?.requests?.leave_at_door == 1 {
                showDoorStepAlertView()
            }
            statusButton.setTitle(status.statusStr, for: .normal)
            
        case .ARRIVED:
            self.statusButton.setTitle(status.statusStr, for: .normal)
            
            
            //if AppManager.share.getBaseDetails()?.appsetting?.order_otp == 1 {
            if checkRequestData?.order_otp == "1"{
                if checkRequestData?.requests?.leave_at_door == 1 {
                            let param:Parameters = [FoodieInput.id : self.checkRequestData?.requests?.id ?? 0,
                                                      FoodieInput._method : FoodieConstant.patch,
                                                      FoodieInput.status : FoodieOrderStatus.PAYMENT.rawValue]
                              foodiePresenter?.updateRequest(param: param)
                }else{
                showAmountPaid()
                }
            }
            else{
                let param:Parameters = [FoodieInput.id : self.checkRequestData?.requests?.id ?? 0,
                                        FoodieInput._method : FoodieConstant.patch,
                                        FoodieInput.status : FoodieOrderStatus.PAYMENT.rawValue]
                foodiePresenter?.updateRequest(param: param)
            }
        case .COMPLETED:
            print(status.statusStr)
            statusButton.setTitle(status.statusStr, for: .normal)
        default:
            return
        }
        orderNumberView.isHidden = status != .PROCESSING
        trackingView.isHidden = status == .PROCESSING
        if status == .PROCESSING || status == .STARTED ||  status == .REACHED {
            let pickup = checkRequestData?.requests?.pickup
            shopNameLabel.text = pickup?.store_name
            shopAddressLabel.text = pickup?.store_location
            let url = URL(string: pickup?.picture ?? String.Empty)
            self.shopImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.profile),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
             // Perform operation.
                if (error != nil) {
                    // Failed to load image
                    self.shopImageView.image = UIImage(named: Constant.profile)
                } else {
                    // Successful in loading image
                    self.shopImageView.image = image
                }
            })
            phoneNumber = pickup?.contact_number ?? String.Empty
            if let latitude = pickup?.latitude,  let longitude = pickup?.longitude {
                locationDetails = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }else{
            let delivery = checkRequestData?.requests?.delivery
            let user = checkRequestData?.requests?.user
            shopAddressLabel.text = (delivery?.flat_no?.giveSpace ?? String.Empty) + (delivery?.street?.giveSpace ??  String.Empty)
            shopNameLabel.text = (user?.firstName?.giveSpace ??  String.Empty) + (user?.lastName?.giveSpace  ?? String.Empty)
            let url = URL(string: user?.picture ?? String.Empty)
            self.shopImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constant.profile),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
             // Perform operation.
                if (error != nil) {
                    // Failed to load image
                    self.shopImageView.image = UIImage(named: Constant.profile)
                } else {
                    // Successful in loading image
                    self.shopImageView.image = image
                }
            })
            phoneNumber = user?.mobile ?? String.Empty
            if let latitude = delivery?.latitude,  let longitude = delivery?.longitude {
                locationDetails = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        changeTrackingView()
    }
    
    func setValuesForRequest(request: FoodieCheckRequestEntity)  { //Setvalues in checkrequest value
        if (request.responseData?.requests != nil) {
            
            //For location update
            tempRequestId = "\(foodieCheckRequest?.responseData?.requests?.id ?? 0)"
            tempRequestType = .order
            
            foodieCheckRequest = request
            orderNumberLabel.text = request.responseData?.requests?.store_order_invoice_id
            checkRequestData = request.responseData
            let status = FoodieOrderStatus(rawValue: request.responseData?.requests?.status ?? String.Empty)  ?? .none
            currentStatus = status
            handleRequest(status: status)
            let dateStr = request.responseData?.requests?.created_time ?? String.Empty
            let timeArr = AppUtils.shared.dateToString(dateStr: dateStr, dateFormatTo: DateFormat.dd_mm_yyyy_hh_mm_ss, dateFormatReturn: DateFormat.ddmmyyyy)
            let seperatedStrArr  = timeArr.components(separatedBy: ",")
            if seperatedStrArr.count > 1 {
                orderTimeLabel.text = String.removeNil(seperatedStrArr[1])
            } else  {
                orderTimeLabel.text = ""
            }
            orderIDLabel.text = request.responseData?.requests?.store_order_invoice_id
            if let delivery = checkRequestData?.requests?.delivery, let latitude = delivery.latitude,  let longitude = delivery.longitude {
                self.xmapView?.drawPolyLineFromDestination(destination: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), lineColor: .taxiColor)
            }
            if let pickup = checkRequestData?.requests?.pickup, let latitude = pickup.latitude,  let longitude = pickup.longitude {
                self.xmapView?.setSourceLocationMarker(sourceCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), marker: #imageLiteral(resourceName: "ic_source_marker"))
            }
        }
    }
    
    @objc func tapNavigation() {
        let baseUrl = "comgooglemaps-x-callback://"
        if UIApplication.shared.canOpenURL(URL(string: baseUrl)!) {
            let locationDetail = foodieCheckRequest?.responseData?.requests
            var addressString = ""
            if currentStatus == .PROCESSING || currentStatus == .STARTED ||  currentStatus == .REACHED {
                addressString = locationDetail?.pickup?.store_location ?? ""
                addressString = addressString.replacingOccurrences(of: " ", with: "+")
            }else{
                addressString = (locationDetail?.delivery?.flat_no?.giveSpace ?? String.Empty) + (locationDetail?.delivery?.street?.giveSpace ??  String.Empty)
                addressString = addressString.replacingOccurrences(of: " ", with: "+")
            }
            
            guard let _ = locationDetails?.latitude, let _ = locationDetails?.longitude, let url = URL(string: "comgooglemaps://?saddr=\(XCurrentLocation.shared.latitude ?? 0),\(XCurrentLocation.shared.longitude ?? 0)&daddr=\(addressString)&directionsmode=driving"), UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url, options: [:]) { (true) in
                print("google map open")
            }
        }
        else {
            //  checkRequestApiCall()
            simpleAlert(view: self, title: String.Empty, message: "Can't open GoogleMap Application.", state: .error)
        }
    }
    
    @objc func tapChatMsg() {
        
        let providerDetail = foodieCheckRequest?.responseData?.provider_details
        let userDetail = foodieCheckRequest?.responseData?.requests?.user
        let chatView = ChatViewController()
        chatView.requestId = "\((foodieCheckRequest?.responseData?.requests?.id ?? 0))"
        chatView.chatRequestFrom = DocumentType.order.rawValue
        chatView.userId = "\((userDetail?.id ?? 0))"
        chatView.userName = "\( userDetail?.firstName ?? String.Empty)" + " " + "\(userDetail?.lastName ?? String.Empty)"
        chatView.providerId = "\((providerDetail?.id ?? 0))"
        chatView.providerName = "\(providerDetail?.first_name ?? String.Empty)" + " " + "\(providerDetail?.last_name ?? String.Empty)"
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    @objc func tapCall() {
        guard let _ = phoneNumber else {
            return
        }
        AppUtils.shared.call(to: phoneNumber)
    }
    
    @objc func tapStatus() {
        if currentStatus == .PROCESSING {
            updateStatusAPI(status: .STARTED)
        }else if currentStatus == .STARTED {
            updateStatusAPI(status: .REACHED)
        }else if currentStatus == .REACHED {
            updateStatusAPI(status: .PICKEDUP)
        }else if currentStatus == .PICKEDUP {
            updateStatusAPI(status: .ARRIVED)
        }else if currentStatus == .ARRIVED {
            showAmountPaid()
        }else if currentStatus == .COMPLETED  {
            showRatingView()
        }
    }
    
    private func showDoorStepAlertView() {
        if isleaveDoor {
            simpleAlert(view: self, title: String.Empty, message: FoodieConstant.doorStepMsg.localized, buttonTitle: Constant.ok.localized)
            onTapAlert = { [weak self] tag in
                guard let self = self else {
                    return
                }
                if tag == 1 {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            isleaveDoor = false
        }
    }
    
    func changeTrackingView() {
        
        for imageSubview in trackingView.subviews {
            if let image = imageSubview.subviews.first as? UIImageView {
                image.imageTintColor(color1: .white)
                let nextImage = currentStatus.imageTag+1
                if currentStatus.imageTag < image.tag {
                    imageSubview.backgroundColor = .white
                    image.imageTintColor(color1: .lightGray)
                }else{
                    imageSubview.backgroundColor = .foodieColor
                }
                if nextImage == image.tag {
                    imageSubview.backgroundColor = .lightGray
                    image.imageTintColor(color1: .white)
                }
            }
        }
        
        for subview in trackingView.subviews {
            subview.layer.masksToBounds = false
            subview.layer.cornerRadius = subview.frame.height/2
            subview.layer.shadowColor = UIColor.lightGray.cgColor
            subview.layer.shadowPath = UIBezierPath(roundedRect: subview.bounds, cornerRadius: subview.layer.cornerRadius).cgPath
            subview.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            subview.layer.shadowOpacity = 0.5
            subview.layer.shadowRadius = 1.0
        }
    }
    
    //show Rate View
    func showRatingView() {
        if self.ratingView == nil, let ratingView = Bundle.main.loadNibNamed(FoodieConstant.FoodieRatingView, owner: self, options: [:])?.first as? FoodieRatingView {
            
            ratingView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.ratingView = ratingView
            if let response = self.checkRequestData {
                self.ratingView?.setValues(values: response)
                self.view.addSubview(ratingView)
                self.ratingView?.show(with: .bottom, completion: nil)
            }
        }
        self.ratingView?.onClickSubmit = { [weak self] (comment,rating) in
            guard let self = self else {
                return
            }
            let param:Parameters = [FoodieInput.id : self.checkRequestData?.requests?.id ?? 0,
                                    FoodieInput._method : "POST",
                                    FoodieInput.admin_service_id : self.checkRequestData?.requests?.admin_service_id ?? 0,
                                    FoodieInput.rating : rating,
                                    FoodieInput.comment : comment]
            self.foodiePresenter?.getRating(param: param)
        }
    }
    
    // showAmountPaid Alert
    private func showAmountPaid(){
        let vc = FoodieRouter.foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.AmountPopViewViewController) as! AmountPopViewViewController
        vc.delegate = self
        vc.isCashType = (checkRequestData?.requests?.order_invoice?.payment_mode ?? String.Empty) == "CASH"
        vc.otpValue = checkRequestData?.requests?.order_otp ?? String.Empty
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func updateStatusAPI(status: FoodieOrderStatus) {
        let param:Parameters = [FoodieInput.id : checkRequestData?.requests?.id ?? 0,
                                FoodieInput._method : FoodieConstant.patch,
                                FoodieInput.status : status.rawValue]
        foodiePresenter?.updateRequest(param: param)
    }
}

extension FoodieLiveTaskController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = checkRequestData?.requests?.order_invoice?.items?.count
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ItemListCell = ordersListTableView.dequeueReusableCell(withIdentifier: FoodieConstant.ItemListCell, for: indexPath) as! ItemListCell
        if let items = checkRequestData?.requests?.order_invoice?.items?[indexPath.row] {
            cell.setValues(values: items)
        }
        cell.bottomViewLabel.isHidden = ((checkRequestData?.requests?.order_invoice?.items?.count ?? 0)-1) == indexPath.row
        return cell
    }
}


extension FoodieLiveTaskController: UITableViewDelegate {
    
}

//OTP Popup

extension FoodieLiveTaskController: AmountPopUpDelegate {
    
    func popUpDelegate(otp: String) {
        let param:Parameters = [FoodieInput.id : checkRequestData?.requests?.id ?? 0,
                                FoodieInput._method : FoodieConstant.patch,
                                FoodieInput.status : FoodieOrderStatus.PAYMENT.rawValue,
                                FoodieInput.otp : otp]
        foodiePresenter?.updateRequest(param: param)
    }
}

//MARK: - FoodiePresenterToFoodieViewProtocol

extension FoodieLiveTaskController: FoodiePresenterToFoodieViewProtocol {
    
    func getFoodieRequest(foodieEntity: FoodieUpdateRequestEntity) {
        let status = FoodieOrderStatus(rawValue: foodieEntity.responseData?.status ?? String.Empty) ?? .none
        currentStatus = status
        handleRequest(status: status)
        socketAndBgTaskSetUp()
        print(status.rawValue)
    }
    
    func getFoodieRating(successEntity: SuccessEntity) {
        ratingView?.dismissView(onCompletion: {
            self.ratingView = nil
        })
        BackGroundRequestManager.share.resetBackGroudTask()
        ToastManager.show(title: Constant.RatingToast, state: .success)
        let vc = HomeRouter.createHomeModule()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getRequest(requestEntity: FoodieCheckRequestEntity) {
        if requestEntity.responseData != nil {
            foodieCheckRequest = requestEntity
            socketAndBgTaskSetUp()
            DispatchQueue.main.async {
                self.setValuesForRequest(request: requestEntity)
                self.setFooter()
            }
        }
    }
}

