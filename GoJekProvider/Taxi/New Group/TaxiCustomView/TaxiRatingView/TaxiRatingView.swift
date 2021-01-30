//
//  TaxiRatingView.swift
//  GoJekProvider
//
//  Created by apple on 14/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class TaxiRatingView: UIView {
    
    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bookingIdlabel: UILabel!
    @IBOutlet weak var rateDriverLabel: UILabel!
    
    @IBOutlet weak var leaveCommentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var subUserNameView: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var ratingOuterView: UIView!
    
    @IBOutlet weak var userNameImage: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    var onClickSubmit:(()->Void)?
    
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
}

extension TaxiRatingView {
    
    private func initialViewSetup() {
        
        //set custom color

        userNameLabel.adjustsFontSizeToFitWidth = true
        bookingIdlabel.adjustsFontSizeToFitWidth = true
        //set custom Localization
        submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        rateDriverLabel.text = Constant.rateCustomer.localized
        ratingTitleLabel.text = Constant.rating.localized
        submitButton.setTitle(Constant.submit.localized, for: .normal)
        leaveCommentTextView.text = Constant.leaveComment.localized
        
        //Set rating view
        ratingView.setFloatRatingView()
        ratingView.rating = 5
        leaveCommentTextView.delegate = self
        //Set custom font
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        userNameLabel.font = .setCustomFont(name: .medium, size: .x18)
        ratingTitleLabel.font = .setCustomFont(name: .medium, size: .x24)
        rateDriverLabel.font = .setCustomFont(name: .medium, size: .x16)
        leaveCommentTextView.font = .setCustomFont(name: .light, size: .x16)
        bookingIdlabel.font = .setCustomFont(name: .medium, size: .x12)
        submitButton.backgroundColor = .taxiColor
        bookingIdlabel.textColor = .taxiColor
        
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
    
    func setValues(values: Request?) {
        //Show Taxi rating detail
        self.userNameLabel.text = "\(values?.user?.firstName ?? String.Empty) \(values?.user?.lastName ?? String.Empty)"
        self.bookingIdlabel.text = TaxiConstant.bookingId.localized+": \(values?.bookingId ?? String.Empty)"
        
        let userImage = URL(string: values?.user?.picture ?? "")
        self.userNameImage.sd_setImage(with: userImage, placeholderImage: UIImage(named: Constant.profile),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
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
    
    @objc func tapSubmit() {
        onClickSubmit?()
    }
}


extension TaxiRatingView: UITextViewDelegate {
    
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
            leaveCommentTextView.textColor = .blackColor
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}


