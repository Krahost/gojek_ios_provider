//
//  LoginInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- LoginPresentorToLoginInterectorProtocol
//Forward process
class LoginInteractor: LoginPresentorToLoginInterectorProtocol {
  
    var loginPresenter: LoginInterectorToLoginPresenterProtocol?
    
    //Login With user detail
    func loginWithUserDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: LoginEntity.self, with: URLConstant.KLogin, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: false, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let reponseValue = response?.value {
                self.loginPresenter?.updateLoginSuccess(loginEntity: reponseValue)
            }
        })
    }
    
    //Base URL
    func getBaseURL(param: Parameters) {        
        WebServices.shared.requestToApi(type: BaseEntity.self, with:  APPConstant.baseUrl, urlMethod: .post, showLoader: false,params: param, accessTokenAdd: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.loginPresenter?.getBaseURLResponse(baseEntity: response)
            }
        }
    }
    
    //SignUp With user detail
    func signUpWithUserDetail(param: Parameters, imageData: [String : Data]?) {
        WebServices.shared.requestToImageUpload(type: LoginEntity.self, with: URLConstant.KSignUp, uploadData: imageData, showLoader: true, params: param, accessTokenAdd: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.loginPresenter?.updateSignUpSuccess(signUpEntity: responseValue)
            }
        }
        
    }
    
    //Country List
    func countryListDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: CountryEntity.self, with: URLConstant.KCountry, urlMethod: .post, showLoader: false, params: param, accessTokenAdd: false, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.loginPresenter?.updateCountryListSuccess(countryEntity: responseValue)
            }
        })
    }
   
    // Forgot Password
    func forgotPasswordDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: ForgotPasswordEntity.self, with: URLConstant.KForgotPassword, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: false, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.loginPresenter?.updateForgotPasswordSuccess(forgotPasswordEntity: responseValue)
            }
        })
    }
 
    func socialLoginWithUserDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: LoginEntity.self, with: URLConstant.KSocialLogin, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: false, failureReturen: true, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.loginPresenter?.updateSocialLoginSuccess(socialEntity: responseValue)
            }
            else {
                self.loginPresenter?.failureResponse(failureData: (response?.data)!)
            }
        })
    }
    
    func verifyMobileAndEmail(param: Parameters) {
        WebServices.shared.requestToApi(type: LoginEntity.self, with: URLConstant.verify, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.verifySuccess(verifyEntity: response)
            }
        }
    }
    func sendOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: sendOtpEntity.self, with: URLConstant.sendOtp, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.sendOtpSuccess(sendOtpEntity: response)
            }
        }
    }
    
    func verifyOtp(param: Parameters) {
        
        WebServices.shared.requestToApi(type: VerifyOtpEntity.self, with: URLConstant.verifyOtp, urlMethod: .post,showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value  {
                self.loginPresenter?.verifyOtpSuccess(verifyOtpEntity: response)
            }
        }
    }
}
