//
//  OrdersProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var ordersPresenterObject: OrdersViewToOrdersPresenterProtocol?

//MARK:- Orders presenter to view
protocol OrdersPresenterToOrdersViewProtocol {
    
    //Order
    func getOrderHistory(orderHistoryEntity: OrdersEntity)
    func getOrderDetail(orderDetailEntity: OrderDetailEntity)
    func getDisputeList(disputeList: DisputeListEntity)
    
    //Dispute
    func addDispute(disputeEntity: SuccessEntity)
}

extension OrdersPresenterToOrdersViewProtocol {
    
    var ordersPresenter: OrdersViewToOrdersPresenterProtocol? {
        get {
            ordersPresenterObject?.ordersView = self
            return ordersPresenterObject
        }
        set(newValue) {
            ordersPresenterObject = newValue
        }
    }
    
    //Order
    func getOrderHistory(orderHistoryEntity: OrdersEntity) { return }
    func getOrderDetail(orderDetailEntity: OrderDetailEntity) { return }
    func getDisputeList(disputeList: DisputeListEntity) { return }
    
    //Dispute
    func addDispute(disputeEntity: SuccessEntity) { return }
}

//MARK:- Orders interector to presenter
protocol OrdersInterectorToOrdersPresenterProtocol {
    
    //Order
    func getOrderHistory(orderHistoryEntity: OrdersEntity)
    func getOrderDetail(orderDetailEntity: OrderDetailEntity)
    func getDisputeList(disputeList: DisputeListEntity)
    
    //Dispute
    func addDispute(disputeEntity: SuccessEntity)
}

//MARK:- Orders presenter to interector
protocol OrdersPresentorToOrdersInterectorProtocol {
    
    var ordersPresenter: OrdersInterectorToOrdersPresenterProtocol? {get set}
    
    //Order
    func getOrderHistory(isHideLoader: Bool, serviceType: ServiceTypes, parameter: Parameters)
    func getOrderDetail(id: String, type: String)
    func getDisputeList(serviceType:String)
    
    //Dispute
    func addDispute(param: Parameters, type: ServiceTypes)
    
}

//MARK:- Orders view to presenter
protocol OrdersViewToOrdersPresenterProtocol {
    
    var ordersView: OrdersPresenterToOrdersViewProtocol? {get set}
    var ordersInterector: OrdersPresentorToOrdersInterectorProtocol? {get set}
    var ordersRouter: OrdersPresenterToOrdersRouterProtocol? {get set}
    
    //Order
    func getOrderHistory(isHideLoader: Bool, serviceType: ServiceTypes, parameter: Parameters)
    func getOrderDetail(id: String, type: String)
    func getDisputeList(serviceType:String)
    
    //Dispute
    func addDispute(param: Parameters, type: ServiceTypes)
    
}

//MARK:- Orders presenter to router
protocol OrdersPresenterToOrdersRouterProtocol {
    
    static func createOrdersModule() -> UIViewController
}


