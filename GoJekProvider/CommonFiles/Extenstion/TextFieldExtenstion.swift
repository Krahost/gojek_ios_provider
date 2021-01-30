//
//  TextFieldExtenstion.swift
//  GoJekProvider
//
//  Created by apple on 11/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension FloatRatingView {
    
    func setFloatRatingView() {
        self.minRating = 1
        self.maxRating = 5
        self.rating = 5
        self.type = .wholeRatings
        self.emptyImage = UIImage(named: Constant.ratingunSelect)
        self.fullImage = UIImage(named: Constant.ratingSelect)
    }
}

extension UITextField {
    
    func setLeftView(imageStr:String)  {
        
        let leftViewContainer = UIView()
        let leftImageView =  UIImageView()
        let image = UIImage(named: imageStr)
        leftImageView.image = image
        // let imageHeight = self.frame.height/3
        self.leftViewMode = .always
        leftImageView.frame = CGRect(x: 0 , y: 0, width: self.frame.height, height: self.frame.height)
        leftViewContainer.frame = leftImageView.frame
        leftImageView.frame.size.width =  leftImageView.frame.size.width / 2.5
        leftImageView.frame.size.height =  leftImageView.frame.size.width
        leftImageView.center  = leftViewContainer.center
        leftViewContainer.addSubview(leftImageView)
        self.leftView = leftViewContainer//leftImageView
    }
    
    func setCurrency(currency:String)  {
        let currencyLabel =  UILabel()
        currencyLabel.text = currency
        currencyLabel.font = .setCustomFont(name: .bold, size: .x14)
        self.leftViewMode = .always
        currencyLabel.frame = CGRect(x: 8 , y: 0, width: self.frame.height, height: self.frame.height)
        self.leftView = currencyLabel//leftImageView
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.boxColor.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.blackColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}


