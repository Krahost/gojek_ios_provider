//
//  ItemWithoutAddOnsTableViewCell.swift
//  GoJekProvider
//
//  Created by apple on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ItemWithoutAddOnsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Set custom color
        titleLabel.textColor =  .darkGray
        descriptionLabel.textColor = .darkGray
        
        //Set custom font
        titleLabel.font = .setCustomFont(name: .medium, size: .x16)
        descriptionLabel.font = .setCustomFont(name: .medium, size: .x16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
