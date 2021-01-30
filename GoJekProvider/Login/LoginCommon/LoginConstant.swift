//
//  LoginConstant.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum LoginConstant {
    
    //MARK: - String
    static let serviceSelection = "Service Selection"
    static let serviceOngoing = "Service Ongoing"
    static let rateService = "Rate Service"
    static let signIn = "Sign In"
    static let signUp = "Sign Up"
    static let socialLogin =  "Social Login"
    static let connectGoogle = "Connect via Google"
    static let connectFacebook = "Connect via Facebook"
    static let loginVia = "Login Via"
    static let forgotPwdVia = "Forgot Password Via"
    static let forgotPassword = "Forgot Password?"
    static let or = "or"
    static let dontHaveAcc = "Dont't have an account"
    static let createAccount = "Create Account"
    static let alreadyHaveAcc = "Already have an account"
    static let acceptTermsCondition = "I accept the following Terms and conditions"
    static let cannotMakeCallAtThisMoment = "Cannot make call at this moment"
    static let couldnotOpenEmailAttheMoment = "Could not open Email at the moment."
    static let chooseCountryCode = "Choose Country Code"
    static let forgotPasswordTitle = "Forgot Password"
    static let chooseCountry = "Choose Country"
    static let iso2 = "iso2"//used for signin too
    static let chooseState = "Choose State"
    static let chooseCity = "Choose City"
    static let countrySearchError = "No Country Found"
    static let citySearchError = "No City Found"
    static let countryCodeSearchError = "No Country Code Found"
    static let otpTitle = "Enter the OTP received on the registered mobile number"
    static let InvalidOTP = "Enter valid OTP"
    static let otpVerification = "Otp Verification"
    static let verify = "VERIFY"
    static let close = "Close"
    static let completeaccount = "Please take a moment to complete your account"

    static let gender = "Gender"
    static let male = "Male"
    static let female = "Female"
    static let userName = "User Name"
    static let firstName = "First Name"
    static let lastName = "Last Name"
    static let code = "Code"
    static let phoneNumber = "Phone Number"
    static let emailId = "Email Id"
    static let password = "Password"
    static let country = "Country"
    static let city = "City"
    static let state = "State"
    static let expiry = "Expiry Date"
    static let oldPassword = "Old Password"
    static let newPassword = "New Password"
    static let otp = "Otp"
    static let picture = "picture"
    static let referralCode = "Referral(Optional)"
    static let termsAndCondition = "Terms and Conditions"
    static let titleOne = "Service Request"
    static let titleTwo = "Service ongoing"
    static let titleThree = "Rate service"
    static let descriptionOne = "Provide expert services anytime and anywhere as per your convenience."
    static let descriptionTwo = "Help make the world better with your amazing services."
    static let descriptionThree = "Service seekers are always happy to see you assist them."
    static let optional = "(optional)"

    //MARK: - Viewcontroller Identifier
    static let WalkThroughController = "WalkThroughController"
    static let SignInController = "SignInController"
    static let SignUpController = "SignUpController"
    static let ForgotPasswordController = "ForgotPasswordController"
    static let DocumentController = "DocumentController"
    static let OtpChangePasswordController = "OtpChangePasswordController"
    static let SplashController = "SplashViewController"

    static let WalkThroughCell = "WalkThroughCell"
    static let CountryListCell = "CountryListCell"
    static let StateTableViewCell = "StateTableViewCell"
    static let CountryCodeViewController = "CountryCodeViewController"
    static let OtpController = "OtpController"

    //MARK:- Image Names
 
    static let phone = "ic_phone"
    static let mail = "ic_mail"
    static let circleFullImage = "ic_circle_full"
    static let circleImage = "ic_circle"
    static let eye = "ic_eye"
    static let eyeOff = "ic_eye_off"
    static let ic_back = "ic_back"
    static let faceBookImage = "ic_facebook"
    static let googleImage = "ic_google"
    static let editImage = "ic_edit"
    static let icRightArrow = "ic_right_arrow"
    static let searchImage = "search"
    static let imageOne = "Xjek_User_01"
    static let imageTwo = "Xjek_User_02"
    static let imageThre = "Xjek_User_03"

    //MARK: - Alert message
    static let emailIdEmpty = "Please enter your Email Id"
    static let emailIdValid = "Please enter valid Email Id"
    static let passwordEmpty = "Please enter your Password"
    static let oldPasswordEmpty = "Please enter your Old Password"
    static let newPasswordEmpty = "Please enter your New Password"
    static let confirmPasswordEmpty = "Please enter your New Password"

    static let mobileNumberEmpty = "Please enter your Phone Number"
    static let mobileNumberValid = "Please enter Valid Phone Number"
    static let cityEmpty = "Please select your city"
    static let countryEmpty = "Please select your Country"
    static let countryCodeEmpty = "Please select your Country Code"
    static let userNameEmpty = "Please enter your User Name"
    static let passwordlength = "Password Must have Atleast 6 Characters."
    static let firstNameEmpty = "Please enter Firstname"
    static let lastNameEmpty = "Please enter Lastname"
    static let stateEmpty = "Please select your state"
    static let notAcceptTC = "Please accept terms and conditions"
    static let passwordNotSame = "Old password and new password not be same"
    static let passwordMismatch = "New password and confirm password should be same"
    static let passwordChangesMsg = "Your password has been changed. Please login with new password"

    //MARK: - Parameter
    static let PEmail = "email"
    static let PPassword = "password"
    static let PDeviceType = "device_type"
    static let PDeviceToken = "device_token"
    static let PDeviceId = "device_id"
    static let PLoginby = "login_by"
    static let PFirstName = "first_name"
    static let PLastName = "last_name"
    static let PGender = "gender"
    static let PCountryCode = "country_code"
    static let PMobile = "mobile"
    static let PConfirmPassword = "password_confirmation"
    static let PDeviceTypeValue = "IOS"
    static let PManual = "manual"
    static let PCountryId = "country_id"
    static let PStateId = "state_id"
    static let PCityId = "city_id"
    static let Psocialuniqueid = "social_unique_id"
    static let PAccountType = "account_type"
    static let PPicture = "picture"
    static let PReferral_code = "referral_code"
    static let Potp = "otp"

    //when 422 in social login
    static let soicalLoginmessage = "Please signup this account."

}

enum gender: String {
    case male = "MALE"
    case female = "FEMALE"
}
enum loginby: String {
    case manual = "manual"
    case facebook = "FACEBOOK"
    case google = "GOOGLE"
    case apple = "APPLE"

}

enum accountType: String { //Forgot Password
    case email = "email"
    case mobile = "mobile"
}

enum CoreDataEntity: String {
    case userData = "UserData"
    case loginData = "LoginData"
    case location = "XLocation"
}


class StoreLoginData {
    static var shared = StoreLoginData()
    private init() {}
    
    
    var firstName: String?
    var lastName: String?
    var email:String?
    var gender: String?
    var countryCode: String?
    var mobile: String?
    var countryId: Int?
    var cityId: Int?
    var referralCode: String?
    var socialAccessToken: String?
    var loginBy: loginby?
    var profileImageData:[String:Data]?
    var password: String?
    
    func clear() {
        firstName = nil
        lastName = nil
        email = nil
        gender = nil
        countryCode = nil
        mobile = nil
        countryId = nil
        cityId = nil
        referralCode = nil
        socialAccessToken = nil
        loginBy = nil
        profileImageData = nil
        password = nil
        
    }
}
