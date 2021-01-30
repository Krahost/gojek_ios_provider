//
//  NotificationPresenter.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK: - NotificationViewToNotificationPresenterProtocol

class NotificationPresenter: NotificationViewToNotificationPresenterProtocol {
    
    var notificationView: NotificationPresenterToNotificationViewProtocol?
    var notificationInterector: NotificationPresenterToNotificationInteractorProtocol?
    var notificationRouter: NotificationPresenterToNotificationRouterProtocol?
    
    //Get Notification list
    func getNotificationList(param: Parameters, isHideLoader: Bool) {
       notificationInterector?.getNotificationList(param: param, isHideLoader: isHideLoader)
    }
}

//MARK: - NotificationInteractorToNotificationPresenterProtocol

extension NotificationPresenter: NotificationInteractorToNotificationPresenterProtocol {
    
    //Get notification list response
    func notificationListResponse(notificationEntity: NotificationEntity) {
        notificationView?.notificationListResponse(notificationEntity: notificationEntity)
    }
}

