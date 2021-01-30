//
//  MyQRCodeViewController.swift
//  GoJekProvider
//
//  Created by AppleMac on 27/02/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class MyQRCodeViewController: UIViewController {
    
    @IBOutlet weak var myQRImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        myAccountPresenter?.getProfileDetail()
        self.view.backgroundColor = .backgroundColor
    }
    
    private func setNavigationBar() {
        self.title = MyAccountConstant.myQRcode.localized
        self.setLeftBarButtonWith(color: .blackColor)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

//MARK:- MyAccountPresenterToMyAccountViewProtocol

extension MyQRCodeViewController: MyAccountPresenterToMyAccountViewProtocol {
    
    func viewProfileDetail(profileEntity: ProfileEntity) {
        if let profileDetail = profileEntity.responseData {
            AppManager.share.setUserDetails(details: profileDetail)
            
            let tempImage = UIImage(named: MyAccountConstant.icnScan)
            if let imageUrl = URL(string: profileDetail.qrcode_url ?? "") {
                myQRImage.sd_setImage(with: imageUrl, placeholderImage: tempImage)
            }else {
                myQRImage.image = tempImage
            }
            myQRImage.imageTintColor(color1: .blackColor)
        }
    }
}

