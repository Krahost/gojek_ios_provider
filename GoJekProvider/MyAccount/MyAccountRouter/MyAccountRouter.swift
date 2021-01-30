//
//  MyAccountRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class MyAccountRouter: MyAccountPresenterToMyAccountRouterProtocol {
    
    static func createMyAccountModule() -> UIViewController {
       
        var myAccountController  = myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.MyAccountController) as! MyAccountController
        var myAccountPresenter: MyAccountViewToMyAccountPresenterProtocol & MyAccountInteractorToMyAccountPresenterProtocol = MyAccountPresenter()
        var myAccountinteractor: MyAccountPresenterToMyAccountInteractorProtocol = MyAccountInteractor()
        let myAccountRouter: MyAccountPresenterToMyAccountRouterProtocol = MyAccountRouter()
        
        myAccountController.myAccountPresenter = myAccountPresenter
        myAccountPresenter.myAccountView = myAccountController
        myAccountPresenter.myAccountRouter = myAccountRouter
        myAccountPresenter.myAccountInterector = myAccountinteractor
        myAccountinteractor.myAccountPresenter = myAccountPresenter
        return myAccountController
    }
    
    static var myAccountStoryboard: UIStoryboard {
        return UIStoryboard(name:"MyAccount",bundle: Bundle.main)
    }
    
    static func createModule(controller: (UIViewController & MyAccountPresenterToMyAccountViewProtocol)) -> (MyAccountViewToMyAccountPresenterProtocol & MyAccountInteractorToMyAccountPresenterProtocol) {
        var presenter:MyAccountViewToMyAccountPresenterProtocol & MyAccountInteractorToMyAccountPresenterProtocol = MyAccountPresenter()
        var interactor: MyAccountPresenterToMyAccountInteractorProtocol = MyAccountInteractor()
        let router: MyAccountPresenterToMyAccountRouterProtocol = MyAccountRouter()
        
        presenter.myAccountView = controller
        presenter.myAccountInterector = interactor
        presenter.myAccountRouter = router
        interactor.myAccountPresenter = presenter
        return presenter
        
    }
   
}
