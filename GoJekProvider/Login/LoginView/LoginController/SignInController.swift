//
//  SignInController.swift
//  GoJekProvider
//
//  Created by Ansar on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import AuthenticationServices
var isDarkMode = false

class SignInController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var signInView: RoundedView!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var mailImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var socialLoginView: UIView!
    
    @IBOutlet weak var socialLoginLabel: UILabel!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var loginViaLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var phoneTextFieldView: UIView!
    @IBOutlet weak var emailTextFieldView: UIView!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var codeTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var appleView: UIView!
    
    //Is selected phone or email
    var isPhoneSelect = false {
        didSet {
            phoneTextFieldView.isHidden = !isPhoneSelect
            emailTextFieldView.isHidden = isPhoneSelect
            textfieldUIUpdate()
        }
    }
    
    //Set country code and image
    private var countryDetail: Country? {
        didSet {
            if countryDetail != nil {
                codeTextField.setLeftView(imageStr: "CountryPicker.bundle/"+(countryDetail?.code ?? .Empty))
                codeTextField.text = "  \(countryDetail?.dial_code ?? .Empty)"
            }
        }
    }
    
    //Set show Password 
    var isShowPassword:Bool = false {
        didSet {
            passwordTextField.isSecureTextEntry = isShowPassword
            showPasswordButton.setImage(UIImage(named: isShowPassword ? LoginConstant.eyeOff : LoginConstant.eye), for: .normal)
        }
    }
    
    // variable declaration
    private var accessToken: String?
    private var firstName = String.Empty
    private var lastName = String.Empty
    private var email = String.Empty
    private var loginBy: loginby = .manual
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if CommonFunction.checkisRTL() {
            facebookButton.changeToRight(spacing: -15)
            googleButton.changeToRight(spacing: -15)
            signInView.centerImage = UIImage(named: LoginConstant.icRightArrow)
        }
    }
}

//MARK: - LocalMethods

extension SignInController {
    
