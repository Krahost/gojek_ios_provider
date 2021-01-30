//
//  LoginRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class LoginRouter: LoginPresenterToLoginRouterProtocol {

    static func createLoginModule() -> UIViewController {
        
        var walkThroughController  = loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SplashController) as! SplashViewController
        var loginPresenter: LoginViewToLoginPresenterProtocol & LoginInterectorToLoginPresenterProtocol = LoginPresenter()
        var loginInteractor: LoginPresentorToLoginInterectorProtocol = LoginInteractor()
        let loginRouter: LoginPresenterToLoginRouterProtocol = LoginRouter()
        
        walkThroughController.loginPresenter = loginPresenter
        loginPresenter.loginView = walkThroughController
        loginPresenter.loginRouter = loginRouter
        loginPresenter.loginInterector = loginInteractor
        loginInteractor.loginPresenter = loginPresenter
        
        return walkThroughController
    }
    
    static var loginStoryboard: UIStoryboard {
        return UIStoryboard(name:"Login",bundle: Bundle.main)
    }
}

