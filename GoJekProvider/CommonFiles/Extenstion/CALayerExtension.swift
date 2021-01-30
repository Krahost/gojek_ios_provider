//
//  CALayerExtension.swift
//  GoJekProvider
//
//  Created by apple on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0.0, y: 0.0, width: self.frame.size.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.size.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.size.height - thickness, y: 0, width: thickness, height: self.frame.size.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
