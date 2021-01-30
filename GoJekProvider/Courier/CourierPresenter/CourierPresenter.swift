//
//  CourierPresenter.swift
//  GoJekProvider
//
//  Created by Sudar on 03/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation
import Alamofire

//MARK:- CourierViewToCourierPresenterProtocol

class CourierPresenter: CourierViewToCourierPresenterProtocol {
 
    var courierView: CourierPresenterToCourierViewProtocol?
    var courierInterector: CourierPresentorToCourierInterectorProtocol?
    var courierRouter: CourierPresenterToCourierRouterProtocol?
    
    //Post cancel request API
      func cancelRequest(param: Parameters) {
        
          courierInterector?.cancelRequest(param: param)
      }
      
      //Post update request API
      func updateRequest(param: Parameters) {
          courierInterector?.updateRequest(param: param)
      }
      
      //Post Payment request API
      func paymentRequest(param: Parameters) {
          courierInterector?.paymentRequest(param: param)
      }
      
      //Get predefined reasons API
      func getReasons(param: Parameters) {
          courierInterector?.getReasons(param: param)
      }
      
      //Post provider rating API
      func providerRating(param: Parameters) {
          courierInterector?.providerRating(param: param)
      }
      
      func checkRequest(param: Parameters?) {
          courierInterector?.checkRequest(param: param)
      }
 
}

//MARK:- CourierInterectorToCourierPresenterProtocol

extension CourierPresenter: CourierInterectorToCourierPresenterProtocol {
    
    
      func checkRequestResponse(taxiEntity: CourierEntity) {
           courierView?.checkRequestResponse(taxiEntity: taxiEntity)
       }
       
       
       //Cancel request response
       func cancelRequestResponse(taxiEntity: CourierEntity) {
           courierView?.cancelRequestResponse(taxiEntity: taxiEntity)
       }
       
       //Update request response
       func updateRequestResponse(taxiEntity: CourierEntity) {
          courierView?.updateRequestResponse(taxiEntity: taxiEntity)
       }
       
       //Payment request response
       func paymentRequestResponse(taxiEntity: PaidEntity) {
           courierView?.paymentRequestResponse(taxiEntity: taxiEntity)
       }
       
       //Predefined reason response
       func getReasonsResponse(reasonEntity: ReasonEntity) {
           courierView?.getReasonsResponse(reasonEntity: reasonEntity)
       }
       
       //Provider rating response
       func providerRatingResponse(taxiEntity: CourierEntity) {
           courierView?.providerRatingResponse(taxiEntity: taxiEntity)
       }
    
    //Failure response
    func failureResponse(failureData: Data) {
        courierView?.failureResponse(failureData: failureData)
    }
    
}

