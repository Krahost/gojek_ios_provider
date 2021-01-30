//
//  payStackView.swift
//  GoJekProvider
//
//  Created by apple on 23/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PayStackView: UIView {
    
    @IBOutlet weak var walletTitleLabel: UILabel!
    @IBOutlet weak var walletAmtTextField: UITextField!
    @IBOutlet weak var seperaterLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var payStackView: UIView!
    
    var onClickSubmit: ((String?)->())?
    
    var onClickCancel: ((String?)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.walletAmtTextField.delegate = self as? UITextFieldDelegate
        self.walletTitleLabel.font = UIFont.setCustomFont(name: .bold, size: .x16)
        self.submitButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.cancelButton.titleLabel?.font = UIFont.setCustomFont(name: .bold, size: .x18)
        self.walletAmtTextField.font = UIFont.setCustomFont(name: .bold, size: .x20)
        
        self.payStackView.setCornerRadiuswithValue(value: 5.0)
        self.submitButton.setTitle(Constant.submit.localized, for: .normal)
        self.cancelButton.setTitle(Constant.cancel.localized, for: .normal)
        self.cancelButton.textColor(color: .xuberColor)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        
        self.submitButton.textColor(color: .xuberColor)
        self.submitButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
        
        let userDetails = AppManager.share.getUserDetails()
        self.walletTitleLabel.text = "\(Constant.wallet.localized) ( \(userDetails?.currency_symbol ?? "$") )".uppercased()
        self.payStackView.backgroundColor = .boxColor
    }
    
    @objc func submitButtonAction(_ sender: UIButton) {
        onClickSubmit?(walletAmtTextField.text)
    }
    
    @objc func cancelButtonAction(_ sender: UIButton) {
        onClickCancel?(walletAmtTextField.text)
    }
}
