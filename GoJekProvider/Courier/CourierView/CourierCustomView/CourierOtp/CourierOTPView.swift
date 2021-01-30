//
//  CourierOTPView.swift
//  GoJekProvider
//
//  Created by Chan Basha on 05/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierOTPView: UIView {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var otpBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var textFieldThree: UITextField!
    @IBOutlet weak var textFieldFour: UITextField!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var startTripButton: UIButton!
    
    //MARK: - LocalMethod
    
    var onClickStartTripButton:(()->Void)?
    var responseOTP: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        callButton.isHidden = true
        chatButton.isHidden = true
        titleLabel.text = TaxiConstant.enterOTP.localized
        chatButton.setTitle(TaxiConstant.chat.localized.uppercased(), for: .normal)
        callButton.setTitle(TaxiConstant.call.localized.uppercased(), for: .normal)
        startTripButton.setTitle(TaxiConstant.startTrip.localized.uppercased(), for: .normal)
        
        startTripButton.addTarget(self, action: #selector(startTripButtonAction(_:)), for: .touchUpInside)
        
        //Set custom design
        otpBackgroundView.setCornerRadiuswithValue(value: 5.0)
        otpBackgroundView.backgroundColor = .boxColor
        callButton.setCornerRadiuswithValue(value: 5.0)
        chatButton.setCornerRadiuswithValue(value: 5.0)
        startTripButton.setCornerRadiuswithValue(value: 5.0)
        
        //Set custom font
        titleLabel.font = .setCustomFont(name: .bold, size: .x18)
        textFieldOne.font = .setCustomFont(name: .bold, size: .x20)
        textFieldTwo.font = .setCustomFont(name: .bold, size: .x20)
        textFieldThree.font = .setCustomFont(name: .bold, size: .x20)
        textFieldFour.font = .setCustomFont(name: .bold, size: .x20)
        callButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        chatButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        startTripButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        
        //Set custom color
        callButton.backgroundColor = .black
        chatButton.backgroundColor = .black
        startTripButton.backgroundColor = .courierColor
        startTripButton.textColor(color: .white)
        callButton.textColor(color: .white)
        chatButton.textColor(color: .white)
        
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        textFieldThree.delegate = self
        textFieldFour.delegate = self
        
        textFieldOne.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        textFieldTwo.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        textFieldThree.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        textFieldFour.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        textFieldOne.becomeFirstResponder()
        addTextEditChangedAction()
    }
    
    func addTextEditChangedAction() {
        textFieldOne.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        textFieldTwo.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        textFieldThree.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        textFieldFour.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
    }
    
    //Stat button action
    @objc func startTripButtonAction(_ sender: UIButton) {
        
        guard let otp1 = textFieldOne.text, !otp1.isEmpty else {
            textFieldOne.becomeFirstResponder()
            ToastManager.show(title: TaxiConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        guard let otp2 = textFieldTwo.text, !otp2.isEmpty else {
            textFieldTwo.becomeFirstResponder()
            ToastManager.show(title: TaxiConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        guard let otp3 = textFieldThree.text, !otp3.isEmpty else {
            textFieldThree.becomeFirstResponder()
            ToastManager.show(title: TaxiConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        guard let otp4 = textFieldFour.text, !otp4.isEmpty else {
            textFieldFour.becomeFirstResponder()
            ToastManager.show(title: TaxiConstant.InvalidOTP.localized , state: .error)
            return
        }
        
        var otp: [String] = []
        otp.append(otp1)
        otp.append(otp2)
        otp.append(otp3)
        otp.append(otp4)
        
        let checkOtp = otp.joined()
        if let otpResponse = responseOTP {
            if checkOtp != otpResponse {
                ToastManager.show(title: TaxiConstant.InvalidOTP.localized , state: .error)
                return
            }
        }
        onClickStartTripButton?()
    }
}

extension CourierOTPView: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = ""
        if textField.text == "" {
            print("Backspace has been pressed")
        }
        
        if string == "" {
            print("Backspace was pressed")
            switch textField {
            case textFieldTwo:
                textFieldOne.becomeFirstResponder()
            case textFieldThree:
                textFieldTwo.becomeFirstResponder()
            case textFieldFour:
                textFieldThree.becomeFirstResponder()
            default:
                print("default")
            }
            textField.text = ""
            return false
        }
        return true
    }
    
    @objc func textEditChanged(_ sender: UITextField) {
        print("textEditChanged has been pressed")
        let count = sender.text?.count
        if count == 1{
            switch sender {
            case textFieldOne:
                textFieldTwo.becomeFirstResponder()
            case textFieldTwo:
                textFieldThree.becomeFirstResponder()
            case textFieldThree:
                textFieldFour.becomeFirstResponder()
            case textFieldFour:
                textFieldFour.resignFirstResponder()
            default:
                print("default")
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)!{
            //textField.selectAll(self)
        }else{
            print("Empty")
            textField.text = " "
        }
    }
}




