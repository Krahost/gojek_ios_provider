//
//  ButtonExtension.swift
//  GoJekProvider
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension UIButton {
    
    //Set cornor radius based on width or height
    func setCornorRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    //Set Image spance with button
    func setImageTitle(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    //Set title color
    func textColor(color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
    //Set button border with color
    func setBorderwithColor(borderColor: UIColor, textColor: UIColor, backGroundColor: UIColor, borderWidth: CGFloat) {
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = backGroundColor
        self.layer.borderWidth = borderWidth
    }
    
    func changeToRight(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }

    class func CustomButton(target: AnyObject?, selector: Selector?) -> UIButton {

        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if target != nil && selector != nil {
            button.addTarget(target, action: selector!, for: .touchUpInside)
        }
        return button
    }
}
