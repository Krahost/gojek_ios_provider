//
//  IntExtension.swift
//  GoJekProvider
//
//  Created by CSS on 26/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

extension Int {
    
    func toString() -> String {
        return "\(self)"
    }
    
    static func removeNil(_ val : Int?)->Int{
        
        return val ?? 0
    }
}


