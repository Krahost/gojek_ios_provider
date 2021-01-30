//
//  AccountCollectionViewCell.swift
//  GoJekProvider
//
//  Created by apple on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellOuterView: UIView!
    @IBOutlet weak var accountContentLabel: UILabel!
    @IBOutlet weak var accountImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellOuterView.backgroundColor = .appPrimaryColor
        cellOuterView.layer.cornerRadius = 5.0
        cellOuterView.superview?.layer.cornerRadius = 5.0
        accountContentLabel.font = .setCustomFont(name: .bold, size: .x14)
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
     }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.cellOuterView.setCornerRadius()
    }
    
    func setValues(name:String, imageString: String) {
        accountContentLabel.text = name.localized
        accountContentLabel.textColor = .darkGray
        accountImage.image = UIImage(named: imageString)
        accountImage.imageTintColor(color1: .white)
    }
}
