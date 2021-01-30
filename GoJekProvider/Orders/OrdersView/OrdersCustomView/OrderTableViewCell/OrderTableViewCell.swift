//
//  OrderTableViewCell.swift
//  MySample
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 CSS01. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderListLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var cancelOuterView: UIView!
    @IBOutlet weak var callOuterView: UIView!
    @IBOutlet weak var helpOuterView: UIView!
    @IBOutlet weak var ratingOuterView: UIView!
    @IBOutlet weak var orderTypeOuterView: UIView!
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var historyType: HistoryType = .past {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTransportValues(with type: String, values: TransportData) {
        
        orderIdLabel.text = values.booking_id ?? String.Empty
        
        if let commets = values.rating?.provider_comment, commets != String.Empty {
            orderListLabel.text = "\(type.capitalizingFirstLetter()), \(values.ride?.vehicle_name?.capitalizingFirstLetter() ?? String.Empty) \n\n\(commets)"
        }else {
            orderListLabel.text = "\(type.capitalizingFirstLetter()), \(values.ride?.vehicle_name?.capitalizingFirstLetter() ?? String.Empty)"
        }
        if let dateStr = values.assigned_time {
            let dateValue = dateFormatConvertion(dateString: dateStr)
            setDateAndTime(dateString: dateValue)
        }
        
        if let status = OrderStatus(rawValue: values.status ?? "None") {
            orderTypeLabel.text = status.statusStr.capitalizingFirstLetter()
            orderTypeLabel.textColor = status.orderColor
            orderTypeOuterView.backgroundColor = status.orderColor.withAlphaComponent(0.2)
            ratingOuterView.isHidden = status == .CANCELLED
            bottomView.isHidden = status == .CANCELLED
        }
        if historyType == .past  {
        if values.dispute_count == 1{
                   cancelOuterView.isHidden = false
               }else{
                   cancelOuterView.isHidden = true
               }
        }
        if let rating = values.rating {
            ratingLabel.text = "\(rating.provider_rating ?? 1)"
        } else {
            ratingOuterView.isHidden = true
        }
    }
    
    func setDateAndTime(dateString: String) {
        print("dateString---->",dateString)
        let seperatedStrArr = dateString.components(separatedBy: ",")
        if seperatedStrArr.count > 1 {
            timeLabel.text = String.removeNil(seperatedStrArr[1])
            dateLabel.text =  String.removeNil(seperatedStrArr[0])
        } else  {
            timeLabel.text = String.Empty
            dateLabel.text =  String.removeNil(seperatedStrArr[0])
        }
    }
    
    func setServiceValues(values: TransportData) {
        orderIdLabel.text = values.booking_id
        if let commets = values.rating?.provider_comment, commets != String.Empty {
            orderListLabel.text = (values.service?.service_name?.capitalizingFirstLetter() ?? "") + "\n\n\(commets)"
        } else {
            orderListLabel.text = values.service?.service_name?.capitalizingFirstLetter() ?? ""
        }
        if let rating = values.rating {
            ratingLabel.text = "\(rating.provider_rating ?? 1)"
        }else {
            ratingOuterView.isHidden = true
        }
        
        if let dateStr = values.assigned_time {
            let dateValue = dateFormatConvertion(dateString: dateStr)
            setDateAndTime(dateString: dateValue)
        }
        
        if let status = OrderStatus(rawValue: values.status ?? "None") {
            orderTypeLabel.text = status.statusStr.capitalizingFirstLetter()
            orderTypeLabel.textColor = status.orderColor
            orderTypeOuterView.backgroundColor = status.orderColor.withAlphaComponent(0.2)
            self.ratingOuterView.isHidden = status == .CANCELLED
            self.bottomView.isHidden = status == .CANCELLED
        }
    }
    
    func setCourierValues(with type: String, values: CourierData) {
        
           orderIdLabel.text = values.booking_id
            if let commets = values.rating?.provider_comment, commets != String.Empty {
                orderListLabel.text = "\(type.capitalizingFirstLetter()), \(values.service?.vehicle_name?.capitalizingFirstLetter() ?? String.Empty) \n\n\(commets)"
                   }else {
                orderListLabel.text = "\(type.capitalizingFirstLetter()), \(values.service?.vehicle_name?.capitalizingFirstLetter() ?? String.Empty)"
                   }
        if let rating = values.rating {
            ratingLabel.text = "\(rating.provider_rating ?? 1)"
           }else {
               ratingOuterView.isHidden = true
           }
           
           if let dateStr = values.assigned_time {
               let dateValue = dateFormatConvertion(dateString: dateStr)
               setDateAndTime(dateString: dateValue)
           }
           
           if let status = OrderStatus(rawValue: values.status ?? "None") {
               orderTypeLabel.text = status.statusStr.capitalizingFirstLetter()
               orderTypeLabel.textColor = status.orderColor
               orderTypeOuterView.backgroundColor = status.orderColor.withAlphaComponent(0.2)
               self.ratingOuterView.isHidden = status == .CANCELLED
               self.bottomView.isHidden = status == .CANCELLED
           }
       }
    
    func setFoodieValues(values: FoodieHistoryData) {
        
        orderIdLabel.text = values.store_order_invoice_id
        if let commets = values.rating?.provider_comment, commets != String.Empty {
            orderListLabel.text = (values.pickup?.store_name?.capitalizingFirstLetter() ?? String.Empty).giveSpace + (values.pickup?.store_location ?? String.Empty) + "\n\n\(commets)"
        } else {
            orderListLabel.text = (values.pickup?.store_name?.capitalizingFirstLetter() ?? String.Empty).giveSpace + (values.pickup?.store_location ?? String.Empty)
        }
        
        if let rating = values.rating {
            ratingLabel.text = "\(rating.provider_rating ?? 1)"
        } else {
            ratingOuterView.isHidden = true
        }
        
        if let dateStr = values.created_time {
            let dateValue = dateFormatConvertion(dateString: dateStr)
            setDateAndTime(dateString: dateValue)
        }
        
        if let status = OrderStatus(rawValue: values.status ?? "None") {
            orderTypeLabel.text = status.statusStr.capitalizingFirstLetter()
            orderTypeLabel.textColor = status.orderColor
            orderTypeOuterView.backgroundColor = status.orderColor.withAlphaComponent(0.2)
            self.ratingOuterView.isHidden = status == .CANCELLED
            self.bottomView.isHidden = status == .CANCELLED
        }
    }
}

