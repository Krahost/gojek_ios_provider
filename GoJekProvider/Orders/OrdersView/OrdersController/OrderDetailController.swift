//
//  OrderDetailController.swift
//  GoJekUser
//
//  Created by Thiru on 26/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class OrderDetailController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var disputeButton: UIButton!
    @IBOutlet weak var viewReceiptButton: UIButton!
    
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var locationTableView: UITableView!

    
    private var disputeStatusView: DisputeStatusView?
    private var disputeView: DisputeLostItemView?
    private var receiptView: ReceiptView?
    
    var orderDetailData: OrderDetailReponseData?
    var disputeList: [DisputeListData] = []
    var selectedServiceType: ServiceTypes = .trips
    var tripId: Int = 0
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()
        navigationController?.isNavigationBarHidden = true
    }
}

//MARK:- LocalMethod

extension OrderDetailController  {
    
    private func initialLoads() {
        
        let backAction = UITapGestureRecognizer(target: self, action: #selector(tapBackButton))
        backButtonView.addGestureRecognizer(backAction)
        if CommonFunction.checkisRTL() {
            self.backButtonView.transform = self.backButtonView.transform.rotated(by: .pi)
        }
        
        disputeButton.addTarget(self, action: #selector(tapDispute), for: .touchUpInside)
        viewReceiptButton.addTarget(self, action: #selector(tapViewReceipt), for: .touchUpInside)
        DispatchQueue.main.async {
            self.disputeButton.setCornorRadius()
            self.viewReceiptButton.setCornorRadius()
        }
        //Web Request
        ordersPresenter?.getOrderDetail(id: tripId.toString(), type: selectedServiceType.currentType)
        
        setCustomColor()
        setCustomlocalize()
        setCustomFont()
        locationTableView.register(nibName: OrdersConstant.SourceTableViewCell)
        locationTableView.register(nibName: OrdersConstant.SourceDestinationCell)
        
        locationTableView.register(nibName: OrdersConstant.ProfileCell)
        locationTableView.register(nibName: OrdersConstant.DetailOrderCell)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        navigationView.backgroundColor = .boxColor
        backButtonImage.setImageColor(color: .blackColor)
        self.view.backgroundColor = .backgroundColor
    }
    
    private func setCustomFont() {
        orderIDLabel.font = .setCustomFont(name: .bold, size: .x14)
        orderTypeLabel.font = .setCustomFont(name: .medium, size: .x12)
        dateLabel.font = .setCustomFont(name: .medium, size: .x12)
        timeLabel.font = .setCustomFont(name: .medium, size: .x12)
        disputeButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        viewReceiptButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
    }
    
    private func setCustomColor() {
        
        dateLabel.textColor = .appPrimaryColor
        orderTypeLabel.textColor = .lightGray
        timeLabel.textColor = .appPrimaryColor
        disputeButton.backgroundColor = .appPrimaryColor
        viewReceiptButton.backgroundColor = .appPrimaryColor
        view.backgroundColor = .veryLightGray
        navigationView.addShadow(radius: 0, color: .lightGray)
    }
    
    private func setCustomlocalize() {
        viewReceiptButton.setTitle(OrdersConstant.viewReceipt.localized, for: .normal)
    }
    
    private func showDisputeStatus(){
        
        if disputeStatusView == nil, let disputeStatusView = Bundle.main.loadNibNamed(OrdersConstant.DisputeStatusView, owner: self, options: [:])?.first as? DisputeStatusView {
            
            disputeStatusView.frame = CGRect(x: 0, y: view.frame.height-disputeStatusView.frame.height, width: view.frame.width, height: disputeStatusView.frame.height)
            self.disputeStatusView = disputeStatusView
            var disputeString = ""
            var heightValue = 0
            
            var bottom: CGFloat = 0
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let bottomPadding = window?.safeAreaInsets.bottom
            bottom = bottomPadding ?? 0
            
            if selectedServiceType == .service {
                if let dispute = orderDetailData?.service?.dispute {
                    disputeStatusView.setValues(values: dispute)
                    if let disputenameString = self.orderDetailData?.service?.dispute?.dispute_name {
                        
                        if let commentString = self.orderDetailData?.service?.dispute?.comments {
                            disputeString = disputenameString + commentString
                            heightValue = 160
                        }else {
                            disputeString = disputenameString
                            heightValue = 120
                        }
                    }
                }
            } else if selectedServiceType == .trips {
                if let dispute = self.orderDetailData?.transport?.dispute {
                    disputeStatusView.setValues(values: dispute)
                    if let disputenameString = self.orderDetailData?.transport?.dispute?.dispute_name {
                        
                        if let commentString = self.orderDetailData?.transport?.dispute?.comments {
                            disputeString = disputenameString + commentString
                            heightValue = 160
                        }else {
                            disputeString = disputenameString
                            heightValue = 120
                        }
                    }
                }
            }else if selectedServiceType == .delivery {
                if let dispute = self.orderDetailData?.delivery?.dispute {
                    disputeStatusView.setValues(values: dispute)
                    if let disputenameString = self.orderDetailData?.delivery?.dispute?.dispute_name {
                        
                        if let commentString = self.orderDetailData?.delivery?.dispute?.comments {
                            disputeString = disputenameString + commentString
                            heightValue = 160
                        }else {
                            disputeString = disputenameString
                            heightValue = 120
                        }
                    }
                }
            } else {
                if let dispute = self.orderDetailData?.foodie?.dispute {
                    disputeStatusView.setValues(values: dispute)
                    if let disputenameString = self.orderDetailData?.foodie?.dispute?.dispute_name {
                        
                        if let commentString = self.orderDetailData?.foodie?.dispute?.comments {
                            disputeString = disputenameString + commentString
                            heightValue = 160
                        }else {
                            disputeString = disputenameString
                            heightValue = 120
                        }
                    }
                    
                }
            }
            disputeStatusView.DisputeStatusViewHeight.constant = disputeString.heightOfString(usingFont: UIFont.setCustomFont(name: .light, size: .x12), width: disputeStatusView.frame.width-150) + CGFloat(heightValue)
            disputeStatusView.frame = CGRect(x: 0, y: self.view.frame.height - disputeStatusView.DisputeStatusViewHeight.constant - bottom, width: self.view.frame.width, height: disputeStatusView.DisputeStatusViewHeight.constant)
            self.disputeStatusView?.show(with: .bottom, completion: nil)
            showDimView(view: self.disputeStatusView ?? DisputeStatusView())
        }
    }
    
    func showDisputeView() {
        if disputeView == nil, let disputeView = Bundle.main.loadNibNamed(OrdersConstant.DisputeLostItemView, owner: self, options: [:])?.first as? DisputeLostItemView {
            let disputeHeight = disputeView.frame.height
            disputeView.frame = CGRect(x: 0, y: view.frame.height-disputeHeight, width: view.frame.width, height: disputeHeight)
            self.disputeView = disputeView
            disputeView.set(value: disputeList)
            
            self.disputeView?.show(with: .bottom, completion: nil)
            showDimView(view: self.disputeView ?? DisputeLostItemView())
        }
        disputeView?.didSelectReason = { [weak self] (selectedDispute) in
            guard let self = self else {
                return
            }
            var param: Parameters = [OrdersConstant.Pid : self.tripId.toString(),
                                     OrdersConstant.Pdispute_type : userType.Provider.rawValue,
                                     OrdersConstant.Pdispute_name : selectedDispute]
            if self.selectedServiceType == .service {
                param[OrdersConstant.PuserId] = self.orderDetailData?.service?.user?.id ?? 0
                param[OrdersConstant.Pprovider_id] = self.orderDetailData?.service?.provider_id ?? 0
                
            } else if self.selectedServiceType == .trips {
                param[OrdersConstant.PuserId] = self.orderDetailData?.transport?.user?.id ?? 0
                param[OrdersConstant.Pprovider_id] = self.orderDetailData?.transport?.provider_id ?? 0
                
            } else if self.selectedServiceType == .delivery {
                param[OrdersConstant.PuserId] = self.orderDetailData?.delivery?.user?.id ?? 0
                param[OrdersConstant.Pprovider_id] = self.orderDetailData?.delivery?.provider_id ?? 0
                
            } else {
                param[OrdersConstant.PuserId] = self.orderDetailData?.foodie?.user?.id ?? 0
                param[OrdersConstant.PDisputeId] = self.orderDetailData?.foodie?.id ?? 0
                param[OrdersConstant.PStoreId] = self.orderDetailData?.foodie?.order_invoice?.store_order_id ?? 0
                param[OrdersConstant.Pprovider_id] = self.orderDetailData?.foodie?.provider_id ?? 0
                
            }
            self.ordersPresenter?.addDispute(param: param,type:self.selectedServiceType)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if disputeView != nil {
            disputeView?.superview?.dismissView(onCompletion: { [weak self] in
                guard let self = self else {
                    return
                }
                self.disputeView = nil
            })
        }
        if disputeStatusView != nil {
            disputeStatusView?.superview?.dismissView(onCompletion: { [weak self] in
                guard let self = self else {
                    return
                }
                self.disputeStatusView = nil
            })
        }
    }
    
    private func dateFormatConvertion(dateString: String) -> String {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        let dateFormat = Int(baseConfig?.responseData?.appsetting?.date_format ?? "0")
        let dateFormatTo = dateFormat == 1 ? DateFormat.dd_mm_yyyy_hh_mm_ss : DateFormat.dd_mm_yyyy_hh_mm_ss_a
        let dateFormatReturn = dateFormat == 1 ? DateFormat.ddMMMyy24 : DateFormat.ddMMMyy12
        return AppUtils.shared.dateToString(dateStr: dateString, dateFormatTo: dateFormatTo, dateFormatReturn: dateFormatReturn)
    }
    
    private func setDateAndTime(dateString: String) {
        let seperatedStrArr = dateString.components(separatedBy: ",")
        if seperatedStrArr.count > 1 {
            timeLabel.text = String.removeNil(seperatedStrArr[1])
            dateLabel.text =  String.removeNil(seperatedStrArr[0])
        } else  {
            timeLabel.text = String.Empty
            dateLabel.text =  String.removeNil(seperatedStrArr[0])
        }
    }
    
    private func setServiceValues() {
        DispatchQueue.main.async {
            if let transportData = self.orderDetailData?.service {
                if let dateStr = transportData.created_time {
                    let dateValue = self.dateFormatConvertion(dateString: dateStr)
                    self.setDateAndTime(dateString: dateValue)
                }
                let bookId = transportData.booking_id ?? String.Empty
                self.orderIDLabel.text = bookId
                self.orderTypeLabel.text = (transportData.service?.service_name ?? String.Empty)
                if transportData.dispute  != nil {
                    self.disputeButton.setTitle(OrdersConstant.disputeStatus.localized, for: .normal)
                } else {
                    self.disputeButton.setTitle(OrdersConstant.dispute.localized, for: .normal)
                }
            }
        }
    }
    
    private func setTransportValues() {
        
        DispatchQueue.main.async {
            if let transportData = self.orderDetailData?.transport {
                if let dateStr = transportData.created_time {
                    let dateValue = self.dateFormatConvertion(dateString: dateStr)
                    self.setDateAndTime(dateString: dateValue)
                }
                var bookId = transportData.booking_id ?? String.Empty
                bookId = bookId+" ("+(transportData.provider_rated?.toString() ?? String.Empty)+" Rating)"
                self.orderIDLabel.text = bookId
                self.orderTypeLabel.text = (transportData.ride?.vehicle_name?.giveSpace ?? String.Empty) + (transportData.provider_vehicle?.vehicle_no ?? String.Empty)
                
                //Dispute is nil
                if transportData.dispute != nil {
                    self.disputeButton.setTitle(OrdersConstant.disputeStatus.localized, for: .normal)
                } else {
                    self.disputeButton.setTitle(OrdersConstant.dispute.localized, for: .normal)
                }
            }
        }
    }
    
    private func setCourierValues() {
        
        DispatchQueue.main.async {
            if let transportData = self.orderDetailData?.delivery {
                if let dateStr = transportData.created_time {
                    let dateValue = self.dateFormatConvertion(dateString: dateStr)
                    self.setDateAndTime(dateString: dateValue)
                }
                var bookId = transportData.booking_id ?? String.Empty
                bookId = bookId+" ("+(transportData.provider_rated?.toString() ?? String.Empty)+" Rating)"
                self.orderIDLabel.text = bookId
                self.orderTypeLabel.text = (transportData.service?.vehicle_name?.giveSpace ?? String.Empty) + (transportData.service_type?.vehicle?.vehicle_no ?? String.Empty)
             
                //Dispute is nil
                if transportData.dispute != nil {
                    self.disputeButton.setTitle(OrdersConstant.disputeStatus.localized, for: .normal)
                } else {
                    self.disputeButton.setTitle(OrdersConstant.dispute.localized, for: .normal)
                }
            }
        }
    }
    
    private func setFoodieValues() {
        DispatchQueue.main.async {
            if let foodieData = self.orderDetailData?.foodie {
               
                if let dateStr = foodieData.created_time {
                    let dateValue = self.dateFormatConvertion(dateString: dateStr)
                    self.setDateAndTime(dateString: dateValue)
                }
                self.orderIDLabel.text = foodieData.store_order_invoice_id ?? String.Empty
                self.orderTypeLabel.text = (foodieData.pickup?.store_name ?? String.Empty) + "," + (foodieData.pickup?.store_location ?? String.Empty)
                
                if foodieData.dispute  != nil {
                    self.disputeButton.setTitle(OrdersConstant.disputeStatus.localized, for: .normal)
                } else {
                    self.disputeButton.setTitle(OrdersConstant.dispute.localized, for: .normal)
                }
            }
        }
    }
}

//MARK: - IBAction

extension OrderDetailController {
    
    @objc func tapBackButton() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapDispute() {
        if disputeButton.currentTitle == OrdersConstant.dispute.localized {
            showDisputeView()
        } else {
            showDisputeStatus()
        }
    }
    
    @objc func tapViewReceipt() {
        
        //Check Multiple Delivery
        if (self.orderDetailData?.delivery?.deliveries?.count != 1) && (selectedServiceType == .delivery) {
            let alert = UIAlertController(title: APPConstant.appName.localized, message: "", preferredStyle: .actionSheet)
            
            for i in 0..<(self.orderDetailData?.delivery?.deliveries?.count ?? 0) {
                alert.addAction(UIAlertAction(title: OrdersConstant.delivery.localized + " " + "\(i + 1)", style: .default , handler:{ (UIAlertAction)in
                    if self.receiptView == nil, let receiptView = Bundle.main.loadNibNamed(OrdersConstant.ReceiptView, owner: self, options: [:])?.first as? ReceiptView {
                    receiptView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    self.receiptView = receiptView
                    if let payment = self.orderDetailData?.delivery {
                        self.receiptView?.setCourierVaue(values: payment, index: i)
                    }
                    self.receiptView?.show(with: .bottom, completion: nil)
                    self.showDimView(view: self.receiptView ?? DisputeStatusView())
                    }
                    self.receiptView?.onTapClose = { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.receiptView?.superview?.dismissView(onCompletion: {
                            self.receiptView = nil
                        })
                    }
                }))
            }
            
            alert.addAction(UIAlertAction(title: Constant.dismiss.localized, style: .cancel, handler:{ (UIAlertAction)in
            }))
            self.present(alert, animated: true, completion: {
            })
        }
        else{
        
        if receiptView == nil, let receiptView = Bundle.main.loadNibNamed(OrdersConstant.ReceiptView, owner: self, options: [:])?.first as? ReceiptView {
            
            receiptView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            self.receiptView = receiptView
            if selectedServiceType == .orders  {
                if let payment = orderDetailData?.foodie?.order_invoice {
                    self.receiptView?.setFoodieValues(values: payment)
                }
            }
            else if self.selectedServiceType == .trips  {
                if let payment = self.orderDetailData?.transport?.payment {
                    self.receiptView?.setValues(values: payment,calculator: self.orderDetailData?.transport?.calculator ?? "")
                }
            }
            else if self.selectedServiceType == .service  {
                          
                if let payment = self.orderDetailData?.service?.payment
                {
                    self.receiptView?.setValues(values: payment,calculator: self.orderDetailData?.transport?.calculator ?? "")
                }
            }
            else {
                if let payment = self.orderDetailData?.delivery {
                    self.receiptView?.setCourierVaue(values: payment, index: 0)
                }
            }
            
            self.receiptView?.show(with: .bottom, completion: nil)
            showDimView(view: self.receiptView ?? DisputeStatusView())
        }
        self.receiptView?.onTapClose = {
            self.receiptView?.superview?.dismissView(onCompletion: {
                self.receiptView = nil
            })
        }
        }
    }
}

//MARK: - OrdersPresenterToOrdersViewProtocol

extension OrderDetailController:  OrdersPresenterToOrdersViewProtocol {
    
    func getOrderDetail(orderDetailEntity: OrderDetailEntity) {
        orderDetailData = orderDetailEntity.responseData
        if selectedServiceType == .trips {
            setTransportValues()
            ordersPresenter?.getDisputeList(serviceType:"ride")
        }
        else if selectedServiceType == .orders {
            setFoodieValues()
            ordersPresenter?.getDisputeList(serviceType:"order")
            
        }else if selectedServiceType == .delivery {
            setCourierValues()
            ordersPresenter?.getDisputeList(serviceType:"delivery")
            
        } else {
            setServiceValues()
            ordersPresenter?.getDisputeList(serviceType:"services")
            
        }
        locationTableView.reloadData()

    }
    
    func getDisputeList(disputeList: DisputeListEntity) {
        self.disputeList = disputeList.responseData ?? []
    }
    
    func addDispute(disputeEntity: SuccessEntity) {
        ToastManager.show(title: OrdersConstant.disputeCreatedMsg.localized, state: .success)
        if disputeView != nil {
            disputeView?.superview?.dismissView(onCompletion: {
                self.disputeView = nil
                self.ordersPresenter?.getOrderDetail(id:self.tripId.toString(),type:self.selectedServiceType.currentType)
            })
        }
    }
}
extension OrderDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdersConstant.ProfileCell, for: indexPath) as! ProfileCell
            if let orderdata = self.orderDetailData {
                cell.setValues(data: orderdata)
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdersConstant.SourceTableViewCell, for: indexPath) as! SourceTableViewCell
            if selectedServiceType == .trips {
                cell.sourceLabel.text = self.orderDetailData?.transport?.s_address
            }else if selectedServiceType == .orders {
                cell.sourceLabel.text = self.orderDetailData?.foodie?.pickup?.store_location
            }else if selectedServiceType == .delivery {
                cell.sourceLabel.text = self.orderDetailData?.delivery?.s_address
            }else{
                cell.sourceLabel.text = self.orderDetailData?.service?.s_address
            }
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdersConstant.SourceDestinationCell, for: indexPath) as! SourceDestinationCell
            if selectedServiceType == .trips {
                cell.destinationLabel.text = self.orderDetailData?.transport?.d_address
            }else if selectedServiceType == .orders {
                cell.destinationLabel.text = self.orderDetailData?.foodie?.delivery?.map_address
            }else if selectedServiceType == .delivery {
                let delivery = self.orderDetailData?.delivery?.deliveries?[indexPath.row]
                cell.destinationLabel.text = delivery?.d_address
            }
            if indexPath.row == ((self.orderDetailData?.delivery?.deliveries?.count ?? 0) - 1) {
                cell.centerStatusView.isHidden = true
            }else{
                cell.centerStatusView.isHidden = false
            }
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdersConstant.DetailOrderCell, for: indexPath) as! DetailOrderCell
            if let orderdata = self.orderDetailData {
                cell.setValues(data: orderdata)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if section == 0 || section == 1 || section == 3{
            count = 1
        }else if section == 2 {
            if selectedServiceType == .trips || selectedServiceType == .orders{
                count = 1
            }else if selectedServiceType == .delivery {
                count = self.orderDetailData?.delivery?.deliveries?.count ?? 0
            }
        }
        return count
    }
    
}
