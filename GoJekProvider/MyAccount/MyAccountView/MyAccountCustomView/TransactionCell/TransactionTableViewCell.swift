//
//  TransactionTableViewCell.swift
//  GoJekProvider
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.transactionIdLabel.font = .setCustomFont(name: .bold, size: .x14)
        self.amountLabel.font = .setCustomFont(name: .bold, size: .x14)
        self.statusLabel.font = .setCustomFont(name: .bold, size: .x14)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
