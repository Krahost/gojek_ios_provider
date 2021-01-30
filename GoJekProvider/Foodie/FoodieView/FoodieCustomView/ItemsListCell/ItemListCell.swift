//
//  ItemListCell.swift
//  GoJekProvider
//
//  Created by Ansar on 04/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ItemListCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addOnLabel: UILabel!
    @IBOutlet weak var bottomViewLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        itemNameLabel.font = .setCustomFont(name: .medium, size: .x14)
        priceLabel.font = .setCustomFont(name: .medium, size: .x14)
        addOnLabel.font = .setCustomFont(name: .medium, size: .x12)
        self.contentView.backgroundColor = .backgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ItemListCell {
    
    func setValues(values: Items) {
        
        if CommonFunction.checkisRTL() {
            priceLabel.textAlignment = .left
        }else {
            priceLabel.textAlignment = .right
        }
        
        let productName = values.product?.item_name ?? String.Empty
        let qty = values.quantity ?? 0
        itemNameLabel.text = productName.giveSpace + "x".giveSpace + qty.toString()
        let totalAmount = Double(values.total_item_price ?? 0)
        let cartDetails = getCartAddOnValue(values: values.cartaddon ?? [])
        priceLabel.text = (totalAmount).setCurrency() //+ cartDetails.1 - addon amount not used
        addOnLabel.text = cartDetails.0
    }
    
    func getCartAddOnValue(values: [cartaddon]) -> (String,Double) {
        var cartName:String = String.Empty
        var addOnAmount:Double = 0
        for cart in values {
            cartName = cartName + (cart.addon_name ?? String.Empty) + ","
            addOnAmount = addOnAmount + (cart.addon_price ?? 0)
        }
        cartName = String(cartName.dropLast())
        return (cartName,addOnAmount)
    }
}
