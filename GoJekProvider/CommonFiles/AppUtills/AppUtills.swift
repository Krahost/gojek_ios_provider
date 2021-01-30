//
//  AppUtills.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import MessageUI

class AppUtils: UIViewController {
    
    //Singleton class
    static let shared = AppUtils()
    
    //Email Validation
    func isValidEmail(emailStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    //MARK: Password Validation
    func isValidPassword(password : String) -> Bool{
        if( password.count >= 6){
            return true
        }
        return false
    }
    
    func isValidString(str: String)->Bool{
        if str != String.Empty {
            return true
        }
        return false
    }
    
    func isImageUpload(isbool: Bool)->Bool{
        if !isbool {
             return false
        }
         return true
    }
    
    //Validate mobile
    func isValidPhone(phone : String)->Bool{
        if (phone.count < 7) || (phone.count < 15) {
            return false
        }
        return true
    }
    
    //String Null validation
    func isStringEmpty(str:String) -> Bool {
        if (str.count == 0 || str == String.Empty || str == "(null)" || str.isEmpty || str == "<null>") {
            return true
        }
        return false
    }
    
    //Validate String
    func isStringValid(_ textFieldValue : String) -> Bool {
        for chr in textFieldValue {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                return false
            }
        }
        return true
    }
    
    //Get Countries from JSON
    func getCountries()->[Country]{
        var source: [Country] = []
        if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "countryCodes", ofType: "json") ?? String.Empty) as Data? {
            do{
                source = try JSONDecoder().decode([Country].self, from: data)
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return source
    }
    
    //Make Call
    
    func call(to number: String?) {
        print("Numbeer---->",number ?? "No Number")
        if let phoneNumber = number, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            self.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: String.Empty, message: LoginConstant.cannotMakeCallAtThisMoment.localized,state: .error)
        }
    }
    
    // Send Email
    func sendEmail(to mailId : [String], from view : UIViewController & MFMailComposeViewControllerDelegate,subject: String) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = view
            mail.setToRecipients(mailId)
            mail.setSubject(subject)
            view.present(mail, animated: true)
        }else {
            self.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: String.Empty, message: LoginConstant.couldnotOpenEmailAttheMoment.localized,state: .error)
        }
    }
    
    //Open Url
    func open(url urlString: String) {
        if let  url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func dateToString(dateStr: String, dateFormatTo: String, dateFormatReturn: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatTo
        let dateFromString = dateFormatter.date(from: dateStr)
        guard let currentDate = dateFromString else {
            return ""
        }
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormatReturn
        let stringFromDate = dateFormatter2.string(from: currentDate)
        return stringFromDate
    }
    
    func secondsToHoursMinutesSeconds (time: Int) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}



