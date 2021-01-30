//
//  ChangePasswordController.swift
//  GoJekUser
//
//  Created by Ansar on 01/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var otpTextField: CustomTextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var oldPasswordTextField: CustomTextField!
    @IBOutlet weak var newPasswordTextField: CustomTextField!
    @IBOutlet weak var oldShowPasswordButton: UIButton!
    @IBOutlet weak var newShowPasswordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nextView: RoundedView!
    
    @IBOutlet weak var confirmPasswordView: UIView!
    
    var isFromChangePassword: Bool = false
    var otpString:String = String.Empty
    var accountType:accountType = .email
    var emailOrPhone = String.Empty
    var countryCode = String.Empty
    var myAccountPresenter:MyAccountViewToMyAccountPresenterProtocol!
    
    var isShowOtp: Bool = false {
        didSet {
            if !isFromChangePassword {
                otpView.isHidden = !isFromChangePassword
                newPasswordView.isHidden = isFromChangePassword
                confirmPasswordView.isHidden = isFromChangePassword
                oldPasswordView.isHidden = isFromChangePassword
                nextView.isHidden = !isFromChangePassword
                saveButton.isHidden = isFromChangePassword
            }else{
                otpView.isHidden = !isShowOtp
                newPasswordView.isHidden = isShowOtp
                confirmPasswordView.isHidden = isShowOtp
                oldPasswordView.isHidden = isFromChangePassword
                nextView.isHidden = !isShowOtp
                saveButton.isHidden = isShowOtp
            }
            
        }
    }
    
    var isHideOldPassword:Bool = false {
        didSet {
            oldPasswordTextField.isSecureTextEntry = isHideOldPassword
            oldShowPasswordButton.setImage(UIImage(named: isHideOldPassword ? LoginConstant.eyeOff : LoginConstant.eye), for: .normal)
        }
    }
    var isHideNewPassword:Bool = false {
        didSet {
            newPasswordTextField.isSecureTextEntry = isHideNewPassword
            newShowPasswordButton.setImage(UIImage(named: isHideNewPassword ? LoginConstant.eyeOff : LoginConstant.eye), for: .normal)
        }
    }
    
    var isHideConfirmPassword:Bool = false {
        didSet {
            confirmPasswordTextField.isSecureTextEntry = isHideConfirmPassword
            confirmPasswordButton.setImage(UIImage(named: isHideConfirmPassword ? LoginConstant.eyeOff : LoginConstant.eye), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        //Hide show tabbar
        
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}

//MARK: - LocalMethod

extension ChangePasswordController {
    
    //View basic setup
    private func viewDidSetup() {
        nextView.centerImage = UIImage(named: LoginConstant.icRightArrow)
        nextView.centerImageView.imageTintColor(color1: .white)
        myAccountPresenter = MyAccountRouter.createModule(controller: self)
       // otpTextField.text = otpString
        isShowOtp = isFromChangePassword
        isHideNewPassword = true
        isHideConfirmPassword = true
        isHideOldPassword = true
        otpView.isHidden = !isFromChangePassword
        setTitle()
        nextView.backgroundColor = .appPrimaryColor
        
        confirmPasswordButton.tintColor = .lightGray
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordButton.setImage(UIImage.init(named: Constant.eyeOff), for: .normal)
        confirmPasswordButton.addTarget(self, action: #selector(tapShowPassword(_:)), for: .touchUpInside)
        let nextGesture = UITapGestureRecognizer(target: self, action: #selector(tapNext))
        nextView.addGestureRecognizer(nextGesture)
        
//        title = MyAccountConstant.changePassword
        setLeftBarButtonWith(color: .blackColor)
        addshadow()

        
        oldShowPasswordButton.tintColor = .lightGray
        oldPasswordTextField.isSecureTextEntry = true
        oldShowPasswordButton.setImage(UIImage.init(named: Constant.eyeOff), for: .normal)
        oldShowPasswordButton.addTarget(self, action: #selector(tapShowPassword(_:)), for: .touchUpInside)
        
        newShowPasswordButton.tintColor = .lightGray
        newPasswordTextField.isSecureTextEntry = true
        newShowPasswordButton.setImage(UIImage.init(named: Constant.eyeOff), for: .normal)
        newShowPasswordButton.addTarget(self, action: #selector(tapShowPassword(_:)), for: .touchUpInside)
        
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        DispatchQueue.main.async {
            self.saveButton.setCornorRadius()
        }
        setCustomColor()
        setCustomLocalization()
        setDarkMode()
    }
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.outterView.backgroundColor = .boxColor
    }
    
    func setTitle() {
        title = isFromChangePassword ? (isShowOtp ? MyAccountConstant.otpVerification.localized : MyAccountConstant.resetPassword.localized) : MyAccountConstant.changePwd.localized
    }
    
    //SetCustom color
    private func setCustomColor() {
        
        saveButton.backgroundColor = .appPrimaryColor
        view.backgroundColor = .veryLightGray
    }
    
    //Set custom localization
    private func setCustomLocalization() {
        
        self.saveButton.setTitle(Constant.save.localized, for: .normal)
        self.oldPasswordTextField.placeholder = MyAccountConstant.oldPassword.localized
        self.newPasswordTextField.placeholder = MyAccountConstant.newPassword.localized
        self.otpTextField.placeholder = MyAccountConstant.Otp.localized
        self.otpTextField.font = .setCustomFont(name: .light, size: .x16)
        self.newPasswordTextField.font = .setCustomFont(name: .light, size: .x16)
        self.oldPasswordTextField.font = .setCustomFont(name: .light, size: .x16)
        self.confirmPasswordTextField.font = .setCustomFont(name: .light, size: .x16)
        self.saveButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        confirmPasswordTextField.placeholder = MyAccountConstant.confirmPassword.localized
        
    }
}

//MARK: - IBAction

extension ChangePasswordController {
    
    //Save button action
    @objc func tapSaveButton() {
        
        if validation() {
            if isFromChangePassword {
                var parameter: Parameters
                parameter = [MyAccountConstant.PAccountType : accountType.rawValue,
                             MyAccountConstant.PUsername : emailOrPhone,
                             MyAccountConstant.POtp : otpString,
                             Constant.saltkey: APPConstant.saltKeyValue,
                             MyAccountConstant.PPassword : newPasswordTextField.text!,
                             MyAccountConstant.PConfirmPassword : confirmPasswordTextField.text!]
                if accountType == .mobile {
                    parameter[MyAccountConstant.PCountryCode] = countryCode
                }
                myAccountPresenter?.resetPasswordDetail(param: parameter)
                
            }else{
                //Change passworsd API call
                let param: Parameters = [MyAccountConstant.oldpassword: oldPasswordTextField.text!,
                                         MyAccountConstant.password: newPasswordTextField.text!,
                                         MyAccountConstant.passwordconfirmation: newPasswordTextField.text!]
                myAccountPresenter?.changePassword(param: param)
            }
        }
    }
    
    //Validation
    private func validation() -> Bool {
        let oldPasswordStr = oldPasswordTextField.text?.trim()
        if !isFromChangePassword {
            guard !(oldPasswordStr?.isEmpty ?? false) else {
                oldPasswordTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: LoginConstant.oldPasswordEmpty.localized,state: .error)
                
                return false
            }
            guard (oldPasswordStr?.isValidPassword ?? false) else {
                oldPasswordTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: LoginConstant.passwordlength.localized,state: .error)
                
                return false
            }
        }
        
        guard let newPasswordStr = newPasswordTextField.text?.trim(), !newPasswordStr.isEmpty else {
            newPasswordTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty, message: LoginConstant.newPasswordEmpty.localized,state: .error)
            
            return false
        }
        guard newPasswordStr.isValidPassword else {
            newPasswordTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty, message: LoginConstant.passwordlength.localized,state: .error)
            
            return false
        }
        if !isFromChangePassword {
            guard oldPasswordStr != newPasswordStr else {
                newPasswordTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: LoginConstant.passwordNotSame.localized,state: .error)
                return false
            }
        }
        guard let confirmPasswordStr = confirmPasswordTextField.text?.trim(), !confirmPasswordStr.isEmpty else {
            confirmPasswordTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty, message: LoginConstant.confirmPasswordEmpty.localized,state: .error)
            return false
        }
        guard confirmPasswordStr.isValidPassword else {
            confirmPasswordTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty, message: LoginConstant.passwordlength.localized,state: .error)
            return false
        }
        guard newPasswordStr == confirmPasswordStr else {
            confirmPasswordTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty, message: LoginConstant.passwordMismatch.localized,state: .error)
            return false
        }
        
        return true
    }
    
    //Password show hide
    @objc func tapShowPassword(_ sender:UIButton) {
        if sender.tag == 0 {
            isHideOldPassword = !isHideOldPassword
        }
        else if sender.tag == 1 {
            isHideNewPassword = !isHideNewPassword
        }
        else {
            isHideConfirmPassword = !isHideConfirmPassword
        }
    }
    
    @objc func tapNext() {
        print("OTP \(otpString)")
        if otpString.count > 0  && otpString == otpTextField.text {
            isShowOtp = false
            setTitle()
        }
        else {
            simpleAlert(view: self, title: String.Empty, message: (otpTextField.text?.isEmpty ?? false) ? MyAccountConstant.enterOtp.localized : MyAccountConstant.invalidOtp.localized,state: .error)
        }
    }
}

//MARK: - MyAccountPresenterToMyAccountViewProtocol

extension ChangePasswordController: MyAccountPresenterToMyAccountViewProtocol {
    
    //Change password success
    func changePasswordResponse(profileEntity: ProfileEntity) {

        simpleAlert(view: self, title: Constant.passwordChangesMsg.localized, message: String.Empty, buttonTitle: Constant.ok.localized)
        onTapAlert = { (tag) in
            if tag == 1 {
                let walkThrough = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.WalkThroughController)
                CommonFunction.changeRootController(controller: walkThrough)
            }
        }
  }
    
    func updateResetPasswordSuccess(resetPasswordEntity: ResetPasswordEntity) {
        simpleAlert(view: self, title: Constant.passwordChangesMsg.localized, message: String.Empty, buttonTitle: Constant.ok.localized)
        onTapAlert = { (tag) in
            if tag == 1 {
                let walkThrough = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.WalkThroughController)
                CommonFunction.changeRootController(controller: walkThrough)
            }
        }
    }
}

extension ChangePasswordController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                                    replacementString string: String) -> Bool
        {
            if textField == self.otpTextField && (textField.text?.count ?? 0) > 6 && !string.isEmpty  {
                return false
    
            }
            return true
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
