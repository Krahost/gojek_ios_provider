//
//  SupportController.swift
//  GoJekProvider
//
//  Created by Ansar on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import MessageUI

class SupportController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var stackView:UIStackView!
    @IBOutlet weak var supportHeadingLabel:UILabel!
    @IBOutlet weak var contactTeamLabel:UILabel!
    @IBOutlet weak var callLabel:UILabel!
    @IBOutlet weak var mailStaticLabel:UILabel!
    @IBOutlet weak var websiteStaticLabel:UILabel!
    
    @IBOutlet weak var supportImage:UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var callView: UIView!
    
    //MARK: - LocalVariable
    
    var imagesArr = [MyAccountConstant.phone, MyAccountConstant.mailImage, MyAccountConstant.web]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        hideTabBar()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        viewDidSetup() 
    }
}

//MARK: - LocalMethod

extension SupportController {
    
    private func viewDidSetup() {
        
        title = MyAccountConstant.support.localized
        setLeftBarButtonWith(color: .blackColor)
        self.setNavigationTitle()
        
        supportHeadingLabel.text = MyAccountConstant.supportDesc.localized
        callLabel.text = MyAccountConstant.call.localized
        mailStaticLabel.text = MyAccountConstant.mail.localized
        websiteStaticLabel.text = MyAccountConstant.website.localized
        contactTeamLabel.text = MyAccountConstant.contactOurTeam.localized
        supportImage.image = UIImage(named: MyAccountConstant.supportImage)
        supportImage.imageTintColor(color1: .blackColor)
        
        //Call set custom color
        setCustomColor()
        
        //Call set customImage
        setCustomImages()
        
        //Call set custom font
        setCustomFont()
        setDarkMode()
    }
    
    private func setDarkMode(){
          self.view.backgroundColor = .backgroundColor
          self.outterView.backgroundColor = .boxColor
      }
    
    private func setCustomColor() {
        
        view.backgroundColor = .veryLightGray
        topView.backgroundColor = .boxColor
        supportHeadingLabel.textColor = .blackColor
        websiteStaticLabel.textColor = .blackColor
        callLabel.textColor = .blackColor
        mailStaticLabel.textColor = .blackColor
    }
    
    private func setCustomFont() {
        
        supportHeadingLabel.font = .setCustomFont(name: .bold, size: .x14)
        contactTeamLabel.font = .setCustomFont(name: .bold, size: .x16)
        websiteStaticLabel.font = .setCustomFont(name: .bold, size: .x14)
        callLabel.font = .setCustomFont(name: .bold, size: .x14)
        mailStaticLabel.font = .setCustomFont(name: .bold, size: .x14)
    }
    
    
    private func setCustomImages()  {
        for view in stackView.subviews {
            let viewGesture = UITapGestureRecognizer(target: self, action: #selector(tapSupportContent(_:)))
            viewGesture.view?.tag = view.tag
            view.addGestureRecognizer(viewGesture)
            if let innerView = view.subviews.first {
                innerView.backgroundColor = .lightGray
                DispatchQueue.main.async {
                    innerView.setCornerRadius()
                }
                
                for components in innerView.subviews {
                    if let image = components as? UIImageView {
                        image.image = UIImage(named: imagesArr[image.tag])
                        image.imageTintColor(color1: .blackColor)
                    }
                }
            }
        }
    }
}

//MARK: - IBAction

extension SupportController {
    
    @objc private func tapSupportContent(_ sender:UITapGestureRecognizer) {
        
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        
        if sender.view?.tag == 1 {
            if let supportCall = baseConfig?.responseData?.appsetting?.supportdetails?.contact_number?.first?.number {
                let trimnumberCall = supportCall.removeWhitespace()
                               print(trimnumberCall)
                               AppUtils.shared.call(to: trimnumberCall)
            }
        }else if sender.view?.tag == 2 {
            if let email = baseConfig?.responseData?.appsetting?.supportdetails?.contact_email {
                openMailApp(emailStr: email)
            }
        }else {
            if let website = baseConfig?.responseData?.appsetting?.cmspage?.help {
                AppUtils.shared.open(url: website)
                
            }
        }
    }
    private func openMailApp(emailStr: String){
        let subject = "Hi \(APPConstant.appName) Team"
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([emailStr])
            mailComposerVC.setSubject(subject)
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            let coded = "mailto:\(emailStr)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded ?? "") {
                if UIApplication.shared.canOpenURL(emailURL) {
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                        if !result {
                            // show some Toast or error alert
                            //("Your device is not currently configured to send mail.")
                            self.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: String.Empty, message: LoginConstant.couldnotOpenEmailAttheMoment.localized,state: .error)
                            
                        }
                    })
                }else {
                    sendMailAlert()
                }
            }
        }
    }
    
    private func sendMailAlert() {
        self.simpleAlert(view: UIApplication.topViewController() ?? UIViewController(), title: String.Empty, message: LoginConstant.couldnotOpenEmailAttheMoment.localized,state: .error)
    }
}

//MARK: - MFMailComposeViewControllerDelegate

extension SupportController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
