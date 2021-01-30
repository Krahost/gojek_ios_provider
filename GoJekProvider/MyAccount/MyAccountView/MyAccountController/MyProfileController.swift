//
//  MyProfileController.swift
//  GoJekProvider
//
//  Created by Ansar on 25/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import PhoneNumberKit

class MyProfileController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var editOuterView: UIView!
    @IBOutlet weak var profileDetailView: UIView!
    
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var codeTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var emailIdTextField: CustomTextField!
    @IBOutlet weak var cityTextField: CustomTextField!
    @IBOutlet weak var countryTextField: CustomTextField!
    @IBOutlet weak var maleButton:UIButton!
    @IBOutlet weak var femaleButton:UIButton!
    
    @IBOutlet weak var genderLabel:UILabel!
    
    var selectedCityId: Int = 0
    var selectedCountryId: Int = 0
    var isFromUpdate = false
    
    var countryData: [CountryData] = []
    var cityData: [CityData] = []
    var isMobileEdited: Bool = false //local flag for isMobile Edited
    let phoneNumberKit = PhoneNumberKit()
    var iso2 = String()

    //Set country code and image
    private var countryDetail: Country? {
        didSet {
            if countryDetail != nil {
                codeTextField.setLeftView(imageStr: "CountryPicker.bundle/"+(countryDetail?.code ?? String.Empty))
                self.iso2 = countryDetail?.code ?? ""
                codeTextField.text = "  \(countryDetail?.dial_code ?? String.Empty)"
            }
        }
    }
    
    var isMaleFemale:Bool = false { //true - male , false - female
        didSet {
            maleButton.setImage(UIImage(named: isMaleFemale ? LoginConstant.circleFullImage : LoginConstant.circleImage), for: .normal)
            femaleButton.setImage(UIImage(named: isMaleFemale ? LoginConstant.circleImage : LoginConstant.circleFullImage), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set view propery
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myAccountPresenter?.getProfileDetail()

        //Hide show tabbar
        hideTabBar()
        if checkisRTL() {
            maleButton.setImageTitle(spacing: 10)
            femaleButton.setImageTitle(spacing: 10)
            femaleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: -6)
            femaleButton.imageView?.contentMode = .scaleAspectFit
            maleButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: -6)
            maleButton.imageView?.contentMode = .scaleAspectFit            
        }
        navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func showNotApproved(_ sender: Any) {
       // approvalText.isHidden = !approvalText.isHidden
    }
}

//MARK: - LocalMethods

extension MyProfileController  {
    
    //Setup view basic
    private func viewDidSetup() {
        
        addshadow()
        self.title = MyAccountConstant.profile.localized
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.setCustomFont(name: .medium, size: .x22)]
        setLeftBarButtonWith(color: .blackColor)
        
        //Get country name list
        let param: Parameters = [Constant.saltkey: APPConstant.saltKeyValue]
        myAccountPresenter?.countryListDetail(param: param)
        
        if let userData = AppManager.share.getUserDetails() {
            setProfileDetails(userData: userData)
        }
        
        
        //Set color
        setCustomColor()
        
        //Set placehoder localization
        setCustomLocalization()
        
        //Call set custom font methodapple
        
        setCustomFont()
        
        //Profile detail view update
        profileDetailView.setCornerRadiuswithValue(value: 5.0)
        
        //Add action to exit button and set image
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.appPrimaryColor.cgColor
        profileImage.backgroundColor = .whiteColor
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        profileImage.addGestureRecognizer(gesture)
        let editgesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        editOuterView.addGestureRecognizer(editgesture)
        saveButton.setTitle(Constant.save.localized, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
        self.editImageView.setImageColor(color: .whiteColor)

        editOuterView.setBorder(width: 2.0, color: .whiteColor)
        
        maleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(tapGender(_:)), for: .touchUpInside)
        
