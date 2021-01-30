//
//  WalkThroughCell.swift
//  GoJekProvider
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Lottie

struct AnimationModel {
    var title: String
    var description: String
    var fileName: String
}

class WalkThroughCell: UICollectionViewCell {
    
    @IBOutlet weak var walkThroughImage: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var animationView: AnimationView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //Set custom font
        headingLabel.font = .setCustomFont(name: .medium, size: .x20)
        contentLabel.font = .setCustomFont(name: .light, size: .x14)
        
        contentLabel.textColor = .lightGray
        self.contentView.backgroundColor = .backgroundColor
    }
    
    func setValues(image: String, heading: String,content: String) {
        headingLabel.text = heading
        contentLabel.text = content
        walkThroughImage.image = UIImage(named: image)
    }
    
    func playAnimation(animationDetails:AnimationModel){
        
        headingLabel.text = animationDetails.title
        contentLabel.text = animationDetails.description
        if let _ = animationView {
            animationView.removeFromSuperview()
            
        }
        
        animationView = AnimationView(name: animationDetails.fileName)
        animationView.frame = self.bounds
        animationView.contentMode = .scaleAspectFit
        contentView.addSubview(animationView)
        animationView.play()
        contentView.bringSubviewToFront(headingLabel)
        contentView.bringSubviewToFront(contentLabel)
        
    }
    
    func playAnimation(){
        self.layoutIfNeeded()
        if let _ = animationView {
            animationView.play()
        }
    }

}
