//
//  ManageServiceTableViewCell.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ManageServiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var innerSideView: UIView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var servicedescriptionLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalSetup()
    }
    
    private func initalSetup(){
        setImage()
        setCustomFont()
    }
    
    func setAdminServiceData(data: AdminServiceData){
        if data.admin_service == ServiceType.transport.rawValue {
            serviceImageview.image = UIImage(named: MyAccountConstant.deliveryMan)
            sideView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.8)
            serviceNameLabel.text = MyAccountConstant.transportTitle.localized
            if data.providerservices != nil {
                servicedescriptionLabel.text = MyAccountConstant.showVehicle.localized
                
            }else{
                servicedescriptionLabel.text = MyAccountConstant.transportDescription.localized
            }
            serviceImageview.imageTintColor(color1: UIColor.systemPink.withAlphaComponent(0.8))
        }else if data.admin_service == ServiceType.order.rawValue {
            serviceImageview.image = UIImage(named: MyAccountConstant.scooter)
            sideView.backgroundColor = .systemGreen
            serviceImageview.imageTintColor(color1: .systemGreen)
            serviceNameLabel.text = MyAccountConstant.orderTitle.localized
            if data.providerservices != nil {
                servicedescriptionLabel.text = MyAccountConstant.showDelivery.localized
                
            }else{
                servicedescriptionLabel.text = MyAccountConstant.orderDescription.localized
            }
        }else if data.admin_service == ServiceType.service.rawValue {
            serviceImageview.image = UIImage(named: MyAccountConstant.repairingService)
            let violetColor: UIColor =  UIColor(red: 124/255.0, green: 35/255.0, blue: 146/255.0, alpha: 1.0)
            serviceImageview.imageTintColor(color1: violetColor)
            sideView.backgroundColor = violetColor
            serviceNameLabel.text = MyAccountConstant.serviceTitle.localized
            if data.providerservices != nil {
                servicedescriptionLabel.text = MyAccountConstant.showService.localized
            }else{
                servicedescriptionLabel.text = MyAccountConstant.serviceDescription.localized
            }
        }else if  data.admin_service == ServiceType.delivery.rawValue {
           serviceImageview.image = UIImage(named: MyAccountConstant.scooter)
            serviceImageview.imageTintColor(color1:.courierColor)
            sideView.backgroundColor = .courierColor
            serviceNameLabel.text = MyAccountConstant.courierDelivery.localized
            if data.providerservices != nil {
                servicedescriptionLabel.text = MyAccountConstant.showDelivery.localized
            }else{
                servicedescriptionLabel.text = MyAccountConstant.courierDescription.localized
            }
            
        }
    }
    
    private func setImage(){
        rightArrowImageView.image = UIImage(named: MyAccountConstant.rightArrow)
        if CommonFunction.checkisRTL() {
            rightArrowImageView.transform = rightArrowImageView.transform.rotated(by: .pi)
        }
    }
    
    // set custom font
    private func setCustomFont() {
        serviceView.adddropshadow(radius: 5)
        serviceView.backgroundColor = .boxColor
        contentView.backgroundColor = .backgroundColor
        servicedescriptionLabel.textColor = .lightGray
        serviceNameLabel.font = .setCustomFont(name: .bold, size: .x16)
        servicedescriptionLabel.font = .setCustomFont(name: .light, size: .x14)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
