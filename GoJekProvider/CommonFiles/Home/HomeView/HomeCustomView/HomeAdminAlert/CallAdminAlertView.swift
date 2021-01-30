//
//  CallAdminAlertView.swift
//  GoJekProvider
//
//  Created by apple on 07/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit



class CallAdminAlertView: UIView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var callAdminView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var callAdminButton: UIButton!

    //MARK: - BlockMethod
    var onClickSubmit: ((String)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewDidSetup()
    }
}

//MARK: - LocalMethod

extension CallAdminAlertView {
    
    func viewDidSetup() {

        //Set custom design
        callAdminView.layer.cornerRadius = 5.0
        callAdminView.layer.masksToBounds = true
        callAdminButton.setCornerRadius()
        
        //Add action to calladmin button
        callAdminButton.addTarget(self, action: #selector(callAdminButtonAction), for: .touchUpInside)
        
        setCustomLocalization()
        setCustomColor()
        setCustomFont()
    }
    
    private func setCustomFont() {
        
        alertTitleLabel.font = .setCustomFont(name: .medium, size: .x18)
        alertDescriptionLabel.font = .setCustomFont(name: .light, size: .x16)
        callAdminButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x20)
    }
    
    private func setCustomColor() {
        
        backgroundColor = .clear
        callAdminView.backgroundColor = .boxColor
        alertDescriptionLabel.textColor = .lightGray
        callAdminButton.backgroundColor = .appPrimaryColor
        callAdminButton.setTitleColor(.white, for: .normal)
    }
    
    private func setCustomLocalization() {
    
        //Set detault text
        alertTitleLabel.text = HomeConstant.Alert
        alertDescriptionLabel.text = HomeConstant.callAdminAlert
    }
}

//MARK: - IBAction

extension CallAdminAlertView {
    
    @objc func callAdminButtonAction(_ sender: UIButton) {
        onClickSubmit!(callAdminButton.titleLabel?.text ?? String.Empty)
    }
}