    private func initialLoads(){
        //UI update
        DispatchQueue.main.async {
            self.topView.roundedTop(desiredCurve: self.topView.frame.height/3)
        }
        
        //Call local method
        setupSignInButton()
        setCustomLocalization()
        setCustomColor()
        setCustomFont()
        setCountry()
        setCustomAction()
        SetCustomValues()
        setDarkMode()
    }
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.socialLoginView.backgroundColor = .boxColor
        self.outterView.backgroundColor = .boxColor
    }
    
    private func SetCustomValues() {
        facebookButton.setImageTitle(spacing: 10)
        googleButton.setImageTitle(spacing: 10)
        signInView.addShadow(radius: 3.0, color: .lightGray)
        
        phoneImage.image = UIImage(named: LoginConstant.phone)
        mailImage.image = UIImage(named: LoginConstant.mail)
        signInView.centerImage = UIImage(named: LoginConstant.icRightArrow)
        facebookButton.setImage(UIImage(named: LoginConstant.faceBookImage), for: .normal)
        googleButton.setImage(UIImage(named: LoginConstant.googleImage), for: .normal)
        
        isPhoneSelect = true
        isShowPassword = true
        
        let baseConfig = AppManager.share.getBaseDetails()
        if baseConfig?.appsetting?.social_login == 1 {
            socialLoginView.isHidden = false
            orLabel.isHidden = false
        }else{
            socialLoginView.isHidden = true
            orLabel.isHidden = true
        }
    }
    
    private func setCustomAction() {
        let signinGuesture = UITapGestureRecognizer(target: self, action: #selector(signInButtonAction))
        signInView.addGestureRecognizer(signinGuesture)
        
        let phoneViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoneEmail(_:)))
        phoneView.addGestureRecognizer(phoneViewGesture)
        
        let mailViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoneEmail(_:)))
        mailView.addGestureRecognizer(mailViewGesture)
        
        facebookButton.addTarget(self, action: #selector(tapFacebook), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(tapGoogle), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(tapShowPassword), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotButtonAction), for: .touchUpInside)
    }
    
    // Set country code Based on Sim
    private func setCountry(){
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let countryCodeList = AppUtils.shared.getCountries()
            for eachCountry in countryCodeList {
                if countryCode == eachCountry.code {
                    self.countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
                }
            }
        }
    }
    
    private func textfieldUIUpdate() {
        passwordTextField.text = .Empty
        emailTextField.text = .Empty
        phoneNumberTextField.text = .Empty
        view.endEditing(true)
        DispatchQueue.main.async {
            if self.isPhoneSelect {
                self.phoneImage.imageTintColor(color1: .appPrimaryColor)
                self.mailImage.imageTintColor(color1: .lightGray)
                self.phoneView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.1)
                self.mailView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            } else {
                self.mailImage.imageTintColor(color1: .appPrimaryColor)
                self.phoneImage.imageTintColor(color1: .lightGray)
                self.phoneView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
                self.mailView.backgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.1)
            }
        }
    }
    
    private func setupSignInButton() {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                self.appleView.isHidden = false
                let signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
                signInButton.addTarget(self, action: #selector(self.tapApple), for: .touchDown)
                self.appleView.addSubview(signInButton)
                signInButton.translatesAutoresizingMaskIntoConstraints = false
                signInButton.bottomAnchor.constraint(equalTo: self.appleView.bottomAnchor,constant: 0).isActive = true
                signInButton.leftAnchor.constraint(equalTo: self.appleView.leftAnchor,constant: 0).isActive = true
                signInButton.topAnchor.constraint(equalTo: self.appleView.topAnchor,constant: 0).isActive = true
                signInButton.rightAnchor.constraint(equalTo: self.appleView.rightAnchor,constant: 0).isActive = true
                signInButton.setCornerRadiuswithValue(value: 8)
            } else {
                // Fallback on earlier versions
                self.appleView.isHidden = true
            }
            
        }
        
    }
    
    //Set localize sting
    private func setCustomLocalization() {
        
        loginViaLabel.text = LoginConstant.loginVia.localized
        forgotPasswordButton.setTitle(LoginConstant.forgotPassword.localized, for: .normal)
        signUpButton.setTitle(LoginConstant.signUp.localized, for: .normal)
        socialLoginLabel.text = LoginConstant.socialLogin.localized
        orLabel.text = LoginConstant.or.localized.uppercased()
        dontHaveAccountLabel.text = LoginConstant.dontHaveAcc.localized
        facebookButton.setTitle(LoginConstant.connectFacebook.localized, for: .normal)
        googleButton.setTitle(LoginConstant.connectGoogle.localized, for: .normal)
        
        //Placeholder text
        emailTextField.placeholder = Constant.PEmail.localized
        codeTextField.placeholder = Constant.PCode.localized
        codeTextField.fieldShapeType = .Left
        passwordTextField.placeholder = Constant.PPassword.localized
        phoneNumberTextField.placeholder = Constant.PPhoneNumber.localized
        phoneNumberTextField.fieldShapeType = .Right
    }
    
    //Set custom color
    private func setCustomColor() {
        
        view.backgroundColor = .veryLightGray
        loginViaLabel.textColor = .blackColor
        forgotPasswordButton.textColor(color: .blackColor)
        facebookButton.textColor(color: .blackColor)
        googleButton.textColor(color: .blackColor)
        dontHaveAccountLabel.textColor = .darkGray
        socialLoginLabel.textColor = .blackColor
        orLabel.textColor = .appPrimaryColor
        signUpButton.textColor(color:.appPrimaryColor)
        signInView.backgroundColor = .appPrimaryColor
        
        signInView.centerImageView.imageTintColor(color1: .white)
    }
    
    // set custom font
    private func setCustomFont() {
        emailTextField.font = .setCustomFont(name: .light, size: .x16)
        codeTextField.font = .setCustomFont(name: .light, size: .x16)
        passwordTextField.font = .setCustomFont(name: .light, size: .x16)
        phoneNumberTextField.font = .setCustomFont(name: .light, size: .x16)
        
        signUpButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        facebookButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        googleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        dontHaveAccountLabel.font = .setCustomFont(name: .light, size: .x14)
        orLabel.font = .setCustomFont(name: .bold, size: .x16)
        loginViaLabel.font = .setCustomFont(name: .bold, size: .x20)
        socialLoginLabel.font = .setCustomFont(name: .bold, size: .x20)
    }
    
    //Validation
    private func validation() -> Bool {
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
            guard (AppUtils.shared.isValidEmail(emailStr: emailTextField.text!)) else {
                emailTextField.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdValid.localized,state: .error)
                return false
            }
        }
        guard let passwordStr = passwordTextField.text?.trim(), !passwordStr.isEmpty else {
            passwordTextField.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.passwordEmpty.localized,state: .error)
            return false
        }
        guard passwordStr.isValidPassword else {
            passwordTextField.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.passwordlength.localized,state: .error)
            return false
        }
        return true
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
    
    private func socialLoginApi() {
        var param:Parameters
        param = [Constant.saltkey: APPConstant.saltKeyValue,
                 LoginConstant.PDeviceType: LoginConstant.PDeviceTypeValue,
                 LoginConstant.Psocialuniqueid: accessToken ?? .Empty,
                 LoginConstant.PDeviceToken: deviceTokenString,
                 LoginConstant.PLoginby:loginBy.rawValue]
        loginPresenter?.socialLoginWithUserDetail(param: param)
    }
    
}

//MARK: - Actions

