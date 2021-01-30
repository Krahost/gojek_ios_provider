//
//  HomeRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class HomeRouter: HomePresenterToHomeRouterProtocol {
    
    static func createHomeModule() -> UIViewController {
        var homeViewController  = homeStoryboard.instantiateViewController(withIdentifier: HomeConstant.VHomeViewController) as! HomeViewController
        var homePresenter: HomeViewToHomePresenterProtocol & HomeInterectorToHomePresenterProtocol = HomePresenter()
        var homeInteractor: HomePresentorToHomeInterectorProtocol = HomeInteractor()
        let homeRouter: HomePresenterToHomeRouterProtocol = HomeRouter()
        
        homeViewController.homePresenter = homePresenter
        homePresenter.homeView = homeViewController
        homePresenter.homeRouter = homeRouter
        homePresenter.homeInterector = homeInteractor
        homeInteractor.homePresenter = homePresenter
        return homeViewController
    }
    
    static var homeStoryboard: UIStoryboard {
        return UIStoryboard(name:"Home",bundle: Bundle.main)
    }
}
