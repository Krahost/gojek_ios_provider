//
//  ForgotPasswordController.swift
//  GoJekProvider
//
//  Created by CSS on 23/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var forgotPasswordViaLabel: UILabel!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var phoneview: UIView!
    @IBOutlet weak var mailImage: UIImageView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var codeTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var forgotPasswordView: RoundedView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var contactAdminLabel: UILabel!
    @IBOutlet weak var outterView: UIView!
    
    let baseConfig = AppConfigurationManager.shared.baseConfigModel
    
    
    //Is selected phone or email
    var isPhoneSelect = false
    
    //Set country code and image
    private var countryDetail: Country? {
        didSet {
            if countryDetail != nil {
                codeTextField.setLeftView(imageStr: "CountryPicker.bundle/"+(countryDetail?.code ?? .Empty))
                codeTextField.text = "  \(countryDetail?.dial_code ?? .Empty)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalLoads()
    }
    
}

extension ForgotPasswordController {
    
    func initalLoads(){
        addButtonActions()
        setNavigation()
        setCustomFont()
        setCustomLocalization()
        setCountry()
        forgotPasswordView.backgroundColor = .appPrimaryColor
        self.phoneImage.image = UIImage(named: LoginConstant.phone)
        self.mailImage.image = UIImage(named: LoginConstant.mail)
        contactAdminLabel.text = "Please Contact Admin\n" + " \(baseConfig?.responseData?.appsetting?.supportdetails?.contact_number?.first?.number ?? "")"
        
        if baseConfig?.responseData?.appsetting?.send_email == 1 && baseConfig?.responseData?.appsetting?.send_sms == 1  {
            contactAdminLabel.isHidden = true
            mailView.isHidden = false
            phoneview.isHidden = false
            forgotPasswordView.isHidden = false
            emailTextField.isHidden = true
            phoneNumberTextField.isHidden = false
            codeTextField.isHidden = false
            isPhoneSelect = true

        }else if baseConfig?.responseData?.appsetting?.send_email == 1  && baseConfig?.responseData?.appsetting?.send_sms == 0  {
            emailTextField.isHidden = false
            phoneNumberTextField.isHidden = true
            codeTextField.isHidden = true
            contactAdminLabel.isHidden = true
            mailView.isHidden = false
            phoneview.isHidden = true
            forgotPasswordView.isHidden = false
            isPhoneSelect = false
        }else if baseConfig?.responseData?.appsetting?.send_sms == 1  && baseConfig?.responseData?.appsetting?.send_email == 0  {
            emailTextField.isHidden = true
            phoneNumberTextField.isHidden = false
            contactAdminLabel.isHidden = true
            codeTextField.isHidden = false
            mailView.isHidden = true
            phoneview.isHidden = false
            forgotPasswordView.isHidden = false
            isPhoneSelect = true
        }else if baseConfig?.responseData?.appsetting?.send_email == 0 && baseConfig?.responseData?.appsetting?.send_sms == 0 {
            emailTextField.isHidden = true
            phoneNumberTextField.isHidden = true
            codeTextField.isHidden = true
            contactAdminLabel.isHidden = false
            mailView.isHidden = true
            phoneview.isHidden = true
            forgotPasswordView.isHidden = true
        }
        setDarkMode()
    }
    
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.outterView.backgroundColor = .boxColor
    }
    
    // set Navigation
    private func setNavigation(){
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackColor, NSAttributedString.Key.font: UIFont.setCustomFont(name: .medium, size: .x22)]
        let navItem = UINavigationItem(title: LoginConstant.forgotPasswordTitle.localized)
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: Constant.back), style: .plain, target: self, action: #selector(onbackButtonAction))
        navItem.leftBarButtonItem = leftBarButton
        navigationBar.setItems([navItem], animated: false)
        navigationBar.tintColor = .blackColor
    }
    
    // Set Button Actions
    private func addButtonActions(){
        let forgotPassword = UITapGestureRecognizer(target: self, action: #selector(tapForgotPassword))
        forgotPasswordView.addGestureRecognizer(forgotPassword)
        let phoneViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoneEmail(_:)))
        phoneview.addGestureRecognizer(phoneViewGesture)
        let mailViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoneEmail(_:)))
        mailView.addGestureRecognizer(mailViewGesture)
        textFieldUpdate()
    }
    
    func textFieldUpdate() {
        emailTextField.text = .Empty
        phoneNumberTextField.text = .Empty
        view.endEditing(true)
        if self.isPhoneSelect {
            self.phoneImage.imageTintColor(color1: .appPrimaryColor)
            self.mailImage.imageTintColor(color1: .lightGray)
            self.phoneview.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.1)
            self.mailView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            self.phoneNumberTextField.isHidden = false
            self.codeTextField.isHidden = false
            self.emailTextField.isHidden = true
        } else {
            self.mailImage.imageTintColor(color1: .appPrimaryColor)
            self.phoneImage.imageTintColor(color1: .lightGray)
            self.phoneview.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            self.mailView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.1)
            self.phoneNumberTextField.isHidden = true
            self.codeTextField.isHidden = true
            self.emailTextField.isHidden = false
        }
    }
    
    //Set localize sting
    private func setCustomLocalization() {
        forgotPasswordView.centerImage = UIImage(named: LoginConstant.icRightArrow)
        forgotPasswordView.centerImageView.imageTintColor(color1: .white)
        
        forgotPasswordViaLabel.text = LoginConstant.forgotPwdVia.localized
        //Placeholder text
        emailTextField.placeholder = Constant.PEmail.localized
        codeTextField.placeholder = Constant.PCode.localized
        codeTextField.fieldShapeType = .Left
        phoneNumberTextField.placeholder = Constant.PPhoneNumber.localized
        phoneNumberTextField.fieldShapeType = .Right
    }
    
    //Validation
    private func Validate(){
        //TextField validation
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdEmpty.localized,state: .error)
            return
        }
        
        guard ((AppUtils.shared.isValidEmail(emailStr: emailTextField.text!))) else {
            emailTextField.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdValid.localized,state: .error)
            return
        }
    }
    
    @objc func tapForgotPassword() {
        if validation() {
            var param: Parameters
            if isPhoneSelect {
                param = [LoginConstant.PCountryCode: codeTextField.text!.trim().dropFirst(),
                         LoginConstant.PMobile: phoneNumberTextField.text!.trim(),
                         LoginConstant.PAccountType: LoginConstant.PMobile,
                         Constant.saltkey: APPConstant.saltKeyValue]
            }else{
                param = [LoginConstant.PEmail: emailTextField.text!,
                         LoginConstant.PAccountType: LoginConstant.PEmail,
                         Constant.saltkey: APPConstant.saltKeyValue]
                
            }
            loginPresenter?.forgotPasswordDetail(param: param)
        }
    }
    
    //Validation
    private func validation() -> Bool {
        
        if baseConfig?.responseData?.appsetting?.send_email == 1 && baseConfig?.responseData?.appsetting?.send_sms == 1  {
            if isPhoneSelect {
                guard let phoneStr = phoneNumberTextField.text?.trim(), !phoneStr.isEmpty else {
                    phoneNumberTextField.becomeFirstResponder()
                    simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberEmpty.localized,state: .error)
                    return false
                }
                guard phoneStr.isPhoneNumber else{
                    phoneNumberTextField.becomeFirstResponder()
                    simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberValid.localized,state: .error)
                    return false
                }
            }else{
                guard let emailStr = emailTextField.text?.trim(), !emailStr.isEmpty else {
                    emailTextField.becomeFirstResponder()
                    simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdEmpty.localized,state: .error)
                    return false
                }
                guard (AppUtils.shared.isValidEmail(emailStr: self.emailTextField.text!)) else {
                    emailTextField.becomeFirstResponder()
                    simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdValid.localized,state: .error)
                    return false
                }
            }
        }else if baseConfig?.responseData?.appsetting?.send_email == 1  && baseConfig?.responseData?.appsetting?.send_sms == 0  {
            
            guard let emailStr = emailTextField.text?.trim(), !emailStr.isEmpty else {
                emailTextField.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdEmpty.localized,state: .error)
                return false
            }
            guard (AppUtils.shared.isValidEmail(emailStr: self.emailTextField.text!)) else {
                emailTextField.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdValid.localized,state: .error)
                return false
            }
            
        }else if baseConfig?.responseData?.appsetting?.send_sms == 1  && baseConfig?.responseData?.appsetting?.send_email == 0  {
            guard let phoneStr = phoneNumberTextField.text?.trim(), !phoneStr.isEmpty else {
                phoneNumberTextField.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberEmpty.localized,state: .error)
                return false
            }
            guard phoneStr.isPhoneNumber else{
                phoneNumberTextField.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberValid.localized,state: .error)
                return false
            }
        }
        
        return true
    }
    
    @IBAction func onbackButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
