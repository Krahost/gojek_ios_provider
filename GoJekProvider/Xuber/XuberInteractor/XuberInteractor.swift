//
//  XuberInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
//MARK:- XuberPresentorToXuberInterectorProtocol

class XuberInteractor: XuberPresentorToXuberInterectorProtocol {
   
    
    
    var xuberPresenter: XuberInterectorToXuberPresenterProtocol?
    
    //Post cancel request API
    func cancelRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: URLConstant.KXuberCancelRequest, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: true, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.cancelRequestResponse(successEntity: responseValue)
            }
        })
    }
    
    //Post accept request API
    func acceptRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: AcceptRequestEntity.self, with: URLConstant.KXuberAcceptRequest, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: true, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.acceptRequestResponse(acceptRequestEntity: responseValue)
            }
        })
    }
    
    
    //Post start service request API
    func startServiceRequest(param: Parameters, imageData: [String : Data]?){
        
        WebServices.shared.requestToImageUpload(type: StartServiceEntity.self, with: URLConstant.KXuberUpdateRequest, uploadData: imageData, showLoader: true, params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.startServiceRequestResponse(startRequestEntity: responseValue)
            }
        }
    }
    
    //Post end service request API
    func endServiceRequest(param: Parameters, imageData: [String : Data]?){
        WebServices.shared.requestToImageUpload(type: EndServiceEntity.self, with: URLConstant.KXuberUpdateRequest, uploadData: imageData, showLoader: true, params: param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.endServiceRequestResponse(endRequestEntity: responseValue)
            }
        }
    }
    
    func arriveRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: StartServiceEntity.self, with: URLConstant.KXuberUpdateRequest, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: true, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.arriveRequestResponse(arriveRequestEntity: responseValue)
            }
        })
    }
    
    //Post Payment request API
    func paymentRequest(param: Parameters){
        WebServices.shared.requestToApi(type: ConfirmPaymentEntity.self, with: URLConstant.KXuberUpdateRequest, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: true, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.paymentRequestResponse(paymentEntity: responseValue)
            }
        })
    }
    
    //Post provider rating API
    func providerRating(param: Parameters){
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: URLConstant.KXuberRateUser, urlMethod: .post, showLoader: true, params: param, accessTokenAdd: true, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.RatingResponse(successEntity: responseValue)
            }
        })
    }
 
    func getReasons(param: Parameters) {
        WebServices.shared.requestToApi(type: ReasonEntity.self, with: URLConstant.KReason, urlMethod: .get, showLoader: true,params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.xuberPresenter?.getReasons(reasonEntity: response)
            }
        }
    }
    func checkRequest(param: Parameters?) {
        
        WebServices.shared.requestToApi(type: XuberCheckRequest.self, with: URLConstant.KXuberCheckRequest, urlMethod: .get, showLoader: false, params: param, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.xuberPresenter?.checkRequestResponse(requestEntity: responseValue)
            }
        })
    }
}
