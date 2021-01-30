//
//  XuberArriveView.swift
//  GoJekProvider
//
//  Created by apple on 12/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberArriveView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var arriveView: UIStackView!
    
    @IBOutlet weak var startView: UIStackView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var serviceDescriptionLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var arrivedButton: UIButton!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topView: UIStackView!
    
    var onClickStarted:(()->Void)?
    var onClickCancel:(()->Void)?
    var onClickCamera:(()->Void)?
    var onClickHelp:(()->Void)?
    
    override func layoutSubviews() {
        
        overView.layer.cornerRadius = 10
        timeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        // shadow
        overView.layer.shadowColor = UIColor.black.cgColor
        overView.layer.shadowOffset = CGSize(width: 3, height: 3)
        overView.layer.shadowOpacity = 0.7
        overView.layer.shadowRadius = 4.0
        overView.layer.masksToBounds = true
        
        cameraView.setCornerRadius()
        cameraImage.imageTintColor(color1: .white)
        profileImageView.setCornerRadius()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        nameLabel.adjustsFontSizeToFitWidth = true
        otpTextField.delegate = self
        rateImageView.image = UIImage(named: Constant.ratingSelect)
        rateLabel.textColor = .lightGray
        instructionLabel.text = XuberConstant.instructions.localized
        instructionLabel.font = .setCustomFont(name: .light, size: .x16)
        instructionLabel.textColor = .lightGray
        timeButton.setTitleColor(.white, for: .normal)
        timeButton.setImage(UIImage(named: XuberConstant.iclock)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        timeButton.tintColor = .white
        if CommonFunction.checkisRTL() {
            timeButton.setImageTitle(spacing: -10)

        }else {
            timeButton.setImageTitle(spacing: 10)

        }
        timeButton.setCornerRadiuswithValue(value: 10)
        otpTextField.placeholder = XuberConstant.enterOTP.localized
        helpButton.setCornorRadius()
        helpButton.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.5)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        arrivedButton.addTarget(self, action: #selector(arrivedButtonAction), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(helpButtonAction), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(tapCamera(_:)), for: .touchUpInside)
        
        serviceLabel.font = .setCustomFont(name: .bold, size: .x16)
        serviceDescriptionLabel.font = .setCustomFont(name: .light, size: .x16)
        serviceLabel.textColor = .black
        
        //Set custom color
        serviceDescriptionLabel.textColor = .lightGray
        cancelButton.backgroundColor = .clear
        arrivedButton.backgroundColor = .clear
        startButton.setTitleColor(.xuberColor, for: .normal)
        cancelButton.setTitleColor(.xuberColor, for: .normal)
        arrivedButton.setTitleColor(.xuberColor, for: .normal)
        otpTextField.backgroundColor = .backgroundColor
        cameraView.backgroundColor = .xuberColor
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 1
        
        timeButton.backgroundColor = .xuberColor
        
        //Set custom font
        otpTextField.font = .setCustomFont(name: .light, size: .x16)
        nameLabel.font = .setCustomFont(name: .medium, size: .x18)
        cancelButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        arrivedButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        startButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        
        //Set custom localization
        cancelButton.setTitle(Constant.cancel.localized.uppercased(), for: .normal)
        arrivedButton.setTitle(Constant.start.localized.uppercased(), for: .normal)
        startButton.backgroundColor = .clear
        self.overView.backgroundColor = .boxColor
    }
    
    @objc func helpButtonAction(){
        onClickHelp?()
    }
    
    @objc func arrivedButtonAction() {
        onClickStarted?()
    }
    @objc func cancelButtonAction() {
        onClickCancel?()
    }
    
    @objc func startButtonAction(){
        onClickStarted?()
    }
    @objc func tapCamera(_ sender: UIButton) {
        onClickCamera?()
        
    }
}
extension UIView {
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


extension XuberArriveView : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
}
