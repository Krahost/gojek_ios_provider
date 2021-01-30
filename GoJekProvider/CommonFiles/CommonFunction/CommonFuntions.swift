//
//  CommonFuntions.swift
//  GoJekUser
//
//  Created by Ansar on 13/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Stripe

class CommonFunction: NSObject {
    
    static var isMapKeyExpired:Bool = false
    
    static func changeRootController(controller: UIViewController) {
        /* Initiating instance of ui-navigation-controller with view-controller */
        let navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        navigationController.isNavigationBarHidden = true
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        /* Setting up the root view-controller as ui-navigation-controller */
        appdelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appdelegate.window?.rootViewController = navigationController
        appdelegate.window?.makeKeyAndVisible()
    }
    
    static func forceLogout() {
        
        BackGroundRequestManager.share.stopBackGroundRequest()
        AppManager.share.accessToken = ""
        DataBaseManager.shared.delete(entityName: CoreDataEntity.loginData.rawValue)
        XSocketIOManager.sharedInstance.closeSocketConnection()
        BackGroundRequestManager.share.stopBackGroundRequest()
        
        let walkThrough = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.WalkThroughController)
        let signIN = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignInController)
        let navigationController = UINavigationController()
        navigationController.viewControllers = [walkThrough,signIN]
        navigationController.isNavigationBarHidden = true
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        /* Setting up the root view-controller as ui-navigation-controller */
        appdelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appdelegate.window?.rootViewController = navigationController
        appdelegate.window?.makeKeyAndVisible()
    }
    
    static func setGoogleMapKey() -> String {
        if self.isMapKeyExpired {
            return APPConstant.googleKey
        }else{
            let baseModel = AppConfigurationManager.shared.baseConfigModel
            if let mapKey = baseModel?.responseData?.appsetting?.ios_key, mapKey.count > 0 {
                return mapKey
            }else{
                return APPConstant.googleKey
            }
        }
    }
    
    private static func getStripeKey() -> [PaymentCredentials] {
        let paymentBaseModel = AppConfigurationManager.shared.baseConfigModel.responseData?.appsetting?.payments ?? []
        for payment in paymentBaseModel {
            if payment.name == "card" {
                return payment.credentials ?? []
            }
        }
        return []
    }
    
    static func setDynamicMapAndStripeKey() {
        //Set Google Map Key
        GMSServices.provideAPIKey(self.setGoogleMapKey())
        GMSPlacesClient.provideAPIKey(self.setGoogleMapKey())
        
        //Set Stripe Key
        if self.getStripeKey().count > 0 {
            for credential in self.getStripeKey()  where credential.name == StripeCredentialKey.stripe_publishable_key.rawValue  {
                if credential.value == String.Empty {
                    STPAPIClient.shared().publishableKey = APPConstant.stripePublishableKey
                }else{
                    STPAPIClient.shared().publishableKey = credential.value ?? APPConstant.stripePublishableKey

                }
            }
            if (STPAPIClient.shared().publishableKey?.trim().count)!  < 1 {
                STPAPIClient.shared().publishableKey = APPConstant.stripePublishableKey
            }
        }else{
            STPAPIClient.shared().publishableKey = APPConstant.stripePublishableKey
        }
    }
    static func checkisRTL() -> Bool {
        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.Language) as? String {
            if languageStr == "ar" {
                return true
            }
        }
        return false
    }
    
    static func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}
