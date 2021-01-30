//
//  LoginProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var loginPresenterObject: LoginViewToLoginPresenterProtocol?

///MARK:- Login presenter to Login viewcontroller
//Backward process
protocol LoginPresenterToLoginViewProtocol {
    
    //get base url
    func getBaseURLResponse(baseEntity: BaseEntity)
    
    func updateLoginSuccess(loginEntity: LoginEntity)
    func updateSignUpSuccess(signUpEntity: LoginEntity)
    func updateCountryListSuccess(countryEntity: CountryEntity)
//    func updateGetDocumentSuccess(documentEntity: GetDocumentEntity)
//    func updateAddDocumentSuccess(documentEntity: GetDocumentEntity)
    func updateSocialLoginSuccess(socialEntity: LoginEntity)
    func updateForgotPasswordSuccess(forgotPasswordEntity: ForgotPasswordEntity)
    func verifySuccess(verifyEntity:LoginEntity)
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity)
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity)
    //Failure response
    func failureResponse(failureData: Data)
}

extension LoginPresenterToLoginViewProtocol {
    
    var loginPresenter: LoginViewToLoginPresenterProtocol? {
        get {
            loginPresenterObject?.loginView = self
            return loginPresenterObject
        }
        set(newValue) {
            loginPresenterObject = newValue
        }
    }
    
    //get base url
    func getBaseURLResponse(baseEntity: BaseEntity) { return }
    
    func updateLoginSuccess(loginEntity: LoginEntity) { return }
    func updateSignUpSuccess(signUpEntity: LoginEntity) { return }
    func updateCountryListSuccess(countryEntity: CountryEntity) { return }
//    func updateGetDocumentSuccess(documentEntity: GetDocumentEntity) { return }
//    func updateAddDocumentSuccess(documentEntity: GetDocumentEntity) { return }
    func updateSocialLoginSuccess(socialEntity: LoginEntity) { return }
    func updateForgotPasswordSuccess(forgotPasswordEntity: ForgotPasswordEntity) { return }
    func verifySuccess(verifyEntity:LoginEntity) { return }
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity) { return }
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity) { return }
    //Failure response
    func failureResponse(failureData: Data) { return }
}

//MARK:- Login interector to Login presenter
//Backward process
protocol LoginInterectorToLoginPresenterProtocol {
    
    //get base url
    func getBaseURLResponse(baseEntity: BaseEntity)
    
    func updateLoginSuccess(loginEntity: LoginEntity)
    func updateSignUpSuccess(signUpEntity: LoginEntity)
    func updateCountryListSuccess(countryEntity: CountryEntity)
    func updateSocialLoginSuccess(socialEntity: LoginEntity)
    func updateForgotPasswordSuccess(forgotPasswordEntity: ForgotPasswordEntity)
    func verifySuccess(verifyEntity:LoginEntity)
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity)
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity)
    //Failure response
    func failureResponse(failureData: Data)
    
}

//MARK:- Login presenter to Login interector
//Forward process
protocol LoginPresentorToLoginInterectorProtocol {
    var loginPresenter: LoginInterectorToLoginPresenterProtocol? {get set}
    
    //Base
    func getBaseURL(param: Parameters)
    
    func loginWithUserDetail(param: Parameters)
    func signUpWithUserDetail(param: Parameters, imageData: [String : Data]?)
    func countryListDetail(param: Parameters)
    func socialLoginWithUserDetail(param: Parameters)
    func forgotPasswordDetail(param: Parameters)
    func verifyMobileAndEmail(param: Parameters)
    func sendOtp(param: Parameters)
    func verifyOtp(param: Parameters)
}

//MARK:- Login view to Login presenter
//Forward process
protocol LoginViewToLoginPresenterProtocol {
    
    var loginView: LoginPresenterToLoginViewProtocol? {get set}
    var loginInterector: LoginPresentorToLoginInterectorProtocol? {get set}
    var loginRouter: LoginPresenterToLoginRouterProtocol? {get set}
    
    //Base
    func getBaseURL(param: Parameters)
    
    func loginWithUserDetail(param: Parameters)
    func signUpWithUserDetail(param: Parameters, imageData: [String : Data]?)
    func countryListDetail(param: Parameters)
    func forgotPasswordDetail(param: Parameters)
    func socialLoginWithUserDetail(param: Parameters)
    func verifyMobileAndEmail(param: Parameters)
    func sendOtp(param: Parameters)
    func verifyOtp(param: Parameters)
    
}

//MARK:- Login presenter to Login router
//Forward process
protocol LoginPresenterToLoginRouterProtocol {
    static func createLoginModule() -> UIViewController
}


