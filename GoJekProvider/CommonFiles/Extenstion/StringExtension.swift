//
//  StringExtension.swift
//  GoJekProvider
//
//  Created by Ansar on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

var currentBundle: Bundle!

extension String {
    
    //Check sting is empty
    static var Empty: String {
        return ""
    }
    
    func toInt() -> Bool {
        return Int(self) != nil
    }
    
    var giveSpace: String {
        return self + " "
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    //If sting have value or not
    static func removeNil(_ value : String?) -> String{
        return value ?? String.Empty
    }
    
    //Validate is number
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    //Remove white spaces
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    //Change localise language
    func localize()->String{
        return NSLocalizedString(self, bundle: currentBundle, comment: String.Empty)
        
    }
    
    //Mark:- Localize String varibale
    var localized: String {
        
        guard let path = Bundle.main.path(forResource: LocalizeManager.share.currentlocalization(), ofType: "lproj") else {
            return NSLocalizedString(self, comment: "returns a chosen localized string")
        }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: String.Empty, comment: String.Empty)
        
    }
    
    //Make first letter has capital letter
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var isValidPassword: Bool {
        return self.count >= 6
    }
    
    // Validate MobileNumber
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    // Method to convert JSON String to Dictionary
    func stringToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toDictionary() -> NSDictionary {
        let blankDict : NSDictionary = [:]
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return blankDict
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
        
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func isInt() -> Bool {
        return Int(self) != nil
    }
    
    func heightOfString(usingFont font: UIFont,width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
}

// Conversion of UTC Local
func UTCToLocalToHours(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "HH:mm:ss"
    
    return dateFormatter.string(from: dt ?? Date())
}

// Conversion of UTC Local
func UTCToLocal(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: dt ?? Date())
}

// time calculation

func dateDiff(dateStr:String) -> String {
    let f:DateFormatter = DateFormatter()
    f.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let showDate = inputFormatter.date(from: dateStr)
    
    let date1:Date = showDate!
    let date2: Date = Date()
    let calendar: Calendar = Calendar.current
    
    let components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
    
    let weeks = Int(components.month!)
    let days = Int(components.day!)
    let hours = Int(components.hour!)
    let min = Int(components.minute!)
    let sec = Int(components.second!)
    let year = Int(components.year!)
    
    var timeAgo = String.Empty
    if sec == 0 {
        timeAgo = "just now"
    }else if (sec > 0){
        if (sec >= 2) {
            timeAgo = "\(sec) secs ago"
        } else {
            timeAgo = "\(sec) sec ago"
        }
    }
    
    if (min > 0){
        if (min >= 2) {
            timeAgo = "\(min) mins ago"
        } else {
            timeAgo = "\(min) min ago"
        }
    }
    
    if(hours > 0){
        if (hours >= 2) {
            timeAgo = "\(hours) hrs ago"
        } else {
            timeAgo = "\(hours) hr ago"
        }
    }
    
    if (days > 0) {
        if (days >= 2) {
            timeAgo = "\(days) days ago"
        } else {
            timeAgo = "\(days) day ago"
        }
    }
    
    if(weeks > 0){
        if (weeks >= 2) {
            timeAgo = "\(weeks) months ago"
        } else {
            timeAgo = "\(weeks) month ago"
        }
    }
    
    if(year > 0){
        if (year >= 2) {
            timeAgo = "\(year) years ago"
        } else {
            timeAgo = "\(year) year ago"
        }
    }
    return timeAgo;
    
    
}
extension String {
  func replace(string:String, replacement:String) -> String {
      return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
  }

  func removeWhitespace() -> String {
      return self.replace(string: " ", replacement: "")
  }
}
