//
//  DocumentTableViewCell.swift
//  GoJekProvider
//
//  Created by CSS on 27/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var FrontpdfImage: UIImageView!
    @IBOutlet weak var backpdfImage: UIImageView!
    @IBOutlet weak var frontPdfLabel: UILabel!
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var backImageLabel: UILabel!
    @IBOutlet weak var frontImageLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var expiryView: UIView!
    @IBOutlet weak var frontViewButton: UIButton!
    
    @IBOutlet weak var backViewButton: UIButton!
    @IBOutlet weak var backPdfLabel: UILabel!
    @IBOutlet weak var expiryButton: UIButton!
    @IBOutlet weak var backTitleLabel: UILabel!
    @IBOutlet weak var frontTitleLabel: UILabel!
    @IBOutlet weak var subFrontView: UIView!
    @IBOutlet weak var subBackView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backTitleImageView: UIImageView!
    @IBOutlet weak var frontTitleImageView: UIImageView!
    @IBOutlet weak var expirySubView: UIView!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var expiryImageView: UIImageView!
    @IBOutlet weak var expiryValueLabel: UILabel!
    weak var delegate: DocumentTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setInital()
        setCustomFont()
    }
    
    private func setInital(){
        backpdfImage.isHidden = true
        FrontpdfImage.isHidden = true
        backTitleImageView.image = UIImage(named: MyAccountConstant.file)
        frontTitleImageView.image = UIImage(named: MyAccountConstant.file)
        contentView.backgroundColor = .backgroundColor
        backTitleImageView.image = UIImage(named: MyAccountConstant.file)
        
        backTitleImageView.imageTintColor(color1: UIColor.appPrimaryColor.withAlphaComponent(0.5))
        frontTitleImageView.image = UIImage(named: MyAccountConstant.file)
        
        frontTitleImageView.imageTintColor(color1: UIColor.appPrimaryColor.withAlphaComponent(0.5))
        DispatchQueue.main.async {
            
            self.subFrontView.addDashedBorder(strokeColor: .appPrimaryColor, lineWidth: 1, isBottomOnly: false)
            self.subBackView.addDashedBorder(strokeColor: .appPrimaryColor, lineWidth: 1, isBottomOnly: false)
        }
        frontTitleLabel.textColor = .lightGray
        backTitleLabel.textColor = .lightGray
        expiryValueLabel.textColor = .lightGray
        frontTitleLabel.text = MyAccountConstant.uploadFrontPage.localized
        backTitleLabel.text = MyAccountConstant.uploadBackPage.localized
        expirySubView.setCornerRadiuswithValue(value: 8)
        subFrontView.setCornerRadiuswithValue(value: 8)
        subBackView.setCornerRadiuswithValue(value: 8)
        expiryImageView.image = UIImage(named: MyAccountConstant.CalendarImage)
        expiryButton.addTarget(self, action: #selector(expiryButtonAction), for: .touchUpInside)
        backViewButton.setTitle(MyAccountConstant.view.localized, for: .normal)
        backViewButton.setTitleColor(.appPrimaryColor, for: .normal)
        backViewButton.isHidden = true
        frontViewButton.setTitle(MyAccountConstant.view.localized, for: .normal)
        frontViewButton.setTitleColor(.appPrimaryColor, for: .normal)
        frontViewButton.isHidden = true
        expiryLabel.text = MyAccountConstant.expiry.localized
        subFrontView.backgroundColor = .boxColor
        subBackView.backgroundColor = .boxColor
        expirySubView.backgroundColor = .backgroundColor
        overView.backgroundColor = .boxColor

    }
    
    // set custom font
    private func setCustomFont() {
        backViewButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        frontViewButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        
        frontPdfLabel.font = .setCustomFont(name: .bold, size: .x16)
        backPdfLabel.font = .setCustomFont(name: .bold, size: .x16)
        expiryValueLabel.font = .setCustomFont(name: .medium, size: .x16)
        
        frontImageLabel.font = .setCustomFont(name: .light, size: .x16)
        backImageLabel.font = .setCustomFont(name: .light, size: FontSize.x16)
        backTitleLabel.font = .setCustomFont(name: .light, size: FontSize.x14)
        frontTitleLabel.font = .setCustomFont(name: .light, size: FontSize.x14)
        expiryLabel.font = .setCustomFont(name: .light, size: FontSize.x16)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func expiryButtonAction(_ sender:UIButton) {
        PickerManager.shared.showDatePicker(selectedDate: nil) { (data) in
            print(data)
            self.delegate?.onExpiryTap(expiryStr: data)
        }
    }
}

// MARK: - Protocol for set Value for DateWise Label
protocol DocumentTableViewCellDelegate: class {
    func onExpiryTap(expiryStr: String)
    
}
