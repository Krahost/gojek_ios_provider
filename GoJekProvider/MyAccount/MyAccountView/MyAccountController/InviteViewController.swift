//
//  InviteViewController.swift
//  GoJekProvider
//
//  Created by CSS01 on 21/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    //MARK: - IBOutlet

    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var inviteReferralCodeView: UIView!
    @IBOutlet weak var referralDetailView: UIView!
    @IBOutlet weak var referalDescrLabel: UILabel!
    @IBOutlet weak var referralView: UIView!
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var referralCodeTitleLabel: UILabel!
    @IBOutlet weak var referralCodeLabel: UILabel!
    @IBOutlet weak var shareButtonView: RoundedView!
    
    @IBOutlet weak var referralCountTitleLabel: UILabel!
    @IBOutlet weak var referralAmountTitleLabel: UILabel!
    @IBOutlet weak var referralCountLabel: UILabel!
    @IBOutlet weak var referralAmountLabel: UILabel!
    
    //MARK: - Presenter

    var accountPresenter: MyAccountViewToMyAccountPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        hideTabBar()
    }
    
}

//MARK: - LocalMethod

extension InviteViewController {
    
    private func viewDidSetup() {
        
        title = MyAccountConstant.inviteReferral.localized
        setLeftBarButtonWith(color: .blackColor)
        
        inviteView.setCornerRadiuswithValue(value: 5.0)
        inviteReferralCodeView.setCornerRadiuswithValue(value: 5.0)
        referralDetailView.setCornerRadiuswithValue(value: 5.0)
        
        shareButtonView.backgroundColor = .appPrimaryColor
        shareButtonView.centerImage = UIImage(named: Constant.shareImage)
        shareButtonView.centerImageView.imageTintColor(color1: .white)

        referralView.setCornerRadiuswithValue(value: 5)
        
       // shareButtonView.centerImageView.imageTintColor(color1: .white)
        shareButtonView.addShadow(radius: 3.0, color: .lightGray)

        giftImageView.image = UIImage(named: MyAccountConstant.referFriend)
        giftImageView.imageTintColor(color1: UIColor.systemGreen.withAlphaComponent(0.5))
        view.backgroundColor = .backgroundColor
        
        if CommonFunction.checkisRTL() {
            self.referalDescrLabel.textAlignment = .right
        }
        
        //Call custom color method
        setCustomColor()
        
        //Call custom font method
        setCustomFont()
        
        //Call custom localization
        localize()
        
        let shareGesture =  UITapGestureRecognizer(target: self, action: #selector(tapShare))
        shareButtonView.addGestureRecognizer(shareGesture)
        setDarkMode()
    }
    
    
    func setDarkMode(){
        inviteView.backgroundColor = .boxColor
        inviteReferralCodeView.backgroundColor = .boxColor
        referralDetailView.backgroundColor = .boxColor
    }
  
    
    private func localize() {
        let currency = AppManager.share.getUserDetails()?.currency_symbol ?? String.Empty
        let referalCode = AppManager.share.getUserDetails()?.referral?.referral_code
        let referalCount = AppManager.share.getUserDetails()?.referral?.referral_count
        let referalAmount = AppManager.share.getUserDetails()?.referral?.referral_amount
        let userReferalCount = AppManager.share.getUserDetails()?.referral?.user_referral_count
        let userReferalAmount = AppManager.share.getUserDetails()?.referral?.user_referral_amount
        
        let inviteFriend = MyAccountConstant.inviteFriend.localized
        let referalAmt = " \(currency)\(referalAmount ?? 0) "
        let messageStr1 = inviteFriend + referalAmt
        let forEvery = MyAccountConstant.forEvery.localized
        let referalCnt = " \(referalCount?.toString() ?? "") "
        let messageStr2 = forEvery + referalCnt + MyAccountConstant.newUser.localized
        self.referalDescrLabel.textColor = .blackColor
        
        self.referalDescrLabel.attributeString(string: (messageStr1+"\n\n"+messageStr2), range1: NSRange(location: MyAccountConstant.inviteFriend.localized.count, length: referalAmt.count), range2: NSRange(location: messageStr1.count+forEvery.count+2, length: referalCnt.count), color: UIColor.systemGreen.withAlphaComponent(0.5))
        
        self.referralCodeLabel.text = referalCode
        self.referralCountLabel.text = " \(userReferalCount?.toString() ?? "") "
        self.referralAmountLabel.text = (currency)+(userReferalAmount?.toString() ?? "0")
        
        //Static
        referralCodeTitleLabel.text = MyAccountConstant.yourRefferalcode.localized
        referralCountTitleLabel.text = MyAccountConstant.referralCount.localized
        referralAmountTitleLabel.text = MyAccountConstant.referralAmount.localized
        
        referralCountLabel.textColor = .lightGray
        referralAmountLabel.textColor = .lightGray

    }
    
    //Set custom font
    private func setCustomFont() {
        
        referalDescrLabel.font = .setCustomFont(name: .bold, size: .x14)
        referralCodeTitleLabel.font = .setCustomFont(name: .bold, size: .x16)
        referralCodeLabel.font = .setCustomFont(name: .bold, size: .x16)
        referralCountTitleLabel.font = .setCustomFont(name: .bold, size: .x16)
        referralAmountTitleLabel.font = .setCustomFont(name: .bold, size: .x16)
        referralCountLabel.font = .setCustomFont(name: .bold, size: .x16)
        referralAmountLabel.font = .setCustomFont(name: .bold, size: .x16)
    }
    
    //Set custom color
    private func setCustomColor() {
        
        shareButtonView.backgroundColor = .appPrimaryColor
        referralCodeLabel.textColor = .lightGray
        
    }
    
    @objc func tapShare()  {
        var message = MyAccountConstant.inviteContent.localized + referralCodeLabel.text! + "\n"
        message += APPConstant.userAppStoreLink + "\n"
        message += MyAccountConstant.haveGoodDay.localized
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }

}
