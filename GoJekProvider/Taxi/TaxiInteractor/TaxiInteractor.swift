//
//  TaxiInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- TaxiPresentorToTaxiInterectorProtocol

class TaxiInteractor: TaxiPresentorToTaxiInterectorProtocol {
    
    var taxiPresenter: TaxiInterectorToTaxiPresenterProtocol?
    
    
    func checkRequest(param: Parameters?) {
        WebServices.shared.requestToApi(type: TaxiEntity.self, with: URLConstant.KTaxiCheckRequest, urlMethod: .get, showLoader: false, params: nil, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.taxiPresenter?.checkRequestResponse(taxiEntity: responseValue)
            }
        })
    }
    
    //Post update request API
    func cancelRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: TaxiEntity.self, with: URLConstant.KCancelTaxiRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.taxiPresenter?.cancelRequestResponse(taxiEntity: responseValue)
            }
        })
    }
    
    //Post update request API
       func airportQueueRequest() {
           WebServices.shared.requestToApi(type: AirportQueueEntity.self, with: URLConstant.KAirportQueueRequest, urlMethod: .post, showLoader: true, params: nil, completion: { [weak self] response in
               guard let self = self else {
                   return
               }
               if let responseValue = response?.value {
                self.taxiPresenter?.airportQueueResponse(airportQueueEntity: responseValue)
               }
           })
       }
    
    
    //Post update request API
    func updateRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: TaxiEntity.self, with: URLConstant.KUpdateTaxiRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.taxiPresenter?.updateRequestResponse(taxiEntity: responseValue)
            }
        })
    }
    
    //Post Payment request API
    func paymentRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: PaidEntity.self, with: URLConstant.KPaymentRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self]  response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.taxiPresenter?.paymentRequestResponse(taxiEntity: responseValue)
            }
        })
    }
    
    //Get predefined reasons API
    func getReasons(param: Parameters) {
        WebServices.shared.requestToApi(type: ReasonEntity.self, with: URLConstant.KGetReasons, urlMethod: .get, showLoader: true, params: param, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.taxiPresenter?.getReasonsResponse(reasonEntity: responseValue)
            }
        })
    }
    
    //Post provider rating API
    func providerRating(param: Parameters) {
        WebServices.shared.requestToApi(type: TaxiEntity.self, with: URLConstant.KProviderRate, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.taxiPresenter?.providerRatingResponse(taxiEntity: responseValue)
               // self.taxiPresenter?.updateRequestResponse(taxiEntity: responseValue)
            }
        })
    }
    
    //Post provider wating time
    func providerWaitingTime(param: Parameters) {
        WebServices.shared.requestToApi(type: WaitTimeEntity.self, with: URLConstant.KWaitingTime, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.taxiPresenter?.providerWaitingTimeResponse(waitTimeEntity: responseValue)
            }
        })
    }
}
