//
//  TaxiRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TaxiRouter: TaxiPresenterToTaxiRouterProtocol {
    
    static func createTaxiModule() -> UIViewController {
        var taxiHomeViewController  = taxiStoryboard.instantiateViewController(withIdentifier: TaxiConstant.TaxiHomeViewController) as! TaxiHomeViewController
        var taxiPresenter: TaxiViewToTaxiPresenterProtocol & TaxiInterectorToTaxiPresenterProtocol = TaxiPresenter()
        var taxiInteractor: TaxiPresentorToTaxiInterectorProtocol = TaxiInteractor()
        let taxiRouter: TaxiPresenterToTaxiRouterProtocol = TaxiRouter()
        
        taxiHomeViewController.taxiPresenter = taxiPresenter
        taxiPresenter.taxiView = taxiHomeViewController
        taxiPresenter.taxiRouter = taxiRouter
        taxiPresenter.taxiInterector = taxiInteractor
        taxiInteractor.taxiPresenter = taxiPresenter
        return taxiHomeViewController
    }
    
    static var taxiStoryboard: UIStoryboard {
        return UIStoryboard(name:"Taxi",bundle: Bundle.main)
    }
}

