//
//  CourierRatingView.swift
//  GoJekProvider
//
//  Created by Chan Basha on 05/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class CourierRatingView: UIView {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var BGView: UIView!
    
    var onClickSubmit:(()->Void)?
    
    override func awakeFromNib(){
        initialLoads()
    }
    
    private func initialLoads(){
        setFont()
        setDesign()
        commentsTextView.delegate = self
        buttonSubmit.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        BGView.backgroundColor = .boxColor
    }
    
    override func layoutSubviews() {
        userImageView.setCornerRadius()
        commentsTextView.setCornerRadiuswithValue(value: 4)
        buttonSubmit.setCornerRadiuswithValue(value: 6)
        BGView.setCornerRadiuswithValue(value: 10)
        
    }
    
    private func setFont(){
        labelRating.font = .setCustomFont(name: .bold, size: .x18)
        commentsTextView.font = .setCustomFont(name: .light, size: .x14)
        buttonSubmit.titleLabel?.font = .setCustomFont(name: .bold, size: .x14)
        commentsTextView.text = Constant.leaveComment.localized
        ratingView.setFloatRatingView()
    }
    
    private func setDesign(){
        
        buttonSubmit.backgroundColor = .courierColor
        buttonSubmit.setTitleColor(.white, for: .normal)
    }
    
    func setValues(values: CourierRequest?) {
        let userImage = URL(string: values?.user?.picture ?? "")
        self.userImageView.sd_setImage(with: userImage, placeholderImage: UIImage(named: Constant.profile),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.userImageView.image = UIImage(named: Constant.profile)
            } else {
                // Successful in loading image
                self.userImageView.image = image
            }
        })
    }
    
    @objc func tapSubmit() {
        onClickSubmit?()
    }
}
extension CourierRatingView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constant.leaveComment.localized {
            textView.text = .Empty
            textView.textColor = .black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == .Empty {
            commentsTextView.text = Constant.leaveComment.localized
            commentsTextView.textColor = .lightGray
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}
