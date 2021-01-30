//
//  CourierRequestListView.swift
//  GoJekProvider
//
//  Created by Chan Basha on 15/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierRequestListView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelSender: UILabel!
    @IBOutlet weak var labelSenderName: UILabel!
    
    @IBOutlet weak var labelNoOfdelivery: UILabel!
    
    @IBOutlet weak var labelDeliveryalue: UILabel!
    
    @IBOutlet weak var labelPickupLocation: UILabel!
    
    @IBOutlet weak var labelPickupLocationValue: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelPricValue: UILabel!
    
    
    @IBOutlet weak var btnAccept: UIButton!
    
    var tapOnAccept : (()->Void)?
    
   
    override func awakeFromNib()
    {
     
        
        initialLoads()
        
        
    }
    
    private func initialLoads()
    {
        
        setFont()
        setConstant()
        setDesign()
        self.btnAccept.addTarget(self, action: #selector(acceptAction(sender:)), for: .touchUpInside)
        
        
    }

    private func setFont(){
        
        labelPrice.font = .setCustomFont(name: .medium, size: .x16)
        labelPricValue.font = .setCustomFont(name: .medium, size: .x16)
        labelPickupLocation.font = .setCustomFont(name: .medium, size: .x16)
        labelPickupLocationValue.font = .setCustomFont(name: .medium, size: .x12)
        labelNoOfdelivery.font = .setCustomFont(name: .medium, size: .x16)
        labelDeliveryalue.font = .setCustomFont(name: .medium, size: .x16)
        labelSender.font = .setCustomFont(name: .medium, size: .x16)
        labelSenderName.font = .setCustomFont(name: .medium, size: .x16)
        btnAccept.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        
    
        
    }
    
    private func setConstant()
    {
       
        labelSender.text = "Sender"
        labelPickupLocation.text = "Pick Up Location"
        labelNoOfdelivery.text = "No Of Delivery"
        labelPrice.text = "Toatal Price"
        
        
        
        
    }
    
    private func setDesign(){
        
        
        bgView.layer.cornerRadius = 12
        labelSender.textColor = .lightGray
        labelPickupLocation.textColor = .lightGray
        labelNoOfdelivery.textColor = .lightGray
        labelPrice.textColor = .lightGray
        btnAccept.backgroundColor = .appPrimaryColor
        btnAccept.setTitleColor(.black, for: .normal)
        labelPricValue.textColor = .appPrimaryColor
        
        
    }
    
    @IBAction func acceptAction(sender:UIButton){
        
        self.tapOnAccept?()
    }
    
    
    
}
