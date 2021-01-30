//
//  CourierInteractor.swift
//  GoJekProvider
//
//  Created by Sudar on 03/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation
import Alamofire

//MARK:- CourierPresentorToCourierInterectorProtocol

//Forward process
class CourierInteractor: CourierPresentorToCourierInterectorProtocol {

  
    var courierPresenter: CourierInterectorToCourierPresenterProtocol?
    
    
    func checkRequest(param: Parameters?) {
           WebServices.shared.requestToApi(type: CourierEntity.self, with: URLConstant.KCourierCheckRequest, urlMethod: .get, showLoader: false, params: nil, encode: URLEncoding.default, completion: { [weak self] response in
               guard let self = self else {
                   return
               }
               if let responseValue = response?.value {
                
                
                
                   self.courierPresenter?.checkRequestResponse(taxiEntity: responseValue)
               }
           })
       }
       
       //Post update request API
       func cancelRequest(param: Parameters) {
           WebServices.shared.requestToApi(type: CourierEntity.self, with: URLConstant.KCancelTaxiRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
               guard let self = self else {
                   return
               }
               if let responseValue = response?.value {
                   self.courierPresenter?.cancelRequestResponse(taxiEntity: responseValue)
               }
           })
       }
       
       
       //Post update request API
       func updateRequest(param: Parameters) {
           WebServices.shared.requestToApi(type: CourierEntity.self, with: URLConstant.KUpdateCourierRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
               guard let self = self else {
                   return
               }
               if let responseValue = response?.value {
                   self.courierPresenter?.updateRequestResponse(taxiEntity: responseValue)
               }
           })
       }
       
       //Post Payment request API
       func paymentRequest(param: Parameters) {
           WebServices.shared.requestToApi(type: PaidEntity.self, with: URLConstant.KCourierPaymentRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self]  response in
               guard let self = self else {
                   return
               }
               if let responseValue = response?.value {
                   self.courierPresenter?.paymentRequestResponse(taxiEntity: responseValue)
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
                   self.courierPresenter?.getReasonsResponse(reasonEntity: responseValue)
               }
           })
       }
       
       //Post provider rating API
       func providerRating(param: Parameters) {
           WebServices.shared.requestToApi(type: CourierEntity.self, with: URLConstant.KCourierProviderRate, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
               guard let self = self else {
                   return
               }
               if let responseValue = response?.value {
                   self.courierPresenter?.providerRatingResponse(taxiEntity: responseValue)
                  // self.taxiPresenter?.updateRequestResponse(taxiEntity: responseValue)
               }
           })
       }
}
