//
//  SetupVehicleController.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class SetupVehicleController: UIViewController {
    
    @IBOutlet weak var vehicleListTableView: UITableView!
    
    var rideTypeArr:[RideTypeData] = []
    var serviceType:ServiceType = .transport
    var adminServiceId = ""
    var shopTypeArr:[ShoptypeResponseData] = []
    var courierTypeArr : [DeliverytypeResponseData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //web service
        if serviceType == .transport {
            myAccountPresenter?.getRideTypeDetail()
        }else if serviceType == .order {
            myAccountPresenter?.getShopTypeDetail()
        }else
        {
             myAccountPresenter?.getDeliveryTypeDetail()
        }
        
        //Hide show tabbar
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
// MARK: - LocalMethod

extension SetupVehicleController {
    private func initialLoads(){
        vehicleListTableView.register(nibName: MyAccountConstant.SetupVehicleTableViewCell)
        
        title = MyAccountConstant.transportDescription.localized
        setLeftBarButtonWith(color: .blackColor)
        view.backgroundColor = .backgroundColor
        vehicleListTableView.backgroundColor = .backgroundColor
    }
    
    @objc func SwitchCourierClicked(sender : UISwitch){
        var status = 0
        if(sender.isOn){
            status = 1
        }
        let param = ["admin_service":"DELIVERY","status": "\(status)"]
        myAccountPresenter?.providerStatusUpdate(id: courierTypeArr[sender.tag].providerservice?.provider_vehicle_id ?? 0, param: param)
    }
    
    @objc func SwitchOrderClicked(sender : UISwitch){
      var status = 0
      if(sender.isOn){
          status = 1
      }
      let param = ["admin_service":"ORDER","status": "\(status)"]
      myAccountPresenter?.providerStatusUpdate(id: shopTypeArr[sender.tag].providerservice?.provider_vehicle_id ?? 0, param: param)
    }
    
    @objc func SwitchTransportClicked(sender : UISwitch){
      var status = 0
      if(sender.isOn){
          status = 1
      }
      let param = ["admin_service":"TRANSPORT","status": "\(status)"]
      myAccountPresenter?.providerStatusUpdate(id: rideTypeArr[sender.tag].providerservice?.provider_vehicle_id ?? 0, param: param)
    }
    
    
    
}
// MARK: - UITableViewDataSource

extension SetupVehicleController: UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if serviceType == .transport {
            count = rideTypeArr.count
        }
        else if serviceType == .order
        {
            count = shopTypeArr.count
        }else
        {
            count = courierTypeArr.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SetupVehicleTableViewCell = vehicleListTableView.dequeueReusableCell(withIdentifier: MyAccountConstant.SetupVehicleTableViewCell, for: indexPath) as! SetupVehicleTableViewCell
        if serviceType == .transport {
            let rideTypeDict = rideTypeArr[indexPath.row]
            cell.setRideTypeData(data: rideTypeDict)
            cell.statusSwitch.tag = indexPath.row
            cell.statusSwitch.addTarget(self, action: #selector(SwitchTransportClicked(sender:)), for: .valueChanged)
        }
        else if serviceType == .order
        {
            let shopTypeDict = shopTypeArr[indexPath.row]
            cell.setShopTypeData(data: shopTypeDict)
            cell.statusSwitch.tag = indexPath.row
            cell.statusSwitch.addTarget(self, action: #selector(SwitchOrderClicked(sender:)), for: .valueChanged)
        }else{
            
            let deliveryTypeDict = courierTypeArr[indexPath.row]
            cell.setDeliveryData(data: deliveryTypeDict)
            cell.statusSwitch.tag = indexPath.row
            cell.statusSwitch.addTarget(self, action: #selector(SwitchCourierClicked(sender:)), for: .valueChanged)
            
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SetupVehicleController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if serviceType == .transport {
            let rideTypeDict = rideTypeArr[indexPath.row]
            let addVehicleController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.AddVehicleController)  as! AddVehicleController
            addVehicleController.serviceType = .transport
            addVehicleController.adminServiceId = adminServiceId
            addVehicleController.categoryId = rideTypeDict.id ?? 0
            addVehicleController.transportArr = rideTypeDict.servicelist ?? []
            addVehicleController.providerService = rideTypeDict.providerservice
            if(rideTypeArr[indexPath.row].providerservice == nil){
                 addVehicleController.isEdit = true
             }
             else{
             if (rideTypeArr[indexPath.row].providerservice?.status ?? "").uppercased() == "ASSESSING" {
                 addVehicleController.isEdit = true
             }
             else{
                 addVehicleController.isEdit = false
              }
             }
            navigationController?.pushViewController(addVehicleController, animated: true)
        }
        else if serviceType == .order {
            let shopTypeDict = shopTypeArr[indexPath.row]
            let addVehicleController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.AddVehicleController)  as! AddVehicleController
            addVehicleController.serviceType = .order
            addVehicleController.adminServiceId = adminServiceId
            addVehicleController.categoryId = shopTypeDict.id ?? 0
            addVehicleController.providerService = shopTypeDict.providerservice
            if(shopTypeArr[indexPath.row].providerservice == nil){
                 addVehicleController.isEdit = true
             }
             else{
             if (shopTypeArr[indexPath.row].providerservice?.status ?? "").uppercased() == "ASSESSING" {
                 addVehicleController.isEdit = true
             }
             else{
                 addVehicleController.isEdit = false
              }
             }
            navigationController?.pushViewController(addVehicleController, animated: true)
        }else{
            
            let courierTypeDict = courierTypeArr[indexPath.row]
            let addVehicleController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.AddVehicleController)  as! AddVehicleController
            addVehicleController.serviceType = .delivery
            addVehicleController.adminServiceId = adminServiceId
            addVehicleController.categoryId = courierTypeDict.id ?? 0
            addVehicleController.transportArr = courierTypeDict.servicelist ?? []
            addVehicleController.providerService = courierTypeDict.providerservice
            if(courierTypeArr[indexPath.row].providerservice == nil){
                addVehicleController.isEdit = true
            }
            else{
            if (courierTypeArr[indexPath.row].providerservice?.status ?? "").uppercased() == "ASSESSING" {
                addVehicleController.isEdit = true
            }
            else{
                addVehicleController.isEdit = false
             }
            }
            navigationController?.pushViewController(addVehicleController, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - MyAccountPresenterToMyAccountViewProtocol

extension SetupVehicleController: MyAccountPresenterToMyAccountViewProtocol {
    
    func providerStatusUpdate(profileEntity: ProfileEntity) {
        //web service
        if serviceType == .transport {
            myAccountPresenter?.getRideTypeDetail()
        }else if serviceType == .order {
            myAccountPresenter?.getShopTypeDetail()
        }else
        {
             myAccountPresenter?.getDeliveryTypeDetail()
        }
    }
    
    
    func getRideTypeSuccess(getRideTypeEntity: GetRideTypeEntity) {
        if let rideArray = getRideTypeEntity.responseData {
            rideTypeArr.removeAll()
            for detail in rideArray {
                if detail.status == 1 {
                    rideTypeArr.append(detail)
                }
            }
        }
        vehicleListTableView.reloadData()
    }
    
    func getShopTypeSuccess(getShopTypeEntity: ShopTypeEntity) {
        if let shopArray = getShopTypeEntity.responseData {
            shopTypeArr.removeAll()
            for detail in shopArray {
                if detail.status == 1 {
                    shopTypeArr.append(detail)
                }
            }
        }
        vehicleListTableView.reloadData()
    }
    
    func getDeliveryTypeSuccess(getCourierTypeEntity: CourierTypeEntity) {
        if let courierArray = getCourierTypeEntity.responseData {
                   courierTypeArr.removeAll()
                   for detail in courierArray {
                       if detail.status == 1 {
                           courierTypeArr.append(detail)
                       }
                   }
               }
        vehicleListTableView.reloadData()
 
    }
}
