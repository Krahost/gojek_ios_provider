//
//  SignUpController.swift
//  GoJekUser
//
//  Created by Ansar on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import AuthenticationServices
import PhoneNumberKit

class SignUpController: UIViewController {
    
    @IBOutlet weak var referralCodeTextField: CustomTextField!
    @IBOutlet weak var createAccountLabel:UILabel!
    @IBOutlet weak var acceptTermsConditionLabel:UILabel!
    @IBOutlet weak var alreadyHaveAccLabel:UILabel!
    @IBOutlet weak var genderLabel:UILabel!
    
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var referralView: UIView!
    @IBOutlet weak var socialLoginview: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var signUpView:RoundedView!
    @IBOutlet weak var signInButton:UIButton!
    @IBOutlet weak var termsConditionButton:UIButton!
    @IBOutlet weak var showPasswordButton:UIButton!
    @IBOutlet weak var maleButton:UIButton!
    @IBOutlet weak var femaleButton:UIButton!
    @IBOutlet weak var socialLoginLabel: UILabel!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var outterView: UIView!
    
    //Textfield
    @IBOutlet weak var firstNameTextfield:CustomTextField!
    @IBOutlet weak var lastNameTextfield:CustomTextField!
    @IBOutlet weak var countryCodeTextfield:CustomTextField!
    @IBOutlet weak var phoneNumberTextfield:CustomTextField!
    @IBOutlet weak var emailTextfield:CustomTextField!
    @IBOutlet weak var passwordTextfield:CustomTextField!
    @IBOutlet weak var countryTextfield:CustomTextField!
    @IBOutlet weak var cityTextfield:CustomTextField!
    var iso2 = String()
    var isAcceptTerms = false {
        didSet {
            var image = UIImage()
            image = UIImage(named: isAcceptTerms ? Constant.squareFill : Constant.sqaureEmpty)!
            termsConditionButton.setImage(image, for: .normal)
        }
    }
    
    var isMaleFemale:Bool = false { //true - male , false - female
        didSet {
            maleButton.setImage(UIImage(named: isMaleFemale ? LoginConstant.circleFullImage : LoginConstant.circleImage), for: .normal)
            femaleButton.setImage(UIImage(named: isMaleFemale ? LoginConstant.circleImage : LoginConstant.circleFullImage), for: .normal)
        }
    }
    //Set show Password
    var isShowPassword:Bool = false {
        didSet {
            passwordTextfield.isSecureTextEntry = isShowPassword
            showPasswordButton.setImage(UIImage(named: isShowPassword ? LoginConstant.eyeOff : LoginConstant.eye), for: .normal)
        }
    }
    
    //Set country code and image
    private var countryDetail: Country? {
        didSet {
            if countryDetail != nil {
                countryCodeTextfield.setLeftView(imageStr: "CountryPicker.bundle/"+(countryDetail?.code ?? .Empty))
                iso2 = countryDetail?.code ?? ""
                countryCodeTextfield.text = "  \(countryDetail?.dial_code ?? .Empty)"
            }
        }
    }
    
    // variable declaration
    
    var isSocialSignup: Bool = false
    var selectedCityId = 0
    var selectedCountryId = 0
    var selectedStateId = 0
    var countryList: [String] = []
    var countryData: [CountryData] = []
    var cityData: [CityData] = []
    var accessToken: String?
    var firstName = String.Empty
    var lastName = String.Empty
    var email = String.Empty
    var loginBy: loginby = .manual
    let phoneNumberKit = PhoneNumberKit()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.roundedTop(desiredCurve: topView.frame.height/3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if CommonFunction.checkisRTL() {
            facebookButton.changeToRight(spacing: -15)
            googleButton.changeToRight(spacing: -15)
            maleButton.changeToRight(spacing: -10)
            femaleButton.changeToRight(spacing: -10)
            
        }
    }
}

