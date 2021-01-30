//
//  PaymentCardCell.swift
//  GoJekUser
//
//  Created by Ansar on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class PaymentCardCell: UICollectionViewCell {
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    var isSelectedItem:Bool = false {
        didSet {
            self.layer.cornerRadius = 5.0
            self.layer.masksToBounds = true
            self.backgroundColor = isSelectedItem ? .appPrimaryColor : UIColor.lightGray.withAlphaComponent(0.2)
            cardLabel.textColor = isSelectedItem ? .white : .gray
            cardNameLabel.textColor = isSelectedItem ? .white : .gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardNameLabel.font = .setCustomFont(name: .medium, size: .x16)
        cardLabel.font = .setCustomFont(name: .medium, size: .x12)
    }

}
