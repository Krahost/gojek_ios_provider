//
//  OrdersRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class OrdersRouter: OrdersPresenterToOrdersRouterProtocol {
    
    static func createOrdersModule() -> UIViewController {
        
        var ordersViewController  = ordersStoryboard.instantiateViewController(withIdentifier: OrdersConstant.VOrdersViewController) as! OrdersController
        var ordersPresenter: OrdersViewToOrdersPresenterProtocol & OrdersInterectorToOrdersPresenterProtocol = OrdersPresenter()
        var ordersInteractor: OrdersPresentorToOrdersInterectorProtocol = OrdersInteractor()
        let ordersRouter: OrdersPresenterToOrdersRouterProtocol = OrdersRouter()
        
        ordersViewController.ordersPresenter = ordersPresenter
        ordersPresenter.ordersView = ordersViewController
        ordersPresenter.ordersRouter = ordersRouter
        ordersPresenter.ordersInterector = ordersInteractor
        ordersInteractor.ordersPresenter = ordersPresenter
        
        return ordersViewController
    }
    
    static var ordersStoryboard: UIStoryboard {
        return UIStoryboard(name:"Orders",bundle: Bundle.main)
    }
}
