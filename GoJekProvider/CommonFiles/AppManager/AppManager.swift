//
//  AppManager.swift
//  GoJekProvider
//
//  Created by Rajes on 01/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class AppManager {
    
    static var share = AppManager()
    
    private var userDetails: ProfileData!
    
    public var accessToken: String?
    
    private var BaseResponseDetails:BaseResponseData!
    
    func setUserDetails(details:ProfileData) {
        self.userDetails =  details
    }
    
    func getUserDetails() -> ProfileData? {
        return  userDetails
    }
    
    
    func setBaseDetails(details:BaseResponseData){
        self.BaseResponseDetails = details
    }
    
    func getBaseDetails() -> BaseResponseData? {
        return BaseResponseDetails
    }
}
