//
//  OrdersController.swift
//  GoJekUser
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class OrdersController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var filterBtnView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    
    //MARK: - LocalVariable
    var filterView: FilterView!
    var orderHistoryData: HistoryResponseData?
    

    var isUpdate:Bool = false
    
    
    var historyType: HistoryType = .past {
        didSet {
            //            updateUI()
        }
    }
    var selectedServiceType:String = String.Empty
    var currentServiceType:ServiceTypes = .trips
    var nextpageurl = ""
      var currentPage = 1
          
    
    // View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationbar()
        initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingIndicator.show()
        currentPage = 1
        getOrderHistory()
        navigationController?.isNavigationBarHidden = false
        addNavigationTitle()
        showTabBar()
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
         setDarkMode()
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if filterView != nil {
            filterView.superview?.dismissView(onCompletion: { [weak self] in
                guard let self = self else {
                    return
                }
                self.filterView = nil
            })
        }
    }
}

//MARK: - LocalMethod
extension OrdersController {
    
    func initialLoad() {
        setNavigationTitle()
        ordersTableView.register(nibName: OrdersConstant.VOrderTableViewCell)
        filterBtnView.backgroundColor = .white
        
        filterButton.setImage(UIImage(named: OrdersConstant.icfilter)?.withRenderingMode(.alwaysTemplate), for: .normal)
        filterButton.tintColor = .appPrimaryColor
        
        filterBtnView.setCornerRadius()

        
        historyType = .past
        currentPage = 1
 
        filterButton.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        addshadow()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.filterBtnView.backgroundColor = .boxColor
        if(isDarkMode){
             filterBtnView.layer.borderColor = UIColor.white.cgColor
             filterBtnView.layer.borderWidth = 0.5
             filterBtnView.layer.shadowOpacity = 0.0
             filterBtnView.layer.shadowRadius = 0.0
         }
         else{
             filterBtnView.layer.borderWidth = 0.0
             filterBtnView.layer.shadowColor = UIColor.lightGray.cgColor
             filterBtnView.layer.shadowOpacity = 3.0
             filterBtnView.layer.shadowRadius = 8.0
             filterBtnView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.2))
             filterBtnView.layer.masksToBounds = false
             filterBtnView.addShadow(offset: CGSize.init(width: 0, height: 3), color: .black, radius: 30, opacity: 0.35)
         }
    }
    
    private func setNavigationbar() {
        ordersTableView.contentInsetAdjustmentBehavior = .never

    }
    private func addNavigationTitle(){
        self.navigationItem.setTwoLineTitle(lineOne: OrdersConstant.history.localized, lineTwo: currentServiceType.currentType.capitalized)

    }
    
    private func getOrderHistory() {
        
        ordersPresenter?.getOrderHistory(isHideLoader: true, serviceType: currentServiceType, parameter: [OrdersConstant.PPage:currentPage, OrdersConstant.Ptype: historyType.currentType])
        
    }
}

//MARK:- Actions

extension OrdersController {
    
    @objc func tapHelp(_ sender: UIButton) {
        print("Help \(sender.tag)")
    }
    
    @objc func tapCall(_ sender: UIButton) {
        print("Call \(sender.tag)")
    }
    
    @objc func tapCancel(_ sender: UIButton) {
        print("Cancel \(sender.tag)")
    }
}


//MARK: - IBAction
extension OrdersController{
    
    @objc func filterAction() {
        // filterBtnView.addPressAnimation()
        
        if filterView == nil {
            filterView = Bundle.main.loadNibNamed(OrdersConstant.VFilterView, owner: self, options: [:])?.first as? FilterView
            let height = (view.frame.height/100)*25
            filterView.frame = CGRect(x: 0, y: view.frame.height-height-50, width: view.frame.width, height: height)
            for index in 0..<ServiceTypes.allCases.count {
                if orderHistoryData?.type == ServiceTypes.allCases[index].currentType {
                    filterView.selectedType = index+1
                }
            }
            filterView?.show(with: .bottom, completion: nil)
            showDimView(view: filterView)
        }
        
        
        filterView.onTapServices = { [weak self] serviceType in
            guard let self = self else {
                return
            }
            self.selectedServiceType = serviceType
            self.navigationItem.setTwoLineTitle(lineOne: OrdersConstant.history.localized, lineTwo: serviceType)

            for current in ServiceTypes.allCases {
                if serviceType == current.currentType {
                    self.currentServiceType = current
                    self.currentPage = 1

                    self.getOrderHistory()
                }
            }
            self.filterView.superview?.dismissView(onCompletion: {
                self.filterView = nil
            })
        }
    }
}

