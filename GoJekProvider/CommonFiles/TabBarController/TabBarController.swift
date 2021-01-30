//
//  TabBarController.swift
//  TabBarController
//
//  Created by Selva on 18/08/17.
//  Copyright © 2017 optisol. All rights reserved.
//

import UIKit

class TabBarController:  UITabBarController {
    
    static let shared = TabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func listTabBarController() -> UITabBarController {
        
        // Set up the home View Controller
        let homeViewController = HomeRouter.createHomeModule()
        homeViewController.tabBarItem.title = HomeConstant.THome.localized
        homeViewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.setCustomFont(name: .bold, size: .x12)], for: .normal)
        homeViewController.tabBarItem.image = UIImage(named: Constant.home)
        homeViewController.tabBarItem.selectedImage = UIImage(named: Constant.home)
        let homeViewNavigation = UINavigationController(rootViewController: homeViewController)
        
        // Set up the order View Controller
        let ordersController = OrdersRouter.createOrdersModule()
        ordersController.tabBarItem.title = OrdersConstant.history.localized
        ordersController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.setCustomFont(name: .bold, size: .x12)], for: .normal)
        ordersController.tabBarItem.image = UIImage(named: Constant.order)
        ordersController.tabBarItem.selectedImage = UIImage(named: Constant.order)
        let ordersViewNavigation = UINavigationController(rootViewController: ordersController)
        
        // Set up the notification View Controller
        let notificationController = NotificationRouter.createNotificationModule()
        notificationController.tabBarItem.title = NotificationConstant.TNotification.localized
        notificationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.setCustomFont(name: .bold, size: .x12)], for: .normal)
        notificationController.tabBarItem.image = UIImage(named: Constant.notification)
        notificationController.tabBarItem.selectedImage = UIImage(named: Constant.notification)
        let notificationViewNavigation = UINavigationController(rootViewController: notificationController)
        
        // Set up the account View Controller
        let myAccountController = MyAccountRouter.createMyAccountModule()
        myAccountController.tabBarItem.title = MyAccountConstant.account.localized
        myAccountController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.setCustomFont(name: .bold, size: .x12)], for: .normal)
        myAccountController.tabBarItem.image = UIImage(named: Constant.account)
        myAccountController.tabBarItem.selectedImage = UIImage(named: Constant.account)
        let myAccountViewNavigation = UINavigationController(rootViewController: myAccountController)
        myAccountViewNavigation.navigationItem.hidesBackButton = true
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeViewNavigation, ordersViewNavigation, notificationViewNavigation, myAccountViewNavigation]
        tabBarController.tabBar.tintColor = .appPrimaryColor
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        return tabBarController
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
}
