//
//  XuberHomeViewController.swift
//  GoJekProvider
//
//  Created by apple on 12/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SDWebImage

class XuberHomeViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var currentLocationview: UIView!
    @IBOutlet weak var topInfoView: UIView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var dotView: RoundedView!
    
    //MARK: - LocalVariable
    
    private var xuberCheckRequestData: XuberCheckResponseData?
    private var xuberArrivedView: XuberArriveView?
    private var xuberRatingView: XuberRatingView?
    private var xuberHelpView: XuberHelpView?
    private var tableView: CustomTableView?
    
    var serviceStates = ServiceState.arrive.rawValue
    var currentTravelState: String?
    
    var beforeServiceimgeData: Data?
    var afterServiceimgeData: Data?
    
    var titleCameraStr = String.Empty
    var extraCharge = String.Empty
    var desAdditionalCharge = String.Empty
    var startedAt = String.Empty
    var ratingComments = String.Empty
    var ratingValue = 0.0
    var timer : Timer?
    var reasonData:[ReasonData] = []
    var menuButton = UIButton()
    var xmapView: XMapView?
    
    var isChatAlreadyPresented:Bool = false
      var isAppFrom =  false
    
    var floatyButton : FloatyButton?
    var tempId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        viewDidSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        //For chat_order
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat_service.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: Notification.Name(pushNotificationType.chat.rawValue), object: nil)
        isAppFrom = true
    }
    
    @objc private func enterForeground() {
        if let _ = xuberCheckRequestData {
            xuberCheckRequestData = nil
        }
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show tabbar
        hideTabBar()
        navigationController?.navigationBar.isHidden = true
        BackGroundRequestManager.share.resetBackGroudTask()
        socketAndBgTaskSetUp()
        addMapView()
        isChatAlreadyPresented = false

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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        floatyButton?.removeFromSuperview()
        floatyButton = nil
        xuberCheckRequestData = nil
        removeMapView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        xmapView?.frame = mapView.bounds
        currentLocationview.setCornerRadius()
    }
}

// MARK: - LocalMethod

extension XuberHomeViewController {
    
    // view setup
    private func viewDidSetup() {
        topInfoView.layer.cornerRadius = 5.0
        topInfoView.layer.masksToBounds = true
        addressTitleLabel.text = XuberConstant.serviceLocation.localized
        setCustomFont()
        setCustomColor()
        xuberArrivedView?.layer.cornerRadius = 10
        topInfoView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        // for to get cancel reasons list
        menuButton.isHidden = true
        xuberPresenter?.getReasons(param: [XuberConstant.type: XuberConstant.service.uppercased()])
        let locationViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapCurrentLocation(_:)))
        self.currentLocationview.addGestureRecognizer(locationViewGesture)
        mapView.backgroundColor = .backgroundColor

    }
    
    private func setCustomFont() {
        addressTitleLabel.font = .setCustomFont(name: .medium, size: .x18)
        addressDetailLabel.font = .setCustomFont(name: .light, size: .x16)
    }
    
    @objc func tapCurrentLocation(_ sender: UITapGestureRecognizer){
        self.xmapView?.showCurrentLocation()
    }
    
    
    private func setCustomColor() {
        addressDetailLabel.textColor = .lightGray
        addressTitleLabel.textColor = .white
        dotView.backgroundColor = .xuberColor
        
    }
}

extension XuberHomeViewController {
    
