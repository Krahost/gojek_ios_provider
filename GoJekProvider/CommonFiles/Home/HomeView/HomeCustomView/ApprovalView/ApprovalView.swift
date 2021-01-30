//
//  ApprovalView.swift
//  GoJekProvider
//
//  Created by apple on 24/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ApprovalView: UIView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerTitleLabel: UILabel!
    @IBOutlet weak var addServiceButton: UIButton!
    @IBOutlet weak var addDocumentButton: UIButton!
    @IBOutlet weak var addBankDetailsButton: UIButton!
    @IBOutlet weak var adminApprovalLabel: UILabel!
    @IBOutlet weak var addProfileButton: UIButton!
    
    //MARK: - LocalVariable
    var onClickPendingType: ((PendingType?)->())?
    var approvalType: [PendingType]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaultSetup()
    }
}

//MARK: - LocalMethod

extension ApprovalView {
    
    private func defaultSetup() {
        
        containerView.setCornerRadiuswithValue(value: 5)
        addServiceButton.tag = 100
        addDocumentButton.tag = 101
        addBankDetailsButton.tag = 102
        addProfileButton.tag = 103
        
        addServiceButton.isHidden = true
        addDocumentButton.isHidden = true
        addBankDetailsButton.isHidden = true
        addProfileButton.isHidden = false
        
        setApprovalPendingUI()
        setCustomLocalization()
        outterView.backgroundColor = .boxColor
    }
    
    private func buttonSetup(button: UIButton, title: String) {
        button.setCornerRadiuswithValue(value: 5)
        button.setBorder(width: 0.5, color: .lightGray)
        button.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        button.setTitle(title, for: .normal)
        button.tintColor = .lightGray
    }
    
    private func setCustomLocalization() {
        
        buttonSetup(button: addServiceButton, title: Constant.addService.localized)
        buttonSetup(button: addDocumentButton, title: Constant.addDocument.localized)
        buttonSetup(button: addBankDetailsButton, title: Constant.addBankDetails.localized)
        buttonSetup(button: addProfileButton, title: Constant.addProfileDetails.localized)
        
        containerTitleLabel.text = Constant.completeSteps.localized
        adminApprovalLabel.text = Constant.waitAdminApproval.localized
    }
    
    func setApprovalPendingUI() {
        
        guard let _ = approvalType else { return  }
        stackView.arrangedSubviews[1].isHidden = true
        addServiceButton.isHidden = true
        addDocumentButton.isHidden = true
        addBankDetailsButton.isHidden = true
        
        for type in approvalType {
            switch type {
            case .Service:
                addServiceButton.isHidden = false
            case .Document:
                addDocumentButton.isHidden = false
            case .BankDetails:
                addBankDetailsButton.isHidden = false
            case .adminApproval:
                stackView.arrangedSubviews[0].isHidden = true
                stackView.arrangedSubviews[1].isHidden = false
            case .profile:
                addProfileButton.isHidden = false
            }
        }
    }
   func setAccountDisableUI() {
    //.tabBarController?.tabBar.isHidden = false
   // containerTitleLabel.text = Constant.accountDisable.localized
    adminApprovalLabel.text = Constant.pleasecontactAdmin.localized
    adminApprovalLabel.numberOfLines = 2
    
          guard let _ = approvalType else { return  }
          stackView.arrangedSubviews[1].isHidden = true
          addServiceButton.isHidden = true
          addDocumentButton.isHidden = true
          addBankDetailsButton.isHidden = true
          
          for type in approvalType {
              switch type {
              case .Service:
                  addServiceButton.isHidden = false
              case .Document:
                  addDocumentButton.isHidden = false
              case .BankDetails:
                  addBankDetailsButton.isHidden = false
              case .adminApproval:
                  stackView.arrangedSubviews[0].isHidden = true
                  stackView.arrangedSubviews[1].isHidden = false
              case .profile:
                addProfileButton.isHidden = false
            }
          }
      }
    
}

//MARK: - IBAction

extension ApprovalView {
    
    @IBAction func addServiceAction(sender: UIButton) {
        onClickPendingType?(.Service)
    }
    
    @IBAction func addDocumentAction(sender: UIButton) {
        onClickPendingType?(.Document)
    }
    
    @IBAction func addBankDetailsAction(sender: UIButton) {
        onClickPendingType?(.BankDetails)
    }
    
    @IBAction func addProfileAction(_ sender: UIButton) {
        onClickPendingType?(.profile)
    }
}
