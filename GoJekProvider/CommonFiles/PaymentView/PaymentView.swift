//
//  PaymentView.swift
//  GoJekUser
//
//  Created by Ansar on 08/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PaymentView: UIView {
    
    @IBOutlet weak var addAmountButton: UIButton!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var walletOuterView: UIView!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var walletButtonStackView: UIStackView!
    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var walletTotalAmtLabel: UILabel!
    
    let baseModel = AppManager.share.getUserDetails()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addAmountButton.setCornorRadius()
    }
}

extension PaymentView {
    
    private func initialLoads() {
        addAmountButton.setTitle(Constant.addAmount.localized, for: .normal)
        setCustomFont()
        setCustomColor()
    }
    
    private func setCustomColor() {
        
        backgroundColor = .backgroundColor
//        cashTextField.placeholder = ""
        addAmountButton.backgroundColor = .appPrimaryColor
        cashTextField.backgroundColor = .veryLightGray
        cashTextField.textColor = .black
        walletOuterView.backgroundColor = .boxColor
        addAmountButton.setTitleColor(.white, for: .normal)
        
        var walletImage = UIImage.init(named: TaxiConstant.walletImage)
        walletImage = walletImage?.withRenderingMode(.alwaysTemplate)
        walletImage = walletImage?.imageTintColor(color: .appPrimaryColor)
        walletImageView.image = walletImage
    }
    
    private func setCustomFont() {
        
        let currencySymbol = baseModel?.currency_symbol ?? String.Empty
        walletTotalAmtLabel.font = .setCustomFont(name: .bold, size: .x22)
        walletLabel.font = .setCustomFont(name: .medium, size: .x16)
        currencyLabel.font = .setCustomFont(name: .bold, size: .x18)
        currencyLabel.text = currencySymbol
        walletTotalAmtLabel.textColor = .black
        walletTotalAmtLabel.textAlignment = .center
        addAmountButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x20)
        for subView in walletButtonStackView.subviews {
            if let button = subView as? UIButton {
                button.backgroundColor = .darkGray
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
                button.setCornerRadiuswithValue(value: 5.0)
                button.setTitle("\(button.tag*50)", for: .normal)
                button.addTarget(self, action: #selector(tapWalletCash(_:)), for: .touchUpInside)
            }
        }
        currencyLabel.adjustsFontSizeToFitWidth = true
    }
    
    @objc func tapWalletCash(_ sender: UIButton) {
        
        cashTextField.text = String(sender.titleLabel?.text ?? "")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
