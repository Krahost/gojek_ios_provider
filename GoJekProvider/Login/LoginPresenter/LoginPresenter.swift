//
//  LoginPresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- LoginViewToLoginPresenterProtocol

class LoginPresenter: LoginViewToLoginPresenterProtocol {
 
    var loginView: LoginPresenterToLoginViewProtocol?
    var loginInterector: LoginPresentorToLoginInterectorProtocol?
    var loginRouter: LoginPresenterToLoginRouterProtocol?
    
    func loginWithUserDetail(param: Parameters) {
        loginInterector?.loginWithUserDetail(param: param)
    }
    
    func countryListDetail(param: Parameters) {
        loginInterector?.countryListDetail(param: param)
    }
    
    func signUpWithUserDetail(param: Parameters, imageData: [String : Data]?) {
        loginInterector?.signUpWithUserDetail(param: param, imageData: imageData)
    }
    func forgotPasswordDetail(param: Parameters) {
        loginInterector?.forgotPasswordDetail(param: param)
    }
    
    func socialLoginWithUserDetail(param: Parameters) {
        loginInterector?.socialLoginWithUserDetail(param: param)
    }

    func getBaseURL(param: Parameters) {
        loginInterector?.getBaseURL(param: param)
    }
    func verifyMobileAndEmail(param: Parameters) {
        loginInterector?.verifyMobileAndEmail(param: param)
    }
    func sendOtp(param: Parameters){
        loginInterector?.sendOtp(param: param)
    }
    func verifyOtp(param: Parameters){
        loginInterector?.verifyOtp(param: param)
    }
}

//MARK:- LoginInterectorToLoginPresenterProtocol

extension LoginPresenter: LoginInterectorToLoginPresenterProtocol {
    
    func sendOtpSuccess(sendOtpEntity: sendOtpEntity) {
        loginView?.sendOtpSuccess(sendOtpEntity: sendOtpEntity)
    }
    
    func verifyOtpSuccess(verifyOtpEntity: VerifyOtpEntity) {
        loginView?.verifyOtpSuccess(verifyOtpEntity: verifyOtpEntity)
    }
    func verifySuccess(verifyEntity: LoginEntity) {
        loginView?.verifySuccess(verifyEntity: verifyEntity)
    }
    func updateForgotPasswordSuccess(forgotPasswordEntity: ForgotPasswordEntity) {
        loginView?.updateForgotPasswordSuccess(forgotPasswordEntity: forgotPasswordEntity)
    }
    
    func updateSocialLoginSuccess(socialEntity: LoginEntity) {
        loginView?.updateSocialLoginSuccess(socialEntity: socialEntity)
    }
    
    func getBaseURLResponse(baseEntity: BaseEntity) {
        loginView?.getBaseURLResponse(baseEntity: baseEntity)
    }
    
    func updateSignUpSuccess(signUpEntity: LoginEntity) {
        loginView?.updateSignUpSuccess(signUpEntity: signUpEntity)
    }
    
    func updateCountryListSuccess(countryEntity: CountryEntity) {
        loginView?.updateCountryListSuccess(countryEntity: countryEntity)
    }
    
    func updateLoginSuccess(loginEntity: LoginEntity) {
        loginView?.updateLoginSuccess(loginEntity: loginEntity)
    }
    
    //Failure response
    func failureResponse(failureData: Data) {
        loginView?.failureResponse(failureData: failureData)
    }
    
}