    private func addMapView() {
        xmapView = XMapView(frame: mapView.bounds)
        xmapView?.tag = 100
        mapView.addSubview(xmapView!)
        xmapView?.currentLocationMarkerImage = UIImage(named: FoodieConstant.ic_delivery_boy)?.resizeImage(newWidth: 40)
        xmapView?.didDragMap = { [unowned self] isDrag in
            self.xuberArrivedView?.isHidden = isDrag
        }
        mapView.bringSubviewToFront(floatyButton ?? UIButton()) // bring to front view if goes to chat and come back in between flow
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
        
        if let _ = getFloatyView() {
            floatyButton?.buttonOneImage = UIImage(named: Constant.phoneImage)?.imageTintColor(color: .white) ?? UIImage()
            floatyButton?.buttonTwoImage = UIImage(named: Constant.chatImage)?.imageTintColor(color: .white) ?? UIImage()
            floatyButton?.backgroundColor = .xuberColor
            floatyButton?.bgColor = .xuberColor
            
            floatyButton?.onTapButtonOne = { [weak self] in
                guard let self = self else {
                    return
                }
                if let phoneNumber = self.xuberCheckRequestData?.requests?.user?.mobile {
                    AppUtils.shared.call(to: phoneNumber)
                }
            }
            floatyButton?.onTapButtonTwo = { [weak self] in
                guard let self = self else {
                    return
                }
                self.navigateToChatView()
            }
        }
    }
    
    private func getFloatyView() -> FloatyButton? {
        guard let _ = floatyButton else {
            floatyButton = FloatyButton()
            mapView.addSubview(floatyButton ?? UIView())
            floatyButton?.translatesAutoresizingMaskIntoConstraints = false
            floatyButton?.bottomAnchor.constraint(equalTo: xuberArrivedView?.topAnchor ?? NSLayoutYAxisAnchor(), constant: -10).isActive = true
            floatyButton?.rightAnchor.constraint(equalTo: xuberArrivedView?.rightAnchor ?? NSLayoutXAxisAnchor(), constant: -10).isActive = true
            floatyButton?.heightAnchor.constraint(equalTo: xuberArrivedView?.widthAnchor ?? NSLayoutDimension(), multiplier: 0.12).isActive = true
            floatyButton?.widthAnchor.constraint(equalTo: xuberArrivedView?.widthAnchor ?? NSLayoutDimension(), multiplier: 0.12).isActive = true
            return floatyButton
        }
        return floatyButton
    }
    
    private func navigateToChatView() {
        
        let providerDetail = xuberCheckRequestData?.provider_details
        let userDetail = xuberCheckRequestData?.requests?.user
        let chatView = ChatViewController()
        chatView.requestId = "\((xuberCheckRequestData?.requests?.id ?? 0))"
        chatView.chatRequestFrom = DocumentType.service.rawValue
        chatView.userId = "\((userDetail?.id ?? 0))"
        chatView.userName = "\( userDetail?.first_name ?? .Empty)" + " " + "\(userDetail?.last_name ?? .Empty)"
        chatView.providerId = "\((providerDetail?.id ?? 0))"
        chatView.providerName = "\(providerDetail?.first_name ?? .Empty)" + " " + "\(providerDetail?.last_name ?? .Empty)"
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    // show Arrived View
    private func showArrivedView() {
        if xuberArrivedView == nil, let xuberArrivedView = Bundle.main.loadNibNamed(XuberConstant.xuberArriveView, owner: self, options: [:])?.first as? XuberArriveView {
            self.view.addSubview(xuberArrivedView)
            xuberArrivedView.translatesAutoresizingMaskIntoConstraints = false
            xuberArrivedView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            xuberArrivedView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            xuberArrivedView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            self.xuberArrivedView = xuberArrivedView
            xuberArrivedView.show(with: .bottom, completion: nil)
        }
        
        setMenuButton()
        updateXuberUserDetail()
        changeStatus()
        
        xuberArrivedView?.onClickHelp = { [weak self] in
            guard let self = self else {
                return
            }
            self.showXuberHelpView()
        }
        
        xuberArrivedView?.onClickCamera = { [weak self] in
            guard let self = self else {
                return
            }
            let xuberServiceImageController = XuberRouter.XuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberServiceImageUploadController) as! XuberServiceImageUploadController
            xuberServiceImageController.titleStr = self.titleCameraStr
            xuberServiceImageController.delegate = self
            self.present(xuberServiceImageController, animated: true, completion: nil)
            
        }
        
        xuberArrivedView?.onClickCancel = { [weak self] in
            guard let self = self else {
                return
            }
            self.showCancelTable()
        }
        
        xuberArrivedView?.onClickStarted = { [weak self] in
            guard let self = self else {
                return
            }
            //change statues
            if self.currentTravelState == ServiceState.accepted.rawValue  {
                self.ArriveXuberRequest()
            }
            else if self.currentTravelState == ServiceState.arrive.rawValue  {
                if (self.validation()) {
                    self.startServiceXuberRequest()
                }
            }
            else if self.currentTravelState == ServiceState.start.rawValue  {
                if (self.endValidation()) {
            
                    self.timer?.invalidate()
                    self.timer = nil
                    self.simpleAlert(view: self, title: XuberConstant.additionalChargeMsg.localized, message: .Empty, buttonOneTitle: Constant.SYes.localized, buttonTwoTitle: Constant.SNo.localized)
                    onTapAlert = { (tag) in
                        if tag == 1 {
                            self.showAdditionalCharge()
                        }
                        else if tag == 2 {
                            self.desAdditionalCharge = .Empty
                            self.extraCharge = .Empty
                            self.endServiceXuberRequest()
                        }
                    }
                }
            }
        }
    }
    