//MARK: Methods

extension OrderTableViewCell {
    
    private func initialLoads() {
        
        backGroundView.setCornerRadiuswithValue(value: 5)
      //  cancelButton.setTitle(Constant.cancel.localized, for: .normal)
        self.cancelButton.tintColor = .red
             self.cancelButton.setTitleColor(.red, for: .normal)
        self.cancelButton.setTitle(OrdersConstant.dispute, for: .normal)
        self.cancelButton.setImage(UIImage.init(named: OrdersConstant.ic_dispute), for:.normal)
        self.cancelButton.setImageTitle(spacing: 5)

        //        dateBackgroundView.setOneSideCorner(corners: [.topLeft,.bottomLeft], radius: 5)
        orderTypeOuterView.setCornerRadius()
        orderIdLabel.adjustsFontSizeToFitWidth = true
        callButton.setTitle(OrdersConstant.call.localized, for: .normal)
        callButton.setImage(UIImage(named: Constant.phoneImage), for: .normal)
        callButton.setImageTitle(spacing: 10)
        callButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 6)
        callButton.imageView?.contentMode = .scaleAspectFit
        
        helpButton.setTitle(OrdersConstant.help.localized, for: .normal)
        helpButton.setImage(UIImage(named: OrdersConstant.helpImage), for: .normal)
        helpButton.setImageTitle(spacing: 10)
        helpButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 6)
        helpButton.imageView?.contentMode = .scaleAspectFit
        
        ratingImageView.image = UIImage.init(named: FoodieConstant.ratingUnselect)
        ratingImageView.image = ratingImageView.image?.withRenderingMode(.alwaysTemplate)
        ratingImageView.tintColor = .lightGray
        
        setCustomFont()
        setCustomColor()
        setDarkMode()
    }
    
    private func setDarkMode(){
         self.backGroundView.backgroundColor = .boxColor
         self.backGroundView.backgroundColor = .boxColor
     }
    
    private func dateFormatConvertion(dateString: String) -> String {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        let dateFormat = Int(baseConfig?.responseData?.appsetting?.date_format ?? "0")
        let dateFormatTo = dateFormat == 1 ? DateFormat.dd_mm_yyyy_hh_mm_ss : DateFormat.dd_mm_yyyy_hh_mm_ss_a
        let dateFormatReturn = dateFormat == 1 ? DateFormat.ddMMMyy24 : DateFormat.ddMMMyy12
        return AppUtils.shared.dateToString(dateStr: dateString, dateFormatTo: dateFormatTo, dateFormatReturn: dateFormatReturn)
    }
    
    private func setCustomFont() {
        
        orderIdLabel.font = .setCustomFont(name: .bold, size: .x14)
        orderTypeLabel.font = .setCustomFont(name: .medium, size: .x12)
        orderListLabel.font = .setCustomFont(name: .medium, size: .x14)
        dateLabel.font = .setCustomFont(name: .medium, size: .x14)
        timeLabel.font = .setCustomFont(name: .medium, size: .x14)
        ratingLabel.font = .setCustomFont(name: .medium, size: .x14)
        callButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        helpButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        cancelButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    private func setCustomColor() {
        dateBackgroundView.backgroundColor = .appPrimaryColor
       // cancelButton.setTitleColor(.appPrimaryColor, for: .normal)
    }
    
    // UiDesign
    
    private func updateUI() {
        if historyType == .past {
            callOuterView.isHidden = true
            helpOuterView.isHidden = true
            cancelOuterView.isHidden = true
            ratingOuterView.isHidden = false
        }
        else if historyType == .ongoing {
            callOuterView.isHidden = false
            helpOuterView.isHidden = true
            cancelOuterView.isHidden = true
            ratingOuterView.isHidden = true
        }
        else{
            callOuterView.isHidden = true
            helpOuterView.isHidden = false
            cancelOuterView.isHidden = true
            ratingOuterView.isHidden = true
        }
    }
}
