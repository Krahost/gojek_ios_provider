//
//  FoodiePresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- FoodieViewToFoodiePresenterProtocol

class FoodiePresenter: FoodieViewToFoodiePresenterProtocol {
    
    var foodieView: FoodiePresenterToFoodieViewProtocol?;
    var foodieInterector: FoodiePresentorToFoodieInterectorProtocol?;
    var foodieRouter: FoodiePresenterToFoodieRouterProtocol?
    
    func updateRequest(param: Parameters) {
        foodieInterector?.updateRequest(param: param)
    }
    
    func getRating(param: Parameters) {
        foodieInterector?.getRating(param: param)
    }
    
    func getRequest(param: Parameters?) {
        foodieInterector?.getRequest(param: param)
    }
}

//MARK:- FoodieInterectorToFoodiePresenterProtocol

extension FoodiePresenter: FoodieInterectorToFoodiePresenterProtocol {
    
    func getFoodieRequest(foodieEntity: FoodieUpdateRequestEntity) {
        foodieView?.getFoodieRequest(foodieEntity: foodieEntity)
    }
    
    func getFoodieRating(successEntity: SuccessEntity) {
        foodieView?.getFoodieRating(successEntity: successEntity)
    }
    
    func getRequest(requestEntity: FoodieCheckRequestEntity) {
        foodieView?.getRequest(requestEntity: requestEntity)
    }
}

