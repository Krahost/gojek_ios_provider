//
//  PaymentTypeTableViewCell.swift
//  GoJekProvider
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PaymentTypeTableViewCell: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardBakgroundView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardNameLabel.font = .setCustomFont(name: .medium, size: .x16)
        cardNameLabel.textColor = .blackColor
        backgroundColor = .backgroundColor
        backgroundColor = .backgroundColor

        cardBakgroundView.backgroundColor = .boxColor
    }
    
    func setPaymentValue(payment: Payments) {
        cardNameLabel.text = payment.name?.uppercased()
        
        switch payment.name?.uppercased() {
        case Constant.cash.uppercased():
            cardTypeImageView.image = UIImage(named: Constant.ic_money)
        default:
            cardTypeImageView.image = UIImage(named: Constant.ic_creditCard)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