//MARK: - UITableViewDataSource
extension OrdersController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if historyType == .past {
            if currentServiceType == .trips {
                count = orderHistoryData?.transport?.data?.count ?? 0
                if count == 0 {
                    ordersTableView.setBackgroundImageAndTitle(imageName: OrdersConstant.historyImage, title: OrdersConstant.historyempty.localized,tintColor : .blackColor)
                }else{
                    ordersTableView.backgroundView = nil
                }
            }
            else if currentServiceType == .service {
                count = orderHistoryData?.service?.data?.count ?? 0
                if count == 0 {
                    ordersTableView.setBackgroundImageAndTitle(imageName: OrdersConstant.historyImage, title: OrdersConstant.historyempty.localized,tintColor : .blackColor)
                }else{
                    ordersTableView.backgroundView = nil
                }
            }
            else if currentServiceType == .delivery {
                count = orderHistoryData?.delivery?.data?.count ?? 0
                if count == 0 {
                    ordersTableView.setBackgroundImageAndTitle(imageName: OrdersConstant.historyImage, title: OrdersConstant.historyempty.localized,tintColor : .blackColor)
                }else{
                    ordersTableView.backgroundView = nil
                }
            }
            else{
                count = orderHistoryData?.foodie?.data?.count ?? 0
                if count == 0 {
                    ordersTableView.setBackgroundImageAndTitle(imageName: OrdersConstant.historyImage, title: OrdersConstant.historyempty.localized,tintColor : .blackColor)
                }else{
                    ordersTableView.backgroundView = nil
                }
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: OrdersConstant.VOrderTableViewCell, for: indexPath) as! OrderTableViewCell
        
