//
//  WebServices.swift
//  GoJekProvider
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class WebServices: UIViewController {
    
    static let shared = WebServices()
    
    /**
     Call Webservice with single model
     
     - Parameter type:                   Mappable model for this API Call
     - parameter endPointURL:            EndPoint URL for this API. Default: empty string.
     - parameter urlMethod:              Http method type.
     - parameter showLoader:             Loader show and hide.
     - parameter Params:                 Parameters for this API. Default: nil
     - parameter accessTokenAdd:         Add access token for this Api.  Default: true
     - parameter failureReturen:         Failure returen to view for this Api.  Default: false
     - Completion:                       Return model response to the handler
     */
    
    func requestToApi<T: Mappable>(type: T.Type,
                                   with endPointURL: String,
                                   urlMethod: HTTPMethod!,
                                   showLoader: Bool,
                                   params: Parameters? = nil,
                                   accessTokenAdd: Bool? = true,
                                   failureReturen: Bool? = false,
                                   encode: ParameterEncoding? = JSONEncoding.default,
                                   completion: @escaping(_ result: DataResponse<T, AFError>?) -> Void) {
        
        
        //Network reachable check
        guard NetworkState.isConnected() else {
            self.showErrorMessage(message: Constant.noNetwork.localized)
            return
        }
        
        //Activity Indicator Animation start
        if showLoader {
            LoadingIndicator.show()
        }
        
        //Form base url & add header
        var baseUrl = AppConfigurationManager.shared.getBaseUrl()
        if baseUrl == String.Empty {
            baseUrl = APPConstant.baseUrl
        }
        
        //Form base url & add header (if both same )
        var url = String.Empty
        if baseUrl == endPointURL {
            url = baseUrl
        }
        else {
            url = baseUrl + endPointURL
        }
        var headers: HTTPHeaders = [Constant.RequestType: Constant.RequestValue,
                                    Constant.ContentType: Constant.ContentValue]
        if accessTokenAdd == true {
            if let accessToken = AppManager.share.accessToken{
                headers[Constant.Authorization] = Constant.Bearer + accessToken
            }
        }
        
        print("Request URL: \(url)")
        print("Parameters: \(params ?? [:]))")
        
        //Alamofire request
        
        AF.request(url, method: urlMethod!, parameters: params, encoding: encode!, headers: headers).validate().responseObject { (response: DataResponse<T, AFError>) in
            
            //Activity Indicator Animation stop
            LoadingIndicator.hide()
            
            //Response validate
            switch response.result {
                case .success:
                    completion(response)
                case .failure:
                    print("error:--->",response.error as Any)
                    if failureReturen! {
                        completion(response)
                    }else if let data = response.data {
                        self.showErrorMessage(responseData: data)
                    }else {
                       // self.showErrorMessage(message: response.error.debugDescription)
                }
            }
        }
    }
    
    /**
     Call Webservice with Multipart FormData
     
     - Parameter type:                   Mappable model for this API Call
     - parameter endPointURL:            EndPoint URL for this API. Default: empty string.
     - parameter imageData:              Single iamge data.
     - parameter showLoader:             Loader show and hide.
     - parameter Params:                 Parameters for this API. Default: nil
     - parameter accessTokenAdd:         Add access token for this Api.  Default: true
     - parameter failureReturen:         Failure returen to view for this Api.  Default: false
     - Completion:                       Return model response to the handler
     */
    
    func requestToImageUpload<T: Mappable>(type: T.Type,
                                           with endPointURL: String,
                                           uploadData: [String: Data]? = nil,
                                           isTypePDF: Bool? = false,
                                           showLoader: Bool,
                                           params: Parameters? = nil,
                                           accessTokenAdd: Bool? = true,
                                           failureReturen: Bool? = false,
                                           encode: ParameterEncoding? = JSONEncoding.default,
                                           completion: @escaping(_ result: DataResponse<T, AFError>?) -> Void) {
        
        //Network reachable check
        guard NetworkState.isConnected() else {
            self.showErrorMessage(message: Constant.noNetwork.localized)
            return
        }
        
        //Activity Indicator Animation start
        if showLoader {
            LoadingIndicator.show()
        }
        
        //Form base url & add header
        var baseUrl = AppConfigurationManager.shared.getBaseUrl()
        if baseUrl == String.Empty {
            baseUrl = APPConstant.baseUrl
        }
        
        //Form base url & add header (if both same )
        var url = String.Empty
        if baseUrl == endPointURL {
            url = baseUrl
        }
        else {
            url = baseUrl + endPointURL
        }
        
        var headers: HTTPHeaders = [Constant.RequestType: Constant.RequestValue,
                                    Constant.ContentType: Constant.MultiPartValue]
        
        if accessTokenAdd == true {
            if let accessToken = AppManager.share.accessToken{
                headers[Constant.Authorization] = Constant.Bearer + accessToken
            }
        }
        
        print("Request URL: \(url)")
        print("Parameters: \(params ?? [:])")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            //Param Mapping
            for (key, value) in params ?? [:] {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            //File Name
            let uniqueString: String = ProcessInfo.processInfo.globallyUniqueString
            
            //Data Mapping
            if let dataArray = uploadData {
                for array in dataArray {
                    let mimeTypeVal = isTypePDF == true ? "application/pdf" : "image/png"
                    let fileType = isTypePDF == true ? ".pdf" : ".png"
                    multipartFormData.append(array.value, withName: array.key, fileName: uniqueString+fileType, mimeType: mimeTypeVal)
                }
            }
            
        }, to: url, method: .post, headers: headers).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
            
        .responseObject(completionHandler: { (response: DataResponse<T, AFError>) in
            
            //Activity Indicator Animation stop
            LoadingIndicator.hide()
            if response.response?.statusCode == 200 {
                completion(response)
            }else if failureReturen! {
                completion(response)
            }else if let data = response.data {
                self.showErrorMessage(responseData: data)
            }else {
                //self.showErrorMessage(message: response.error.debugDescription)
            }
        })
    }
}

//MARK: - FailureResponse
extension WebServices {
    
    //Error message get from errordata
    func showErrorMessage(responseData: Data) {
        
        if let utf8Text = String(data: responseData, encoding: .utf8),
            let messageDic = utf8Text.stringToDictionary(),
            let message = messageDic[Constant.message],let errorCode = messageDic[Constant.statusCode] {
            self.showErrorMessage(message: message as! String)
            if let code = errorCode as? String,code == "401" {
                // Force Logout
                DispatchQueue.main.async {
                    CommonFunction.forceLogout()
                }
            }
        }
    }
    
    //Show error message
    func showErrorMessage(message: String) {
        
        if let topViewController = UIApplication.topViewController() {
            self.simpleAlert(view: topViewController, title: String.Empty, message: message,state: .error)
        }
    }
    
    //URL Error
    func failureError(error: URLError) {
        switch error.code {
            case .notConnectedToInternet:
                self.showErrorMessage(message: Constant.noInterNetConnection.localized)
                break
            case .timedOut:
                self.showErrorMessage(message: Constant.requestTimeOut.localized)
                break
            case .networkConnectionLost:
                self.showErrorMessage(message: Constant.networkConnectionLost.localized)
                break
            default:
                self.showErrorMessage(message: Constant.unknownError.localized)
                break
        }
    }
}

//MARK: - NetworkState
class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