    func showCancelTable() {
        if tableView == nil, let tableView = Bundle.main.loadNibNamed(Constant.CustomTableView, owner: self, options: [:])?.first as? CustomTableView {
            
            let height = (view.frame.height/100)*35
            tableView.frame = CGRect(x: 20, y: (view.frame.height/2)-(height/2), width: view.frame.width-40, height: height)
            tableView.heading = Constant.chooseReason.localized
            self.tableView = tableView
            self.tableView?.setCornerRadiuswithValue(value: 10.0)
            var reasonArr:[String] = []
            for reason in reasonData {
                reasonArr.append(reason.reason ?? .Empty)
            }
            if !reasonArr.contains(Constant.other) {
                reasonArr.append(Constant.other)
            }
            tableView.values = reasonArr
            tableView.show(with: .bottom, completion: nil)
            showDimView(view: tableView)
        }
        self.tableView?.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView?.superview?.dismissView(onCompletion: {
                self.tableView = nil
            })
        }
        self.tableView?.selectedItem = { [weak self] (selectedReason) in
            guard let self = self else {
                return
            }
            self.cancelXuberRequest(reason: selectedReason)
        }
    }
    
    private func changeStatus(){
        switch currentTravelState {
        case ServiceState.arrive.rawValue:
        xuberArrivedView?.startButton.setTitle(XuberConstant.startService.localized.uppercased(), for: .normal)
            xmapView?.clearAll()
            xuberArrivedView?.arriveView.isHidden = true
            xuberArrivedView?.startView.isHidden = false
        
        if xuberCheckRequestData?.serve_otp == "1" || (xuberCheckRequestData?.requests?.created_type?.uppercased() == Constant.admin.uppercased()) {
            xuberArrivedView?.otpView.isHidden = false
        }else {
            xuberArrivedView?.otpView.isHidden = true
        }
            xuberArrivedView?.timeButton.isHidden = true
            titleCameraStr = XuberConstant.beforeService
            if xuberCheckRequestData?.requests?.service?.allow_before_image == 1 {
                xuberArrivedView?.cameraView.isHidden = false
                xuberArrivedView?.topView.isHidden = false
                
            } else {
                xuberArrivedView?.cameraView.isHidden = true
                xuberArrivedView?.topView.isHidden = true
            }
            break
        case ServiceState.start.rawValue:
            xmapView?.clearAll()
            xuberArrivedView?.startButton.setTitle(XuberConstant.endService.localized.uppercased(), for: .normal)
            xuberArrivedView?.arriveView.isHidden = true
            xuberArrivedView?.startView.isHidden = false
            xuberArrivedView?.otpView.isHidden = true
            xuberArrivedView?.timeButton.isHidden = false
            xuberArrivedView?.topView.isHidden = false
            self.menuButton.isHidden = true
            floatyButton?.removeFromSuperview()
            floatyButton = nil
            titleCameraStr = XuberConstant.afterService
            if xuberCheckRequestData?.requests?.service?.allow_after_image == 1 {
                xuberArrivedView?.cameraView.isHidden = false
            }else{
                xuberArrivedView?.cameraView.isHidden = true
            }
            if let topController = UIApplication.topViewController() {
                if topController is XuberAditionalChargesViewController {}
                else { showStartTimer() }
            }
            break
        case ServiceState.accepted.rawValue:
            xuberArrivedView?.arrivedButton.setTitle(Constant.arrived.localized.uppercased(), for: .normal)
            xuberArrivedView?.otpView.isHidden = true
            xuberArrivedView?.startView.isHidden = true
            xuberArrivedView?.arriveView.isHidden = false
            xuberArrivedView?.timeButton.isHidden = true
            xuberArrivedView?.cameraView.isHidden = true
            xuberArrivedView?.topView.isHidden = true
            break
        default:
            break
        }
    }
    
    //show Additional charge
    func showAdditionalCharge(){
        let xuberAditionalController = XuberRouter.XuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberAditionalChargesViewController) as! XuberAditionalChargesViewController
        xuberAditionalController.delegate = self
        xuberAditionalController.afterServiceimgeData = afterServiceimgeData
        present(xuberAditionalController, animated: true, completion: nil)
    }
    
    //show InVoice
    func showInvoice(){
        if let topController = UIApplication.topViewController() {
            if topController is XuberInVoiceController {
                NotificationCenter.default.post(name: Notification.Name(XuberConstant.serviceInvoiceDetail), object: nil, userInfo: ["data": xuberCheckRequestData as Any])
            } else {
                let xuberInVoiceController = XuberRouter.XuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberInVoiceController) as! XuberInVoiceController
                xuberInVoiceController.xuberCheckRequestData = xuberCheckRequestData
                xuberInVoiceController.delegate = self
                present(xuberInVoiceController, animated: true, completion: nil)}
        }
    }
    
    // Update Xuber User Details
    func updateXuberUserDetail(){
        DispatchQueue.main.async {
            let name = (self.xuberCheckRequestData?.requests?.user?.first_name ?? .Empty) + (self.xuberCheckRequestData?.requests?.user?.last_name ?? .Empty)
            self.xuberArrivedView?.nameLabel.text = name
            self.xuberArrivedView?.rateLabel.text = (self.xuberCheckRequestData?.requests?.user?.rating ?? 0).rounded(.awayFromZero).toString()
            
            let userImage = URL(string: self.xuberCheckRequestData?.requests?.user?.picture ?? "")
            self.xuberArrivedView?.profileImageView.sd_setImage(with: userImage, placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                      // Perform operation.
                         if (error != nil) {
                             // Failed to load image
                             self.xuberArrivedView?.profileImageView.image = UIImage(named: Constant.profile)
                         } else {
                             // Successful in loading image
                             self.xuberArrivedView?.profileImageView.image = image
                         }
                     })
            
            self.xuberArrivedView?.serviceLabel.text = XuberConstant.service

            self.xuberArrivedView?.serviceDescriptionLabel.text = self.xuberCheckRequestData?.requests?.service?.service_name
            
            if self.xuberCheckRequestData?.requests?.service?.allow_desc == 1 {
                self.xuberArrivedView?.instructionLabel.isHidden = false
                self.xuberArrivedView?.helpButton.isHidden = false
                self.xuberArrivedView?.serviceLabel.isHidden = false
                self.xuberArrivedView?.serviceDescriptionLabel.isHidden = false
            }
            else {
                self.xuberArrivedView?.instructionLabel.isHidden = true
                self.xuberArrivedView?.serviceLabel.isHidden = true
                self.xuberArrivedView?.helpButton.isHidden = true
                self.xuberArrivedView?.serviceDescriptionLabel.isHidden = true
            }
        }
    }
    
    //show Help View
    func showXuberHelpView() {
        
        if xuberHelpView == nil, let xuberHelpView = Bundle.main.loadNibNamed(XuberConstant.xuberHelpView, owner: self, options: [:])?.first as? XuberHelpView {
            let subViewHeight = xuberHelpView.frame.height
            let subViewWidth = (self.view.frame.width/100)*90
            xuberHelpView.frame = CGRect(origin: CGPoint(x: (self.view.frame.width/2)-subViewWidth/2, y: (self.view.frame.height/2) - subViewHeight/2), size: CGSize(width: subViewWidth, height:  subViewHeight))
            self.xuberHelpView = xuberHelpView
            self.view.addTransparent(with: xuberHelpView)
        }
        let userImage = URL(string: xuberCheckRequestData?.requests?.allow_image ?? "")
        xuberHelpView?.helpimageView.sd_setImage(with: userImage, placeholderImage: UIImage.init(named: Constant.holderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
         // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.xuberHelpView?.helpimageView.image = UIImage(named: Constant.holderImage)
            } else {
                // Successful in loading image
                self.xuberHelpView?.helpimageView.image = image
            }
        })
        xuberHelpView?.instructionDescriptionLabel.text = xuberCheckRequestData?.requests?.allow_description ?? .Empty
        xuberHelpView?.onClickClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.xuberHelpView?.superview?.removeFromSuperview()
            self.xuberHelpView?.removeFromSuperview()
            self.xuberHelpView = nil
        }
    }
    
    //show Rate View
    func showRatingView() {
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                if topController is XuberInVoiceController {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            let name = (self.xuberCheckRequestData?.requests?.user?.first_name ?? .Empty) + (self.xuberCheckRequestData?.requests?.user?.last_name ?? .Empty)
            self.xuberRatingView?.userNameLabel.text = name
            self.xuberRatingView?.bookingIdLabel.text = self.xuberCheckRequestData?.requests?.booking_id
            
            let userImage = URL(string: self.xuberCheckRequestData?.requests?.user?.picture ?? "")
            self.xuberRatingView?.userNameImage.sd_setImage(with: userImage, placeholderImage: UIImage.init(named: Constant.holderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                 // Perform operation.
                    if (error != nil) {
                        // Failed to load image
                        self.xuberRatingView?.userNameImage.image = UIImage(named: Constant.holderImage)
                    } else {
                        // Successful in loading image
                        self.xuberRatingView?.userNameImage.image = image
                    }
                })
           
        }
        
        if self.xuberRatingView == nil, let xuberRatingView = Bundle.main.loadNibNamed(XuberConstant.xuberRatingView, owner: self, options: [:])?.first as? XuberRatingView {
            
            xuberRatingView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            xuberRatingView.delegate = self
            self.xuberRatingView = xuberRatingView
            self.view.addSubview(xuberRatingView)
        }
    }
}