extension SignUpController {
    //initalLoad Method
    private func initialLoads() {
        setupSignInButton()
        
        setCustomFont()
        setCustomColors()
        setLocalize()
        setCustomAction()
        setCustomValues()
        
        getCountries()
        setCountry()
        setWhenSocialLoginRefer()
        loginByUpdate()
        setTermsAndConditionAttributeText()
        setDarkMode()
    }
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.outterView.backgroundColor = .boxColor
        googleView.backgroundColor = .boxColor
        facebookView.backgroundColor = .boxColor
        socialLoginview.backgroundColor = .backgroundColor
    }
    
    private func setCustomValues() {
        isAcceptTerms = false
        isShowPassword = true
        
        facebookButton.setImage(UIImage(named: LoginConstant.faceBookImage), for: .normal)
        googleButton.setImage(UIImage(named: LoginConstant.googleImage), for: .normal)
        signUpView.centerImage = UIImage(named: LoginConstant.icRightArrow)
        
        facebookView.setCornerRadiuswithValue(value: 5)
        googleView.setCornerRadiuswithValue(value: 5)
        
        appleView.setCornerRadiuswithValue(value: 5)
        facebookButton.setImageTitle(spacing: 10)
        googleButton.setImageTitle(spacing: 10)
        
        countryCodeTextfield.fieldShapeType = .Left
        phoneNumberTextfield.fieldShapeType = .Right
        
        maleButton.setImage(UIImage(named: LoginConstant.circleImage), for: .normal)
        femaleButton.setImage(UIImage(named: LoginConstant.circleImage), for: .normal)
    }
    
    private func setCustomAction() {
        facebookButton.addTarget(self, action: #selector(tapFacebook), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(tapGoogle), for: .touchUpInside)
        termsConditionButton.addTarget(self, action: #selector(tapTermsCondtions(_:)), for: .touchUpInside)
        
        signInButton.addTarget(self, action: #selector(tapSignIn(_:)), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        
        let signUp = UITapGestureRecognizer(target: self, action: #selector(tapSignUp))
        signUpView.addGestureRecognizer(signUp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestuteView))
        acceptTermsConditionLabel.isUserInteractionEnabled = true
        acceptTermsConditionLabel.addGestureRecognizer(tap)
    }
    
    //Color Method
    private func setCustomColors() {
        
        view.backgroundColor = .veryLightGray
        signUpView.centerImageView.imageTintColor(color1: .white)
        signUpView.addShadow(radius: 3.0, color: .lightGray)
        signUpView.backgroundColor = .appPrimaryColor
        googleButton.setTitleColor(.blackColor, for: .normal)
        facebookButton.setTitleColor(.blackColor, for: .normal)
        appleView.backgroundColor = .black
        optionalLabel.textColor = .lightGray
        acceptTermsConditionLabel.textColor = .darkGray
        alreadyHaveAccLabel.textColor = .darkGray
        createAccountLabel.textColor = .blackColor
        signInButton.textColor(color: .appPrimaryColor)
    }
    
    //localize Method
    private func setLocalize() {
        
        optionalLabel.text = LoginConstant.optional.localized
        createAccountLabel.text = LoginConstant.createAccount.localized
        alreadyHaveAccLabel.text = LoginConstant.alreadyHaveAcc.localized
        genderLabel.text = LoginConstant.gender.localized
        maleButton.setTitle(LoginConstant.male.localized, for: .normal)
        femaleButton.setTitle(LoginConstant.female.localized, for: .normal)
        signInButton.setTitle(LoginConstant.signIn.localized, for: .normal)
        acceptTermsConditionLabel.text = LoginConstant.acceptTermsCondition.localized
        firstNameTextfield.placeholder = LoginConstant.firstName.localized
        lastNameTextfield.placeholder = LoginConstant.lastName.localized
        
        countryCodeTextfield.placeholder = LoginConstant.code.localized
        phoneNumberTextfield.placeholder = LoginConstant.phoneNumber.localized
        emailTextfield.placeholder = LoginConstant.emailId.localized
        passwordTextfield.placeholder = LoginConstant.password.localized
        cityTextfield.placeholder = LoginConstant.city.localized
        countryTextfield.placeholder = LoginConstant.country.localized
        referralCodeTextField.placeholder = LoginConstant.referralCode.localized
        facebookButton.setTitle(LoginConstant.connectFacebook.localized, for: .normal)
        googleButton.setTitle(LoginConstant.connectGoogle.localized, for: .normal)
        socialLoginLabel.text = LoginConstant.socialLogin.localized
    }
    
    //font Method
    private func setCustomFont() {
        
        optionalLabel.font = .setCustomFont(name: .medium, size: .x12)
        referralCodeTextField.font = .setCustomFont(name: .medium, size: .x16)
        socialLoginLabel.font = .setCustomFont(name: .bold, size: .x20)
        googleButton.titleLabel?.font = .setCustomFont(name: .medium, size: FontSize.x14)
        facebookButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        createAccountLabel.font = .setCustomFont(name: .bold, size: .x20)
        alreadyHaveAccLabel.font = .setCustomFont(name: .medium, size: .x14)
        firstNameTextfield.font = .setCustomFont(name: .medium, size: .x16)
        lastNameTextfield.font = .setCustomFont(name: .medium, size: .x16)
        countryCodeTextfield.font = .setCustomFont(name: .medium, size: .x16)
        phoneNumberTextfield.font = .setCustomFont(name: .medium, size: .x16)
        emailTextfield.font = .setCustomFont(name: .medium, size: .x16)
        cityTextfield.font = .setCustomFont(name: .medium, size: .x16)
        countryCodeTextfield.font = .setCustomFont(name: .medium, size: .x16)
        countryTextfield.font = .setCustomFont(name: .medium, size: .x16)
        genderLabel.font = .setCustomFont(name: .medium, size: .x16)
        passwordTextfield.font = .setCustomFont(name: .medium, size: .x16)
        signInButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        acceptTermsConditionLabel.font = .setCustomFont(name: .medium, size: .x14)
        maleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        femaleButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    private func setupSignInButton() {
           
           if #available(iOS 13.2, *) {
            self.appleView.isHidden = false
               let signInButton = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
               signInButton.addTarget(self, action: #selector(tapApple), for: .touchDown)
               self.appleView.addSubview(signInButton)
               
               signInButton.translatesAutoresizingMaskIntoConstraints = false
               signInButton.bottomAnchor.constraint(equalTo: appleView.bottomAnchor,constant: 0).isActive = true
               signInButton.leftAnchor.constraint(equalTo: appleView.leftAnchor,constant: 0).isActive = true
               signInButton.topAnchor.constraint(equalTo: appleView.topAnchor,constant: 0).isActive = true
               signInButton.rightAnchor.constraint(equalTo: appleView.rightAnchor,constant: 0).isActive = true
               signInButton.setCornerRadiuswithValue(value: 8)
           } else {
               // Fallback on earlier versions
            if #available(iOS 13.0, *) {
                self.appleView.isHidden = false
                let signInButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
                signInButton.addTarget(self, action: #selector(tapApple), for: .touchDown)
                self.appleView.addSubview(signInButton)
                
                signInButton.translatesAutoresizingMaskIntoConstraints = false
                signInButton.bottomAnchor.constraint(equalTo: appleView.bottomAnchor,constant: 0).isActive = true
                signInButton.leftAnchor.constraint(equalTo: appleView.leftAnchor,constant: 0).isActive = true
                signInButton.topAnchor.constraint(equalTo: appleView.topAnchor,constant: 0).isActive = true
                signInButton.rightAnchor.constraint(equalTo: appleView.rightAnchor,constant: 0).isActive = true
                signInButton.setCornerRadiuswithValue(value: 8)
            } else {
                // Fallback on earlier versions
                self.appleView.isHidden = true
            }
               
           }
           
       }
    
    private func loginByUpdate() {
        
        if loginBy != .manual {
            socialLoginview.isHidden = true
            let attrString = NSMutableAttributedString(string: "Welcome to \(APPConstant.appName)\n",
                attributes: [NSAttributedString.Key.font: UIFont.init(name: FontType.medium.rawValue, size: 20)!])
            attrString.append(NSMutableAttributedString(string: LoginConstant.completeaccount.localized,
                                                        attributes: [NSAttributedString.Key.font: UIFont.init(name: FontType.light.rawValue, size: 12)!]))
            createAccountLabel.attributedText = attrString
            alreadyHaveAccLabel.isHidden = true
            signInButton.setTitle(LoginConstant.close.localized, for: .normal)
        } else {
            createAccountLabel.text = LoginConstant.createAccount.localized
            let baseConfig = AppConfigurationManager.shared.baseConfigModel
            socialLoginview.isHidden = baseConfig?.responseData?.appsetting?.social_login == 0
        }
    }
    
    private func setWhenSocialLoginRefer(){
        let baseConfig = AppManager.share.getBaseDetails()
        if baseConfig?.appsetting?.referral == 0 {
            referralView.isHidden = true
        }
        
        if isSocialSignup {
            setSocialValues()
        }
        if baseConfig?.appsetting?.referral == 0 {
            referralView.isHidden = true
        }
        loginByUpdate()
        
        passwordView.isHidden = isSocialSignup
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
    
    private func socialLoginApi(){
        var param:Parameters
        param = [Constant.saltkey: APPConstant.saltKeyValue,
                 LoginConstant.PDeviceType: LoginConstant.PDeviceTypeValue,
                 LoginConstant.Psocialuniqueid: accessToken ?? .Empty,
                 LoginConstant.PLoginby:loginBy.rawValue]
        loginPresenter?.socialLoginWithUserDetail(param: param)
    }
    
    private func setSocialValues() {
        
        firstNameTextfield.text = firstName
        lastNameTextfield.text = lastName
        emailTextfield.text = email
        if email == .Empty {
            emailTextfield.isUserInteractionEnabled = true
        }else{
            emailTextfield.isUserInteractionEnabled = false
        }
    }
    
    func setTermsAndConditionAttributeText() {
        
        let text = (acceptTermsConditionLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Terms and conditions")
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineColor: UIColor.blue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont.setCustomFont(name: .medium, size: .x14)
        ]
        underlineAttriString.addAttributes(linkAttributes, range: range)
        acceptTermsConditionLabel.attributedText =  underlineAttriString
    }
    
    @objc func tapGestuteView() {
        
        let vc = WebViewController()
        if let termsUrl = AppConfigurationManager.shared.baseConfigModel.responseData?.appsetting?.cmspage?.terms {
            vc.urlString = termsUrl
        }
        vc.navTitle = LoginConstant.termsAndCondition.localized
        navigationController?.pushViewController(vc, animated: true)
    }
    //Validation Method
    private func validation() -> Bool {
        guard let firstNameStr = firstNameTextfield.text?.trim(), !firstNameStr.isEmpty else {
            firstNameTextfield.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.firstNameEmpty.localized,state: .error)
            return false
        }
        guard let lastNameStr = lastNameTextfield.text?.trim(), !lastNameStr.isEmpty else {
            lastNameTextfield.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.lastNameEmpty.localized,state: .error)
            return false
        }
        guard let phoneNameStr = phoneNumberTextfield.text?.trim(), !phoneNameStr.isEmpty else {
            phoneNumberTextfield.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberEmpty.localized,state: .error)
            return false
        }
        guard phoneNameStr.isPhoneNumber else{
            phoneNumberTextfield.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberValid.localized,state: .error)
            return false
        }
        guard let emailStr = emailTextfield.text?.trim(), !emailStr.isEmpty else {
            emailTextfield.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdEmpty.localized,state: .error)
            return false
        }
        guard ((AppUtils.shared.isValidEmail(emailStr: emailTextfield.text!))) else {
            emailTextfield.becomeFirstResponder()
            simpleAlert(view: self, title: .Empty, message: LoginConstant.emailIdValid.localized,state: .error)
            return false
        }
        if !isSocialSignup {
            guard let password = passwordTextfield.text?.trim(), !password.isEmpty  else {
                passwordTextfield.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: LoginConstant.passwordEmpty.localized,state: .error)
                return false
            }
            guard password.isValidPassword else {
                passwordTextfield.becomeFirstResponder()
                simpleAlert(view: self, title: .Empty, message: LoginConstant.passwordlength.localized,state: .error)
                return false
            }
        }
        guard let counryStr = countryTextfield.text, !counryStr.isEmpty else {
            simpleAlert(view: self, title: .Empty, message: LoginConstant.countryEmpty.localized,state: .error)
            return false
        }
        
        guard let cityStr = cityTextfield.text, !cityStr.isEmpty else {
            simpleAlert(view: self, title: .Empty, message: LoginConstant.cityEmpty.localized,state: .error)
            return false
        }
        guard isAcceptTerms else {
            simpleAlert(view: self, title: .Empty, message: LoginConstant.notAcceptTC.localized,state: .error)
            return false
        }
        return true
    }
    
    //get Country Api
    private func getCountries() {
        let param: Parameters = [Constant.saltkey: APPConstant.saltKeyValue]
        loginPresenter?.countryListDetail(param: param)
    }
    
    //Google login
    @objc func tapGoogle() {
        googleLogin()
    }
    
    //Facebook login
    @objc func tapFacebook() {
        let fbClass = FacebookLoginClass()
        fbClass.initializeFacebook(controller: self) { [weak self] (fbDetails) in
            guard let self = self else {
                return
            }
            self.firstName = fbDetails?.first_name ?? String.Empty
            self.lastName = fbDetails?.last_name ?? String.Empty
            self.email = fbDetails?.email ?? String.Empty
            self.loginBy = .facebook
            self.accessToken = "\(fbDetails?.id ?? 0 as AnyObject)"
            self.loginByUpdate()
            self.socialLoginApi()
        }
    }
    
    // Google Login
    private func googleLogin(){
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
                self.loginByUpdate()
                self.socialLoginApi()
            }else{
                ToastManager.show(title: error ?? "", state: .warning)
            }
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
                    self.loginByUpdate()
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

