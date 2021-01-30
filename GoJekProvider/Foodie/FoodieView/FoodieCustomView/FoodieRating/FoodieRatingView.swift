//
//  FoodieRatingView.swift
//  GoJekProvider
//
//  Created by Ansar on 06/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class FoodieRatingView: UIView {
    
    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bookingIdlabel: UILabel!
    @IBOutlet weak var rateDriverLabel: UILabel!
    
    @IBOutlet weak var leaveCommentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var subUserNameView: UIView!
    @IBOutlet weak var ratingOuterView: UIView!
    
    @IBOutlet weak var userNameImage: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    var onClickSubmit:((String,Double)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialViewSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            if CommonFunction.checkisRTL() {
                self.userNameView.setOneSideCorner(corners: [.topRight,.bottomRight], radius: self.userNameView.frame.height/2)
            }else {
                self.userNameView.setOneSideCorner(corners: [.topLeft,.bottomLeft], radius: self.userNameView.frame.height/2)
            }
            self.userNameImage.setCornerRadius()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}

extension FoodieRatingView {
    
    private func initialViewSetup() {
        
        //set custom color
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        submitButton.backgroundColor = .foodieColor
        bookingIdlabel.textColor = .lightGray
        leaveCommentTextView.textColor = .lightGray
        ratingOuterView.backgroundColor = .veryLightGray
        submitButton.textColor(color:.white)
        ratingTitleLabel.textColor = .black
        rateDriverLabel.textColor = .black
        ratingView.type = .wholeRatings
        userNameLabel.adjustsFontSizeToFitWidth = true
        bookingIdlabel.adjustsFontSizeToFitWidth = true

        //set custom Localization
        submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        rateDriverLabel.text = Constant.rateCustomer.localized
        ratingTitleLabel.text = Constant.rating.localized
        submitButton.setTitle(Constant.submit.localized, for: .normal)
        leaveCommentTextView.text = Constant.leaveComment.localized
        
        //Set custom font
        submitButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        userNameLabel.font = .setCustomFont(name: .medium, size: .x18)
        ratingTitleLabel.font = .setCustomFont(name: .medium, size: .x24)
        rateDriverLabel.font = .setCustomFont(name: .medium, size: .x16)
        leaveCommentTextView.font = .setCustomFont(name: .light, size: .x16)
        
        //Set rating view
        ratingView.setFloatRatingView()
        leaveCommentTextView.delegate = self
        
        
        //Dark Mode
           leaveCommentTextView.backgroundColor = .backgroundColor
           leaveCommentTextView.textColor = .blackColor
           ratingOuterView.backgroundColor = .boxColor
           userNameView.backgroundColor = .backgroundColor
           subUserNameView.backgroundColor = .boxColor
           submitButton.textColor(color: .white)
           ratingTitleLabel.textColor = .blackColor
           rateDriverLabel.textColor = .blackColor
    }
    
    @objc func tapSubmit() {
        onClickSubmit!(leaveCommentTextView.text == Constant.leaveComment.localized ? String.Empty : leaveCommentTextView.text ,ratingView?.rating ?? 1)
    }
    
    func setValues(values: FoodieRequestResponse) {
        DispatchQueue.main.async {
            let name = (values.requests?.user?.firstName ?? String.Empty).giveSpace + (values.requests?.user?.lastName ?? String.Empty)
            self.userNameLabel.text = name
            self.bookingIdlabel.text = values.requests?.store_order_invoice_id
            let url = URL(string: values.requests?.user?.picture ?? String.Empty)
            
            self.userNameImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                   // Perform operation.
                      if (error != nil) {
                          // Failed to load image
                          self.userNameImage.image = UIImage(named: Constant.profile)
                      } else {
                          // Successful in loading image
                          self.userNameImage.image = image
                      }
                  })
        }
    }
}

//MARK: - UITextViewDelegate

extension FoodieRatingView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constant.leaveComment.localized {
            textView.text = .Empty
            textView.textColor = .blackColor
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == .Empty {
            leaveCommentTextView.text = Constant.leaveComment.localized
            leaveCommentTextView.textColor = .lightGray
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
