//
//  DisputeStatusView.swift
//  TranxitUser
//
//  Created by Ansar on 19/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DisputeStatusView: UIView {
    
    @IBOutlet private weak var tableview : UITableView!
    @IBOutlet private weak var lblHeading : UILabel!
    @IBOutlet private weak var btnCall : UIButton!
    @IBOutlet private weak var viewHeader : UIView!
    @IBOutlet weak var DisputeStatusViewHeight: NSLayoutConstraint!
    
    var isDispute: Bool = false
    var onClickClose: ((Bool)->Void)?

    var disputeData: Dispute?
//    var lostItemData: Lost_item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    private func initialLoads() {
        alpha = 1
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(nibName: OrdersConstant.DisputeSenderCell)
        tableview.register(nibName: OrdersConstant.DisputeReceiverCell)
        btnCall.setTitleColor(.appPrimaryColor, for: .normal)
        btnCall.setImage(UIImage(named: Constant.phoneImage), for: .normal)
        btnCall.tintColor = .appPrimaryColor
        lblHeading.text = OrdersConstant.disputeStatus.localized
        btnCall.isHidden = true
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.backgroundColor = .boxColor
        self.viewHeader.backgroundColor = .boxColor
        self.tableview.backgroundColor = .boxColor
    }

    func setValues(values: Dispute)  {
        isDispute  = true
        disputeData = values
        tableview.reloadInMainThread()
    }
    @objc func tapClose() {
        onClickClose!(true)
    }
    
}

// MARK:- UITableViewDelegate

extension DisputeStatusView: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return getCell(for: indexPath)
    }
    
    private func getCell(for indexPath:IndexPath) -> UITableViewCell {
        if isDispute {
                if indexPath.row == 0 {
                    if disputeData?.dispute_type == userType.Provider.rawValue {
                        if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrdersConstant.DisputeSenderCell, for: indexPath) as? DisputeSenderCell {
                            let userDetail = AppManager.share.getUserDetails()
                            tableCell.setValues(detail: userDetail, lostItem: disputeData)
                            return tableCell
                        }
                }
                }  else {
                    if let adminComment = disputeData?.comments {
                        if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrdersConstant.DisputeReceiverCell, for: indexPath) as? DisputeReceiverCell {
                            tableCell.setValues(adminComment: adminComment)
                            return tableCell
                        }
                    }
                }
       
        }
        else {
            if indexPath.row == 0 {
                if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrdersConstant.DisputeSenderCell, for: indexPath) as? DisputeSenderCell {
                    let userDetail = AppManager.share.getUserDetails()
                    tableCell.setValues(detail: userDetail, lostItem: disputeData)
                    return tableCell
                }
            }
            
            else {
                if let adminComment = disputeData?.comments {
                    if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrdersConstant.DisputeReceiverCell, for: indexPath) as? DisputeReceiverCell {
                        tableCell.setValues(adminComment: adminComment)
                        return tableCell
                    }
                }
        }
        }
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = .boxColor
        return cell
    }
}

// MARK:- UITableViewDelegate

extension DisputeStatusView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
