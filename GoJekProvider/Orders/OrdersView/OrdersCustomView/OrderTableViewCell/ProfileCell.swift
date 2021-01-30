//
//  ProfileCell.swift
//  GoJekUser
//
//  Created by Sudar on 06/07/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileOuterView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
    }
    
    private func initalLoads(){
        DispatchQueue.main.async {
            self.userImage.setShadow()
        }
        setFont()
        setRating()
    }
    
    func setValues(data: OrderDetailReponseData)  {
        DispatchQueue.main.async {
            self.totalLabel.isHidden = true
            self.totalValueLabel.isHidden = true
            if let transportData = data.transport {
                //Validate user data
                if let user = transportData.user {
                    
                    self.userImage.sd_setImage(with: URL(string:  user.picture ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        // Perform operation.
                        if (error != nil) {
                            // Failed to load image
                            self.userImage.image = UIImage(named: Constant.profile)
                        } else {
                            // Successful in loading image
                            self.userImage.image = image
                        }
                    })
                    self.userNameLabel.text = String.removeNil(user.first_name).giveSpace+String.removeNil(user.last_name)
                    if let rating = transportData.rating {
                        self.ratingView.rating = Double(rating.provider_rating ?? 1)
                    }
                } else {
                    self.profileOuterView.isHidden = true
                }
                
            }
            if let delvieryData = data.delivery {
                self.totalLabel.isHidden = false
                self.totalValueLabel.isHidden = false
                if let user = delvieryData.user {
                    
                    self.userImage.sd_setImage(with: URL(string:  user.picture ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        // Perform operation.
                        if (error != nil) {
                            // Failed to load image
                            self.userImage.image = UIImage(named: Constant.profile)
                        } else {
                            // Successful in loading image
                            self.userImage.image = image
                        }
                    })
                    self.totalValueLabel.text = delvieryData.total_amount?.setCurrency()
                    self.userNameLabel.text = String.removeNil(user.firstName).giveSpace+String.removeNil(user.lastName)
                    if let rating = delvieryData.rating {
                        self.ratingView.rating = Double(rating.provider_rating ?? 1)
                    }
                } else {
                    self.profileOuterView.isHidden = true
                }
            }
            if let serviceData = data.service {
                if let user = serviceData.user {
                    
                    self.userImage.sd_setImage(with: URL(string:  user.picture ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        // Perform operation.
                        if (error != nil) {
                            // Failed to load image
                            self.userImage.image = UIImage(named: Constant.profile)
                        } else {
                            // Successful in loading image
                            self.userImage.image = image
                        }
                    })
                    self.userNameLabel.text = String.removeNil(user.first_name).giveSpace+String.removeNil(user.last_name)
                    if let rating = serviceData.rating {
                        self.ratingView.rating = Double(rating.provider_rating ?? 1)
                    }
                    
                } else {
                    self.profileOuterView.isHidden  = true
                }
            }
            if let foodieValue = data.foodie {
                if let user = foodieValue.user {
                    
                    self.userImage.sd_setImage(with: URL(string:  user.picture ?? ""), placeholderImage:UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        // Perform operation.
                        if (error != nil) {
                            // Failed to load image
                            self.userImage.image = UIImage(named: Constant.profile)
                        } else {
                            // Successful in loading image
                            self.userImage.image = image
                        }
                    })
                    self.userNameLabel.text = String.removeNil(user.firstName).giveSpace+String.removeNil(user.lastName)
                    if let rating = foodieValue.rating {
                        self.ratingView.rating = Double(rating.provider_rating ?? 1)
                    }
                } else {
                    self.profileOuterView.isHidden  = true
                }
            }
            
        }
    }
    
    private func setRating() {
        self.ratingView.minRating = 1
        self.ratingView.maxRating = 5
        self.ratingView.emptyImage = UIImage(named: Constant.ratingEmptyImage)
        self.ratingView.fullImage = UIImage(named: Constant.ratingFull)
        self.ratingView.emptyTintColor = .lightGray
        self.ratingView.fullImageTintColor = .taxiColor
        self.totalLabel.textColor = .appPrimaryColor
    }
    
    private func setFont() {
        userNameLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        totalLabel.font = UIFont.setCustomFont(name: .bold, size: .x12)
        totalValueLabel.font = UIFont.setCustomFont(name: .medium, size: .x12)
        totalLabel.text = OrdersConstant.total.localized
    }
    
    override func layoutSubviews() {
        self.userImage.setCornerRadius()
        userImage.setCornerRadius()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
