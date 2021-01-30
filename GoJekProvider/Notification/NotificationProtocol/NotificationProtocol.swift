//
//  NotificationProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var notificationPresenterObject: NotificationViewToNotificationPresenterProtocol?

//MARK:- Notification Presenter to View

protocol NotificationPresenterToNotificationViewProtocol {
    
    //Get notification list response
    func notificationListResponse(notificationEntity: NotificationEntity)
}

extension NotificationPresenterToNotificationViewProtocol {
    
    var notificationPresenter: NotificationViewToNotificationPresenterProtocol? {
        get {
            notificationPresenterObject?.notificationView = self
            return notificationPresenterObject
        }
        set(newValue) {
            notificationPresenterObject = newValue
        }
    }
    
    //Get notification list response
    func notificationListResponse(notificationEntity: NotificationEntity) { return }
   
}

//MARK:- Notification interactor to presenter

protocol NotificationInteractorToNotificationPresenterProtocol {
    
    //Get notification list response
    func notificationListResponse(notificationEntity: NotificationEntity)

}


//MARK:- Notification presenter to Interactor

protocol NotificationPresenterToNotificationInteractorProtocol {
    
    var notificationPresenter: NotificationInteractorToNotificationPresenterProtocol? {get set}
    
    //Get notification list
    func getNotificationList(param: Parameters, isHideLoader: Bool)


}

//MARK:- Account View to presenter

protocol NotificationViewToNotificationPresenterProtocol {
    
    var notificationView: NotificationPresenterToNotificationViewProtocol? {get set}
    var notificationInterector: NotificationPresenterToNotificationInteractorProtocol? {get set}
    var notificationRouter: NotificationPresenterToNotificationRouterProtocol? {get set}
    
    //Get notification list
    func getNotificationList(param: Parameters, isHideLoader: Bool)


}

//MARK:- Notification presenter to router

protocol NotificationPresenterToNotificationRouterProtocol {
    
    static func createNotificationModule() -> UIViewController
}
