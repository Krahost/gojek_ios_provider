//
//  OrdersPresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- OrdersViewToOrdersPresenterProtocol

class OrdersPresenter: OrdersViewToOrdersPresenterProtocol {
    func getOrderHistory(isHideLoader: Bool,serviceType:ServiceTypes, parameter: Parameters) {
        ordersInterector?.getOrderHistory(isHideLoader: isHideLoader,serviceType:serviceType, parameter: parameter)
    }
    
    func getOrderDetail(id: String, type: String) {
        ordersInterector?.getOrderDetail(id: id, type: type)
    }
    func getDisputeList(serviceType:String) {
        ordersInterector?.getDisputeList(serviceType:serviceType)
    }
    func addDispute(param: Parameters,type:ServiceTypes) {
        ordersInterector?.addDispute(param: param,type:type)
    }
    
    var ordersView: OrdersPresenterToOrdersViewProtocol?
    var ordersInterector: OrdersPresentorToOrdersInterectorProtocol?
    var ordersRouter: OrdersPresenterToOrdersRouterProtocol?
    
}

//MARK:- OrdersInterectorToOrdersPresenterProtocol

extension OrdersPresenter: OrdersInterectorToOrdersPresenterProtocol {
    func getOrderDetail(orderDetailEntity: OrderDetailEntity) {
        ordersView?.getOrderDetail(orderDetailEntity: orderDetailEntity)
    }
    func getOrderHistory(orderHistoryEntity: OrdersEntity){
        ordersView?.getOrderHistory(orderHistoryEntity: orderHistoryEntity)

    }
    func getDisputeList(disputeList: DisputeListEntity) {
        ordersView?.getDisputeList(disputeList: disputeList)
    }
    
    func addDispute(disputeEntity: SuccessEntity) {
        ordersView?.addDispute(disputeEntity: disputeEntity)
    }
    
}