        changePasswordButton.setTitle(MyAccountConstant.changePassword.localized, for: .normal)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonAction(_:)), for: .touchUpInside)
        changePasswordButton.contentHorizontalAlignment = .right
        
        phoneNumberTextField.isUserInteractionEnabled = true
        
        maleButton.setImageTitle(spacing: 10)
        femaleButton.setImageTitle(spacing: 10)
        femaleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        femaleButton.imageView?.contentMode = .scaleAspectFit
        maleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        maleButton.imageView?.contentMode = .scaleAspectFit
        
       
        
        //UIupdate
        DispatchQueue.main.async {
            self.editOuterView.setCornerRadius()
            self.saveButton.setCornerRadius()
            self.profileImage.setCornerRadius()
        }
        
        
        //Disable user interaction
        countryTextField.isUserInteractionEnabled = false
        emailIdTextField.isUserInteractionEnabled = false
        setDarkMode()
    }
    
    
    func setDarkMode(){
        self.profileDetailView.backgroundColor = .boxColor
        self.view.backgroundColor = .backgroundColor
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
    
    //Set custom localization
    private func setCustomLocalization() {
        
        // serviceTextField.placeholder = Com
        
        firstNameTextField.placeholder = Constant.firstName.localized
        lastNameTextField.placeholder = Constant.lastName.localized
        codeTextField.placeholder = Constant.PCode.localized
        codeTextField.fieldShapeType = .Left
        phoneNumberTextField.placeholder = Constant.PPhoneNumber.localized
        phoneNumberTextField.fieldShapeType = .Right
        emailIdTextField.placeholder = Constant.PEmail.localized
        cityTextField.placeholder = Constant.PCity.localized
        countryTextField.placeholder = Constant.PCountry.localized
        genderLabel.text = LoginConstant.gender.localized
        maleButton.setTitle(LoginConstant.male.localized, for: .normal)
        femaleButton.setTitle(LoginConstant.female.localized, for: .normal)
    }
    
    //Set custom color
    private func setCustomColor() {
        changePasswordButton.setTitleColor(.blackColor, for: .normal)
        saveButton.backgroundColor = .appPrimaryColor
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    //Set custom font
    private func setCustomFont() {
        genderLabel.font = .setCustomFont(name: .light, size: .x16)
        firstNameTextField.font = .setCustomFont(name: .light, size: .x16)
        lastNameTextField.font = .setCustomFont(name: .light, size: .x16)
        codeTextField.font = .setCustomFont(name: .light, size: .x16)
        phoneNumberTextField.font = .setCustomFont(name: .light, size: .x16)
        emailIdTextField.font = .setCustomFont(name: .light, size: .x16)
        cityTextField.font = .setCustomFont(name: .light, size: .x16)
        countryTextField.font = .setCustomFont(name: .light, size: .x16)
        
        changePasswordButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        saveButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x20)
    }
    
}

//MARK: - IBAction

extension MyProfileController {
    
    @objc func tapImage(_ sender: UITapGestureRecognizer) {
        if let userData = AppManager.share.getUserDetails() {
            if userData.picture_draft == nil {
                if profileImage.image?.isEqual(to: UIImage(named: Constant.userPlaceholderImage) ?? UIImage()) ?? false {
                    showImage(isRemoveNeed: nil, with:{ [weak self] (image) in
                        self?.profileImage.image = image
                    })
                }else{
                    showImage(isRemoveNeed: Constant.removePhoto.localized, with:{ [weak self] (image) in
                        self?.profileImage.image = image
                    })
                }
            }else{
                let popController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.PopViewController)
                
                // set the presentation style
                popController.modalPresentationStyle = UIModalPresentationStyle.popover
                
                // set up the popover presentation controller
                popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
                popController.popoverPresentationController?.delegate = self
                popController.popoverPresentationController?.sourceView = editOuterView // button
                popController.popoverPresentationController?.sourceRect = editOuterView.bounds
                popController.preferredContentSize = CGSize(width: 200, height: 50)
                
                // present the popover
                self.present(popController, animated: true, completion: nil)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
   
    
    @objc func tapGender(_ sender:UIButton) {
        isMaleFemale = sender.tag == 0
        
    }
    
    private func validation() -> Bool {
        guard !(firstNameTextField.text?.isEmpty)! else {
            firstNameTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty.localized, message: LoginConstant.firstNameEmpty.localized,state: .error)
            return false
        }
        
        guard !(lastNameTextField.text?.isEmpty)! else {
            lastNameTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty.localized, message: LoginConstant.lastNameEmpty.localized,state: .error)
            return false
        }
        
        guard let phoneNumber = phoneNumberTextField.text?.trim(),  !(phoneNumber.isEmpty)  else {
            phoneNumberTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty.localized, message: LoginConstant.mobileNumberEmpty.localized,state: .error)
            return false
        }
        guard phoneNumber.isPhoneNumber else {
            phoneNumberTextField.becomeFirstResponder()
            simpleAlert(view: self, title: String.Empty.localized, message: LoginConstant.mobileNumberValid.localized,state: .error)
            return false
        }
        
        guard !(countryTextField.text?.isEmpty)! else {
            simpleAlert(view: self, title: String.Empty.localized, message: LoginConstant.countryEmpty.localized,state: .error)
            return false
        }
        