extension XuberHomeViewController {
    //Start Validation Method
    private func validation() -> Bool {
        if (xuberCheckRequestData?.serve_otp == "1") && (xuberCheckRequestData?.requests?.created_type?.uppercased() != Constant.admin.uppercased()) {

            guard let otpStr = xuberArrivedView?.otpTextField.text?.trim(), !otpStr.isEmpty else {
                xuberArrivedView?.otpTextField.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: XuberConstant.otpEmpty.localized,state: .error)
                return false
            }
            if (Int(xuberArrivedView?.otpTextField.text?.trim() ?? "0") ?? 0 < 4) {
                xuberArrivedView?.otpTextField.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: XuberConstant.otpValid.localized,state: .error)
                return false
            }
        }
        if xuberCheckRequestData?.requests?.service?.allow_before_image == 1  {
            if beforeServiceimgeData == nil {
                simpleAlert(view: self, title: .Empty, message: XuberConstant.beforeImageEmpty.localized,state: .error)
                return false
            }
        }
        return true
    }
    //End Validation Method
    private func endValidation() -> Bool {
        if xuberCheckRequestData?.requests?.service?.allow_after_image == 1  {
            if afterServiceimgeData == nil {
                simpleAlert(view: self, title: .Empty, message: XuberConstant.afterImageEmpty.localized,state: .error)
                return false
            }
        }
        return true
    }
}

