//
//  XuberInVoiceController.swift
//  GoJekProvider
//
//  Created by CSS on 16/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class XuberInVoiceController: UIViewController {
    
    @IBOutlet weak var invoiceTitleLabel: UILabel!
    @IBOutlet weak var invoiceView: UIView!
    
    @IBOutlet weak var confirmPaymentButton: UIButton!
    @IBOutlet weak var amountPaidValueLabel: UILabel!
    @IBOutlet weak var amountPaidLabel: UILabel!
    @IBOutlet weak var additionalChargeButton: UIButton!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var serviceDescriptionLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var amountPaidView: UIView!
    
    var xuberCheckRequestData: XuberCheckResponseData?
    weak var delegate: XuberInVoiceDelegate?
    var endRequestData: EndServiceResponse?
    
    var paymentType: PaymentType = .CASH
    
    var isCashMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
    }
    
}

extension XuberInVoiceController {
    
    private func initSetup(){
        
        confirmPaymentButton.addTarget(self, action: #selector(tapConfirmPayment(_:)), for: .touchUpInside)
        DispatchQueue.main.async {
            self.showInVoiceData()
        }
        invoiceTitleLabel.text = XuberConstant.invoice.localized
        amountPaidLabel.text = XuberConstant.amounttopaid.localized
        invoiceTitleLabel.font = .setCustomFont(name: .medium, size: .x18)
        nameLabel.font = .setCustomFont(name: .bold, size: .x18)
        serviceLabel.font = .setCustomFont(name: .bold, size: .x18)
        serviceDescriptionLabel.font = .setCustomFont(name: .medium, size: .x18)
        serviceDescriptionLabel.adjustsFontSizeToFitWidth = true
        profileImageView.setCornerRadius()
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 1
        additionalChargeButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        additionalChargeButton.layer.borderWidth = 1
        additionalChargeButton.layer.borderColor = UIColor(red: 38/255, green: 118/255, blue: 188/255, alpha: 1).cgColor
        additionalChargeButton.setTitleColor(.xuberColor, for: .normal)
        confirmPaymentButton.setTitleColor(.xuberColor, for: .normal)
        confirmPaymentButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        amountPaidValueLabel.font = .setCustomFont(name: .medium, size: .x16)
        amountPaidLabel.font = .setCustomFont(name: .medium, size: .x16)
        rateImageView.image = UIImage(named: Constant.ratingSelect)
        rateLabel.font = .setCustomFont(name: .medium, size: .x18)
        rateLabel.textColor = .lightGray
        serviceDescriptionLabel.textColor = .lightGray
        timeValueLabel.textColor = .lightGray
        amountPaidView.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.5)
        amountPaidLabel.textColor = .xuberColor
        amountPaidLabel.font =  .setCustomFont(name: .medium, size: .x18)
        amountPaidValueLabel.textColor = .xuberColor
        amountPaidValueLabel.font =  .setCustomFont(name: .medium, size: .x18)
        invoiceView.setCornerRadiuswithValue(value: 10)
        additionalChargeButton.setCornerRadiuswithValue(value: 10)
        amountPaidView.setCornerRadiuswithValue(value: 10)
        
        additionalChargeButton.titleLabel?.numberOfLines = 1
        additionalChargeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        additionalChargeButton.titleLabel?.lineBreakMode = .byClipping
        
        NotificationCenter.default.addObserver(self, selector: #selector(invoiceDetailUpdate), name: Notification.Name(XuberConstant.serviceInvoiceDetail), object: nil)
        invoiceView.backgroundColor = .boxColor
    }
    
    @objc func invoiceDetailUpdate(notification: Notification) {
        let detail = notification.userInfo
        xuberCheckRequestData = detail?["data"] as? XuberCheckResponseData
        DispatchQueue.main.async {
            let xuberRequestData = self.xuberCheckRequestData?.requests
            let name = (xuberRequestData?.user?.first_name ?? String.Empty) + (xuberRequestData?.user?.last_name ?? String.Empty)
            self.nameLabel.text = name
            self.rateLabel.text = (xuberRequestData?.user?.rating?.rounded(.toNearestOrEven) ?? 0).toString()
            
           
            self.profileImageView.sd_setImage(with: URL(string:  xuberRequestData?.user?.picture ?? ""), placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
             // Perform operation.
                if (error != nil) {
                    // Failed to load image
                    self.profileImageView.image = UIImage(named: Constant.profile)
                } else {
                    // Successful in loading image
                    self.profileImageView.image = image
                }
            })
            self.paymentType = PaymentType(rawValue: xuberRequestData?.payment_mode ?? String.Empty) ?? .CASH
            if xuberRequestData?.payment_mode == Constant.cash.uppercased() {
                self.confirmPaymentButton.setTitle(XuberConstant.confirmPayment.localized.uppercased(), for: .normal)
                self.isCashMode = true
                
            }else{
                self.confirmPaymentButton.setTitle(XuberConstant.SDone.localized.uppercased(), for: .normal)
                self.isCashMode = false
                
            }
            self.serviceLabel.text = XuberConstant.service
            self.timeTaken(startTime: (xuberRequestData?.started_at ?? ""), endTime: (xuberRequestData?.finished_at ?? ""))
            self.serviceDescriptionLabel.text = xuberRequestData?.service?.service_name
            self.timeLabel.text = XuberConstant.timeTaken
            self.amountPaidValueLabel.text = xuberRequestData?.payment?.payable?.setCurrency()
            let additionalCharge = XuberConstant.plusadditionalCharge.localized + (xuberRequestData?.payment?.extra_charges?.setCurrency() ?? "0.0") + " "
            self.additionalChargeButton.setTitle(additionalCharge, for: .normal)
            self.additionalChargeButton.isHidden = (xuberRequestData?.payment?.extra_charges ?? 0) == 0
        }
    }
    
