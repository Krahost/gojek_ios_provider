//
//  XuberHelpView.swift
//  GoJekProvider
//
//  Created by CSS on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberHelpView: UIView {
    
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var instructionDescriptionLabel: UILabel!
    @IBOutlet weak var helpimageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var onClickClose:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        instructionLabel.text = "Instruction"
        imageLabel.text = "Image"
        instructionDescriptionLabel.textColor = .lightGray
        instructionDescriptionLabel.font = .setCustomFont(name: .bold, size: .x18)
        instructionLabel.font = .setCustomFont(name: .bold, size: .x18)
        instructionLabel.textColor = .black
        
        imageLabel.font = .setCustomFont(name: .bold, size: .x18)
        imageLabel.textColor = .black
        closeImageView.image = UIImage(named: XuberConstant.cancelImage)
        closeButton.addTarget(self, action: #selector(tapCancelImage), for: .touchUpInside)
    }

    @objc func tapCancelImage(){
        
        onClickClose!()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.overView.setCornerRadiuswithValue(value: 8)
    }
}
