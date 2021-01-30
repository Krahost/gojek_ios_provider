//
//  AddCardViewController.swift
//  GoJekUser
//
//  Created by Sravani on 26/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import CreditCardForm

class AddCardViewController: UIViewController {
    
    @IBOutlet weak var creditCardView: CreditCardFormView!
    
    //MARK:- Local Variable
    let paymentTextField = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension AddCardViewController {
    
    func initialLoads() {
        let userDetails = AppManager.share.getUserDetails()
//        STPPaymentConfiguration.shared().publishableKey = APPConstant.stripePublishableKey
        creditCardView.cardHolderString = (userDetails?.first_name ?? "") + (userDetails?.last_name ?? "")
        creditCardView.defaultCardColor = .appPrimaryColor
        creditCardView.backgroundColor = .backgroundColor

        createTextField()
        title = MyAccountConstant.addCard.localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.SDone.localized, style: .done, target: self, action: #selector(doneButtonClick))
        navigationItem.rightBarButtonItem?.isEnabled = true
        setLeftBarButtonWith(color: .blackColor)
        self.view.backgroundColor = .backgroundColor
        
    }
    
    @objc func doneButtonClick() {
        view.endEditing(true)
        
        if paymentTextField.cardParams.number == nil {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.cardNumberEmpty.localized,state: .error)
        }
        else if paymentTextField.cardParams.expYear == 0 {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.yearEmpty.localized,state: .error)
        }
        else if paymentTextField.cardParams.expMonth == 0 {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.monthEmpty.localized,state: .error)
            
        }
        else if paymentTextField.cardParams.cvc == nil {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.ccvEmpty.localized,state: .error)
        }
        else{
            LoadingIndicator.show()
            let stpCardParam = STPCardParams.init()
            stpCardParam.number = paymentTextField.cardParams.number
            stpCardParam.expMonth = paymentTextField.expirationMonth
            stpCardParam.expYear = paymentTextField.expirationYear
            stpCardParam.cvc = paymentTextField.cvc
            STPAPIClient.shared().createToken(withCard:  stpCardParam) { [weak self] (stpToken, error) in
                guard let self = self else {
                    return
                }
                print(stpToken?.tokenId ?? String.Empty)
                guard let token = stpToken?.tokenId else {
                    LoadingIndicator.hide()
                    return
                }
                let param: Parameters = [MyAccountConstant.PStripeToken: token]
                self.myAccountPresenter?.addCard(param: param)
            }
        }
    }
    
    func createTextField() {
        paymentTextField.frame = CGRect(x: 15, y: 199, width: view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        paymentTextField.postalCodeEntryEnabled = false

        paymentTextField.numberPlaceholder = "XXXX XXXX XXXX XXXX"
        
        view.addSubview(paymentTextField)
        
        NSLayoutConstraint.activate([
            paymentTextField.topAnchor.constraint(equalTo: creditCardView.bottomAnchor, constant: 20),
            paymentTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width-20),
            paymentTextField.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
}

// MARK:- STPPaymentCardTextFieldDelegate

extension AddCardViewController : STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        navigationItem.rightBarButtonItem?.isEnabled = textField.isValid
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }
}

//MARK:- PostViewProtocol

extension AddCardViewController: MyAccountPresenterToMyAccountViewProtocol {
    
    func addCardSuccess(addCardResponse: CardEntityResponse) {
        
        print(addCardResponse.message ?? String.Empty)
        LoadingIndicator.hide()
        DispatchQueue.main.async {
            self.simpleAlert(view: self, title: String.Empty, message: addCardResponse.message ?? String.Empty, buttonTitle: Constant.ok.localized)
            onTapAlert = { tag in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

