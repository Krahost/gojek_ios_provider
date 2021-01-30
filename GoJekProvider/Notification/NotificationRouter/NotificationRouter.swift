//
//  NotificationRouter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class NotificationRouter: NotificationPresenterToNotificationRouterProtocol {
    
    static func createNotificationModule() -> UIViewController {
        var notificationController  = NotificationStoryboard.instantiateViewController(withIdentifier: NotificationConstant.NotificationController) as! NotificationController
        var notificationPresenter: NotificationViewToNotificationPresenterProtocol & NotificationInteractorToNotificationPresenterProtocol = NotificationPresenter()
        var notificationinteractor: NotificationPresenterToNotificationInteractorProtocol = NotificationInteractor()
        let notificationRouter: NotificationPresenterToNotificationRouterProtocol = NotificationRouter()
        
        notificationController.notificationPresenter = notificationPresenter
        notificationPresenter.notificationView = notificationController
        notificationPresenter.notificationRouter = notificationRouter
        notificationPresenter.notificationInterector = notificationinteractor
        notificationinteractor.notificationPresenter = notificationPresenter
        return notificationController
    }
    
    static var NotificationStoryboard: UIStoryboard {
        return UIStoryboard(name:"Notification",bundle: Bundle.main)
    }
    
}
