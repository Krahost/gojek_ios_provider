//
//  XuberProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var xuberPresenterObject: XuberViewToXuberPresenterProtocol?

//MARK:- Xuber presenter to Xuber viewcontroller
//Backward process
protocol XuberPresenterToXuberViewProtocol: class {
    //Cancel request response
    func cancelRequestResponse(successEntity: SuccessEntity)
    
    //Accept request response
    func acceptRequestResponse(acceptRequestEntity: AcceptRequestEntity)
    
    //arrive request response
    func arriveRequestResponse(arriveRequestEntity: StartServiceEntity)
    
    //Start request response
    func startServiceRequestResponse(startRequestEntity: StartServiceEntity)
    
    //End request response
    func endServiceRequestResponse(endRequestEntity: EndServiceEntity)
    
    //Payment request response
    func paymentRequestResponse(paymentEntity: ConfirmPaymentEntity)
    
    //Provider rating response
    func RatingResponse(successEntity: SuccessEntity)
    
    func getReasons(reasonEntity: ReasonEntity)
    func checkRequestResponse(requestEntity:XuberCheckRequest)

}

extension XuberPresenterToXuberViewProtocol {
    var xuberPresenter: XuberViewToXuberPresenterProtocol? {
        get {
            xuberPresenterObject?.xuberView = self
            return xuberPresenterObject
        }
        set(newValue) {
            xuberPresenterObject = newValue
        }
    }
    
    //Cancel request response
    func cancelRequestResponse(successEntity: SuccessEntity) { return }
    
    //Accept request response
    func acceptRequestResponse(acceptRequestEntity: AcceptRequestEntity) { return }
    
    //arrive request response
    func arriveRequestResponse(arriveRequestEntity: StartServiceEntity) { return }
    
    //Start request response
    func startServiceRequestResponse(startRequestEntity: StartServiceEntity) { return }
    
    //End request response
    func endServiceRequestResponse(endRequestEntity: EndServiceEntity) { return }
    
    //Payment request response
    func paymentRequestResponse(paymentEntity: ConfirmPaymentEntity) { return }
    
    //Provider rating response
    func RatingResponse(successEntity: SuccessEntity) { return }
  
    func checkRequestResponse(requestEntity:XuberCheckRequest) { return }

    func getReasons(reasonEntity: ReasonEntity) { return }

}

//MARK:- Xuber interector to Xuber presenter
//Backward process
protocol XuberInterectorToXuberPresenterProtocol {
    //Cancel request response
    func cancelRequestResponse(successEntity: SuccessEntity)
    
    //Accept request response
    func acceptRequestResponse(acceptRequestEntity: AcceptRequestEntity)
    
    //arrive request response
    func arriveRequestResponse(arriveRequestEntity: StartServiceEntity)
    
    //Start request response
    func startServiceRequestResponse(startRequestEntity: StartServiceEntity)
    
    //End request response
    func endServiceRequestResponse(endRequestEntity: EndServiceEntity)
    
    //Payment request response
    func paymentRequestResponse(paymentEntity: ConfirmPaymentEntity)
    
    //Provider rating response
    func RatingResponse(successEntity: SuccessEntity)
    
    func getReasons(reasonEntity: ReasonEntity)
    
    func checkRequestResponse(requestEntity:XuberCheckRequest)

}

//MARK:- Xuber presenter to Xuber interector
//Forward process
protocol XuberPresentorToXuberInterectorProtocol {
    
    var xuberPresenter: XuberInterectorToXuberPresenterProtocol? {get set}
    
    //Post cancel request API
    func cancelRequest(param: Parameters)
    
    //Post accept request API
    func acceptRequest(param: Parameters)
    
    //Post arrive request API
    func arriveRequest(param: Parameters)
    
    //Post start service request API
    func startServiceRequest(param: Parameters, imageData: [String : Data]?)
    
    //Post end service request API
    func endServiceRequest(param: Parameters, imageData: [String : Data]?)
    
    //Post Payment request API
    func paymentRequest(param: Parameters)
    
    //Post provider rating API
    func providerRating(param: Parameters)
    
    func getReasons(param: Parameters)

    func checkRequest(param: Parameters?)
   
   
}

//MARK:- Xuber view to Xuber presenter
//Forward process
protocol XuberViewToXuberPresenterProtocol {
    
    var xuberView: XuberPresenterToXuberViewProtocol? {get set}
    var xuberInterector: XuberPresentorToXuberInterectorProtocol? {get set}
    var xuberRouter: XuberPresenterToXuberRouterProtocol? {get set}
    
    //Post cancel request API
    func cancelRequest(param: Parameters)
    
    //Post accept request API
    func acceptRequest(param: Parameters)
    
    //Post arrive request API
    func arriveRequest(param: Parameters)
    
    //Post start service request API
    func startServiceRequest(param: Parameters, imageData: [String : Data]?)
    
    //Post end service request API
    func endServiceRequest(param: Parameters, imageData: [String : Data]?)
    
    //Post Payment request API
    func paymentRequest(param: Parameters)
    
    //Post provider rating API
    func providerRating(param: Parameters)
    
    func getReasons(param: Parameters)
    
    func checkRequest(param: Parameters?)

    
}

//MARK:- Xuber presenter to Xuber router
//Forward process
protocol XuberPresenterToXuberRouterProtocol {
    
    static func createXuberModule() -> UIViewController
    
}


