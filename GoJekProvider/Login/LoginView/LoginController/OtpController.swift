//
//  OtpController.swift
//  GoJekUser
//
//  Created by CSS on 18/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class OtpController: UIViewController {
    
    //MARK:- IBOutlet

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var otpVerifyButton: UIButton!
    
    var isprofile = false
    var countryCode = ""
    var phoneNumber = ""
    var iso2 = String()

    weak var delegate: updateOtpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalLoads()
    }
    
}
extension OtpController {
    private func initalLoads(){
        addshadow()
        
        self.title = LoginConstant.otpVerification
        self.setLeftBarButtonWith(color: .black)
        self.navigationController?.isNavigationBarHidden = false
        
        firstTextField.becomeFirstResponder()
        
        setDefaultValue()
        setCustomAction()
        setCustomFont()
        setCustomColor()
    }
    
    private func setDefaultValue() {
        titleLabel.text = LoginConstant.otpTitle
        otpVerifyButton.setTitle(LoginConstant.verify, for: .normal)
    }
    
    private func setCustomFont() {
        titleLabel.font = .setCustomFont(name: .bold, size: .x18)
        firstTextField.font = .setCustomFont(name: .bold, size: .x20)
        secondTextField.font = .setCustomFont(name: .bold, size: .x20)
        thirdTextField.font = .setCustomFont(name: .bold, size: .x20)
        fourthTextField.font = .setCustomFont(name: .bold, size: .x20)
        
        otpVerifyButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x20)
        titleLabel.font = .setCustomFont(name: .bold, size: .x22)
        otpVerifyButton.addShadow(radius: 3.0, color: .lightGray)
    }
    
    private func setCustomColor() {
        otpVerifyButton.setTitleColor(.white, for: .normal)
        otpVerifyButton.backgroundColor = .appPrimaryColor

        firstTextField.tintColor = .appPrimaryColor
        secondTextField.tintColor = .appPrimaryColor
        thirdTextField.tintColor = .appPrimaryColor
        fourthTextField.tintColor = .appPrimaryColor
        
        firstTextField.backgroundColor = .lightGray
        secondTextField.backgroundColor = .lightGray
        thirdTextField.backgroundColor = .lightGray
        fourthTextField.backgroundColor = .lightGray
    }
    
    
    private func setCustomAction() {
        
        otpVerifyButton.addTarget(self, action: #selector(tapOtpVerify), for: .touchUpInside)
        firstTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        secondTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        thirdTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        fourthTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
    }
    
    private func socialSignUp(loginBy:loginby) {
        
        let param:Parameters = [Constant.saltkey: APPConstant.saltKeyValue,
                                LoginConstant.PDeviceType: LoginConstant.PDeviceTypeValue,
                                LoginConstant.PDeviceToken: deviceTokenString,
                                LoginConstant.Psocialuniqueid: StoreLoginData.shared.socialAccessToken ?? "",
                                LoginConstant.PDeviceId: UUID().uuidString,
                                LoginConstant.PLoginby: loginBy.rawValue,
                                LoginConstant.PFirstName: StoreLoginData.shared.firstName ?? "",
                                LoginConstant.PLastName: StoreLoginData.shared.lastName ?? "",
                                LoginConstant.PEmail: StoreLoginData.shared.email ?? "",
                                LoginConstant.PGender: StoreLoginData.shared.gender ?? "",
                                LoginConstant.PCountryCode: (StoreLoginData.shared.countryCode ?? "").dropFirst(),
                                LoginConstant.iso2 : self.iso2,
                                LoginConstant.PMobile: StoreLoginData.shared.mobile ?? "",
                                LoginConstant.PCountryId: StoreLoginData.shared.countryId ?? 0,
                                LoginConstant.PCityId: StoreLoginData.shared.cityId ?? 0,
                                LoginConstant.PReferral_code : StoreLoginData.shared.referralCode ?? ""]
        
        loginPresenter?.signUpWithUserDetail(param: param, imageData: StoreLoginData.shared.profileImageData)
        
    }
    private func normalSignUp() {
        let param:Parameters = [Constant.saltkey : APPConstant.saltKeyValue,
                                LoginConstant.PDeviceType : LoginConstant.PDeviceTypeValue,
                                LoginConstant.PDeviceToken : deviceTokenString,
                                LoginConstant.PDeviceId : UUID().uuidString,
                                LoginConstant.PLoginby : loginby.manual.rawValue,
                                LoginConstant.PPassword : StoreLoginData.shared.password ?? "",
                                LoginConstant.PConfirmPassword : StoreLoginData.shared.password ?? "",
                                LoginConstant.PFirstName: StoreLoginData.shared.firstName ?? "",
                                LoginConstant.PLastName: StoreLoginData.shared.lastName ?? "",
                                LoginConstant.PEmail: StoreLoginData.shared.email ?? "",
                                LoginConstant.PGender: StoreLoginData.shared.gender ?? "",
                                LoginConstant.iso2 : self.iso2,
                                LoginConstant.PCountryCode: (StoreLoginData.shared.countryCode ?? "").dropFirst(),
                                LoginConstant.PMobile: StoreLoginData.shared.mobile ?? "",
                                LoginConstant.PCountryId: StoreLoginData.shared.countryId ?? 0,
                                LoginConstant.PCityId: StoreLoginData.shared.cityId ?? 0,
                                LoginConstant.PReferral_code : StoreLoginData.shared.referralCode ?? ""]
        
        loginPresenter?.signUpWithUserDetail(param: param, imageData: StoreLoginData.shared.profileImageData)
        
    }
    
    private func saveSignin(loginEntity: LoginEntity) {
        
        let fetchData = try!DataBaseManager.shared.context.fetch(LoginData.fetchRequest()) as? [LoginData]
        if fetchData?.count ?? 0 > 0 {
            DataBaseManager.shared.delete(entityName: CoreDataEntity.loginData.rawValue)
        }
        
        let loginDetail = LoginData(context: DataBaseManager.shared.persistentContainer.viewContext)
        loginDetail.access_token  = loginEntity.responseData?.accessToken
        DataBaseManager.shared.saveContext()
    }
}

