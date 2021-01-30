//
//  CourierRequestStatusView.swift
//  GoJekProvider
//
//  Created by Chan Basha on 05/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierRequestStatusView: UIView {
    
    //MARK:- IBOutlets

    @IBOutlet weak var invoiceButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pickupImage: UIImageView!
    @IBOutlet weak var dropImage: UIImageView!
    @IBOutlet weak var finishImage: UIImageView!
    @IBOutlet weak var dropDashView: UIView!
    @IBOutlet weak var processView: UIView!
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var labelCustomer: UILabel!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var buttonArrived: UIButton!
    @IBOutlet weak var buttonRecieved: UIButton!
    @IBOutlet weak var buttonDelivered: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonChat: UIButton!
    @IBOutlet weak var buttonReached: UIButton!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var imgCall: UIImageView!
    @IBOutlet weak var imgChat: UIImageView!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var imgNavigation: UIImageView!
    @IBOutlet weak var buttonNavigation: UIButton!
    @IBOutlet weak var outterStackView: UIStackView!
    

    
     //Local Variables
     var onClickButton: ((String?)->())?
     var callOrChat : ((Int?)->())?
    
    override func awakeFromNib(){
        setFont()
        setDesign()
        setConstant()
        buttonArrived.addTarget(self, action: #selector(arriveButtonAction(_:)), for: .touchUpInside)
        buttonRecieved.addTarget(self, action: #selector(pickupButtonAction(_:)), for: .touchUpInside)
        buttonDelivered.addTarget(self, action: #selector(dropButtonAction(_:)), for: .touchUpInside)
        buttonStart.addTarget(self, action: #selector(arriveButtonAction(_:)), for: .touchUpInside)
        buttonReached.addTarget(self, action: #selector(pickupButtonAction(_:)), for: .touchUpInside)
        buttonCall.tag = 1
        buttonChat.tag = 2
        buttonNavigation.tag = 3
        buttonCall.addTarget(self, action: #selector(callOrChatAction(_:)), for: .touchUpInside)
        buttonChat.addTarget(self, action: #selector(callOrChatAction(_:)), for: .touchUpInside)
        buttonNavigation.addTarget(self, action: #selector(navigationButtonAction(_:)), for: .touchUpInside)
        invoiceButton.addTarget(self, action: #selector(invoiveButtonAction(_:)), for: .touchUpInside)
        outterStackView.backgroundColor = .boxColor
        outterStackView.setCornerRadiuswithValue(value: 10)
        bottomView.backgroundColor = .boxColor
        
        invoiceButton.isHidden = true
    }
    
    private func setFont(){
        labelCustomer.font = .setCustomFont(name: .light, size: .x14)
        labelCustomerName.font = .setCustomFont(name: .bold, size: .x16)
        buttonArrived.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        buttonRecieved.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        buttonDelivered.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        buttonReached.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        buttonStart.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        invoiceButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x12)
    }
    
    private func setDesign(){
        userImageView.setCornerRadius()
        viewChat.setCornerRadius()
        viewCall.setCornerRadius()
        viewNavigation.setCornerRadius()

        buttonDelivered.backgroundColor = .courierColor
        buttonArrived.backgroundColor = .courierColor
        buttonRecieved.backgroundColor = .courierColor
        buttonReached.backgroundColor = .courierColor
        buttonStart.backgroundColor = .courierColor
        invoiceButton.backgroundColor = .courierColor
        buttonDelivered.setTitleColor(.white, for: .normal)
        buttonArrived.setTitleColor(.white, for: .normal)
        buttonRecieved.setTitleColor(.white, for: .normal)
        buttonStart.setTitleColor(.white, for: .normal)
        buttonReached.setTitleColor(.white, for: .normal)
        buttonArrived.layer.cornerRadius = 6
        buttonRecieved.layer.cornerRadius = 6
        buttonDelivered.layer.cornerRadius = 6
        buttonReached.layer.cornerRadius = 6
        buttonStart.layer.cornerRadius = 6
        invoiceButton.layer.cornerRadius = 6
        pickUpView.backgroundColor = .clear
        dropImage.backgroundColor = .clear
        finishView.backgroundColor = .clear
        
        DispatchQueue.main.async {
            self.imgCall.image = UIImage.init(named: CourierConstant.call)?.imageTintColor(color: .courierColor)
            self.imgChat.image = UIImage.init(named: CourierConstant.chat)?.imageTintColor(color: .courierColor)
            self.imgNavigation.image = UIImage.init(named: TaxiConstant.navigationImage)?.imageTintColor(color: .courierColor)

        }
    }
    
    private func setConstant(){
        buttonArrived.setTitle(CourierConstant.arrived.uppercased(), for: .normal)
        buttonRecieved.setTitle(CourierConstant.reachedurLoc.uppercased(), for: .normal)
        buttonDelivered.setTitle(CourierConstant.delivered.uppercased(), for: .normal)
        buttonStart.setTitle(CourierConstant.start.uppercased(), for: .normal)
        buttonReached.setTitle(CourierConstant.droped.uppercased(), for: .normal)
        invoiceButton.setTitle(CourierConstant.invoice.uppercased(), for: UIControl.State.normal)
    }
}

extension CourierRequestStatusView {
    
    @objc func arriveButtonAction(_ sender: UIButton){
        onClickButton?(TravelState.arrived.rawValue)
    }
    
    @objc func pickupButtonAction(_ sender: UIButton){
        onClickButton?(TravelState.droped.rawValue)
    }
    
    @objc func dropButtonAction(_ sender: UIButton) {
        onClickButton?(TravelState.completed.rawValue)
    }
    
    @objc func callOrChatAction(_ sender: UIButton) {
        callOrChat?(sender.tag)
    }
     @objc func navigationButtonAction(_ sender: UIButton) {
           onClickButton?(TaxiConstant.GoogleMap)
       }
    
    @objc func invoiveButtonAction(_ sender : UIButton){
        onClickButton?(TravelState.showInVoice.rawValue)
    }
}
