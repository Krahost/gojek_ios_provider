//
//  XuberRatingView.swift
//  GoJekProvider
//
//  Created by apple on 12/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class XuberRatingView: UIView {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bookingIdLabel: UILabel!
    @IBOutlet weak var rateDriverLabel: UILabel!
    @IBOutlet weak var leaveCommentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var subUserNameView: UIView!
    @IBOutlet weak var ratingOuterView: UIView!
    @IBOutlet weak var userNameImage: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    //MARK: - LocalVariable
    
    weak var delegate: XuberRatingViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        initialViewSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
}

//MARK: - LocalMethod

extension XuberRatingView {
    
    private func initialViewSetup() {
        DispatchQueue.main.async {
            if CommonFunction.checkisRTL() {
                self.userNameView.setOneSideCorner(corners: [.topRight,.bottomRight], radius: self.userNameView.frame.height/2)
            }else {
                self.userNameView.setOneSideCorner(corners: [.topLeft,.bottomLeft], radius: self.userNameView.frame.height/2)
            }
            self.userNameImage.setCornerRadius()
        }
        ratingView.rating = 5
        leaveCommentTextView.delegate = self
        userNameLabel.adjustsFontSizeToFitWidth = true
        //set custom color
        submitButton.backgroundColor = .xuberColor
        bookingIdLabel.textColor = .lightGray
        leaveCommentTextView.textColor = .lightGray
        ratingOuterView.backgroundColor = .veryLightGray
        submitButton.setTitleColor(.white, for: .normal)
        rateDriverLabel.textColor = .black
        ratingTitleLabel.textColor = .black
        userNameLabel.adjustsFontSizeToFitWidth = true

        //set custom Localization
        submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        rateDriverLabel.text = Constant.rateCustomer.localized
        ratingTitleLabel.text = Constant.rating.localized
        submitButton.setTitle(Constant.submit.localized, for: .normal)
        leaveCommentTextView.text = Constant.leaveComment.localized
        
        //Set rating view
        ratingView.setFloatRatingView()
        
        //Set custom font
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
        userNameLabel.font = .setCustomFont(name: .medium, size: .x18)
        bookingIdLabel.font = .setCustomFont(name: .light, size: .x14)
        ratingTitleLabel.font = .setCustomFont(name: .medium, size: .x24)
        rateDriverLabel.font = .setCustomFont(name: .medium, size: .x16)
        leaveCommentTextView.font = .setCustomFont(name: .light, size: .x16)
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
        let comments = leaveCommentTextView.text
        delegate?.ratingView(comments: comments == Constant.leaveComment ? String.Empty : (comments  ?? String.Empty), rateValue: ratingView.rating)
    }
}

//MARK: - UITextViewDelegate

extension XuberRatingView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constant.leaveComment.localized {
            textView.text = .Empty
            textView.textColor = .blackColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == .Empty {
            leaveCommentTextView.text = Constant.leaveComment.localized
            leaveCommentTextView.textColor = .lightGray
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}

// MARK: - Protocol
protocol XuberRatingViewDelegate: class {
    func ratingView(comments: String,rateValue: Double)
}
