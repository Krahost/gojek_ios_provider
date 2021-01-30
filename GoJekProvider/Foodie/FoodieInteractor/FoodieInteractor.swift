//
//  FoodieInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK:- FoodiePresentorToFoodieInterectorProtocol

class FoodieInteractor: FoodiePresentorToFoodieInterectorProtocol {
    
    var foodiePresenter: FoodieInterectorToFoodiePresenterProtocol?
    
    func updateRequest(param: Parameters) {
        WebServices.shared.requestToApi(type: FoodieUpdateRequestEntity.self, with: FoodieAPI.updateRequest, urlMethod: .post, showLoader: false, params: param, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getFoodieRequest(foodieEntity: response)
            }
        })
    }
    
    func getRating(param: Parameters) {
        WebServices.shared.requestToApi(type: SuccessEntity.self, with: FoodieAPI.rating, urlMethod: .post, showLoader: true,params: param) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getFoodieRating(successEntity: response)
            }
        }
    }
    
    func getRequest(param: Parameters?) {
        WebServices.shared.requestToApi(type: FoodieCheckRequestEntity.self, with: FoodieAPI.checkRequest, urlMethod: .get, showLoader: false) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let response = response?.value {
                self.foodiePresenter?.getRequest(requestEntity: response)
            }
        }
    }
}
