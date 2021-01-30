//
//  HomeInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class HomeInteractor: HomePresentorToHomeInterectorProtocol {
    
    var homePresenter: HomeInterectorToHomePresenterProtocol?

    //MARK: - Request
    
    //Check request
    func checkRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: HomeEntity.self, with: URLConstant.KCheckRequest, urlMethod: .get, showLoader: false, params: param, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.homePresenter?.checkRequestSuccess(homeEntity: responseValue)
            }
        })
    }
    
    //Accept Request API
    func acceptRequestDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: HomeEntity.self, with: URLConstant.KAcceptRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.homePresenter?.acceptRequestSuccess(acceptRequestEntity: responseValue)
            }
        })
    }
    
    //Cancel Request API
    func cancelRequestDetail(param: Parameters) {
        WebServices.shared.requestToApi(type: HomeEntity.self, with: URLConstant.KCancelRequest, urlMethod: .post, showLoader: true, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.homePresenter?.cancelRequestSuccess(cancelRequestEntity: responseValue)
            }
        })
    }
    
    //MARK: - Profile
    
    //Get profile detail
    func getProfileDetail() {
        WebServices.shared.requestToApi(type: ProfileEntity.self, with: URLConstant.KProfiledetail, urlMethod: .get, showLoader: true, params: nil, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.homePresenter?.viewProfileDetail(profileEntity: responseValue)
            }
        })
    }
    
    //Update online status
    func updateProviderOnlineStatus(status: String) {
        WebServices.shared.requestToApi(type: ProviderEntity.self, with: URLConstant.KOnlineStatus+status, urlMethod: .get, showLoader: true, params: nil, encode: URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.homePresenter?.providerOnlineStatusResponse(providerEntity: responseValue)
            }
        })
    }
    
    //MARK: - Chat
    func getUserChatHistory(param: Parameters) {
        WebServices.shared.requestToApi(type: ChatEntity.self, with: URLConstant.KUserChat, urlMethod: .get, showLoader: false, params: param, encode: URLEncoding.default) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.homePresenter?.getUserChatHistoryResponse(chatEntity: response)
            }
        }
    }
    //Post update request API
    func airportQueueRequest() {
        WebServices.shared.requestToApi(type: AirportQueueEntity.self, with: URLConstant.KAirportQueueRequest, urlMethod: .post, showLoader: true, params: nil, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
             self.homePresenter?.airportQueueResponse(airportQueueEntity: responseValue)
            }
        })
    }
}
