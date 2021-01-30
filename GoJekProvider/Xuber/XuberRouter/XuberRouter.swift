//
//  XuberRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberRouter: XuberPresenterToXuberRouterProtocol {
    
    static func createXuberModule() -> UIViewController {
        
        let xuberHomeViewController  = XuberStoryboard.instantiateViewController(withIdentifier: XuberConstant.xuberHomeViewController) as! XuberHomeViewController
        var xuberPresenter: XuberViewToXuberPresenterProtocol & XuberInterectorToXuberPresenterProtocol = XuberPresenter()
        var xuberInteractor: XuberPresentorToXuberInterectorProtocol = XuberInteractor()
        let xuberRouter: XuberPresenterToXuberRouterProtocol = XuberRouter()
        
        xuberHomeViewController.xuberPresenter = xuberPresenter
        xuberPresenter.xuberView = xuberHomeViewController
        xuberPresenter.xuberRouter = xuberRouter
        xuberPresenter.xuberInterector = xuberInteractor
        xuberInteractor.xuberPresenter = xuberPresenter
        return xuberHomeViewController
    }
    
    static var XuberStoryboard: UIStoryboard {
        return UIStoryboard(name:"Xuber",bundle: Bundle.main)
    }
}

