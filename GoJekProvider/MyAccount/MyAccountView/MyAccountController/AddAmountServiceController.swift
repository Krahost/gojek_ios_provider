//
//  AddAmountServiceController.swift
//  GoJekProvider
//
//  Created by CSS on 05/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class AddAmountServiceController: UIViewController {

    @IBOutlet weak var baseFareLabel: UILabel!
    @IBOutlet weak var baseFareTextField: UITextField!
    @IBOutlet weak var enterAmountLabel: UILabel!
    @IBOutlet weak var addAmountView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var enterAmountTextField: UITextField!
    @IBOutlet weak var milesTextField: UITextField!
    @IBOutlet weak var fixedLabel: UILabel!
    
    @IBOutlet weak var milesLabel: UILabel!
    weak var delegate: AddAmountServiceControllerDelegate?
    var serviceId = 0
    var rowIndex = 0
    var serviceData: XuberServiceData?
    var bareStrArr:NSMutableArray = []

    
    
    let baseModel = AppManager.share.getUserDetails()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initalLoads()
    }

}

extension AddAmountServiceController {
    private func initalLoads(){
        customFont()
        customLocalization()
         setColors()
        enterAmountTextField.text = baseModel?.currency
        milesTextField.text = baseModel?.currency
        baseFareTextField.text = baseModel?.currency

        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        
        fixedLabel.adjustsFontSizeToFitWidth = true
        baseFareLabel.adjustsFontSizeToFitWidth = true
        milesLabel.adjustsFontSizeToFitWidth = true
        
        //            "FIXED" -> params["service[$i][base_fare]"] = (it.baseFare)
        //            "HOURLY" -> params["service[$i][per_mins]"] = (it.perMins)
        //            "DISTANCETIME" -> {
        //                params["service[$i][per_mins]"] = (it.perMins)
        //                params["service[$i][per_miles]"] = (it.perMiles)
        //            }
        
        if serviceData?.service_city?.fare_type == "HOURLY" {
            enterAmountTextField.isHidden = false
            milesTextField.isHidden = true
            fixedLabel.text = "Per Mins"
            milesLabel.isHidden = true
            fixedLabel.isHidden = false
            baseFareTextField.isHidden = false
            baseFareLabel.isHidden = false
            baseFareLabel.text = "Per BaseFare"

        }else if serviceData?.service_city?.fare_type == "FIXED" {
            enterAmountTextField.isHidden = false
            milesTextField.isHidden = true
            fixedLabel.text = "Per BaseFare"
            milesLabel.isHidden = true
            fixedLabel.isHidden = false
            baseFareTextField.isHidden = true
            baseFareLabel.isHidden = true

        }else if serviceData?.service_city?.fare_type == "DISTANCETIME" {
            enterAmountTextField.isHidden = false
            milesTextField.isHidden = false
            milesLabel.isHidden = false
            fixedLabel.text = "Per Mins"
            milesLabel.text = "Per Miles"
            baseFareLabel.text = "Per BaseFare"
            fixedLabel.isHidden = false
            baseFareTextField.isHidden = false
            baseFareLabel.isHidden = false

        }

    }
    
    private func customFont(){
        
        enterAmountLabel.font = .setCustomFont(name: .light, size: .x16)
        enterAmountTextField.font = .setCustomFont(name: .light, size: .x16)
        cancelButton.titleLabel?.font = .setCustomFont(name: .light, size: .x16)
        submitButton.titleLabel?.font = .setCustomFont(name: .light, size: .x16)
        milesTextField.font = .setCustomFont(name: .light, size: .x16)
        baseFareTextField.font = .setCustomFont(name: .light, size: .x16)
        milesLabel.font = .setCustomFont(name: .light, size: .x16)
        fixedLabel.font = .setCustomFont(name: .light, size: .x16)

    }
    
    private func customLocalization(){
        enterAmountLabel.text = MyAccountConstant.enterAmount.localized
        cancelButton.setTitle(MyAccountConstant.cancel.localized, for: .normal)
        submitButton.setTitle(MyAccountConstant.submit.localized, for: .normal)
    }
    private func setColors(){
        submitButton.setTitleColor(.appPrimaryColor, for: .normal)
        cancelButton.setTitleColor(.blackColor, for: .normal)
        enterAmountTextField.backgroundColor = .veryLightGray
        enterAmountTextField.textColor = .black
        addAmountView.setCornerRadiuswithValue(value: 10)
        addAmountView.backgroundColor = .boxColor
        milesTextField.backgroundColor = .veryLightGray
        baseFareTextField.backgroundColor = .veryLightGray
        
    }
    
    @objc func cancelButtonAction(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func submitButtonAction(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        
       let currency = baseModel?.currency ?? ""
        
        var amtTxt = enterAmountTextField.text ?? ""
        var milesTxt = milesTextField.text ?? ""
        var baseFareTxt = baseFareTextField.text ?? ""
        if let amtrange = amtTxt.range(of: currency) {
                          amtTxt.removeSubrange(amtrange)
                      }
        
        if let milesrange = milesTxt.range(of: currency) {
                                 milesTxt.removeSubrange(milesrange)
                             }
        
        if let baseFarerange = baseFareTxt.range(of: currency) {
                                        baseFareTxt.removeSubrange(baseFarerange)
                                    }
        

        
        if serviceData?.service_city?.fare_type == FareTypeEntity.hourly.rawValue {
            
            let parameters = [
                "service[\(rowIndex)][admin_service]":0,
                "service[\(rowIndex)][per_mins]":Int(amtTxt) ?? 0,
                "service[\(rowIndex)][base_fare]":Int(baseFareTxt) ?? 0

                ] as [String : Any]
            bareStrArr.replaceObject(at: rowIndex, with: parameters)
            
            
        }else if serviceData?.service_city?.fare_type == FareTypeEntity.fixed.rawValue {
            
            let parameters = [
                "service[\(rowIndex)][admin_service]":0,
                "service[\(rowIndex)][base_fare]":Int(amtTxt) ?? 0
                ] as [String : Any]
            
            bareStrArr.replaceObject(at: rowIndex, with: parameters)
            
        }else if serviceData?.service_city?.fare_type == FareTypeEntity.distanceTime.rawValue {
            
            
            let parameters = [
                "service[\(rowIndex)][admin_service]":0,
                "service[\(rowIndex)][per_mins]": Int(amtTxt) ?? 0,
                "service[\(rowIndex)][per_miles]": Int(milesTxt) ?? 0,
                "service[\(rowIndex)][base_fare]":Int(baseFareTxt) ?? 0
                ] as [String : Any]
            bareStrArr.replaceObject(at: rowIndex, with: parameters)
            
            
        }
                
        delegate?.onsubmit(baseFareText: enterAmountTextField.text!, row: rowIndex, permilestext: milesTextField.text!,baseArr: bareStrArr)
    }
}

// MARK: - Protocol for set Value for DateWise Label
protocol AddAmountServiceControllerDelegate: class {
    func onsubmit(baseFareText: String,row: Int,permilestext: String,baseArr: NSMutableArray)
}