//MARK: - Button Action

extension SignUpController {
    //tap SignIn Action
    @objc func tapSignIn(_ sender:UIButton) {
        self.view.endEditing(true)
        let loginViewController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignInController)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    //tap Gender Action
    @objc func tapGender(_ sender:UIButton) {
        isMaleFemale = sender.tag == 0
    }
    //tap TermsCondition Action
    @objc func tapTermsCondtions(_ sender:UIButton) {
        isAcceptTerms = !isAcceptTerms
    }
    
    //tap Signup Action
    @objc func tapSignUp() {
        self.view.endEditing(true)
        signUpView.addPressAnimation()
        if validation() {
            //self.initialAccountkit()
            let param:Parameters = [LoginConstant.PEmail:emailTextfield.text ?? .Empty,
                                    LoginConstant.PMobile:phoneNumberTextfield.text ?? .Empty,
                                    LoginConstant.PCountryCode:(countryCodeTextfield.text ?? .Empty).trim().dropFirst(),
                                    LoginConstant.iso2 : self.iso2,
                                    LoginConstant.PReferral_code:referralCodeTextField.text ?? .Empty,
                                    Constant.saltkey: APPConstant.saltKeyValue]
            loginPresenter?.verifyMobileAndEmail(param: param)
        }
    }
    
