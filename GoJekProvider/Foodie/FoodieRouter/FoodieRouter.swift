//
//  FoodieRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieRouter: FoodiePresenterToFoodieRouterProtocol {
    
    static func createFoodieModule() -> UIViewController {
        var foodieLiveTaskController  = foodieStoryboard.instantiateViewController(withIdentifier: FoodieConstant.FoodieLiveTaskController) as! FoodieLiveTaskController
        var foodiePresenter: FoodieViewToFoodiePresenterProtocol & FoodieInterectorToFoodiePresenterProtocol = FoodiePresenter()
        var foodieInteractor: FoodiePresentorToFoodieInterectorProtocol = FoodieInteractor()
        let foodieRouter: FoodiePresenterToFoodieRouterProtocol = FoodieRouter()
        
        foodieLiveTaskController.foodiePresenter = foodiePresenter
        foodiePresenter.foodieView = foodieLiveTaskController
        foodiePresenter.foodieRouter = foodieRouter
        foodiePresenter.foodieInterector = foodieInteractor
        foodieInteractor.foodiePresenter = foodiePresenter
        return foodieLiveTaskController
    }
    
    static var foodieStoryboard: UIStoryboard {
        return UIStoryboard(name:"Foodie",bundle: Bundle.main)
    }
}
