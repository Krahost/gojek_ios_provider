//
//  LoadingIndicator.swift
//  GoJekProvider
//
//  Created by Rajes on 13/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Lottie

class LoadingIndicator: NSObject{
    
    static var close: (() -> Void)? = {}
    static var backgroundView:UIView = {
        let sView = UIView()
        sView.tag = 10001
        sView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return sView
    }()
    
    static var contentView:AnimationView = {
        let sView = AnimationView(name: "Loader_Color")
        sView.loopMode = .loop
        sView.translatesAutoresizingMaskIntoConstraints = false
        sView.backgroundColor = .clear
        return sView
    }()
    
    static func frameSetup(){
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        contentView.widthAnchor.constraint(equalTo: window!.widthAnchor, multiplier: 0.2).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: window!.widthAnchor, multiplier: 0.2).isActive = true
        contentView.centerYAnchor.constraint(equalTo: window!.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: window!.centerXAnchor).isActive = true
    }
    
    static func show() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            contentView.play()
            for bView in window!.subviews where bView.tag == 10001 {
                hide()
            }
            backgroundView.frame = window!.bounds
            backgroundView.addSubview(contentView)
            window!.addSubview(backgroundView)
            frameSetup()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            contentView.stop()
            contentView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
}


