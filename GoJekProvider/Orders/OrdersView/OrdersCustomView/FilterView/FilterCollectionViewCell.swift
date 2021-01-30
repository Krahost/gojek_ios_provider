//
//  FilterCollectionViewCell.swift
//  MySample
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 CSS01. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOUtlet
    @IBOutlet weak var serviceTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            self.serviceTitleLabel.setCornerRadius()
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        serviceTitleLabel.font = .setCustomFont(name: .medium, size: .x16)
    }
}