// Api Methods
extension XuberHomeViewController {
    
    // arrive API Request
    private func ArriveXuberRequest(){
           if  tempId != 0 {
        let param: Parameters = [HomeConstant.id: tempId,
                                 XuberConstant.PStatus:ServiceState.arrive.rawValue,
                                 XuberConstant.PMethod: XuberConstant.PPatch]
        
        xuberPresenter?.arriveRequest(param: param)
        }
    }
    
    
    
    // Start API Request call
    private func startServiceXuberRequest(){
        if  tempId != 0 {
            var param: Parameters = [HomeConstant.id: tempId,
                                     XuberConstant.PStatus: ServiceState.start.rawValue,
                                     XuberConstant.PMethod: XuberConstant.PPatch]
            
            
            if xuberCheckRequestData?.serve_otp == "1" && (xuberCheckRequestData?.requests?.created_type?.uppercased() != Constant.admin.uppercased()) {

                param[XuberConstant.POtp] = xuberArrivedView?.otpTextField.text ?? .Empty
                
            }
            let beforeImage = xuberCheckRequestData?.requests?.service?.allow_before_image ?? 0
            xuberPresenter?.startServiceRequest(param: param, imageData: beforeImage == 1 ? [XuberConstant.PBeforeService: beforeServiceimgeData ?? Data()] : nil)
        }
    }
    