        guard !(cityTextField.text?.isEmpty)! else {
            simpleAlert(view: self, title: String.Empty.localized, message: LoginConstant.cityEmpty.localized,state: .error)
            return false
        }
        return true
        
    }
    
    @objc func saveButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        
        if validation() {
            let userData = AppManager.share.getUserDetails()
            let countryCode = "+"+(userData?.country_code ?? "+1")
        
                      
            if userData?.mobile == (self.phoneNumberTextField.text ?? "").trim() && countryCode == (self.codeTextField.text ?? "").trim(){
                editProfileAPI()
            }else{
                let baseDetails = AppConfigurationManager.shared.baseConfigModel
                if baseDetails?.responseData?.appsetting?.send_sms == 1 {
                    let param:Parameters = [
                        Constant.saltkey: APPConstant.saltKeyValue,
                        LoginConstant.PCountryCode: (codeTextField.text ?? "").trim().dropFirst(),
                        LoginConstant.iso2 : self.iso2,
                        LoginConstant.PMobile: phoneNumberTextField.text!.trim()]
                    
                    self.myAccountPresenter?.sendOtp(param: param)
                }else{
                    editProfileAPI()
                    
                }
            }
        }
    }
    
    //Web service call
    private func editProfileAPI() {
        var param : Parameters
        if validation() {
            param = [LoginConstant.PFirstName : firstNameTextField.text!,
                     LoginConstant.PLastName : lastNameTextField.text!,
                     LoginConstant.iso2 : self.iso2,
                     LoginConstant.PCityId : self.selectedCityId]
            if isMobileEdited {
                let countryCode = self.codeTextField.text?.trim()
                param[LoginConstant.PCountryCode] = countryCode?.dropFirst()
                param[LoginConstant.PMobile] = self.phoneNumberTextField.text?.trim()
            }
            if (maleButton.imageView?.image == UIImage(named: LoginConstant.circleImage)) && (femaleButton.imageView?.image == UIImage(named: LoginConstant.circleImage)){
                param[LoginConstant.PGender] = ""
                
            }else{
                param[LoginConstant.PGender] = self.isMaleFemale ? gender.male.rawValue : gender.female.rawValue
            }
            var profileImageData: Data!
            if  let profileData = profileImage.image?.jpegData(compressionQuality: 0.5) {
                profileImageData = profileData
            }
            if profileImage.image?.isEqual(to: UIImage(named: Constant.userPlaceholderImage) ?? UIImage()) ?? false {
                profileImageData  = nil
            }
            if profileImageData != nil {
                myAccountPresenter?.updateProfileDetail(param: param, imageData: [MyAccountConstant.PPicture:profileImageData])
            }else {
                param[LoginConstant.PPicture] = "no_image"
                self.myAccountPresenter?.updateProfileDetail(param: param, imageData: nil)
            }
        }
    }
    
    @objc func changePasswordButtonAction(_ sender: UIButton) {
        
        let changePasswordController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ChangePasswordController) as! ChangePasswordController
        navigationController?.pushViewController(changePasswordController, animated: true)
    }
    private func checkisRTL() -> Bool {
        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.Language) as? String {
            if languageStr == "ar" {
                return true
            }
        }
        return false
    }
}

//MARK: - MyAccountPresenterToMyAccountViewProtocol

extension MyProfileController: MyAccountPresenterToMyAccountViewProtocol {
    
    func viewProfileDetail(profileEntity: ProfileEntity) {
        if let userDetail = profileEntity.responseData {
            AppManager.share.setUserDetails(details: userDetail)
            setProfileDetails(userData: userDetail)
        }
        if isFromUpdate {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            appDelegate.window?.rootViewController = TabBarController().listTabBarController()
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        let otpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.OtpController) as! OtpController
        otpController.delegate = self
        otpController.isprofile = true
        otpController.countryCode = codeTextField.text!
        otpController.phoneNumber = phoneNumberTextField.text!
        otpController.iso2 = self.iso2
        navigationController?.pushViewController(otpController, animated: true)
    }
    
