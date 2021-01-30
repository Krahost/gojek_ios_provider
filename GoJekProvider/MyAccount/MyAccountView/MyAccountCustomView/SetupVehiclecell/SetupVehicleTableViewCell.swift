//
//  SetupVehicleTableViewCell.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class SetupVehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var overView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SetupVehicleTableViewCell {
    
    private func initalLoads() {
        
        contentView.backgroundColor = .backgroundColor
        tickImageView.image = UIImage(named: MyAccountConstant.check)
        vehicleNameLabel.font = .setCustomFont(name: .light, size: .x16)
        overView.adddropshadow(radius: 5)
        overView.backgroundColor = .boxColor
        tickImageView.isHidden = true
        statusSwitch.onTintColor = .appPrimaryColor
        statusSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    func setRideTypeData(data: RideTypeData) {
        
        vehicleNameLabel.text = data.ride_name
        if data.providerservice != nil {
            tickImageView.isHidden = false
        }
        else {
            tickImageView.isHidden = true
        }
        if(data.providerservice == nil){
            statusSwitch.isHidden = true
        }
        else{
        if (data.providerservice?.status ?? "").uppercased() == "ASSESSING" {
            statusSwitch.isHidden = true
        }
        else{
            statusSwitch.isHidden = false
            if (data.providerservice?.status ?? "").uppercased() == "ACTIVE" {
                statusSwitch.setOn(true, animated: true)
            }
            else{
                statusSwitch.setOn(false, animated: true)
            }
         }
        }
    }
    
    func setShopTypeData(data: ShoptypeResponseData) {
        
        vehicleNameLabel.text = data.name
        if data.providerservice != nil {
            tickImageView.isHidden = false
        }
        else {
            tickImageView.isHidden = true
        }
        if(data.providerservice == nil){
               statusSwitch.isHidden = true
           }
           else{
           if (data.providerservice?.status ?? "").uppercased() == "ASSESSING" {
               statusSwitch.isHidden = true
           }
           else{
               statusSwitch.isHidden = false
               if (data.providerservice?.status ?? "").uppercased() == "ACTIVE" {
                   statusSwitch.setOn(true, animated: true)
               }
               else{
                   statusSwitch.setOn(false, animated: true)
               }
            }
           }
        
    }
    
    
    func setDeliveryData(data:DeliverytypeResponseData){
        
        vehicleNameLabel.text = data.delivery_name
        if data.providerservice != nil {
            tickImageView.isHidden = false
        }
        else {
            tickImageView.isHidden = true
        }
        if(data.providerservice == nil){
               statusSwitch.isHidden = true
           }
           else{
           if (data.providerservice?.status ?? "").uppercased() == "ASSESSING" {
               statusSwitch.isHidden = true
           }
           else{
               statusSwitch.isHidden = false
               if (data.providerservice?.status ?? "").uppercased() == "ACTIVE" {
                   statusSwitch.setOn(true, animated: true)
               }
               else{
                   statusSwitch.setOn(false, animated: true)
               }
            }
           }
    }
}