    //End API Request cell
    private func endServiceXuberRequest(){
            if  tempId != 0 {
        let param: Parameters = [HomeConstant.id: tempId,
                                 XuberConstant.PStatus: ServiceState.end.rawValue,
                                 XuberConstant.PMethod: XuberConstant.PPatch,
                                 XuberConstant.PExtraCharge: extraCharge,
                                 XuberConstant.PExtraChargeDes:desAdditionalCharge]
        let afterImage = xuberCheckRequestData?.requests?.service?.allow_after_image ?? 0
        xuberPresenter?.endServiceRequest(param: param, imageData: afterImage == 1 ? [XuberConstant.PAfterPicture: afterServiceimgeData ?? Data()] : nil)
        }
    }
    
    //Payment API Request cell
    private func confirmPaymentXuberRequest(){
           if  tempId != 0 {
        let param: Parameters = [HomeConstant.id: tempId,
                                 XuberConstant.PStatus: "PAYMENT",
                                 XuberConstant.PMethod: XuberConstant.PPatch]
        
        xuberPresenter?.paymentRequest(param: param)
        }
    }
    
    //Rate User API Request cell
    private func rateUserXuberRequest(){
             if  tempId != 0 {
        let param: Parameters = [HomeConstant.id: tempId,
                                 XuberConstant.PMethod: XuberConstant.PPost,
                                 XuberConstant.PAdminServiceId:3,
                                 XuberConstant.PRating:ratingValue,
                                 XuberConstant.PComment:ratingComments]
        
        xuberPresenter?.providerRating(param: param)
        }
    }
    
    //Cancel API Request call
    private func cancelXuberRequest(reason: String) {
            if  tempId != 0 {
        let param: Parameters = [HomeConstant.id: xuberCheckRequestData?.requests?.id ?? 0,
                                 HomeConstant.serviceId: XuberConstant.service.uppercased(),
                                 HomeConstant.PCancel:reason]
        xuberPresenter?.cancelRequest(param: param)
        }
    }
}