    //show Password Action
    @objc func showPassword() {
        isShowPassword = !isShowPassword
    }
    //show TabbarController
    func signUpSuccess() {
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        appDelegate.window?.rootViewController = TabBarController().listTabBarController()
        appDelegate.window?.makeKeyAndVisible()
    }
}

//MARK: - Textfield delegate

extension SignUpController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case countryCodeTextfield:
            let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
            countryCodeView.pickerType = .countryCode
            countryCodeView.countryCode = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.countryDetail = countryDetail
                if self.phoneNumberTextfield.text != "" {
                    do {
                        
                        let phoneNumber = try self.phoneNumberKit.parse((self.phoneNumberTextfield.text ?? ""), withRegion: countryDetail.code, ignoreType: false)
                        let formatedNumber = self.phoneNumberKit.format(phoneNumber, toType: .international)
                        print(phoneNumber)
                        print(formatedNumber)
                    }
                    catch {
                        print("Generic parser error")
                        self.simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberValid.localized,state: .error)
                        
                        
                        
                    }
                }
            }
            present(countryCodeView, animated: true, completion: nil)
            return false
        case countryTextfield:
            let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
            countryCodeView.pickerType = .countryList
            countryCodeView.countryListEntity = countryData
            countryCodeView.selectedCountry = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.countryTextfield.text = countryDetail.country_name
                self.selectedCountryId = countryDetail.id ?? 0
                self.cityTextfield.text = .Empty
                self.cityData = countryDetail.city ?? []
            }
            present(countryCodeView, animated: true, completion: nil)
            return false
        case cityTextfield:
            guard let stateStr = countryTextfield.text, !stateStr.isEmpty else{
                simpleAlert(view: self, title: .Empty, message: LoginConstant.countryEmpty.localized,state: .error)
                return false
            }
            let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
            countryCodeView.pickerType = .cityList
            countryCodeView.cityListEntity = cityData
            countryCodeView.selectedCity = { [weak self] cityDetail in
                guard let self = self else {
                    return
                }
                self.cityTextfield.text = cityDetail.city_name
                self.selectedCityId = cityDetail.id ?? 0
            }
            present(countryCodeView, animated: true, completion: nil)
            return false
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            print("done")
            if textField == phoneNumberTextfield {
                 do {
              
                     let phoneNumber = try phoneNumberKit.parse((phoneNumberTextfield.text ?? ""), withRegion: countryDetail!.code, ignoreType: false)
                            let formatedNumber = phoneNumberKit.format(phoneNumber, toType: .international)
                            print(phoneNumber)
                            print(formatedNumber)
                 }
                 catch {
                     print("Generic parser error")
                    simpleAlert(view: self, title: .Empty, message: LoginConstant.mobileNumberValid.localized,state: .error)


                    
                 }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextfield && (textField.text?.count ?? 0) > 19 && !string.isEmpty  {
            
            return false
        }
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        return true
    }
}

