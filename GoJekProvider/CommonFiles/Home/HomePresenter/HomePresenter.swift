//
//  HomePresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- HomeViewToHomePresenterProtocol

class HomePresenter: HomeViewToHomePresenterProtocol {
   
    var homeView: HomePresenterToHomeViewProtocol?;
    var homeInterector: HomePresentorToHomeInterectorProtocol?;
    var homeRouter: HomePresenterToHomeRouterProtocol?
    
    //MARK: - Request
    
    func checkRequest(param: Parameters) {
        homeInterector?.checkRequest(param: param)
    }
    
    //Taxi request accept api
    func acceptRequestDetail(param: Parameters) {
        homeInterector?.acceptRequestDetail(param: param)
    }
    
    //Taxi request cancel api
    func cancelRequestDetail(param: Parameters) {
        homeInterector?.cancelRequestDetail(param: param)
    }
    
    //MARK: - Profile
    
    //Get profile detail
    func getProfileDetail() {
        homeInterector?.getProfileDetail()
    }
    
    //Update online status
    func updateProviderOnlineStatus(status: String) {
        homeInterector?.updateProviderOnlineStatus(status: status)
    }
    func airportQueueRequest() {
        homeInterector?.airportQueueRequest()
    }

    
    //MARK: - Chat
    
    //Post Chat
//    func postUserChat(param: Parameters) {
//        homeInterector?.postUserChat(param: param)
//    }
    
    //Get Chat
    func getUserChatHistory(param: Parameters) {
        homeInterector?.getUserChatHistory(param: param)
    }
}


//MARK:- HomeInterectorToHomePresenterProtocol

extension HomePresenter: HomeInterectorToHomePresenterProtocol {
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity) {
        homeView?.airportQueueResponse(airportQueueEntity: airportQueueEntity)
    }
    
    
    //MARK: - Request
    
    func checkRequestSuccess(homeEntity: HomeEntity) {
        homeView?.checkRequestSuccess(homeEntity: homeEntity)
    }

    //Taxi request cancel response
    func cancelRequestSuccess(cancelRequestEntity: HomeEntity) {
        homeView?.cancelRequestSuccess(cancelRequestEntity: cancelRequestEntity)
    }
    
    //Taxi request accept response
    func acceptRequestSuccess(acceptRequestEntity: HomeEntity) {
        homeView?.acceptRequestSuccess(acceptRequestEntity: acceptRequestEntity)
    }
    
    //MARK: - Profile
    
    //Profile detail response
    func viewProfileDetail(profileEntity: ProfileEntity) {
        homeView?.viewProfileDetail(profileEntity: profileEntity)
    }
    
    //Update online status
    func providerOnlineStatusResponse(providerEntity: ProviderEntity) {
        homeView?.providerOnlineStatusResponse(providerEntity: providerEntity)
    }
    
    //MARK: - Chat

    //Get Chat
    func getUserChatHistoryResponse(chatEntity: ChatEntity) {
        homeView?.getUserChatHistoryResponse(chatEntity: chatEntity)
    }
    
}