// Timer
extension XuberHomeViewController {
    // set Start Timer
    private func showStartTimer(){
        
        guard let _ = timer else {
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(XuberHomeViewController.countDownDate), userInfo: nil, repeats: true)
            return
            
        }
        
    }
    // count down for timer
    @objc func countDownDate() {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter1.date(from: UTCToLocal(date: startedAt))
        var startTimeStr: String? = nil
        if let date = date {
            startTimeStr = dateFormatter1.string(from: date)
        }
        let nowstr = dateFormatter1.string(from: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate: Date? = formatter.date(from: startTimeStr ?? .Empty)
        let endDate: Date? = formatter.date(from: nowstr)
        
        var timeDifference: TimeInterval? = nil
        if let startDate = startDate {
            timeDifference = endDate?.timeIntervalSince(startDate)
        }
        var seconds = Int(timeDifference ?? 0)
        
        let hours: Int = seconds / 3600
        let minutes: Int = (seconds % 3600) / 60
        seconds = (seconds % 3600) % 60
        xuberArrivedView?.timeButton.setTitle(String(format:"%02i:%02i:%02i", hours, minutes, seconds), for: .normal)
    }
    
}

//Background check Request Api
extension XuberHomeViewController {
    
    func socketAndBgTaskSetUp() {
        if let requestData = xuberCheckRequestData{
            BackGroundRequestManager.share.startBackGroundRequest(type: .ModuleWise, roomId:  SocketUtitils.construtRoomKey(requestID: "\(requestData.requests?.id ?? 0)", serviceType: .service), listener: .Service)
            BackGroundRequestManager.share.requestCallback =  { [weak self] in
                guard let self = self else {
                    return
                }
                self.checkRequestApiCall()
            }
        } else {
            checkRequestApiCall()
        }
    }
    
    func checkRequestApiCall() {
        
        let param: Parameters = [HomeConstant.latitude: XCurrentLocation.shared.latitude ?? 0.0,
                                 HomeConstant.longitude: XCurrentLocation.shared.longitude ?? 0.0]
        xuberPresenter?.checkRequest(param: param)
    }
    
    func updateRequest(requestDetail: XuberCheckRequest) {
        
        let details = requestDetail.responseData
        xuberCheckRequestData = details
        let destinationLocation = CLLocationCoordinate2D.init(latitude: details?.requests?.s_latitude ?? 0.0, longitude: details?.requests?.s_longitude ?? 0.0)
        updateXuberUserDetail()
        
        let destinationAddress = details?.requests?.s_address
        addressDetailLabel.text = destinationAddress
        startedAt = details?.requests?.started_at ?? .Empty
        
        //For location update
        tempRequestId = "\(self.xuberCheckRequestData?.requests?.id ?? 0)"
        tempRequestType = .service
        tempId = self.xuberCheckRequestData?.requests?.id ?? 0
        
        currentTravelState = xuberCheckRequestData?.requests?.status
        menuButton.isHidden = true
        switch currentTravelState {
        case ServiceState.start.rawValue, ServiceState.arrive.rawValue:
            DispatchQueue.main.async {
                self.showArrivedView()
            }
            break
        case ServiceState.accepted.rawValue:
            menuButton.isHidden = false
            DispatchQueue.main.async {
                // self.menuButton.frame.origin.y = (self.xuberArrivedView?.frame.height ?? 0)+10
                self.showArrivedView()
            }
            xmapView?.createRoute(to: destinationLocation, with: destinationAddress ?? String.Empty,color: .xuberColor)
            break
        case ServiceState.end.rawValue:
            xuberArrivedView = nil
            xuberArrivedView?.isHidden = true
            DispatchQueue.main.async {
                self.showInvoice()
            }
            break
        case ServiceState.payment.rawValue:
            xuberArrivedView = nil
            xuberArrivedView?.isHidden = true
            DispatchQueue.main.async {
                self.showRatingView()
            }
            break
        default:
            navigationController?.popViewController(animated: true)
            //                if let providerRate = requestDetail?.provider_rated, providerRate == 0  {
            //                  //  showRatingView()
            //                }
            break
        }
    }
    
}
// Service Image Delegate
extension XuberHomeViewController: XuberServiceImageUploadDelegate {
    func beforeAfterServiceImage(serviceType: String, imageData: Data) {
        if serviceType == XuberConstant.beforeService {
            beforeServiceimgeData = imageData
        }else{
            afterServiceimgeData = imageData
            
        }
    }
}
// Additional charge Delegate
extension XuberHomeViewController: XuberAditionalChargesDelegate {
    func cancelAdtitionalCharge() {
         self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.countDownDate), userInfo: nil, repeats: true)


    }
    
    func aditionalChargeValue(amount: String, description: String, afterImage: Data?) {
        afterServiceimgeData = afterImage
        desAdditionalCharge = description
        extraCharge = amount
        
        endServiceXuberRequest()
    }
}

