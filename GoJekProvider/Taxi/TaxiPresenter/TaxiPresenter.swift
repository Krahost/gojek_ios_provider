//
//  TaxiPresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- TaxiViewToTaxiPresenterProtocol

class TaxiPresenter: TaxiViewToTaxiPresenterProtocol {
   
    
    func airportQueueRequest() {
        taxiInterector?.airportQueueRequest()
    }
    
    
    
    
    var taxiView: TaxiPresenterToTaxiViewProtocol?
    var taxiInterector: TaxiPresentorToTaxiInterectorProtocol?
    var taxiRouter: TaxiPresenterToTaxiRouterProtocol?
    
    //Post cancel request API
    func cancelRequest(param: Parameters) {
        taxiInterector?.cancelRequest(param: param)
    }
    
    //Post update request API
    func updateRequest(param: Parameters) {
        taxiInterector?.updateRequest(param: param)
    }
    
    //Post Payment request API
    func paymentRequest(param: Parameters) {
        taxiInterector?.paymentRequest(param: param)
    }
    
    //Get predefined reasons API
    func getReasons(param: Parameters) {
        taxiInterector?.getReasons(param: param)
    }
    
    //Post provider rating API
    func providerRating(param: Parameters) {
        taxiInterector?.providerRating(param: param)
    }
    
    //Post provider waiting time API
    func providerWaitingTime(param: Parameters) {
        taxiInterector?.providerWaitingTime(param: param)
    }
    
    func checkRequest(param: Parameters?) {
        taxiInterector?.checkRequest(param: param)
    }
  
}
//MARK:- TaxiInterectorToTaxiPresenterProtocol

extension TaxiPresenter: TaxiInterectorToTaxiPresenterProtocol {
    
    
    func checkRequestResponse(taxiEntity: TaxiEntity) {
        taxiView?.checkRequestResponse(taxiEntity: taxiEntity)
    }
    
    
    //Cancel request response
    func cancelRequestResponse(taxiEntity: TaxiEntity) {
        taxiView?.cancelRequestResponse(taxiEntity: taxiEntity)
    }
    
    //Update request response
    func updateRequestResponse(taxiEntity: TaxiEntity) {
       taxiView?.updateRequestResponse(taxiEntity: taxiEntity)
    }
    
    //Payment request response
    func paymentRequestResponse(taxiEntity: PaidEntity) {
        taxiView?.paymentRequestResponse(taxiEntity: taxiEntity)
    }
    
    //Predefined reason response
    func getReasonsResponse(reasonEntity: ReasonEntity) {
        taxiView?.getReasonsResponse(reasonEntity: reasonEntity)
    }
    
    //Provider rating response
    func providerRatingResponse(taxiEntity: TaxiEntity) {
        taxiView?.providerRatingResponse(taxiEntity: taxiEntity)
    }
    
    //Provider waiting time response
    func providerWaitingTimeResponse(waitTimeEntity: WaitTimeEntity) {
        taxiView?.providerWaitingTimeResponse(waitTimeEntity: waitTimeEntity)
    }
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity) {
          taxiView?.airportQueueResponse(airportQueueEntity: airportQueueEntity)
    }
    
}

