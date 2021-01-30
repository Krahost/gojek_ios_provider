//
//  HomeViewController.swift
//  GoJekProvider
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import GoogleMaps
import MessageUI

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var goOnlineButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var airportQueueBtn: UIButton!
    //MARK: - LocalVariable
    var adminAlertView: CallAdminAlertView?
    var approvalView: ApprovalView?
    var checkRquestData: CheckResponseData?
    var isAppPresentTapOnPush: Bool = false
    let baseDetail = AppManager.share.getBaseDetails()
    var xmapView: XMapView?
    var courierRequestListView : CourierRequestListView?
    
    //Set value at online status change
    var isXJekProviderOnline = false {
        didSet {
            //Button Title change
            let buttonTitle = (isXJekProviderOnline ? HomeConstant.goOffline.localized : HomeConstant.goOnline.localized)
            goOnlineButton.setTitle(buttonTitle, for: .normal)
            
            if isXJekProviderOnline {
                locationButton.isHidden = false
                mapView.isHidden = false
                offlineView.isHidden = true
            } else {
                locationButton.isHidden = true
                mapView.isHidden = true
                offlineView.isHidden = false
            }
        }
    }
    
    private var selectedLanguage: Language = .english {
        didSet {
            LocalizeManager.share.setLocalization(language: selectedLanguage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.bringSubviewToFront(goOnlineButton)
        self.isAppPresentTapOnPush = false
        self.navigationController?.isNavigationBarHidden = true
        self.isXJekProviderOnline = true
        
        self.showTabBar()
        self.enableTabBar()
        self.addMapView()
        self.homePresenter?.getProfileDetail()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        xmapView?.frame = mapView.bounds
        goOnlineButton.setCornorRadius()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BackGroundRequestManager.share.stopBackGroundRequest()
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

private extension HomeViewController {
    
    private func viewDidSetup() {
        
        goOnlineButton.addTarget(self, action: #selector(goOnlineButtonAction(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(reconnectSocket), name: UIApplication.willEnterForegroundNotification, object: nil)
        airportQueueBtn.addTarget(self, action:  #selector(airportQueueAction(_:)), for: .touchUpInside)
        airportQueueBtn.tintColor = .white
               airportQueueBtn.setCornorRadius()
               airportQueueBtn.backgroundColor = .red
               airportQueueBtn.setImage(UIImage.init(named: TaxiConstant.ic_airportQueue), for: .normal)
        setCustomColor()
        setCustomFont()
        batteryLevelAndLowPowerModeSelect()
        mapView.backgroundColor = .backgroundColor
        self.view.backgroundColor = .backgroundColor
        self.offlineView.backgroundColor = .backgroundColor
    }
    @objc func airportQueueAction(_ sender: UIButton) {
        homePresenter?.airportQueueRequest()

       }
    private func addMapView() {
        self.xmapView = XMapView(frame: self.mapView.bounds)
        self.xmapView?.tag = 100
        self.mapView.addSubview(self.xmapView!)
    }
    
    private func removeMapView() {
        for subView in mapView.subviews where subView.tag == 100 {
            subView.removeFromSuperview()
            xmapView = nil
        }
    }
    
    //Set Custom color
    private func setCustomColor() {
        
        view.backgroundColor = .veryLightGray
        goOnlineButton.setTitleColor(.white, for: .normal)
        goOnlineButton.backgroundColor = .appPrimaryColor
    }
    
    //Set Custom color
    private func setCustomFont() {
        locationButton.layer.cornerRadius = locationButton.frame.height/2
        locationButton.layer.shadowColor = UIColor.lightGray.cgColor
        locationButton.layer.shadowOpacity = 4.0
        locationButton.imageView?.setImageColor(color: .black)
        locationButton.backgroundColor = .white
        locationButton.setImage(UIImage.init(named: TaxiConstant.currentLocationImage), for: .normal)
        locationButton.addTarget(self, action: #selector(currentLocationButtonAction(_:)), for: .touchUpInside)
        goOnlineButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x20)
    }
    
    //Check batter level
    func batteryLevelAndLowPowerModeSelect() {
        
        // Low battery level
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.isBatteryMonitoringEnabled {
            
            NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelChanged(notification:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        }
    }
}

extension HomeViewController {
    
    @objc private func reconnectSocket() {
        if let _ = checkRquestData {
            checkRquestData = nil
        }
        BackGroundRequestManager.share.resetBackGroudTask()
        self.makeCheckRequestCall()
        socketSetUp()
    }
    
    @objc func batteryLevelChanged(notification: Notification) {
        let level = UIDevice.current.batteryLevel
        print(level)
        if level <= 0.15 {
            simpleAlert(view: self, title: String.Empty, message: Constant.detectingBatteryPower.localized, buttonTitle: Constant.ok.localized)
        }
    }
    
    @objc func goOnlineButtonAction(_ sender: UIButton) {
        var status = "1"
        if isXJekProviderOnline {
            status = "0"
        }
        homePresenter?.updateProviderOnlineStatus(status: status)
    }
    
    //Curent location button action
    @objc func currentLocationButtonAction(_ sender: UIButton) {
        xmapView?.currentLocationViewSetup()
    }
}

// MARK: - Check request API Call

extension HomeViewController {
    
    func socketSetUp() {
        let profile = AppManager.share.getUserDetails()
        let saltKey = APPConstant.saltKeyValue.fromBase64()
        var cityID = "0"
        let demo = AppConfigurationManager.shared.baseConfigModel.responseData?.appsetting?.demo_mode ?? 0
        if demo == 0 {
            cityID = "\(profile?.city_id ?? 0)"
        }
        BackGroundRequestManager.share.startBackGroundRequest(type: .CommonRequest, roomId: "room_\(saltKey ?? String.Empty)_\(cityID)", listener: .common)
        BackGroundRequestManager.share.requestCallback = { [weak self] in
            guard let self = self else {
                return
            }
            self.makeCheckRequestCall()
        }
    }
    
    func makeCheckRequestCall() {
        
        let param: Parameters = [HomeConstant.latitude: XCurrentLocation.shared.latitude ?? 0.0,
                                 HomeConstant.longitude: XCurrentLocation.shared.longitude ?? 0.0]
        homePresenter?.checkRequest(param: param)
        
    }
    
    private func showCourierRequestList() {
        if self.courierRequestListView == nil, let listView = Bundle.main.loadNibNamed(CourierConstant.CourierRequestListView, owner: self, options: [:])?.first as? CourierRequestListView {
            
            listView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            self.courierRequestListView = listView
            //view.addTransparent(with: listView)
            self.view.addSubview(listView)
            listView.show(with: .bottom, completion: nil)
        }
        
        DispatchQueue.main.async {
     
            self.courierRequestListView?.labelDeliveryalue.text = "\(self.checkRquestData?.requests?.first?.delivery?.count ?? 0)"
            
            if let deliverArray = self.checkRquestData?.requests?.first?.request?.deliveryArr{
                
                self.courierRequestListView?.labelDeliveryalue.text = "\(deliverArray.count)"
                
            }
            
        
            self.courierRequestListView?.labelPickupLocationValue.text = self.checkRquestData?.requests?.first?.request?.sAddress
    
        
            self.courierRequestListView?.labelPricValue.text = "\("CFA" )\(self.checkRquestData?.requests?.first?.total_amount ?? 0)"
        
            self.courierRequestListView?.labelSenderName.text = self.checkRquestData?.requests?.first?.user?.firstName ?? ""
         }
        self.courierRequestListView?.tapOnAccept = {
              
                let param: Parameters = [HomeConstant.id: (self.checkRquestData?.requests?.first?.requestId ?? 0),
                                         HomeConstant.serviceId: (self.checkRquestData?.requests?.first?.adminServiceId ?? 0)]
                self.homePresenter?.acceptRequestDetail(param: param)
    
        }
        
        
    }
    
    //Request detail vaidation
    private func updateCheckRequestDetail() {
        
        //Check user online or offline
        DispatchQueue.main.async {
            if self.checkRquestData?.providerDetails?.isOnline == 1 {
                self.isXJekProviderOnline = true
                
                let negativeBalance = Double(self.baseDetail?.appsetting?.provider_negative_balance ?? "0") ?? 0.0
                let walletAmount = AppManager.share.getUserDetails()?.wallet_balance ?? 0.0
                if walletAmount < negativeBalance {
                    self.showAdminAlertView(alertdescription: HomeConstant.lowWallet, actionTitle: HomeConstant.rechargeWallet)
                }
            }
            else {
                self.isXJekProviderOnline = false
            }
        }
        //Document validation
        guard let providerDetail = checkRquestData?.providerDetails else {
            return
        }
        
        var pendingTypes: [PendingType] = []
        //Service document
        if providerDetail.isService == 0 {
            pendingTypes.append(.Service)
        }
        //Common docuemnt
        if providerDetail.isDocument == 0 {
            pendingTypes.append(.Document)
        }
        //Bank document
        if providerDetail.isBankdetail == 0 {
            pendingTypes.append(.BankDetails)
        }
        if providerDetail.isProfile == 0 {
            pendingTypes.append(.profile)
        }
        //Navigate document or account
        if pendingTypes.count > 0 {
            DispatchQueue.main.async {
                self.removeAdminAlertView()
                self.showIncompleteProfileDetails(pendingType: pendingTypes)
            }
        } else {
            self.accountStatesValidate()
        }
    }
    
    //Account state validate
    private func accountStatesValidate() {
        
        
        if checkRquestData?.providerDetails?.activationStatus == 0 {
            removeAdminAlertView()
            self.accDisableView()
         //   self.tabBarController?.tabBar.isHidden = true
         // approvalView?.setAccountDisableUI()
        }else{
         //    self.tabBarController?.tabBar.isHidden = false
        switch checkRquestData?.accountStatus {
        //Waiting for admin approval
        case AccountStatus.document.rawValue:
            removeAdminAlertView()
            var pendingTypes: [PendingType] = []
            pendingTypes.append(.adminApproval)
            showIncompleteProfileDetails(pendingType: pendingTypes)
        //Admin approved
        case AccountStatus.approved.rawValue:
            //Check service status
            removeApprovalView()
            removeAdminAlertView()
            if let tempStatus = checkRquestData?.serviceStatus {
                checkServiceType(status: tempStatus, requestData: checkRquestData)
            }
        //Bannded by admin
        case AccountStatus.banned.rawValue:
            removeApprovalView()
            showAdminAlertView(alertdescription: HomeConstant.callAdminAlert, actionTitle: HomeConstant.contactAdmin)
            
        default:
            break
        }
        }
    }
    
    //Remove view once done
    private func removeApprovalView() {
        //Remove approval view
        if approvalView != nil {
            approvalView?.superview?.removeFromSuperview()
            approvalView?.dismissView(onCompletion: {
                self.approvalView = nil
            })
        }
    }
    
    private func removeAdminAlertView() {
        //Remove admin alert view
        if adminAlertView != nil {
            adminAlertView?.superview?.removeFromSuperview()
            adminAlertView?.dismissView(onCompletion: {
                self.adminAlertView = nil
            })
        }
    }
    
    func checkServiceType(status: String, requestData: CheckResponseData?) {
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("App in Background")
            return
        }
        let topController = UIApplication.topViewController()
        if let data = requestData,
            let serviceRequest = data.requests?.first {
            
            if serviceRequest.status ?? String.Empty == TravelState.searching.rawValue {
                DispatchQueue.main.async {
                    self.showIncomingRequestView()
                }
            } else {
                
                
                if topController is IncomingRequestController {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        self.enableTabBar()
                        self.checkServiceType(status: status, requestData: requestData)
                    }
                }
            }
            
            if topController is HomeViewController {
                DispatchQueue.main.async {
                    self.moveToRespectiveServiceModule(status: status)
                }
            }
            
        } else {
            
            if topController is IncomingRequestController {
                dismiss(animated: true, completion: nil)
                self.enableTabBar()
            }
            
            if topController is HomeViewController {
                DispatchQueue.main.async {
                    self.moveToRespectiveServiceModule(status: status)
                }
            }
        }
    }
    
    func moveToRespectiveServiceModule(status: String) {
        
        //For Double check is valid request for current user
        if let reqestDetails = checkRquestData?.requests?.first {
            if (reqestDetails.providerId ?? 0) != (AppManager.share.getUserDetails()?.id ?? 0) {
                return
            }
        }
        DispatchQueue.main.async {
            switch status {
            case ActiveStatus.transport.rawValue:
                self.onRideNavigation(to: ActiveStatus.transport.rawValue)
            case ActiveStatus.order.rawValue:
                self.onRideNavigation(to: ActiveStatus.order.rawValue)
            case ActiveStatus.service.rawValue:
                self.onRideNavigation(to: ActiveStatus.service.rawValue)
            case ActiveStatus.delivery.rawValue:
                 self.onRideNavigation(to: ActiveStatus.delivery.rawValue)
            default:
                break
            }
        }
    }
    
    private func onRideNavigation(to applicationType: String) {
        
        BackGroundRequestManager.share.stopBackGroundRequest()
        XSocketIOManager.sharedInstance.connectedWithRoom = false
        let topController = UIApplication.topViewController()
        
        switch applicationType {
        //Taxi app home screen navigate
        case ActiveStatus.transport.rawValue:
            if topController is TaxiHomeViewController {
                return
            } else {
                let taxiHomeViewController = TaxiRouter.createTaxiModule()
                navigationController?.pushViewController(taxiHomeViewController, animated: true)
            }
            
        //Foodie app home screen navigate
        case ActiveStatus.order.rawValue:
            if topController is FoodieLiveTaskController {
                return
            } else {
                let foodieHomeViewController = FoodieRouter.createFoodieModule()
                navigationController?.pushViewController(foodieHomeViewController, animated: true)
            }
            
        //Service app home screen navigate
        case ActiveStatus.service.rawValue:
            if topController is XuberHomeViewController {
                return
            } else {
                let xuberHomeViewController = XuberRouter.createXuberModule()
                navigationController?.pushViewController(xuberHomeViewController, animated: true)
            }
           case ActiveStatus.delivery.rawValue:
            
            if topController is CourierHomeController {
                return
            } else {
                let courierHomeViewController = CourierRouter.createCourierModule()
                navigationController?.pushViewController(courierHomeViewController, animated: true)
            }
            
            
        default:
            break
        }
    }
    
    //Show the document incomplete view
    private func showIncompleteProfileDetails(pendingType: [PendingType]) {
        
        if approvalView == nil,
            let tempApprovalView = Bundle.main.loadNibNamed(HomeConstant.ApprovalView, owner: self, options: [:])?.first as? ApprovalView {
            
            tempApprovalView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            approvalView = tempApprovalView
            self.view.addTransparent(with: tempApprovalView)
            tempApprovalView.show(with: .bottom, completion: nil)
            approvalView?.approvalType = pendingType
            approvalView?.setApprovalPendingUI()
            approvalView?.onClickPendingType = { [weak self] (type) in
                guard let self = self else {
                    return
                }
                self.approvalView?.superview?.removeFromSuperview()
                self.approvalView?.dismissView(onCompletion: {
                    self.approvalView = nil
                    guard let pendingType = type else {
                        return
                    }
                    self.navigateToPendingTypeView(type: pendingType)
                })
            }
        } else {
            //if pendingType ==
            approvalView?.approvalType = pendingType
            approvalView?.setApprovalPendingUI()
        }
    }
    
// show disable view
    func accDisableView() {
    if approvalView == nil,
               let tempApprovalView = Bundle.main.loadNibNamed(HomeConstant.ApprovalView, owner: self, options: [:])?.first as? ApprovalView {
               
               tempApprovalView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
               approvalView = tempApprovalView
        self.view.window?.addTransparent(with: tempApprovalView)
               tempApprovalView.show(with: .bottom, completion: nil)
        approvalView?.approvalType = [PendingType.adminApproval]
           approvalView?.setAccountDisableUI()
               approvalView?.onClickPendingType = { [weak self] (type) in
                   guard let self = self else {
                       return
                   }
                   self.approvalView?.superview?.removeFromSuperview()
                   self.approvalView?.dismissView(onCompletion: {
                       self.approvalView = nil
                       guard let pendingType = type else {
                           return
                       }
                       self.navigateToPendingTypeView(type: pendingType)
                   })
               }
           } else {
               //if pendingType ==
        approvalView?.approvalType = [PendingType.adminApproval]
               approvalView?.setAccountDisableUI()
           }
    }
    
    //Navigate to pending type view
    private func navigateToPendingTypeView(type: PendingType) {
        switch type {
        case .BankDetails:
            let bankDetailController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.BankDetailController) as! BankDetailController
            navigationController?.pushViewController(bankDetailController, animated: true)
            
        case .Service:
            let manageServiceController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ManageServiceController) as! ManageServiceController
            navigationController?.pushViewController(manageServiceController, animated: true)
            
        case .Document:
            let manageDoucmentController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ManageDocumentController) as! ManageDocumentController
            navigationController?.pushViewController(manageDoucmentController, animated: true)
            
        case .profile:
            let profileController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.MyProfileController) as! MyProfileController
            navigationController?.pushViewController(profileController, animated: true)
        default:
            break
        }
    }
    
    //Show incoming request view
    private func showIncomingRequestView() {
        disableTabBar()
        tabBarController?.selectedIndex = 0
        if UIApplication.topViewController() is IncomingRequestController {return}
        let incomingVC = HomeRouter.homeStoryboard.instantiateViewController(withIdentifier: HomeConstant.IncomingViewController) as! IncomingRequestController
        incomingVC.modalPresentationStyle = .overCurrentContext
        incomingVC.checkResponseDetail = checkRquestData
        incomingVC.delegate = self
        present(incomingVC, animated: true, completion: nil)
    }
    
    //Show Bannded user view
    private func showAdminAlertView(alertdescription: String, actionTitle: String) {
        if adminAlertView == nil, let tempAlertView = Bundle.main.loadNibNamed(HomeConstant.VCallAdminAlertView, owner: self, options: [:])?.first as? CallAdminAlertView {
            tempAlertView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            adminAlertView = tempAlertView
            view.addTransparent(with: tempAlertView)
            tempAlertView.show(with: .bottom, completion: nil)
            adminAlertView?.alertDescriptionLabel.text = alertdescription
            adminAlertView?.callAdminButton.setTitle(actionTitle, for: .normal)
            adminAlertView?.onClickSubmit = { [weak self] onAdmin in
                guard let self = self else {
                    return
                }
                self.removeAdminAlertView()
                if actionTitle == HomeConstant.rechargeWallet {
                    let resetPasswordController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.PaymentViewController) as! PaymentViewController
                    self.navigationController?.pushViewController(resetPasswordController, animated: true)
                } else {
                    if let email = self.baseDetail?.appsetting?.supportdetails?.contact_email {
                        AppUtils.shared.sendEmail(to: [email], from: self, subject: "Hi \(APPConstant.appName) Team")
                    }
                }
            }
        }
    }
    
    private func localizable() {
        
        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
            self.selectedLanguage = language
            
        }else {
            LocalizeManager.share.setLocalization(language: .english)
        }
        
        if !CommonFunction.isAppAlreadyLaunchedOnce() {
            if self.selectedLanguage == .arabic {
                
                self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                
            }else {
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        
        if !CommonFunction.checkisRTL() {
            
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        showTabBar()
    }
}

// MARK: - HomePresenterToHomeViewProtocol

extension HomeViewController: IncomingRequestDelegate {
    
    internal func acceptButtonAction(_ sender: UIButton) {
//        if checkRquestData?.requests?.first?.request?.admin_service == "DELIVERY"
//               {
//                   showCourierRequestList()
//
//               }else{
               
               let param: Parameters = [HomeConstant.id: (checkRquestData?.requests?.first?.requestId ?? 0),
                                        HomeConstant.serviceId: (checkRquestData?.requests?.first?.adminServiceId ?? 0)]
               homePresenter?.acceptRequestDetail(param: param)
               
               
               //}
          
        
        
    }
    
    internal func rejectButtonAction(_ sender: UIButton) {
        
        let param: Parameters = [HomeConstant.id: (checkRquestData?.requests?.first?.requestId ?? 0),
                                 HomeConstant.serviceId: (checkRquestData?.requests?.first?.adminServiceId ?? 0)]
        homePresenter?.cancelRequestDetail(param: param)
    }
    
    internal func finishButtonAction() {
        self.enableTabBar()
        makeCheckRequestCall()
    }
}

// MARK: - HomePresenterToHomeViewProtocol

extension HomeViewController: HomePresenterToHomeViewProtocol {
    

    func viewProfileDetail(profileEntity: ProfileEntity) {
        if let userDetails = profileEntity.responseData {
            AppManager.share.setUserDetails(details: userDetails)
            if userDetails.airport_at != "" && userDetails.airport_at != nil{
                airportQueueBtn.backgroundColor = .red
                
            }else{
                airportQueueBtn.backgroundColor = .gray
            }
        }
        if !CommonFunction.checkisRTL() {
            UserDefaults.standard.set(AppManager.share.getUserDetails()?.language, forKey: MyAccountConstant.language)
            self.localizable()
        }
       
        socketSetUp()
        makeCheckRequestCall()
    }
    
    func acceptRequestSuccess(acceptRequestEntity: HomeEntity) {
        
        let topVC = UIApplication.topViewController()
        if topVC is IncomingRequestController {
            DispatchQueue.main.async {
                self.enableTabBar()
                topVC?.dismiss(animated: true, completion: nil)
                self.makeCheckRequestCall()
            }
        }
    }
    
    func cancelRequestSuccess(cancelRequestEntity: HomeEntity) {
        let topVC = UIApplication.topViewController()
        if topVC is IncomingRequestController {
            DispatchQueue.main.async {
                topVC?.dismiss(animated: true, completion: {
                    self.enableTabBar()
                })
            }
        }
    }
    
    func providerOnlineStatusResponse(providerEntity: ProviderEntity) {
        
        print(providerEntity)
        if providerEntity.responseData?.providerStatus == "0" {
            isXJekProviderOnline = false
        } else {
            isXJekProviderOnline = true
        }
    }
    
    func checkRequestSuccess(homeEntity: HomeEntity) {
        
        print("check Request response \(String(describing: homeEntity.responseData?.requests?.count))")
        checkRquestData = homeEntity.responseData
        updateCheckRequestDetail()
    }
    
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity) {
      //  print(airportQueueEntity.message ?? "")
        ToastManager.show(title: airportQueueEntity.message ?? "", state: .warning)
        if airportQueueEntity.responseData?.status == 1{
             airportQueueBtn.backgroundColor = .red
        }else {
             airportQueueBtn.backgroundColor = .gray
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate

extension HomeViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
