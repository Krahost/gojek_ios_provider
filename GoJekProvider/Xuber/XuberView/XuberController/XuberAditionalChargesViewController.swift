//
//  XuberAditionalChargesViewController.swift
//  GoJekProvider
//
//  Created by CSS on 19/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberAditionalChargesViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var aditionalChargeTitleLabel: UILabel!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: XuberAditionalChargesDelegate?
    var afterServiceimgeData:Data!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //   overView.addDashLine(strokeColor: .xuberColor, lineWidth: 6)
    }
}

extension XuberAditionalChargesViewController {
    private func setupView(){
        
        submitButton.setTitle(Constant.submit.localized, for: .normal)
        submitButton.setTitleColor(.xuberColor, for: .normal)
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        cancelButton.setTitle(Constant.cancel.localized, for: .normal)
        cancelButton.setTitleColor(.xuberColor, for: .normal)
        cancelButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        amountTextField.delegate = self
        amountTextField.font = .setCustomFont(name: .medium, size: .x16)
        amountTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        amountTextField.layer.borderWidth = 1
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.setCornerRadiuswithValue(value: 8)
        descriptionTextView.textColor = .black
        amountTextField.setCornerRadiuswithValue(value: 8)
        amountTextField.textColor = .lightGray
        let userDetails = AppManager.share.getUserDetails()
        
        amountTextField.setCurrency(currency: userDetails?.currency ?? .Empty)
        //        amountTextField.pad
        amountTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        amountLabel.font = .setCustomFont(name: .light, size: .x16)
        amountLabel.text = XuberConstant.amount.localized
        descriptionTextView.textColor = .lightGray
        descriptionTextView.font = .setCustomFont(name: .medium, size: .x16)
        descriptionLabel.font = .setCustomFont(name: .light, size: .x16)
        descriptionLabel.text = XuberConstant.description.localized
        aditionalChargeTitleLabel.font = .setCustomFont(name: .bold, size: .x18)
        aditionalChargeTitleLabel.text = XuberConstant.additionalCharges.localized
        
        overView.setCornerRadiuswithValue(value: 10)
        submitButton.addTarget(self, action: #selector(tapSubmit(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(tapCancel(_:)), for: .touchUpInside)
        overView.backgroundColor = .boxColor
        amountTextField.backgroundColor = .backgroundColor
    }
    
    @objc func tapSubmit(_ sender:UIButton) {
        self.view.endEditing(true)
        
        if amountTextField.text == "" || amountTextField.text == "0" {
            simpleAlert(view: self, title: "", message: XuberConstant.additionalChargePriceMsg.localized, buttonTitle: Constant.ok.localized)
            return
        }
        dismiss(animated: true, completion: nil)
        delegate?.aditionalChargeValue(amount: amountTextField.text ?? String.Empty, description: descriptionTextView.text, afterImage: afterServiceimgeData)
    }
    
    @objc func tapCancel(_ sender:UIButton) {
        
        navigationController?.popViewController(animated: true)
        delegate?.cancelAdtitionalCharge()
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension XuberAditionalChargesViewController: UITextViewDelegate,UITextFieldDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 10
    }
}
// MARK: - Protocol
protocol XuberAditionalChargesDelegate: class {
    func aditionalChargeValue(amount: String,description: String,afterImage: Data?)
    func cancelAdtitionalCharge()

}