    @objc func tapConfirmPayment(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        let paidStatus = xuberCheckRequestData?.requests?.paid ?? 0
        delegate?.confirmPayment(isCash: isCashMode,isPaid:paidStatus)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(XuberConstant.serviceInvoiceDetail), object: nil)
    }
    
    private func showInVoiceData() {

        serviceLabel.text = XuberConstant.service
        timeLabel.text = XuberConstant.timeTaken

        if endRequestData != nil {
            let name = (endRequestData?.user?.firstName ?? String.Empty) + (endRequestData?.user?.lastName ?? String.Empty)
            nameLabel.text = name
            rateLabel.text = "\(endRequestData?.user?.rating?.rounded(.toNearestOrEven) ?? 0)"
            
            self.profileImageView.sd_setImage(with: URL(string:  endRequestData?.user?.picture ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                if (error != nil) {
                    // Failed to load image
                    self.profileImageView.image = UIImage(named: Constant.profile)
                } else {
                    // Successful in loading image
                    self.profileImageView.image = image
                }
            })
            
            timeTaken(startTime: (endRequestData?.started_at ?? ""), endTime: (endRequestData?.finished_at ?? ""))
            serviceDescriptionLabel.text = endRequestData?.service?.service_name
            paymentType = PaymentType(rawValue: endRequestData?.payment_mode ?? String.Empty) ?? .CASH
             if endRequestData?.payment?.payment_mode == Constant.cash.uppercased() {
                confirmPaymentButton.setTitle(XuberConstant.confirmPayment.localized.uppercased(), for: .normal)
                isCashMode = true
            }else{
                confirmPaymentButton.setTitle(XuberConstant.SDone.localized.uppercased(), for: .normal)
                isCashMode = false
            }
            amountPaidValueLabel.text = endRequestData?.payment?.payable?.setCurrency()
            let additionalCharge = XuberConstant.plusadditionalCharge.localized + (endRequestData?.payment?.extra_charges?.setCurrency() ?? "0") + " "
            additionalChargeButton.setTitle(additionalCharge, for: .normal)
            additionalChargeButton.isHidden = (endRequestData?.payment?.extra_charges ?? 0) == 0
        }else{
            let name = (xuberCheckRequestData?.requests?.user?.first_name ?? String.Empty) + (xuberCheckRequestData?.requests?.user?.last_name ?? String.Empty)
            nameLabel.text = name
            rateLabel.text = (xuberCheckRequestData?.requests?.user?.rating?.rounded(.toNearestOrEven) ?? 0).toString()
            
            self.profileImageView.sd_setImage(with: URL(string:  xuberCheckRequestData?.requests?.user?.picture ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                if (error != nil) {
                    // Failed to load image
                    self.profileImageView.image = UIImage(named: Constant.profile)
                } else {
                    // Successful in loading image
                    self.profileImageView.image = image
                }
            })
        
            paymentType = PaymentType(rawValue: xuberCheckRequestData?.requests?.payment_mode ?? String.Empty) ?? .CASH
            if xuberCheckRequestData?.requests?.payment?.payment_mode == Constant.cash.uppercased() {
                confirmPaymentButton.setTitle(XuberConstant.confirmPayment.localized.uppercased(), for: .normal)
                isCashMode = true
                
            }else{
                confirmPaymentButton.setTitle(XuberConstant.SDone.localized.uppercased(), for: .normal)
                isCashMode = false
                
            }
            timeTaken(startTime: (xuberCheckRequestData?.requests?.started_at ?? ""), endTime: (xuberCheckRequestData?.requests?.finished_at ?? ""))
            serviceDescriptionLabel.text = xuberCheckRequestData?.requests?.service?.service_name
            amountPaidValueLabel.text = xuberCheckRequestData?.requests?.payment?.payable?.setCurrency()
            let additionalCharge = XuberConstant.plusadditionalCharge.localized + (xuberCheckRequestData?.requests?.payment?.extra_charges?.setCurrency() ?? "0.0") + " "
            additionalChargeButton.setTitle(additionalCharge, for: .normal)
            additionalChargeButton.isHidden = (endRequestData?.payment?.extra_charges ?? 0) == 0
            
        }
        
    }
    
    private func timeTaken(startTime:String, endTime:String) {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter1.date(from: UTCToLocal(date: startTime))
        var startTimeStr: String? = nil
        if let date = date {
            startTimeStr = dateFormatter1.string(from: date)
        }
        
        let enddate: Date? = dateFormatter1.date(from: UTCToLocal(date: endTime))
        var endTimeStr: String? = nil
        if let date1 = enddate {
            endTimeStr = dateFormatter1.string(from: date1)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate: Date? = formatter.date(from: startTimeStr ?? String.Empty)
        let endDate: Date? = formatter.date(from: endTimeStr ?? String.Empty)
        
        var timeDifference: TimeInterval? = nil
        if let startDate = startDate {
            timeDifference = endDate?.timeIntervalSince(startDate)
        }
        var seconds = Int(timeDifference ?? 0)
        
        let hours: Int = seconds / 3600
        let minutes: Int = (seconds % 3600) / 60
        seconds = (seconds % 3600) % 60
        timeValueLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

// MARK: - Protocol
protocol XuberInVoiceDelegate: class {
    
    func confirmPayment(isCash: Bool,isPaid:Int)
}
