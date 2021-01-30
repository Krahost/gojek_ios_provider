//
//  NotificationController.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class NotificationController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    var notificationData: [NotificationData] = []
    var cellHeights: [IndexPath : CGFloat] = [:]

    var offSet: Int = 0
    var isUpdate = false
    var totalRecord = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = NotificationConstant.TNotification.localized
        
        //Webservice call
        notificationPresenter?.getNotificationList(param: [MyAccountConstant.PLimit: 10, MyAccountConstant.POffset: offSet], isHideLoader: true)
    }
}

//MARK: - LocalMethod

extension NotificationController {
    
    private func viewDidSetup() {
        
        self.view.backgroundColor = .backgroundColor
        
        tableView.register(nibName: NotificationConstant.NotificationTableViewCell)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        setNavigationTitle()
        addshadow()
    }
}

//MARK: - UITableViewDataSource

extension NotificationController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationData.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 170.0 }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationConstant.NotificationTableViewCell, for: indexPath) as! NotificationTableViewCell
        
        cell.setValues(values: notificationData[indexPath.row])
        cell.showButton.addTarget(self, action: #selector(self.tapShowMoreLess(btn:)), for: .touchUpInside)
        cell.showButton.tag = indexPath.row
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        //Pagination calculationa and method call
        let lastCell = (notificationData.count) - 2
        if notificationData.count >= 10,
            indexPath.row == lastCell,
            totalRecord != 0 {
            isUpdate = true
            offSet = offSet + (notificationData.count)
            notificationPresenter?.getNotificationList(param: [MyAccountConstant.PLimit: 10, MyAccountConstant.POffset: offSet], isHideLoader: false)
        }
    }
    
    @objc func tapShowMoreLess(btn:UIButton) {
        let btnTag = btn.tag
        print(btnTag)
        let indexPath = IndexPath.init(row: btn.tag, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        if cell.isShowMoreLess {
            cell.isShowMoreLess = false
            cell.notificationDetailLabel.numberOfLines = 3
            cell.showButton.setTitle("Show More", for: .normal)
            
        }else{
            cell.isShowMoreLess = true
            cell.notificationDetailLabel.numberOfLines = 0
            cell.showButton.setTitle("Show Less", for: .normal)
            
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate

extension NotificationController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - NotificationPresenterNotificationViewProtocol

extension NotificationController: NotificationPresenterToNotificationViewProtocol {
    
    func notificationListResponse(notificationEntity: NotificationEntity) {
        if isUpdate  {
            if (notificationEntity.responseData?.notification?.count ?? 0) > 0
            {
                for i in 0..<(notificationEntity.responseData?.notification?.count ?? 0)
                {
                    let dict = notificationEntity.responseData?.notification?[i]
                    notificationData.append(dict!)
                }
            }
        } else {
            notificationData = notificationEntity.responseData?.notification ?? []
        }
        
        if notificationData.count == 0 {
            tableView.setBackgroundImageAndTitle(imageName: NotificationConstant.noNotification, title: NotificationConstant.notificationEmpty.localized)
        } else {
            tableView.backgroundView = nil
        }
        totalRecord  = notificationEntity.responseData?.total_records ?? 0
        tableView.reloadInMainThread()
    }
}