// Core Data
extension SignUpController {
    //To save coredata
    fileprivate func saveSignin(loginEntity: LoginEntity) {
        let fetchData = try!DataBaseManager.shared.context.fetch(LoginData.fetchRequest()) as? [LoginData]
        if fetchData?.count ?? 0 > 0 {
            DataBaseManager.shared.delete(entityName: CoreDataEntity.loginData.rawValue)
        }
        
        let loginDetail = LoginData(context: DataBaseManager.shared.persistentContainer.viewContext)
        loginDetail.access_token  = loginEntity.responseData?.accessToken
        DataBaseManager.shared.saveContext()
    }
}

//MARK: - API
extension SignUpController: LoginPresenterToLoginViewProtocol {
    
    func updateSignUpSuccess(signUpEntity: LoginEntity) {
        AppManager.share.accessToken = signUpEntity.responseData?.accessToken
        saveSignin(loginEntity: signUpEntity)
        signUpSuccess()
        
    }
    
    func verifySuccess(verifyEntity: LoginEntity) {
        
        if verifyEntity.responseData?.otp == 1 {
            AppConfigurationManager.shared.baseConfigModel = nil

            loginPresenter?.getBaseURL(param: [Constant.saltkey: APPConstant.saltKeyValue])

           
        }else{
            if self.loginBy == .manual {
                self.normalSignUp()
            }else{
                self.socialSignUp(loginBy: self.loginBy)
            }
        }
    }
    
