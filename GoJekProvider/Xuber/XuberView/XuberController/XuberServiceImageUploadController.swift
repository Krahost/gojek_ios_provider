//
//  XuberServiceImageUploadController.swift
//  GoJekProvider
//
//  Created by CSS on 16/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol XuberServiceImageUploadDelegate: class {
    
    func beforeAfterServiceImage(serviceType: String,imageData: Data)
}

class XuberServiceImageUploadController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var beforeAfterTitleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var uploadImageLabel: UILabel!
    
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var dummyUploadImageView: UIImageView!
    @IBOutlet weak var uploadImageOverView: UIView!
    
    weak var delegate: XuberServiceImageUploadDelegate?
    var titleStr = String.Empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalSetup()
    }
}

// MARK: - LocalMethod

extension XuberServiceImageUploadController {
    
    private func initalSetup(){
        uploadImageOverView.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.5)
        submitButton.backgroundColor = .xuberColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        submitButton.setTitle(Constant.submit.localized, for: .normal)
        beforeAfterTitleLabel.font = .setCustomFont(name: .bold, size: .x18)
        beforeAfterTitleLabel.text = XuberConstant.beforeService.localized
        beforeAfterTitleLabel.textColor = .lightGray
        uploadImageLabel.font = .setCustomFont(name: .medium, size: .x16)
        uploadImageLabel.text = XuberConstant.uploadImage.localized
        uploadImageLabel.textColor = .xuberColor
        beforeAfterTitleLabel.text = titleStr
        
        uploadImageOverView.backgroundColor = UIColor.xuberColor.withAlphaComponent(0.5)
        overView.setCornerRadiuswithValue(value: 10)
        uploadImageOverView.setCornerRadiuswithValue(value: 10)
        submitButton.setCornerRadiuswithValue(value: 10)
        dummyUploadImageView.image = UIImage(named: MyAccountConstant.file)
        dummyUploadImageView.imageTintColor(color1: .xuberColor)
        
        let uploadViewgesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        uploadImageOverView.addGestureRecognizer(uploadViewgesture)
        submitButton.addTarget(self, action: #selector(tapSubmit(_:)), for: .touchUpInside)
        backgroundButton.addTarget(self, action: #selector(onClickBackground(_:)), for: .touchUpInside)
        
    }
    
    @objc func onClickBackground(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapSubmit(_ sender:UIButton) {
        var serviceimgeData:Data!
        
        if  let dataImg = uploadImageView.image?.jpegData(compressionQuality: 0.4) {
            
            serviceimgeData = dataImg
            delegate?.beforeAfterServiceImage(serviceType: titleStr, imageData: serviceimgeData)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func tapImage(_ sender: UITapGestureRecognizer) {
        
        showOpenCamera { [weak self] (image) in
            guard let self = self else {
                return
            }
            self.uploadImageView.image = image
        }
    }
}
