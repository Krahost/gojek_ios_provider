//
//  EarningsCell.swift
//  GoJekProvider
//
//  Created by CSS on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class EarningsCell: UICollectionViewCell {
    
    //MARk: - IBOutlet
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var singleLineView: UIView!
    @IBOutlet weak var earningsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    override func layoutSubviews() {
        earningsView.setGradientBackground(colorTop: UIColor.systemBlue.withAlphaComponent(0.5), colorBottom: .systemBlue)
        singleLineView.addSingleLineDash(color: .lightGray, width:  1)
        earningsView.setCornerRadiuswithValue(value: 10)
    }
    
    func setupView(){
        targetLabel.font = .setCustomFont(name: .medium, size: .x18)
        pointsLabel.font = .setCustomFont(name: .bold, size: .x26)

        targetLabel.textColor = .white
        pointsLabel.textColor = .white

    }
}