        cell.historyType = historyType
        cell.helpButton.addTarget(self, action: #selector(tapHelp(_:)), for: .touchUpInside)
        cell.helpButton.tag = indexPath.row
        cell.callButton.addTarget(self, action: #selector(tapCall(_:)), for: .touchUpInside)
        cell.callButton.tag = indexPath.row
        cell.cancelButton.addTarget(self, action: #selector(tapCancel(_:)), for: .touchUpInside)
        cell.cancelButton.tag = indexPath.row
        
        if currentServiceType == .trips {
            
            let type = orderHistoryData?.type
            if let values = orderHistoryData?.transport?.data?[indexPath.row] {
                cell.setTransportValues(with: type ?? String.Empty, values: values)
            }
        }
        else if currentServiceType == .service {
            if let values = orderHistoryData?.service?.data?[indexPath.row] {
                cell.setServiceValues(values: values)
            }
        } else if currentServiceType == .delivery {
            let type = orderHistoryData?.type
            if let values = orderHistoryData?.delivery?.data?[indexPath.row] {
                cell.setCourierValues(with: type ?? String.Empty, values: values)
                
            }
        }
        else if currentServiceType == .orders {
            
            if let values = orderHistoryData?.foodie?.data?[indexPath.row] {
                cell.setFoodieValues(values: values)
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Pagination Api call
        if currentServiceType == .trips {
            
            if orderHistoryData?.transport?.data?.count ?? 0 > 10 {
                let lastCell  = (orderHistoryData?.transport?.data?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {
                        isUpdate = true
                        currentPage = currentPage + 1
                        getOrderHistory()
                    }
                }
            }
        }else if currentServiceType == .service {
            
            if orderHistoryData?.service?.data?.count ?? 0 > 10 {
                let lastCell  = (orderHistoryData?.service?.data?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {
                        isUpdate = true
                        currentPage = currentPage + 1
                        getOrderHistory()
                    }
                }
            }
        }else if currentServiceType == .orders {
            
            if orderHistoryData?.foodie?.data?.count ?? 0 > 10 {
                let lastCell  = (orderHistoryData?.foodie?.data?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {
                        isUpdate = true
                        currentPage = currentPage + 1
                        getOrderHistory()
                    }
                }
            }
        }else if currentServiceType == .delivery {
            
            if orderHistoryData?.delivery?.data?.count ?? 0 > 10 {
                let lastCell  = (orderHistoryData?.delivery?.data?.count ?? 0) - 3
                if indexPath.row == lastCell {
                    if nextpageurl != "" {
                        isUpdate = true
                        currentPage = currentPage + 1
                        getOrderHistory()
                    }
                }
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension OrdersController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if historyType == .past {
            if ((self.orderHistoryData?.transport?.data?[indexPath.row].status != "CANCELLED") && (self.orderHistoryData?.service?.data?[indexPath.row].status != "CANCELLED") && (self.orderHistoryData?.foodie?.data?[indexPath.row].status != "CANCELLED")){
                
                let vc = OrdersRouter.ordersStoryboard.instantiateViewController(withIdentifier: OrdersConstant.VOrderDetailController) as! OrderDetailController
                if currentServiceType == .trips {
                    vc.tripId = orderHistoryData?.transport?.data?[indexPath.row].id ?? 0
                }
                else if currentServiceType == .orders {
                    vc.tripId = orderHistoryData?.foodie?.data?[indexPath.row].id ?? 0
                }
                else if currentServiceType == .delivery {
                    vc.tripId = orderHistoryData?.delivery?.data?[indexPath.row].id ?? 0
                }
                else {
                    vc.tripId = orderHistoryData?.service?.data?[indexPath.row].id ?? 0
                }
                
                vc.selectedServiceType = currentServiceType
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - OrdersPresenterToOrdersViewProtocol
extension OrdersController:  OrdersPresenterToOrdersViewProtocol {
    
    func getOrderHistory(orderHistoryEntity: OrdersEntity) {

        orderHistoryData?.service?.data?.removeAll()
        orderHistoryData?.transport?.data?.removeAll()
        orderHistoryData?.foodie?.data?.removeAll()
        orderHistoryData?.delivery?.data?.removeAll()

        if isUpdate  {
            switch currentServiceType {
            case .trips:
                if (orderHistoryData?.transport?.data?.count ?? 0) > 0 {
                    self.nextpageurl = orderHistoryEntity.responseData?.transport?.next_page_url ?? ""
                    
                    for i in 0..<(orderHistoryData?.transport?.data?.count ?? 0) {
                        if let dict = orderHistoryEntity.responseData?.transport?.data?[i] {
                            orderHistoryData?.transport?.data?.append(dict)
                        }
                    }
                }
            case .orders:
                if (orderHistoryData?.foodie?.data?.count ?? 0) > 0 {
                    self.nextpageurl = orderHistoryEntity.responseData?.foodie?.next_page_url ?? ""
                    
                    for i in 0..<(orderHistoryData?.foodie?.data?.count ?? 0) {
                        if let dict = orderHistoryEntity.responseData?.foodie?.data?[i] {
                            orderHistoryData?.foodie?.data?.append(dict)
                        }
                    }
                }
            case .delivery:
                if (orderHistoryData?.delivery?.data?.count ?? 0) > 0 {
                    self.nextpageurl = orderHistoryEntity.responseData?.delivery?.next_page_url ?? ""
                    
                    for i in 0..<(orderHistoryData?.delivery?.data?.count ?? 0) {
                        if let dict = orderHistoryEntity.responseData?.delivery?.data?[i] {
                            orderHistoryData?.delivery?.data?.append(dict)
                        }
                    }
                }
            default:
                if (orderHistoryData?.service?.data?.count ?? 0) > 0 {
                    self.nextpageurl = orderHistoryEntity.responseData?.service?.next_page_url ?? ""
                    
                    for i in 0..<(orderHistoryData?.service?.data?.count ?? 0) {
                        if let dict = orderHistoryEntity.responseData?.service?.data?[i] {
                            orderHistoryData?.service?.data?.append(dict)
                        }
                    }
                }
            }
        }
        else {
            orderHistoryData = orderHistoryEntity.responseData
        }
        LoadingIndicator.hide()

        ordersTableView.reloadInMainThread()
    }
}