extension SignInController {
    //SignIn Action
    @objc func signInButtonAction() {
        signInView.addPressAnimation()
        view.endEditing(true)
        if validation() {
            var param: Parameters
            if isPhoneSelect {
                param = [LoginConstant.PCountryCode: codeTextField.text!.trim().dropFirst(),
                         LoginConstant.PMobile: phoneNumberTextField.text!.trim()]
            } else {
                param = [LoginConstant.PEmail: emailTextField.text!]
            }
            param[LoginConstant.PPassword] = passwordTextField.text!
            param[Constant.saltkey] = APPConstant.saltKeyValue
            param[LoginConstant.PDeviceType] = LoginConstant.PDeviceTypeValue
            param[LoginConstant.PDeviceToken] = deviceTokenString
            loginPresenter?.loginWithUserDetail(param: param)
        }
    }
    //Forgot Action
    @objc func forgotButtonAction() {
        view.endEditing(true)
        let forgotPasswordController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.ForgotPasswordController) as! ForgotPasswordController
        forgotPasswordController.isPhoneSelect = isPhoneSelect
        navigationController?.pushViewController(forgotPasswordController, animated: true)
    }
    
    // tap show Password
    @objc func tapShowPassword() {
        isShowPassword = !isShowPassword
    }
    
    
    //Call Login API Service
    func signinSuccess() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
    
    //sigup button 
    @objc func signupButtonAction() {
        view.endEditing(true)
        let signUpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignUpController)
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    
    //Login with mobile or email
    @objc func tapPhoneEmail(_ sender: UITapGestureRecognizer) {
        isPhoneSelect = sender.view?.tag == 1 ? true : false
    }
    
    
    //Google login
    @objc func tapGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let googleSignin = GoogleSignin.share
        googleSignin.getGoogleData { [weak self] (googleDetails,error) in
            guard let self = self else {
                return
            }
            if googleDetails != nil {
                self.accessToken = googleDetails?.userID ?? ""
                self.firstName = googleDetails?.profile.name ?? ""
                self.lastName = googleDetails?.profile.familyName ?? ""
                self.email = googleDetails?.profile.email ?? ""
                self.loginBy = .google
                self.socialLoginApi()
            }else{
                ToastManager.show(title: error ?? "", state: .warning)
            }
        }
    }
    
    //Facebook login
    @objc func tapFacebook() {
        let fbClass = FacebookLoginClass()
        fbClass.initializeFacebook(controller: self) { [weak self] (fbDetails) in
            guard let self = self else {
                return
            }
            self.firstName = fbDetails?.first_name ?? .Empty
            self.lastName = fbDetails?.last_name ?? .Empty
            self.email = fbDetails?.email ?? .Empty
            self.loginBy = .facebook
            self.accessToken = "\(fbDetails?.id ?? 0 as AnyObject)"
            self.socialLoginApi()
        }
    }
    
    //Apple login
    @objc func tapApple() {
        if #available(iOS 13.0, *) {
            AppleSignin.shared.initAppleSignin(scope: [.email, .fullName]) { (appleData) in
                if appleData.error == nil {
                    self.accessToken = appleData.userId ?? ""
                    self.firstName = appleData.firstName ?? ""
                    self.lastName = appleData.lastName ?? ""
                    self.email = appleData.email ?? ""
                    self.loginBy = .apple
                    self.socialLoginApi()
                } else {
                    self.simpleAlert(view: self, title: String.Empty, message: appleData.error ?? "", state: .error)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

//MARK: - UITextFieldDelegate

extension SignInController: UITextFieldDelegate {
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if textField == passwordTextField && (textField.text?.count ?? 0) > 19 && !string.isEmpty  {
            
            return false
        }
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        return true
    }
}

//MARK: - LoginPresenterToLoginViewProtocol

extension SignInController: LoginPresenterToLoginViewProtocol {
    
    func updateLoginSuccess(loginEntity: LoginEntity) {
        print(loginEntity)
        AppManager.share.accessToken = loginEntity.responseData?.accessToken
        saveSignin(loginEntity: loginEntity)
        signinSuccess()
    }
    
    func updateSocialLoginSuccess(socialEntity: LoginEntity) {
        AppManager.share.accessToken = socialEntity.responseData?.accessToken
        saveSignin(loginEntity: socialEntity)
        signinSuccess()
    }
    
    func failureResponse(failureData: Data) {
        if
            let utf8Text = String(data: failureData, encoding: .utf8),
            let messageDic = utf8Text.stringToDictionary(),
            let message = messageDic[Constant.message] {
            if "\(message)" == LoginConstant.soicalLoginmessage {
                print("IS Yet to register")
                let signUpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignUpController) as! SignUpController
                signUpController.firstName = firstName
                signUpController.lastName = lastName
                signUpController.email = email
                signUpController.loginBy = loginBy
                signUpController.accessToken = accessToken
                signUpController.isSocialSignup = true
                navigationController?.pushViewController(signUpController, animated: true)
                
            }else{
                simpleAlert(view: self, title: .Empty, message: message as! String,state: .error)
            }
        }
    }
}