    func getBaseURLResponse(baseEntity: BaseEntity) {
        AppConfigurationManager.shared.baseConfigModel = baseEntity
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        AppManager.share.setBaseDetails(details: baseEntity.responseData!)
        let param:Parameters = [Constant.saltkey: APPConstant.saltKeyValue,
                                LoginConstant.PCountryCode: (countryCodeTextfield.text ?? "").trim().dropFirst(),
                                LoginConstant.iso2 : self.iso2,
                                LoginConstant.PMobile: phoneNumberTextfield.text!.trim()]
        
        loginPresenter?.sendOtp(param: param)
    }
    
    private func socialSignUp(loginBy:loginby) {
        var param:Parameters
        param = [Constant.saltkey: APPConstant.saltKeyValue,
                 LoginConstant.PDeviceType:  LoginConstant.PDeviceTypeValue,
                 LoginConstant.PDeviceToken: deviceTokenString,
                 LoginConstant.Psocialuniqueid: accessToken ?? "",
                 LoginConstant.PDeviceId: UUID().uuidString,
                 LoginConstant.PLoginby: loginBy.rawValue,
                 LoginConstant.PFirstName: firstNameTextfield.text!,
                 LoginConstant.PLastName: lastNameTextfield.text!,
                 LoginConstant.PEmail: emailTextfield.text!,
                 LoginConstant.PGender: isMaleFemale ? gender.male.rawValue : gender.female.rawValue,
                 LoginConstant.PCountryCode: countryCodeTextfield.text!.trim().dropFirst(),
                 LoginConstant.iso2 : self.iso2,
                 LoginConstant.PMobile: phoneNumberTextfield.text!.trim(),
                 LoginConstant.PCountryId: selectedCountryId,
                 LoginConstant.PCityId: selectedCityId,
                 LoginConstant.PReferral_code : referralCodeTextField.text ?? ""]
        
        let profileImageData: [String:Data]? = nil
        loginPresenter?.signUpWithUserDetail(param: param, imageData: profileImageData)
    }
    