extension XuberHomeViewController : XuberRatingViewDelegate{
    func ratingView(comments: String, rateValue: Double) {
        ratingComments = comments
        ratingValue = rateValue
        
        rateUserXuberRequest()
    }
}

// InVoice Delegate

extension XuberHomeViewController: XuberInVoiceDelegate {
    
    func confirmPayment(isCash: Bool,isPaid:Int) {
        if isCash {
            if isPaid == 0 {
                confirmPaymentXuberRequest()
            }else {
                showRatingView()
            }
        }else {
            showRatingView()
        }
    }
}

//MARK: - XuberPresenterToXuberViewProtocol

extension XuberHomeViewController: XuberPresenterToXuberViewProtocol {
    
    // get cancel reasons
    func getReasons(reasonEntity: ReasonEntity) {
        reasonData = reasonEntity.responseData ?? []
    }
    
   
    
    func cancelRequestResponse(successEntity: SuccessEntity) {
        BackGroundRequestManager.share.resetBackGroudTask()
        navigationController?.popViewController(animated: true)
    }
    func arriveRequestResponse(arriveRequestEntity: StartServiceEntity) {
        currentTravelState = ServiceState.arrive.rawValue
        showArrivedView()
        
    }
    
    func startServiceRequestResponse(startRequestEntity: StartServiceEntity) {
        currentTravelState = ServiceState.start.rawValue
        
        showArrivedView()
        self.startedAt = startRequestEntity.responseData?.started_at ?? ""
        if let topController = UIApplication.topViewController() {
            if topController is XuberAditionalChargesViewController {
                
            } else {
                showStartTimer()
            }
        }
    }
    
    func endServiceRequestResponse(endRequestEntity: EndServiceEntity) {
        currentTravelState = ServiceState.end.rawValue
        xuberArrivedView?.dismissView(onCompletion: {
            self.xuberArrivedView = nil
            self.xuberArrivedView?.isHidden = true
        })
        
        if let topController = UIApplication.topViewController() {
            guard let endServiceData = endRequestEntity.responseData else {
                return
            }
            if topController is XuberInVoiceController {
                return
            } else {
                let xuberInVoiceController = XuberRouter.XuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.XuberInVoiceController) as! XuberInVoiceController
                xuberInVoiceController.endRequestData = endServiceData
                xuberInVoiceController.delegate = self
                present(xuberInVoiceController, animated: true, completion: nil)
            }
        }
    }
    
    func paymentRequestResponse(paymentEntity: ConfirmPaymentEntity) {
        currentTravelState = ServiceState.payment.rawValue
        xuberArrivedView?.dismissView(onCompletion: {
            self.xuberArrivedView = nil
            self.xuberArrivedView?.isHidden = true
        })
        showRatingView()
    }
    
    func RatingResponse(successEntity: SuccessEntity) {
        BackGroundRequestManager.share.resetBackGroudTask()
        ToastManager.show(title: Constant.RatingToast, state: .success)
        DataBaseManager.shared.delete(entityName: CoreDataEntity.location.rawValue)
        navigationController?.popViewController(animated: true)
    }
    
    func checkRequestResponse(requestEntity: XuberCheckRequest) {
        if let response = requestEntity.responseData {
            self.xuberCheckRequestData = response
            self.socketAndBgTaskSetUp()
            DispatchQueue.main.async {
                self.updateRequest(requestDetail: requestEntity)
            }
        }
    }
}
