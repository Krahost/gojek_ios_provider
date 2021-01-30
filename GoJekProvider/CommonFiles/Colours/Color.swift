//
//  Color.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Primary Color
    static var appPrimaryColor: UIColor {
               return UIColor(red: 0/255, green: 94/255, blue: 50/255, alpha: 1)

    }
    
    // Taxi Color
    static var taxiColor: UIColor {
        return UIColor(red: 255/255, green: 162/255, blue: 0/255, alpha: 1)
    }
    
    // Foodie Color
    static var foodieColor: UIColor {
        return UIColor(red: 252/255, green: 58/255, blue: 20/255, alpha: 1)
    }
    
    // Xuber Color
    static var xuberColor: UIColor {
        return UIColor(red: 38/255, green: 118/255, blue: 188/255, alpha: 1)
    }
    
    // Courier Color
    static var courierColor: UIColor
    {
       return UIColor(red: 237/255, green: 119/255, blue: 90/255, alpha: 1)
        
    }
    
    //Light Greay color
    static var veryLightGray: UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    }
    
//    static var backgroundColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor.black
//        }
//        else{
//            return UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1)
//        }
//    }
//    
//    
//    static var boxColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
//        }
//        else{
//            return UIColor.white
//        }
//    }
//    
//    static var blackColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor.white
//        }
//        else{
//            return UIColor.black
//        }
//    }
//    
//    static var whiteColor: UIColor
//    {
//        if(isDarkMode){
//            return UIColor.black
//        }
//        else{
//            return UIColor.white
//        }
//    }
    
    public class var backgroundColor : UIColor{
        return  UIColor(named: "backgroundColor") ?? UIColor.white
    }
    
    public class var boxColor : UIColor{
        return  UIColor(named: "boxColor") ?? UIColor.white
    }
    
    public class var blackColor : UIColor{
        return  UIColor(named: "blackColor") ?? UIColor.white
    }

    public class var whiteColor : UIColor{
        return  UIColor(named: "whiteColor") ?? UIColor.white
    }
    
    
}

