//
//  NotificationInteractor.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//MARK: - NotificationPresenterToNotificationInteractorProtocol

class NotificationInteractor: NotificationPresenterToNotificationInteractorProtocol {
   
    
    var notificationPresenter: NotificationInteractorToNotificationPresenterProtocol?

    func getNotificationList(param: Parameters, isHideLoader: Bool) {

        WebServices.shared.requestToApi(type: NotificationEntity.self, with: URLConstant.KNotification, urlMethod: .get, showLoader: isHideLoader, params: param, encode : URLEncoding.default, completion: { [weak self] response in
            guard let self = self else {
                return
            }
            if let responseValue = response?.value {
                self.notificationPresenter?.notificationListResponse(notificationEntity: responseValue)
            }
        })
    }
}
