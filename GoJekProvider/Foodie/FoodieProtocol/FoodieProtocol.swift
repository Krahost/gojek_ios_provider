//
//  FoodieProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

 var foodiePresenterObject: FoodieViewToFoodiePresenterProtocol?

//MARK:- Foodie presenter to foodie viewcontroller
//Backward process
protocol FoodiePresenterToFoodieViewProtocol {
    func getFoodieRequest(foodieEntity:FoodieUpdateRequestEntity)
    func getFoodieRating(successEntity: SuccessEntity)
    func getRequest(requestEntity:FoodieCheckRequestEntity)
}

extension FoodiePresenterToFoodieViewProtocol {
    
    var foodiePresenter: FoodieViewToFoodiePresenterProtocol? {
        get {
            foodiePresenterObject?.foodieView = self
            return foodiePresenterObject
        }
        set(newValue) {
            foodiePresenterObject = newValue
        }
    }
    
    func getFoodieRequest(foodieEntity:FoodieUpdateRequestEntity) { return }
    func getFoodieRating(successEntity: SuccessEntity) { return }
    func getRequest(requestEntity:FoodieCheckRequestEntity) {return}
}

//MARK:- Foodie interector to foodie presenter
//Backward process
protocol FoodieInterectorToFoodiePresenterProtocol {
    
    func getFoodieRequest(foodieEntity:FoodieUpdateRequestEntity)
    func getFoodieRating(successEntity: SuccessEntity)
    func getRequest(requestEntity:FoodieCheckRequestEntity)
}

//MARK:- Foodie presenter to foodie interector
//Forward process
protocol FoodiePresentorToFoodieInterectorProtocol {
    
    var foodiePresenter: FoodieInterectorToFoodiePresenterProtocol? {get set}
    
    func updateRequest(param: Parameters)
    func getRating(param: Parameters)
    func getRequest(param:  Parameters?)
}

//MARK:- Foodie view to foodie presenter
//Forward process
protocol FoodieViewToFoodiePresenterProtocol {
    
    var foodieView: FoodiePresenterToFoodieViewProtocol? {get set}
    var foodieInterector: FoodiePresentorToFoodieInterectorProtocol? {get set}
    var foodieRouter: FoodiePresenterToFoodieRouterProtocol? {get set}
    
    func updateRequest(param: Parameters)
    func getRating(param: Parameters)
    func getRequest(param:  Parameters?)
}

//MARK:- Foodie presenter to foodie router
//Forward process
protocol FoodiePresenterToFoodieRouterProtocol {

    static func createFoodieModule() -> UIViewController
}

