//
//  TaxiProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var taxiPresenterObject: TaxiViewToTaxiPresenterProtocol?

//MARK:- Taxi presenter to Taxi viewcontroller
//Backward process
protocol TaxiPresenterToTaxiViewProtocol {
    
    //Cancel request response
    func cancelRequestResponse(taxiEntity: TaxiEntity)
    
    //Airport Queue request response
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity)
    
    //update Request response
    func updateRequestResponse(taxiEntity: TaxiEntity)
    
    //Payment request response
    func paymentRequestResponse(taxiEntity: PaidEntity)
    
    //Predefined reason response
    func getReasonsResponse(reasonEntity: ReasonEntity)
    
    //Provider rating response
    func providerRatingResponse(taxiEntity: TaxiEntity)
    
    //Post provider wating time response
    func providerWaitingTimeResponse(waitTimeEntity: WaitTimeEntity)
    
    func checkRequestResponse(taxiEntity: TaxiEntity)
    
    
}

extension TaxiPresenterToTaxiViewProtocol {
    
    var taxiPresenter: TaxiViewToTaxiPresenterProtocol? {
        get {
            taxiPresenterObject?.taxiView = self
            return taxiPresenterObject
        }
        set(newValue) {
            taxiPresenterObject = newValue
        }
    }
    //Cancel request response
    func cancelRequestResponse(taxiEntity: TaxiEntity) { return }
    
    //update Request response
    func updateRequestResponse(taxiEntity: TaxiEntity) { return }
    
    //Payment request response
    func paymentRequestResponse(taxiEntity: PaidEntity) { return }
    
    //Predefined reason response
    func getReasonsResponse(reasonEntity: ReasonEntity) { return }
    
    //Provider rating response
    func providerRatingResponse(taxiEntity: TaxiEntity) { return }
    
    //Post provider wating time response
    func providerWaitingTimeResponse(waitTimeEntity: WaitTimeEntity) { return }
    
    func checkRequestResponse(taxiEntity: TaxiEntity) { return }
    
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity) { return }

}

//MARK:- Taxi interector to Taxi presenter
//Backward process
protocol TaxiInterectorToTaxiPresenterProtocol {
    
    //Cancel request response
    func cancelRequestResponse(taxiEntity: TaxiEntity)
    
    //Update request response
    func updateRequestResponse(taxiEntity: TaxiEntity)
    
    //Payment request response
    func paymentRequestResponse(taxiEntity: PaidEntity)
    
    //Predefined reason response
    func getReasonsResponse(reasonEntity: ReasonEntity)
    
    //Provider rating response
    func providerRatingResponse(taxiEntity: TaxiEntity)
    
    //Post provider wating time response
    func providerWaitingTimeResponse(waitTimeEntity: WaitTimeEntity)
    
    func checkRequestResponse(taxiEntity: TaxiEntity)
    
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity)
}

//MARK:- Taxi presenter to Taxi interector
//Forward process
protocol TaxiPresentorToTaxiInterectorProtocol {
    
    var taxiPresenter: TaxiInterectorToTaxiPresenterProtocol? {get set}
    
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
    
    //Post provider wating time enable
    func providerWaitingTime(param: Parameters)
    
    func checkRequest(param: Parameters?)
    
    func airportQueueRequest()

}

//MARK:- Taxi view to Taxi presenter
//Forward process
protocol TaxiViewToTaxiPresenterProtocol {
    
    var taxiView: TaxiPresenterToTaxiViewProtocol? {get set}
    var taxiInterector: TaxiPresentorToTaxiInterectorProtocol? {get set}
    var taxiRouter: TaxiPresenterToTaxiRouterProtocol? {get set}
    
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
    
    //Post provider wating time enable
    func providerWaitingTime(param: Parameters)
    
    func checkRequest(param: Parameters?)
    
    func airportQueueRequest()
}

//MARK:- Taxi presenter to Taxi router
//Forward process
protocol TaxiPresenterToTaxiRouterProtocol {
    
    static func createTaxiModule() -> UIViewController
}


