//
//  DetailOrderCell.swift
//  GoJekUser
//
//  Created by Sudar on 06/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class DetailOrderCell: UITableViewCell {
    
    // Payment view
    @IBOutlet weak var staticPaymentLabel: UILabel!
    @IBOutlet weak var cardOrCashLabel: UILabel!
    @IBOutlet weak var paymentImageView: UIImageView!
    
    // Status View
    @IBOutlet weak var staticStatusLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var statusOuterView: UIView!

    
    // Commentes View
    @IBOutlet weak var commentOuterView: UIView!
    @IBOutlet weak var staticCommentLabel: UILabel!
    @IBOutlet weak var commentValueLabel: UILabel!
    @IBOutlet weak var paymentOuterView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
    }
    
    private func initalLoads(){
        
        self.paymentImageView.image = UIImage(named: Constant.payment)
        self.paymentImageView.imageTintColor(color1: .lightGray)
        setFont()
        localize()
        setDarkMode()
    }
    
    private func setDarkMode(){
      self.statusOuterView.backgroundColor = .boxColor
      self.paymentOuterView.backgroundColor = .boxColor
      self.commentOuterView.backgroundColor = .boxColor
     }
    
    private func setFont() {
        staticStatusLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        statusValueLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        staticPaymentLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        cardOrCashLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        staticCommentLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        commentValueLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
    }
    private func localize() {
           staticPaymentLabel.text = OrdersConstant.paymentVia.localized
           staticStatusLabel.text = OrdersConstant.status.localized
    }
    
    func setValues(data: OrderDetailReponseData) {
        DispatchQueue.main.async {
            if let transportData = data.transport {
                self.staticCommentLabel.text = OrdersConstant.commentsfor.localized.giveSpace + ServiceType.transport.rawValue

                self.cardOrCashLabel.text = transportData.payment_mode ?? ""
                
                if let comment = transportData.rating?.provider_comment, comment.count != 0,comment != "null"   {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrdersConstant.noComments.localized
                }
                if let paymentImage = PaymentType(rawValue: transportData.payment_mode ?? "")?.image {
                                  self.paymentImageView.image = paymentImage
                              }
                
                if let status = TripStatus(rawValue: transportData.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
                
                if transportData.payment == nil {
                    self.paymentOuterView.isHidden = true
                }
            }
            if let courierData = data.delivery {
                self.staticCommentLabel.text = OrdersConstant.commentsfor.localized.giveSpace + ServiceType.delivery.rawValue
                self.cardOrCashLabel.text = courierData.payment_mode

                if let comment = courierData.rating?.provider_comment, comment.count != 0,comment != "null"   {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrdersConstant.noComments.localized
                }
                
                if let paymentImage = PaymentType(rawValue: courierData.payment_mode ?? "")?.image {
                                                 self.paymentImageView.image = paymentImage
                                             }
                
                if let status = TripStatus(rawValue: courierData.deliveries?.first?.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
            }
            if let serviceData = data.service {
                self.staticCommentLabel.text = OrdersConstant.commentsfor.localized.giveSpace + ServiceType.service.rawValue
                
                self.cardOrCashLabel.text = serviceData.payment?.payment_mode
                if let paymentImage = PaymentType(rawValue: serviceData.payment_mode ?? "")?.image {
                    self.paymentImageView.image = paymentImage
                }
                
                if let comment = serviceData.rating?.provider_comment , comment.count != 0,comment != "null"  {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrdersConstant.noComments.localized
                }
                if let status = TripStatus(rawValue: serviceData.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
                
                if serviceData.payment == nil {
                    self.paymentOuterView.isHidden = true
                }
            }
            if let foodieValue = data.foodie {
                self.staticCommentLabel.text = OrdersConstant.commentsfor.localized.giveSpace + ServiceType.order.rawValue
                if let status = TripStatus(rawValue: foodieValue.status ?? "") {
                    self.statusValueLabel.text = status.statusString
                }
                if let paymentImage = PaymentType(rawValue: foodieValue.order_invoice?.payment_mode ?? "")?.image {
                                 self.paymentImageView.image = paymentImage
                             }
                self.cardOrCashLabel.text = foodieValue.order_invoice?.payment_mode
                if let comment = foodieValue.rating?.provider_comment, comment.count != 0,comment != "null"   {
                    self.commentValueLabel.text = comment
                }else{
                    self.commentValueLabel.text = OrdersConstant.noComments.localized
                }
                if foodieValue.order_invoice == nil {
                    self.paymentOuterView.isHidden = true
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
