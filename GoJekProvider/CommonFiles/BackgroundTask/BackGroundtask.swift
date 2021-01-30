//
//  BackGroundTask.swift
//  GoJekProvider
//
//  Created by apple on 12/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class BackGroundTask: NSObject {

    static let shared = BackGroundTask()

    func requestToApi<T: Mappable>(type: T.Type,
                                   with requestUrl: String,
                                   urlMethod: HTTPMethod? = HTTPMethod.get,
                                   params: Parameters? = nil,
                                   encode: ParameterEncoding? = URLEncoding.default,
                                   completion: @escaping(_ result: DataResponse<T>?) -> Void) {
        
        
        //Network reachable check
        guard NetworkState.isConnected() else {
            WebServices.shared.showErrorMessage(message: Constant.noNetwork.localized)
            return
        }
        
        var headers: HTTPHeaders = [Constant.RequestType: Constant.RequestValue,
                                    Constant.ContentType: Constant.ContentValue]
        
        if let accessToken = AppManager.share.accessToken {
            headers[Constant.Authorization] = Constant.Bearer + accessToken
        }
        
        print("Request URL: \(requestUrl)")
        print("Parameters: \(params ?? [:]))")
        
        //Alamofire request
        Alamofire.request(requestUrl, method: urlMethod!, parameters: params ?? [:], encoding: encode!, headers: headers).validate().responseObject { (response: DataResponse<T>) in
            
            //Print response
            print("Response: \(response.result.description)")
            
            //Response validate
            switch response.result {
            case .success:
                completion(response)
            case .failure(let error):
                if let urlError = error as? URLError {
                    WebServices.shared.failureError(error: urlError)
                }
                else if let data = response.data {
                    WebServices.shared.showErrorMessage(responseData: data)
                }
                else if let alamoError = error as? AFError {
                    WebServices.shared.failureError(error: alamoError)
                }
                else {
                    WebServices.shared.showErrorMessage(message: response.error.debugDescription)
                }
            }
        }
    }
}