    private func setProfileDetails(userData: ProfileData) {
        firstNameTextField.text = userData.first_name ?? String.Empty
        lastNameTextField.text = userData.last_name ?? String.Empty
        emailIdTextField.text = userData.email ?? String.Empty
        phoneNumberTextField.text = userData.mobile ?? String.Empty
        let countrycode = MyAccountConstant.plus + (userData.country_code ?? String.Empty)
        codeTextField.text = countrycode
        countryTextField.text = userData.country?.country_name ?? String.Empty
        cityTextField.text = userData.city?.city_name ?? String.Empty
        selectedCountryId = userData.country_id ?? 0
        selectedCityId = userData.city?.id ?? 0
        if userData.gender != "" {
            isMaleFemale = userData.gender == gender.male.rawValue
        }else{
            maleButton.setImage(UIImage(named: LoginConstant.circleImage), for: .normal)
            femaleButton.setImage(UIImage(named: LoginConstant.circleImage), for: .normal)
        }
        
        if userData.login_by == MyAccountConstant.loginManual {
            changePasswordButton.isHidden = false
        }else{
            changePasswordButton.isHidden = true
        }
        
        let countryCodeList = AppUtils.shared.getCountries()
        for eachCountry in countryCodeList {
//            if countrycode.replacingOccurrences(of: " ", with: "") == eachCountry.dial_code {
//                countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
//            }
            
                        
            if (userData.iso2 ?? "NP").uppercased() == eachCountry.code.uppercased() {
                            self.countryDetail = Country(name: eachCountry.name, dial_code: eachCountry.dial_code, code: eachCountry.code)
            }
            
            
        }
        if userData.picture_draft != nil {
            editOuterView.backgroundColor = .yellow
            editImageView.image = UIImage(named: MyAccountConstant.ic_question)
//            editImageView.imageTintColor(color1: .black)
        }else {
            editOuterView.backgroundColor = .appPrimaryColor
            editImageView.image = UIImage(named: Constant.edit)
//            editImageView.imageTintColor(color1: .white)
            
        }
        self.profileImage.sd_setImage(with: URL(string:  userData.picture ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.profileImage.image = UIImage(named: Constant.profile)
            } else {
                // Successful in loading image
                self.profileImage.image = image
            }
        })
    }
    
    //Show profile update detail
    func updateProfileDetail(profileEntity: ProfileEntity) {
        
        simpleAlert(view: self, title: String.Empty, message: profileEntity.message ?? MyAccountConstant.updateSuccess.localized,state: .success)
        isFromUpdate = true
        //Webserice call
        //Get user profile detail
        myAccountPresenter?.getProfileDetail()
    }
    
    //Country list
    func updateCountryListSuccess(countryEntity: CountryEntity) {
        
        countryData = countryEntity.countryData ?? []
        if let userData = AppManager.share.getUserDetails() {
            for country in countryEntity.countryData ?? [] {
                if country.id  == userData.country?.id {
                    cityData = country.city ?? []
                }
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension MyProfileController: UITextFieldDelegate {
    
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
        self.view.endEditing(true)
        switch textField {
        case cityTextField:
            guard let stateStr = countryTextField.text, !stateStr.isEmpty else{
                simpleAlert(view: self, title: String.Empty, message: LoginConstant.countryEmpty.localized,state: .error)
                return false
            }
            let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
            countryCodeView.pickerType = .cityList
            countryCodeView.cityListEntity = cityData
            countryCodeView.selectedCity = { [weak self] cityDetail in
                guard let self = self else {
                    return
                }
                self.cityTextField.text = cityDetail.city_name
                self.selectedCityId = cityDetail.id ?? 0
            }
            self.present(countryCodeView, animated: true, completion: nil)
            return false
            
        case codeTextField:
            let countryCodeView = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.CountryCodeViewController) as! CountryCodeViewController
            countryCodeView.pickerType = .countryCode
            countryCodeView.countryCode = { [weak self] countryDetail in
                guard let self = self else {
                    return
                }
                self.isMobileEdited = true
                self.countryDetail = countryDetail
                if self.phoneNumberTextField.text != "" {
                    do {
                        
                        let phoneNumber = try self.phoneNumberKit.parse((self.phoneNumberTextField.text ?? ""), withRegion: countryDetail.code, ignoreType: false)
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
        default:
            break
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed {
            print("done")
            if textField == phoneNumberTextField {
                 do {
              
                     let phoneNumber = try phoneNumberKit.parse((phoneNumberTextField.text ?? ""), withRegion: countryDetail!.code, ignoreType: false)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension MyProfileController: updateOtpDelegate {
    func updateOtp(countryCode: String,mobile: String) {
        isMobileEdited = true
        phoneNumberTextField.text = mobile
        codeTextField.text = countryCode
        editProfileAPI()
    }
}

// MARK: - Protocol
protocol updateOtpDelegate: class {
    func updateOtp(countryCode: String,mobile: String)
}
