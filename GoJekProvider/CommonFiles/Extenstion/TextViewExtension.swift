//
//  TextViewExtension.swift
//  GoJekProvider
//
//  Created by apple on 03/06/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension UITextView {
    
    class func CommonTextView(backgroundColor: UIColor, textColor: UIColor, textFont: UIFont) -> UITextView {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = backgroundColor
        textView.textColor = textColor
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.font = textFont
        return textView
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

