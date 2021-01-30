//
//  LottieViewManager.swift
//  GoJekProvider
//
//  Created by Rajes on 01/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Lottie

class LottieViewManager {
    
    static var  lottieView = AnimationView()
    
    static func playWithFrame(fileName:String,sourceView:UIView) {
        
        let animationView = AnimationView(name: fileName)
        lottieView = animationView
        lottieView.frame = sourceView.bounds
        lottieView.center = sourceView.center
        lottieView.contentMode = .scaleAspectFit
        sourceView.addSubview(lottieView)
    }
}
