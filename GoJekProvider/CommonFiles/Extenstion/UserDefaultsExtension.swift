//
//  UserDefaultsExtension.swift
//  GoJekProvider
//
//  Created by apple on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    //UserDefaults add String
    public func addStringToUserDefaults(value: String, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    //UserDefaults get String
    public func getStringFromUserDefaults(key: String) ->(String) {
        var valueDefault = UserDefaults.standard.value(forKey: key)
        if valueDefault == nil{
            valueDefault = String.Empty
        }
        return valueDefault as! (String)
    }
    
    //UserDefaults - add int
    public func addIntToUserDefaults(value: Int, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    //UserDefaults - get int
    public func getIntFromUserDefaults(key: String) ->(Int){
        let valueDefault = UserDefaults.standard.integer(forKey: key)
        return valueDefault
    }
    
    //Check UserDefault exists
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    // UserDefaults - Remove value
    public func removeStringFromUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    //Remove userDefault allValue
    func removeAllUserDefaultValues() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
}
