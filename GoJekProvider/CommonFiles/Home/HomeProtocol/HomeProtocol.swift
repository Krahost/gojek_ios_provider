//
//  HomeProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var homePresenterObject: HomeViewToHomePresenterProtocol?
//typealias LocationTuple = (latitude: Double, longitude: Double)

//MARK:- Taxi presenter to Taxi viewco
//Backward process
protocol HomePresenterToHomeViewProtocol {
    
    //Request
    func acceptRequestSuccess(acceptRequestEntity: HomeEntity)
    func cancelRequestSuccess(cancelRequestEntity: HomeEntity)
    func checkRequestSuccess(homeEntity:HomeEntity)

    //Profile
    func viewProfileDetail(profileEntity: ProfileEntity)
    func providerOnlineStatusResponse(providerEntity: ProviderEntity)
    
    //Chat Request
    func getUserChatHistoryResponse(chatEntity: ChatEntity)
    
    //Airport Queue request response
     func airportQueueResponse(airportQueueEntity: AirportQueueEntity)
}

extension HomePresenterToHomeViewProtocol {
    
    var homePresenter: HomeViewToHomePresenterProtocol? {
        get {
            homePresenterObject?.homeView = self
            return homePresenterObject
        }
        set(newValue) {
            homePresenterObject = newValue
        }
    }
    
    //Request
    func acceptRequestSuccess(acceptRequestEntity: HomeEntity) { return }
    func cancelRequestSuccess(cancelRequestEntity: HomeEntity) { return }
    func checkRequestSuccess(homeEntity: HomeEntity) { return }
    
    //Profile
    func viewProfileDetail(profileEntity: ProfileEntity) { return }
    func providerOnlineStatusResponse(providerEntity: ProviderEntity) { return }

    //Chat Request
    func getUserChatHistoryResponse(chatEntity: ChatEntity) { return }
    
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity) { return }

}

//MARK:- Taxi interector to Taxi presenter
//Backward process
protocol HomeInterectorToHomePresenterProtocol {
    
    //Request
    func acceptRequestSuccess(acceptRequestEntity: HomeEntity)
    func cancelRequestSuccess(cancelRequestEntity: HomeEntity)
    func checkRequestSuccess(homeEntity: HomeEntity)

    //Profile
    func viewProfileDetail(profileEntity: ProfileEntity)
    func providerOnlineStatusResponse(providerEntity: ProviderEntity)

    //Chat Request
    func getUserChatHistoryResponse(chatEntity: ChatEntity)
    
    func airportQueueResponse(airportQueueEntity: AirportQueueEntity)

}

//MARK:- Taxi presenter to Taxi interector
//Forward process
protocol HomePresentorToHomeInterectorProtocol {
    
    var homePresenter: HomeInterectorToHomePresenterProtocol? {get set}
    
    //Request
    func acceptRequestDetail(param: Parameters)
    func cancelRequestDetail(param: Parameters)
    func checkRequest(param: Parameters)
    
    //Profile
    func getProfileDetail()
    func updateProviderOnlineStatus(status: String)
  
    //Chat
    func getUserChatHistory(param: Parameters)
    
    func airportQueueRequest()


}

//MARK:- Taxi view to Taxi presenter
//Forward process
protocol HomeViewToHomePresenterProtocol {
    
    var homeView: HomePresenterToHomeViewProtocol? {get set}
    var homeInterector: HomePresentorToHomeInterectorProtocol? {get set}
    var homeRouter: HomePresenterToHomeRouterProtocol? {get set}
    
    //Request
    func acceptRequestDetail(param: Parameters)
    func cancelRequestDetail(param: Parameters)
    func checkRequest(param: Parameters)
    
    //Profile
    func getProfileDetail()
    func updateProviderOnlineStatus(status: String)
    
    //Chat
    func getUserChatHistory(param: Parameters)
    
    func airportQueueRequest()

}

//MARK:- Taxi presenter to Taxi router
//Forward process
protocol HomePresenterToHomeRouterProtocol {

    static func createHomeModule() -> UIViewController
}

