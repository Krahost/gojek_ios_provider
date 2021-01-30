//
//  OrdersInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- OrdersPresentorToOrdersInterectorProtocol
//Forward process
class OrdersInteractor: OrdersPresentorToOrdersInterectorProtocol {
    
    var ordersPresenter: OrdersInterectorToOrdersPresenterProtocol?
    
    func getOrderHistory(isHideLoader: Bool,serviceType:ServiceTypes, parameter: Parameters) {
        let url = URLConstant.KOrderHistory+"/"+serviceType.currentType
        WebServices.shared.requestToApi(type: OrdersEntity.self, with: url, urlMethod: .get, showLoader: isHideLoader,params:parameter,accessTokenAdd: true, encode : URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.ordersPresenter?.getOrderHistory(orderHistoryEntity: response)
            }
        }
    }
    
    func getOrderDetail(id: String,type: String) {
        WebServices.shared.requestToApi(type: OrderDetailEntity.self, with: URLConstant.KOrderHistory+"/"+type+"/"+id, urlMethod: .get, showLoader: true, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.ordersPresenter?.getOrderDetail(orderDetailEntity: response)
            }
        }
    }
    
   
    func getDisputeList(serviceType:String) {
        let urlConstant = URLConstant.getDisputeList+serviceType + OrdersConstant.Pdispute

        WebServices.shared.requestToApi(type: DisputeListEntity.self, with: urlConstant, urlMethod: .get, showLoader: true, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.ordersPresenter?.getDisputeList(disputeList: response)
            }
        }
    }
    
    func addDispute(param: Parameters,type:ServiceTypes) {
        
           let urlContant = URLConstant.addDispute+"/"+type.currentType
    
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: urlContant, urlMethod: .post, showLoader: true, params:  param, accessTokenAdd: true) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.ordersPresenter?.addDispute(disputeEntity: response)
            }
        }
    }
}
