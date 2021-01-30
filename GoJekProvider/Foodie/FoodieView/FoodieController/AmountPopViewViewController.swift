//
//  AmountPopViewViewController.swift
//  Project
//
//  Created by CSS on 31/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class AmountPopViewViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var otpBackgroundView: UIView!
    @IBOutlet weak var otpImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var enterOTPLabel: UILabel!
    
    @IBOutlet weak var thirdOtpTextField: UITextField!
    @IBOutlet weak var fourthOtpTextField: UITextField!
    @IBOutlet weak var secondOtpTextField: UITextField!
    @IBOutlet weak var firstOtpTextField: UITextField!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    // MARK: - LocalVariable
    var order_otp = String.Empty //to another controller
    var otpValue = String.Empty //from another controller
    
    var delegate: AmountPopUpDelegate?
    var isCashType = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewDidSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - LocalMethod

extension AmountPopViewViewController {
    
    private func viewDidSetup() {
        
        otpBackgroundView.layer.cornerRadius = 5.0
        otpBackgroundView.layer.masksToBounds = true
        otpImageView.image = UIImage(named: FoodieConstant.otpImage)
        enterOTPLabel.text = FoodieConstant.enterOTP.localized
        infoLabel.text = FoodieConstant.paymentConfirmationMsg.localized
        firstOtpTextField.setBottomBorder()
        secondOtpTextField.setBottomBorder()
        thirdOtpTextField.setBottomBorder()
        fourthOtpTextField.setBottomBorder()
        submitButton.setTitle(Constant.submit.localized, for: .normal)
        submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        //call custom font
        setCustomFont()
        infoLabel.isHidden = !isCashType
        //call custom color
        setCustomColor()
        
        firstOtpTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        secondOtpTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        thirdOtpTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        fourthOtpTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        otpBackgroundView.backgroundColor = .boxColor
    }
    
   
    
    // Set custom font
    private func setCustomFont(){
        
        firstOtpTextField.font = .setCustomFont(name: .light, size: .x14)
        secondOtpTextField.font = .setCustomFont(name: .light, size: .x14)
        thirdOtpTextField.font = .setCustomFont(name: .light, size: .x14)
        fourthOtpTextField.font = .setCustomFont(name: .light, size: .x14)
        
        enterOTPLabel.font = .setCustomFont(name: .bold, size: .x18)
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        infoLabel.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    // Set custom color
    private func setCustomColor(){
        
        firstOtpTextField.textColor = .blackColor
        secondOtpTextField.textColor = .blackColor
        thirdOtpTextField.textColor = .blackColor
        fourthOtpTextField.textColor = .blackColor
        
        firstOtpTextField.tintColor = .foodieColor
        secondOtpTextField.tintColor = .foodieColor
        thirdOtpTextField.tintColor = .foodieColor
        fourthOtpTextField.tintColor = .foodieColor
        
        submitButton.backgroundColor = .foodieColor
        submitButton.setTitleColor(.white, for: .normal)
        infoLabel.textColor = .foodieColor
    }
}

// MARK: - IBAction

extension AmountPopViewViewController {
    
    // Submit Button Action
    @objc func tapSubmit() {
        order_otp = firstOtpTextField.text! + secondOtpTextField.text!  + thirdOtpTextField.text! + fourthOtpTextField.text!
        print(otpValue)
        if otpValue != order_otp {
            ToastManager.show(title: FoodieConstant.enterValidOtp.localized, state: .error)
            return
        }
        dismiss(animated: true) {
            self.delegate?.popUpDelegate(otp:self.order_otp)
        }
    }
}

// MARK: - UITextFieldDelegate

extension AmountPopViewViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = ""
        if textField.text == "" {
            print("Backspace has been pressed")
        }
        
        if string == "" {
            print("Backspace was pressed")
            switch textField {
            case secondOtpTextField:
                firstOtpTextField.becomeFirstResponder()
            case thirdOtpTextField:
                secondOtpTextField.becomeFirstResponder()
            case fourthOtpTextField:
                thirdOtpTextField.becomeFirstResponder()
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
            case firstOtpTextField:
                secondOtpTextField.becomeFirstResponder()
            case secondOtpTextField:
                thirdOtpTextField.becomeFirstResponder()
            case thirdOtpTextField:
                fourthOtpTextField.becomeFirstResponder()
            case fourthOtpTextField:
                fourthOtpTextField.resignFirstResponder()
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
