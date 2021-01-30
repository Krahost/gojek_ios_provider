//
//  SplashViewController.swift
//  GoJekProvider
//
//  Created by Rajes on 06/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView
class SplashViewController: UIViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPresenter?.getBaseURL(param: [Constant.saltkey: APPConstant.saltKeyValue])
        
        // While launching splash if any internet problem means, once app comes to foreground this api will work
        addGifLoader()
        NotificationCenter.default.addObserver(self, selector: #selector(appComesForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appComesForeground(notification: NSNotification) {
         loginPresenter?.getBaseURL(param: [Constant.saltkey: APPConstant.saltKeyValue])
    }
    func addGifLoader(){
           activityIndicatorView =  NVActivityIndicatorView(frame:  CGRect(x: self.view.frame.size.width/2 - 50, y:  self.view.frame.height - 80, width: 80, height: 80), type: .ballPulse, color: .appPrimaryColor, padding: 20)
           self.view.addSubview(activityIndicatorView)
           activityIndicatorView.startAnimating()
    }
    func checkAlreadyLogin() -> Bool {
        let fetchData = try! DataBaseManager.shared.context.fetch(LoginData.fetchRequest()) as? [LoginData]
        if (fetchData?.count ?? 0) <= 0 {
            return false
        }
        AppManager.share.accessToken = fetchData?.first?.access_token
        print("Access Token \(fetchData?.first?.access_token ?? .Empty)" )
        return (fetchData?.count ?? 0) > 0
    }
}

extension SplashViewController: LoginPresenterToLoginViewProtocol {
    
    func getBaseURLResponse(baseEntity: BaseEntity) {
         activityIndicatorView.stopAnimating()
        AppConfigurationManager.shared.baseConfigModel = baseEntity
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        AppManager.share.setBaseDetails(details: baseEntity.responseData!)
        CommonFunction.setDynamicMapAndStripeKey()
        if checkAlreadyLogin() {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            appDelegate.window?.rootViewController = TabBarController.shared.listTabBarController()
            appDelegate.window?.makeKeyAndVisible()
        } else {
            let walkThroughViewcontroller =  LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.WalkThroughController)
            navigationController?.pushViewController(walkThroughViewcontroller, animated: true)
        }
    }
}
