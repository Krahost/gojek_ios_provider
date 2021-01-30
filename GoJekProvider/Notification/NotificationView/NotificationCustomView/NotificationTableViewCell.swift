//
//  NotificationTableViewCell.swift
//  MySample
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 CSS01. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationDetailLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var showButton: UIButton!
    
    var isShowMoreLess = false


    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.notificationImage.setCornerRadiuswithValue(value: 5)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         if #available(iOS 13.0, *) {
             if UITraitCollection.current.userInterfaceStyle == .dark {
                 isDarkMode = true
             }
             else {
                 isDarkMode = false
             }
         }
         else{
             isDarkMode = false
         }
         initialLoads()
     }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Cell initial load
    private func initialLoads() {
        notificationTitleLabel.font = .setCustomFont(name: .bold, size: .x16)
        timeLeftLabel.font = .setCustomFont(name: .bold, size: .x12)
        notificationDetailLabel.font = .setCustomFont(name: .medium, size: .x14)
        if(!isDarkMode){
        backGroundView.addShadow(radius: 5.0, color: .lightGray)
        }
        else{
        backGroundView.addShadow(radius: 5.0, color: .black)
        }
        backGroundView.backgroundColor = .boxColor
        contentView.backgroundColor = .backgroundColor
        notificationDetailLabel.numberOfLines = 3
        showButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x14)
        showButton.setTitleColor(.red, for: .normal)
        showButton.setTitle("Show More", for: .normal)
    }
    
    //Cell value setup
    func setValues(values: NotificationData) {
        
        self.notificationImage.sd_setImage(with: URL(string: values.image ?? String.Empty), placeholderImage:UIImage(named: Constant.userPlaceholderImage)?.imageTintColor(color: .veryLightGray),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
         // Perform operation.
            if (error != nil) {
                // Failed to load image
                self.notificationImage.image = UIImage(named: Constant.profile)
            } else {
                // Successful in loading image
                self.notificationImage.image = image
            }
        })
        notificationTitleLabel.text = values.title
        notificationDetailLabel.text = values.descriptions
        let DateTime = dateDiff(dateStr: values.created_at ?? String.Empty)
        timeLeftLabel.text = DateTime
        let lblLineCount = countLabelLines(label: notificationDetailLabel)
        
        if lblLineCount >= 3 {
            showButton.isHidden = false
        }else{
            showButton.isHidden = true
        }
    }

    func countLabelLines(label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font ?? UIFont()], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
}
