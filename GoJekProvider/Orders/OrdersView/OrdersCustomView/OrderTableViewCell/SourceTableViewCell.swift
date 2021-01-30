//
//  SourceTableViewCell.swift
//  GoJekUser
//
//  Created by Sudar on 06/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var staticSourceLabel: UILabel!
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet weak var centerStatusView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sourceLabel.textColor = .lightGray
        sourceLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        staticSourceLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        staticSourceLabel.text = OrdersConstant.source.localized
        setDarkMode()
    }
    
    private func setDarkMode(){
         self.contentView.backgroundColor = .boxColor
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
