//
//  LanguageTableViewCell.swift
//  GoJekProvider
//
//  Created by CSS on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
    }
    
    private func initalLoads(){
        languageNameLabel.font = .setCustomFont(name: .light, size: .x16)
        radioImageView.image = UIImage(named: MyAccountConstant.circleImage)
        self.clipsToBounds = true
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
        self.radioImageView.setImageColor(color: .blackColor)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
