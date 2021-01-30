//
//  XuberPresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- XuberViewToXuberPresenterProtocol

class XuberPresenter: XuberViewToXuberPresenterProtocol {
    
    
    
    var xuberView: XuberPresenterToXuberViewProtocol?;
    var xuberInterector: XuberPresentorToXuberInterectorProtocol?;
    var xuberRouter: XuberPresenterToXuberRouterProtocol?
    
    
    
    //Post cancel request API
    func cancelRequest(param: Parameters){
        xuberInterector?.cancelRequest(param: param)
    }
    
    //Post accept request API
    func acceptRequest(param: Parameters){
        xuberInterector?.acceptRequest(param: param)

    }
    
    //Post start service request API
    func startServiceRequest(param: Parameters, imageData: [String : Data]?){
        xuberInterector?.startServiceRequest(param: param, imageData: imageData)

    }
    
    //Post end service request API
    func endServiceRequest(param: Parameters, imageData: [String : Data]?){
        xuberInterector?.endServiceRequest(param: param, imageData: imageData)

    }
    
    func arriveRequest(param: Parameters) {
        xuberInterector?.arriveRequest(param: param)
    }
    
    //Post Payment request API
    func paymentRequest(param: Parameters){
        xuberInterector?.paymentRequest(param: param)

    }
    
    //Post provider rating API
    func providerRating(param: Parameters){
        xuberInterector?.providerRating(param: param)

    }
    
    func getReasons(param: Parameters) {
        xuberInterector?.getReasons(param: param)
        }
    func checkRequest(param: Parameters?) {
        xuberInterector?.checkRequest(param: param)
    }
    
    
}

//MARK:- XuberInterectorToXuberPresenterProtocol

extension XuberPresenter: XuberInterectorToXuberPresenterProtocol {
    func checkRequestResponse(requestEntity: XuberCheckRequest) {
        xuberView?.checkRequestResponse(requestEntity: requestEntity)
    }
    
    //Cancel request response
    func cancelRequestResponse(successEntity: SuccessEntity){
        xuberView?.cancelRequestResponse(successEntity: successEntity)

    }
    
    //Accept request response
    func acceptRequestResponse(acceptRequestEntity: AcceptRequestEntity){
        xuberView?.acceptRequestResponse(acceptRequestEntity: acceptRequestEntity)

    }
    
    //Start request response
    func startServiceRequestResponse(startRequestEntity: StartServiceEntity){
        xuberView?.startServiceRequestResponse(startRequestEntity: startRequestEntity)

    }
    
    //End request response
    func endServiceRequestResponse(endRequestEntity: EndServiceEntity){
        xuberView?.endServiceRequestResponse(endRequestEntity: endRequestEntity)

    }
    
    func arriveRequestResponse(arriveRequestEntity: StartServiceEntity) {
       xuberView?.arriveRequestResponse(arriveRequestEntity: arriveRequestEntity)
    }
    
    //Payment request response
    func paymentRequestResponse(paymentEntity: ConfirmPaymentEntity){
        xuberView?.paymentRequestResponse(paymentEntity: paymentEntity)

    }
    
    //Provider rating response
    func RatingResponse(successEntity: SuccessEntity){
        xuberView?.RatingResponse(successEntity: successEntity)

    }
    
    
    func getReasons(reasonEntity: ReasonEntity) {
        xuberView?.getReasons(reasonEntity: reasonEntity)
    }
    
    
}

