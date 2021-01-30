//
//  TollChargeView.swift
//  GoJekProvider
//
//  Created by apple on 23/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TollChargeView: UIView {
    
    @IBOutlet weak var tollChargeTitleLabel: UILabel!
    @IBOutlet weak var tollChargeTextField: UITextField!
    @IBOutlet weak var seperaterLabel: UILabel!
    @IBOutlet weak var tollChargeSubmitButton: UIButton!
    @IBOutlet weak var tollChargeView: UIView!
    @IBOutlet weak var tollChargeCancelButton: UIButton!
    
    var onClickSubmit: ((String?)->())?
    var onClickCancel: (()->())?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tollChargeTitleLabel.font = .setCustomFont(name: .bold, size: .x16)
        tollChargeSubmitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        tollChargeCancelButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        tollChargeTextField.font = .setCustomFont(name: .bold, size: .x20)
        tollChargeCancelButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        tollChargeCancelButton.setTitle(Constant.cancel, for: .normal)
        tollChargeCancelButton.textColor(color: .xuberColor)
        tollChargeCancelButton.addTarget(self, action: #selector(tollChargeCancelButtonAction(_:)), for: .touchUpInside)
        tollChargeView.setCornerRadiuswithValue(value: 5.0)
        tollChargeSubmitButton.setTitle(TaxiConstant.submit.localized, for: .normal)
        tollChargeCancelButton.setTitle(Constant.cancel.localized, for: .normal)
        tollChargeSubmitButton.textColor(color: .xuberColor)
        tollChargeCancelButton.textColor(color: .xuberColor)
        tollChargeSubmitButton.addTarget(self, action: #selector(tollChargeSubmitButtonAction(_:)), for: .touchUpInside)
        tollChargeCancelButton.addTarget(self, action: #selector(tollChargeCancelButtonAction(_:)), for: .touchUpInside)
        
        let userDetails = AppManager.share.getUserDetails()
        tollChargeTitleLabel.text = "\(TaxiConstant.tollCharge.localized) ( \(userDetails?.currency ?? "") )".uppercased()
        tollChargeTextField.placeholder = "0"
        tollChargeView.backgroundColor = .boxColor
    }
    
    @objc func tollChargeSubmitButtonAction(_ sender: UIButton) {
        onClickSubmit?(tollChargeTextField.text)
    }
    
    @objc func tollChargeCancelButtonAction(_ sender: UIButton) {
        onClickCancel?()

    }
    
    
}
