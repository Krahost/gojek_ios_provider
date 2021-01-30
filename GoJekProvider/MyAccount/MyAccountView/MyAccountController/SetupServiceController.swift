//
//  SetupServiceController.swift
//  GoJekProvider
//
//  Created by CSS on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class SetupServiceController: UIViewController {
    
    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var subCategoryId = 0
    var adminServiceId = ""
    var categoryId = 0
    var serviceType: ServiceType = .category
    var serviceArr: [XuberServiceData] = []
    var bareStrArr: NSMutableArray = []
    var serviceIdStrArr: NSMutableArray = []

    var priceChoose = ""
    
    var isEditService = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

extension SetupServiceController {
    
    private func initialLoads(){
        serviceTableView.register(nibName: MyAccountConstant.SetupServiceTableViewCell)
        title = MyAccountConstant.serviceDescription.localized
        setLeftBarButtonWith(color: .blackColor)
        saveButton.setCornerRadius()
        view.backgroundColor = .backgroundColor
        
        // webservice
        let param:Parameters = [MyAccountConstant.PServiceCategoryId:categoryId,
                                MyAccountConstant.PServiceSubCategoryId: subCategoryId]
        myAccountPresenter?.getXuberServiceDetail(param: param)
        saveButton.setTitle(Constant.save.localized, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
        saveButton.backgroundColor = .appPrimaryColor
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        serviceTableView.allowsMultipleSelection = true
        saveButton.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.5)
        saveButton.isUserInteractionEnabled = false
    }
    
    @objc func saveButtonAction(_ sender: UIButton) {
        var param:Parameters = [
            MyAccountConstant.PAdminServiceId:adminServiceId,
            MyAccountConstant.PCategoryId:categoryId,
            MyAccountConstant.PSubCategoryId:subCategoryId
        ]
        if bareStrArr.count != 0 {
            saveButton.backgroundColor = .appPrimaryColor
            saveButton.isUserInteractionEnabled = true
            for i in 0..<bareStrArr.count {
                let dictItem = bareStrArr[i] as! [String:Any]
                let serviceId = dictItem["service[\(i)][service_id]"] as? Int ?? 0
                if serviceId != 0 {
                    for (key, value) in dictItem
                    {
                       param[key] = value
                    }
                }
            }
            print(param)
            if isEditService {
                myAccountPresenter?.EditVehicleDetail(param: param, imageData: nil)
                print(param)
            }else{
                myAccountPresenter?.AddVehicleDetail(param: param, imageData: nil)
                print(param)
            }
            
        }else{
            saveButton.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.5)
            saveButton.isUserInteractionEnabled = false
        }
    }
}

// MARK: - UITableViewDataSource

