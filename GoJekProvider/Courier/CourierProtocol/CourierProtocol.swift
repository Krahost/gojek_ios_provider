//
//  CourierProtocol.swift
//  GoJekProvider
//
//  Created by Sudar on 03/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import Foundation
import Alamofire

var courierPresenterObject: CourierViewToCourierPresenterProtocol?

///MARK:- Courier presenter to Courier viewcontroller
//Backward process
protocol CourierPresenterToCourierViewProtocol {
    
    //Cancel request response
    func cancelRequestResponse(taxiEntity: CourierEntity)
    
    //Update request response
    func updateRequestResponse(taxiEntity: CourierEntity)
    
    //Payment request response
    func paymentRequestResponse(taxiEntity: PaidEntity)
    
    //Predefined reason response
    func getReasonsResponse(reasonEntity: ReasonEntity)
    
    //Provider rating response
    func providerRatingResponse(taxiEntity: CourierEntity)
    
     func checkRequestResponse(taxiEntity: CourierEntity)
    
    //Failure response
    func failureResponse(failureData: Data)
}

extension CourierPresenterToCourierViewProtocol {
    
    var courierPresenter: CourierViewToCourierPresenterProtocol? {
        get {
            courierPresenterObject?.courierView = self
            return courierPresenterObject
        }
        set(newValue) {
            courierPresenterObject = newValue
        }
    }
    
          //Cancel request response
          func cancelRequestResponse(taxiEntity: CourierEntity){ return }
          
          //Update request response
          func updateRequestResponse(taxiEntity: CourierEntity){ return }
          
          //Payment request response
          func paymentRequestResponse(taxiEntity: PaidEntity){ return }
          
          //Predefined reason response
          func getReasonsResponse(reasonEntity: ReasonEntity){ return }
          
          //Provider rating response
          func providerRatingResponse(taxiEntity: CourierEntity){ return }
          
           func checkRequestResponse(taxiEntity: CourierEntity){ return }

          //Failure response
          func failureResponse(failureData: Data) { return }
}

//MARK:- Courier interector to Courier presenter
//Backward process
protocol CourierInterectorToCourierPresenterProtocol {
    
    
    
      //Cancel request response
       func cancelRequestResponse(taxiEntity: CourierEntity)
       
       //Update request response
       func updateRequestResponse(taxiEntity: CourierEntity)
       
       //Payment request response
       func paymentRequestResponse(taxiEntity: PaidEntity)
       
       //Predefined reason response
       func getReasonsResponse(reasonEntity: ReasonEntity)
       
       //Provider rating response
       func providerRatingResponse(taxiEntity: CourierEntity)
       
        func checkRequestResponse(taxiEntity: CourierEntity)
    
 
    
    //Failure response
    func failureResponse(failureData: Data)
    
}

//MARK:- Courier presenter to Courier interector
//Forward process
protocol CourierPresentorToCourierInterectorProtocol {
    var courierPresenter: CourierInterectorToCourierPresenterProtocol? {get set}
    
    
    //Post cancel request API
       func cancelRequest(param: Parameters)
       
       //Post update request API
       func updateRequest(param: Parameters)
       
       //Post Payment request API
       func paymentRequest(param: Parameters)
       
       //Get predefined reasons API
       func getReasons(param: Parameters)
       
       //Post provider rating API
       func providerRating(param: Parameters)
       
       func checkRequest(param: Parameters?)

}

//MARK:- Courier view to Courier presenter
//Forward process
protocol CourierViewToCourierPresenterProtocol {
    
    var courierView: CourierPresenterToCourierViewProtocol? {get set}
    var courierInterector: CourierPresentorToCourierInterectorProtocol? {get set}
    var courierRouter: CourierPresenterToCourierRouterProtocol? {get set}
    
      //Post cancel request API
       func cancelRequest(param: Parameters)
       
       //Post update request API
       func updateRequest(param: Parameters)
       
       //Post Payment request API
       func paymentRequest(param: Parameters)
       
       //Get predefined reasons API
       func getReasons(param: Parameters)
       
       //Post provider rating API
       func providerRating(param: Parameters)
       
       func checkRequest(param: Parameters?)
    
}

//MARK:- Courier presenter to Courier router
//Forward process
protocol CourierPresenterToCourierRouterProtocol {
    static func createCourierModule() -> UIViewController
}