//MARK:- IBAction

extension OtpController {
    
    @objc func tapOtpVerify() {
           self.view.endEditing(true)
           guard let otp1 = firstTextField.text, !otp1.isEmpty else {
               firstTextField.becomeFirstResponder()
               ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
               return
           }
           
           guard let otp2 = secondTextField.text, !otp2.isEmpty else {
               secondTextField.becomeFirstResponder()
               ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
               return
           }
           
           guard let otp3 = thirdTextField.text, !otp3.isEmpty else {
               thirdTextField.becomeFirstResponder()
               ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
               return
           }
           
           guard let otp4 = fourthTextField.text, !otp4.isEmpty else {
               fourthTextField.becomeFirstResponder()
               ToastManager.show(title: LoginConstant.InvalidOTP.localized , state: .error)
               return
           }
           
           var otp: [String] = []
           otp.append(otp1)
           otp.append(otp2)
           otp.append(otp3)
           otp.append(otp4)
           
           var param: Parameters = [Constant.saltkey: APPConstant.saltKeyValue,
                                    LoginConstant.Potp: otp.joined()]
           if isprofile {
               
               let newString = countryCode.replacingOccurrences(of: "+", with: "", options: .literal, range: nil)
               param[LoginConstant.PCountryCode] = newString.trim()
               param[LoginConstant.PMobile] = phoneNumber
               
           }else {
               param[LoginConstant.PCountryCode] = (StoreLoginData.shared.countryCode  ?? "").dropFirst()
               param[LoginConstant.PMobile] = StoreLoginData.shared.mobile ?? ""
           }
       
           loginPresenter?.verifyOtp(param: param)
       }
      
}

//MARK:- LoginPresenterToLoginViewProtocolxs

extension OtpController: LoginPresenterToLoginViewProtocol {
    
    func updateSignUpSuccess(signUpEntity: LoginEntity) {
        AppManager.share.accessToken = signUpEntity.responseData?.accessToken
        saveSignin(loginEntity: signUpEntity)
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func verifyOtpSuccess(verifyOtpEntity: VerifyOtpEntity) {
        if isprofile {
            delegate?.updateOtp(countryCode: countryCode,mobile: phoneNumber)
            self.navigationController?.popViewController(animated: true)
        }else{
            if StoreLoginData.shared.loginBy == .manual {
                self.normalSignUp()
            }else{
                self.socialSignUp(loginBy: StoreLoginData.shared.loginBy!)
            }
        }
    }
}

//MARK:- UITextFieldDelegate

extension OtpController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        textField.text = ""
    
        if string == "" {
            switch textField {
            case secondTextField:
                firstTextField.becomeFirstResponder()
            case thirdTextField:
                secondTextField.becomeFirstResponder()
            case fourthTextField:
                thirdTextField.becomeFirstResponder()
            default: break
                
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
            case firstTextField:
                secondTextField.becomeFirstResponder()
            case secondTextField:
                thirdTextField.becomeFirstResponder()
            case thirdTextField:
                fourthTextField.becomeFirstResponder()
            case fourthTextField:
                fourthTextField.resignFirstResponder()
            default:
                break
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)!{
            //textField.selectAll(self)
        }else{
            textField.text = " "
        }
    }
}