extension SetupServiceController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serviceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SetupServiceTableViewCell = serviceTableView.dequeueReusableCell(withIdentifier: MyAccountConstant.SetupServiceTableViewCell, for: indexPath) as! SetupServiceTableViewCell
        let serviceDict = serviceArr[indexPath.row]
        cell.delegate = self
        cell.setServiceData(data: serviceDict)
        let baseModel = AppManager.share.getUserDetails()
        let dictItem = bareStrArr[indexPath.row] as! NSDictionary

        var rate = ""
        if serviceDict.service_city?.fare_type == FareTypeEntity.hourly.rawValue {
            let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
            rate = "\(MyAccountConstant.rate)\(baseModel?.currency ?? "")\(perMins)"
            let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0
            rate = "\(MyAccountConstant.rate)\(baseModel?.currency ?? "")\(perMins)\(" per Mins / ")\(perBare)\(" per Basefare")"

            
        }else if serviceDict.service_city?.fare_type == FareTypeEntity.fixed.rawValue {
            let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

            rate = "\(MyAccountConstant.rate)\(baseModel?.currency ?? "")\(perBare)\(" per Basefare")"

        }else if serviceDict.service_city?.fare_type == FareTypeEntity.distanceTime.rawValue {
            let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
            let perMiles = dictItem["service[\(indexPath.row)][per_miles]"] as? Int ?? 0

            let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0
         
            rate = "\(MyAccountConstant.rate)\(baseModel?.currency ?? "")\(perMins)\(" per Mins / ")\(perMiles)\(" per miles / ")\(perBare)\(" per Basefare")"

        }


        cell.priceLabel.text = rate
        cell.editButton.tag = indexPath.row
        cell.checkImageView.tag = indexPath.row
        let serviceId = dictItem["service[\(indexPath.row)][service_id]"] as? Int ?? 0

        if serviceId == serviceDict.id {
            cell.checkImageView.image = UIImage(named: Constant.squareFill)

        }else{
            cell.checkImageView.image = UIImage(named: Constant.sqaureEmpty)

        }
        if priceChoose == "admin_price" {
            cell.editButton.isHidden = true
            cell.priceLabel.isHidden = true
        }else{
            cell.editButton.isHidden = false
            cell.priceLabel.isHidden = false
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SetupServiceController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = serviceTableView.cellForRow(at: indexPath) as! SetupServiceTableViewCell
        let serviceDict = serviceArr[indexPath.row]
        let dictItem = bareStrArr[indexPath.row] as! NSDictionary

        setSaveColor()
        if cell.checkImageView.image?.isEqual(to: UIImage(named: Constant.sqaureEmpty) ?? UIImage()) ?? false {
            if priceChoose == "admin_price" {
                if serviceDict.service_city?.fare_type == FareTypeEntity.hourly.rawValue {
                    let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                    let parameters = [
                        "service[\(indexPath.row)][service_id]":serviceDict.id ?? 0,
                        "service[\(indexPath.row)][per_mins]":perMins,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                    
                }else if serviceDict.service_city?.fare_type == FareTypeEntity.fixed.rawValue {
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                    let parameters = [
                        "service[\(indexPath.row)][service_id]":serviceDict.id ?? 0,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                }else if serviceDict.service_city?.fare_type == FareTypeEntity.distanceTime.rawValue {
                    let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                    let perMiles = dictItem["service[\(indexPath.row)][per_miles]"] as? Int ?? 0
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                    let parameters = [
                        "service[\(indexPath.row)][service_id]":serviceDict.id ?? 0,
                        "service[\(indexPath.row)][per_mins]": perMins,
                        "service[\(indexPath.row)][per_miles]": perMiles,
                        "service[\(indexPath.row)][base_fare]":perBare

                        ] as [String : Any]
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                    
                }
                
                cell.checkImageView.image = UIImage(named: Constant.squareFill)
            }else{
                let priceStr = cell.priceLabel.text
                let priceStrArr = priceStr?.components(separatedBy: ":")
                if priceStrArr?.count ?? 0 > 0 {
                    var currentPrice = priceStrArr?[1]
                    currentPrice?.removeFirst(0)
                    if currentPrice == "0" {
                        simpleAlert(view: self, title: Constant.empty, message: MyAccountConstant.addBaseFare.localized,state: .error)
                    }
                    else {
                        cell.checkImageView.image = UIImage(named: Constant.squareFill)
                        if serviceDict.service_city?.fare_type == FareTypeEntity.hourly.rawValue {
                            let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                            let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                            let parameters = [
                                
                                "service[\(indexPath.row)][service_id]":serviceDict.id ?? 0,
                                "service[\(indexPath.row)][per_mins]":perMins,
                                "service[\(indexPath.row)][base_fare]":perBare

                                ] as [String : Any]
                            bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                            
                            
                        }else if serviceDict.service_city?.fare_type == FareTypeEntity.fixed.rawValue {
                            let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0
                            
                            let parameters = [
                                "service[\(indexPath.row)][service_id]":serviceDict.id ?? 0,
                                "service[\(indexPath.row)][base_fare]":perBare
                                ] as [String : Any]
                            
                            bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                            
                        }else if serviceDict.service_city?.fare_type == FareTypeEntity.distanceTime.rawValue {
                            let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                            let perMiles = dictItem["service[\(indexPath.row)][per_miles]"] as? Int ?? 0
                            let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                            let parameters = [
                                "service[\(indexPath.row)][service_id]":serviceDict.id ?? 0,
                                "service[\(indexPath.row)][per_mins]": perMins,
                                "service[\(indexPath.row)][per_miles]": perMiles,
                                "service[\(indexPath.row)][base_fare]":perBare

                                ] as [String : Any]
                            bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                            
                            
                        }
                        
                    }
                }
            }
        } else {
            if priceChoose == "admin_price" {
                if serviceDict.service_city?.fare_type == FareTypeEntity.hourly.rawValue {
                    let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                    let parameters = [
                        
                        "service[\(indexPath.row)][service_id]":0,
                        "service[\(indexPath.row)][per_mins]":perMins,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                    
                }else if serviceDict.service_city?.fare_type == FareTypeEntity.fixed.rawValue {
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0
                    
                    let parameters = [
                        "service[\(indexPath.row)][service_id]":0,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                }else if serviceDict.service_city?.fare_type == FareTypeEntity.distanceTime.rawValue {
                    let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                    let perMiles = dictItem["service[\(indexPath.row)][per_miles]"] as? Int ?? 0
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                    let parameters = [
                        "service[\(indexPath.row)][service_id]":0,
                        "service[\(indexPath.row)][per_mins]": perMins,
                        "service[\(indexPath.row)][per_miles]": perMiles,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                    
                }
                cell.checkImageView.image = UIImage(named: Constant.sqaureEmpty)
            }else{
                
                cell.checkImageView.image = UIImage(named: Constant.sqaureEmpty)
                let priceStr = cell.priceLabel.text
                let priceStrArr = priceStr?.components(separatedBy: ":")
                if priceStrArr?.count ?? 0 > 0 {
                    var currentPrice = priceStrArr?[1]
                    currentPrice?.removeFirst()
                }
                if serviceDict.service_city?.fare_type == FareTypeEntity.hourly.rawValue {
                    let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                    let parameters = [
                        
                        "service[\(indexPath.row)][service_id]":0,
                        "service[\(indexPath.row)][per_mins]":perMins,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                    
                }else if serviceDict.service_city?.fare_type == FareTypeEntity.fixed.rawValue {
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0
                    
                    let parameters = [
                        "service[\(indexPath.row)][service_id]":0,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                }else if serviceDict.service_city?.fare_type == FareTypeEntity.distanceTime.rawValue {
                    let perMins = dictItem["service[\(indexPath.row)][per_mins]"] as? Int ?? 0
                    let perMiles = dictItem["service[\(indexPath.row)][per_miles]"] as? Int ?? 0
                    let perBare = dictItem["service[\(indexPath.row)][base_fare]"] as? Int ?? 0

                    let parameters = [
                        "service[\(indexPath.row)][service_id]":0,
                        "service[\(indexPath.row)][per_mins]": perMins,
                        "service[\(indexPath.row)][per_miles]": perMiles,
                        "service[\(indexPath.row)][base_fare]":perBare
                        ] as [String : Any]
                    bareStrArr.replaceObject(at: indexPath.row, with: parameters)
                    
                    
                }
                
            }
            
        }
        
        print(bareStrArr)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

// MARK: - MyAccountPresenterToMyAccountViewProtocol

extension SetupServiceController: MyAccountPresenterToMyAccountViewProtocol {
    
    func getXuberServiceSuccess(getXuberServiceEntity: GetXuberServiceEntity) {
       let xuberServiceArr = getXuberServiceEntity.responseData ?? []
        for i in 0..<xuberServiceArr.count {
            let servicedict = xuberServiceArr[i]
            if servicedict.service_city != nil {
                serviceArr.append(servicedict)
            }
        }
        
        for i in 0..<serviceArr.count {
            let serviceDict = serviceArr[i]
            if serviceDict.providerservices?.count != 0 {
                serviceIdStrArr.add(serviceDict.id ?? 0)
            }
            
            if serviceDict.service_city?.fare_type == FareTypeEntity.hourly.rawValue {
                var parameters: [String: Any] = [:]

                
                if serviceDict.providerservices?.count != 0 {
                    parameters = ["service[\(i)][service_id]" : serviceDict.id ?? 0,
                    "service[\(i)][per_mins]":serviceDict.providerservices?.first?.per_mins ?? 0,
                    "service[\(i)][base_fare]":serviceDict.providerservices?.first?.base_fare ?? 0]

                }else{
                    parameters = ["service[\(i)][per_mins]":serviceDict.service_city?.per_mins ?? 0,
                                  "service[\(i)][base_fare]":serviceDict.service_city?.base_fare ?? 0]

                }
               
                bareStrArr.add(parameters)
            }else if serviceDict.service_city?.fare_type == FareTypeEntity.fixed.rawValue{
                var parameters: [String: Any] = [:]

                
                if serviceDict.providerservices?.count != 0 {
                    parameters = ["service[\(i)][service_id]" : serviceDict.id ?? 0,
                    "service[\(i)][base_fare]":serviceDict.providerservices?.first?.base_fare ?? 0]
                }else{
                    parameters = [
                        "service[\(i)][base_fare]":serviceDict.service_city?.base_fare ?? 0
                        ]
                }
                bareStrArr.add(parameters)
            }else if serviceDict.service_city?.fare_type == FareTypeEntity.distanceTime.rawValue{
                var parameters: [String: Any] =  [:]

                if serviceDict.providerservices?.count != 0 {
                    parameters = ["service[\(i)][service_id]" : serviceDict.id ?? 0,
                                  "service[\(i)][per_mins]":serviceDict.providerservices?.first?.per_mins ?? 0 ,
                                  "service[\(i)][per_miles]":serviceDict.providerservices?.first?.per_miles ?? 0,
                                  "service[\(i)][base_fare]":serviceDict.providerservices?.first?.base_fare ?? 0]

                }else{
                    parameters = [ "service[\(i)][per_mins]":serviceDict.service_city?.per_mins ?? 0 ,
                    "service[\(i)][per_miles]":serviceDict.service_city?.per_miles ?? 0,
                    "service[\(i)][base_fare]":serviceDict.providerservices?.first?.base_fare ?? 0]

                }
                bareStrArr.add(parameters)
                
            }

        }
        if serviceIdStrArr.count == 0 {
            isEditService = false
        }
        else {
            isEditService = true
        }
        
        if serviceArr.count == 0 {
            serviceTableView.setBackgroundImageAndTitle(imageName: MyAccountConstant.noService, title: MyAccountConstant.emptyService.localized)
            saveButton.isHidden = true
        }
        else {
            serviceTableView.backgroundView = nil
            saveButton.isHidden = false
        }
        serviceTableView.reloadData()
        print(bareStrArr)
    }
    
    func getAddVehicleSuccess(getAddVehicleEntity: AddVehicleEntity) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SetupServiceTableViewCellDelegate

extension SetupServiceController: SetupServiceTableViewCellDelegate {
    
    func onEditTap(tag: Int, serviceId: Int) {
        let addAmountController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.AddAmountServiceController)  as!  AddAmountServiceController
        addAmountController.delegate = self
        addAmountController.serviceId = serviceId
        addAmountController.rowIndex = tag
        addAmountController.serviceData = serviceArr[tag]
        addAmountController.bareStrArr = bareStrArr
        present(addAmountController, animated: true, completion: nil)
    }
}

// MARK: - AddAmountServiceControllerDelegate

extension SetupServiceController: AddAmountServiceControllerDelegate {
    func onsubmit(baseFareText: String, row: Int, permilestext: String, baseArr: NSMutableArray) {
       
        let indexPath = IndexPath(row: row, section: 0)
        let cell = serviceTableView.cellForRow(at: indexPath) as! SetupServiceTableViewCell
        let rate = MyAccountConstant.rate.localized + baseFareText
        cell.priceLabel.text = Double(rate)?.setCurrency()
        var fareprice = baseFareText
        fareprice = String(fareprice.dropFirst())
        bareStrArr = baseArr
        serviceTableView.reloadData()
        print(bareStrArr)
       
    }
    
    private func setSaveColor(){
        saveButton.backgroundColor = .appPrimaryColor
        saveButton.isUserInteractionEnabled = true
    }
}