    private func normalSignUp() {
        let param:Parameters = [Constant.saltkey : APPConstant.saltKeyValue,
                                LoginConstant.PDeviceType : LoginConstant.PDeviceTypeValue,
                                LoginConstant.PDeviceToken : deviceTokenString,
                                LoginConstant.PDeviceId : UUID().uuidString,
                                LoginConstant.PLoginby : loginby.manual.rawValue,
                                LoginConstant.PFirstName : firstNameTextfield.text!.trim(),
                                LoginConstant.PLastName : lastNameTextfield.text!.trim(),
                                LoginConstant.PEmail : emailTextfield.text!.trim(),
                                LoginConstant.PGender : isMaleFemale ? gender.male.rawValue : gender.female.rawValue,
                                LoginConstant.PCountryCode : countryCodeTextfield.text!.trim().dropFirst(),
                                LoginConstant.iso2 : self.iso2,
                                LoginConstant.PMobile : phoneNumberTextfield.text!.trim(),
                                LoginConstant.PPassword : passwordTextfield.text!.trim(),
                                LoginConstant.PConfirmPassword : passwordTextfield.text!.trim(),
                                LoginConstant.PCountryId : selectedCountryId,
                                LoginConstant.PCityId : selectedCityId,
                                LoginConstant.PReferral_code : referralCodeTextField.text ?? ""]
        
        let profileImageData:[String:Data]? = nil
        loginPresenter?.signUpWithUserDetail(param: param, imageData: profileImageData)
    }
    
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        StoreLoginData.shared.socialAccessToken = accessToken ?? ""
        StoreLoginData.shared.loginBy = self.loginBy
        StoreLoginData.shared.firstName = firstNameTextfield.text!
        StoreLoginData.shared.lastName = lastNameTextfield.text!
        StoreLoginData.shared.email = emailTextfield.text!
        if (maleButton.imageView?.image == UIImage(named: LoginConstant.circleImage)) && (femaleButton.imageView?.image == UIImage(named: LoginConstant.circleImage)){
            StoreLoginData.shared.gender = nil
        }else{
            StoreLoginData.shared.gender = isMaleFemale ? gender.male.rawValue : gender.female.rawValue
            
        }
        StoreLoginData.shared.countryCode = (countryCodeTextfield.text ?? "").trim()
        StoreLoginData.shared.mobile = phoneNumberTextfield.text!.trim()
        StoreLoginData.shared.countryId = selectedCountryId
        StoreLoginData.shared.cityId = selectedCityId
        StoreLoginData.shared.referralCode = referralCodeTextField.text ?? ""
        StoreLoginData.shared.password = passwordTextfield.text?.trim()
        StoreLoginData.shared.profileImageData  = nil
        
        let otpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.OtpController) as! OtpController
        otpController.iso2 = self.iso2
        navigationController?.pushViewController(otpController, animated: true)
    }
    
    func updateCountryListSuccess(countryEntity: CountryEntity) {
        countryData = countryEntity.countryData ?? []
    }
    
    func failureResponse(failureData: Data) {
        if
            let utf8Text = String(data: failureData, encoding: .utf8),
            let messageDic = utf8Text.stringToDictionary(),
            let message = messageDic[Constant.message] {
            if "\(message)" == LoginConstant.soicalLoginmessage {
                print("IS Yet to register")
                isSocialSignup = true
                setWhenSocialLoginRefer()
                setSocialValues()
            }else{
                simpleAlert(view: self, title: .Empty, message: message as! String,state: .error)
            }
        }
    }
    
    func updateSocialLoginSuccess(socialEntity: LoginEntity) {
        AppManager.share.accessToken = socialEntity.responseData?.accessToken
        saveSignin(loginEntity: socialEntity)
        signUpSuccess()
    }
}

import SafariServices

extension  SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen}
        set { super.modalPresentationStyle = newValue }
    }
}