//MARK: - Methods

extension ForgotPasswordController {
    
    //Login with mobile or email
    @objc func tapPhoneEmail(_ sender: UITapGestureRecognizer) {
        isPhoneSelect = sender.view?.tag == 1 ? true : false
        textFieldUpdate()
    }
    
    // set custom font
    private func setCustomFont() {
        emailTextField.font = .setCustomFont(name: .light, size: .x16)
        codeTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        phoneNumberTextField.font = .setCustomFont(name: .light, size: .x16)
        forgotPasswordViaLabel.font = .setCustomFont(name: .bold, size: .x20)
    }
}

//MARK: - Textfield delegate
extension ForgotPasswordController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField && (textField.text?.count ?? 0) > 19 && !string.isEmpty  {
            return false
        }
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case codeTextField:
            let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
            countryCodeView.pickerType = .countryCode
            countryCodeView.countryCode = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.countryDetail = countryDetail
            }
            present(countryCodeView, animated: true, completion: nil)
            return false
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    // Set country code Based on Sim
    private func setCountry(){
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let countryCodeList = AppUtils.shared.getCountries()
            for eachCountry in countryCodeList {
                if countryCode == eachCountry.code {
                    countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
                }
            }
        }
    }
}

//MARK: - LoginPresenterToLoginViewProtocol

extension ForgotPasswordController: LoginPresenterToLoginViewProtocol{
    func updateForgotPasswordSuccess(forgotPasswordEntity: ForgotPasswordEntity) {
        let resetPasswordController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ChangePasswordController) as! ChangePasswordController
        resetPasswordController.isFromChangePassword = true
        resetPasswordController.otpString = forgotPasswordEntity.forgotPasswordData?.otp?.toString() ?? String.Empty
        resetPasswordController.accountType = isPhoneSelect ? accountType.mobile : accountType.email
        resetPasswordController.emailOrPhone = isPhoneSelect ? phoneNumberTextField.text! : emailTextField.text!
        resetPasswordController.countryCode = String(isPhoneSelect ? codeTextField.text!.trim().dropFirst() : "")
        navigationController?.pushViewController(resetPasswordController, animated: true)
    }
}
