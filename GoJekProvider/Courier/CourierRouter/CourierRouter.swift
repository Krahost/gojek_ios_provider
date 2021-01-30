//
//  CourierRouter.swift
//  GoJekProvider
//
//  Created by Sudar on 03/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierRouter: CourierPresenterToCourierRouterProtocol {

    static func createCourierModule() -> UIViewController {
        
        var walkThroughController  = courierStoryboard.instantiateViewController(withIdentifier: CourierConstant.CourierHomeController) as! CourierHomeController
        var courierPresenter: CourierViewToCourierPresenterProtocol & CourierInterectorToCourierPresenterProtocol = CourierPresenter()
        var courierInteractor: CourierPresentorToCourierInterectorProtocol = CourierInteractor()
        let courierRouter: CourierPresenterToCourierRouterProtocol = CourierRouter()
        
        walkThroughController.courierPresenter = courierPresenter
        courierPresenter.courierView = walkThroughController
        courierPresenter.courierRouter = courierRouter
        courierPresenter.courierInterector = courierInteractor
        courierInteractor.courierPresenter = courierPresenter
        
        return walkThroughController
    }
    
    static var courierStoryboard: UIStoryboard {
        return UIStoryboard(name:"Courier",bundle: Bundle.main)
    }
}
