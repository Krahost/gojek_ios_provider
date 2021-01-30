//
//  ChatUserCollectionViewCell.swift
//  GoJekUser
//
//  Created by CSS15 on 11/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ChatUserCollectionViewCell: UICollectionViewCell {
    
    weak var profileImageView: UIImageView?
    weak var baseTextView: CustomCornerView?
    weak var chatMessageTextView: UITextView?
    weak var deliveredStatusLbl: UILabel?
    weak var gradiantLayer: CAGradientLayer?
    
    var currentUser: Bool = false
    var leftLayoutConstraints: [NSLayoutConstraint] = []
    var rightLayoutConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setUpViews()
    }
    
    
    func loadChatMessages(message: String?, currentUser: Bool) {
        
        var textColor = UIColor.brown
        let devliveredText = String.Empty
        
        chatMessageTextView?.text = message
        profileImageView?.isHidden = true
        
        if(currentUser == true) {
            baseTextView?.backgroundColor = .appPrimaryColor
            
            chatMessageTextView?.textContainerInset = UIEdgeInsets.init(top: ScreenConstants.proportionalValueForValue(value: 12), left: ScreenConstants.proportionalValueForValue(value: 8.0), bottom: ScreenConstants.proportionalValueForValue(value: 8.0), right: ScreenConstants.proportionalValueForValue(value: 12.0))
            
            textColor = .white
            
            baseTextView?.corners = UIRectCorner.bottomLeft.union(UIRectCorner.topRight.union(.topLeft))
            
            NSLayoutConstraint.activate(rightLayoutConstraints)
            NSLayoutConstraint.deactivate(leftLayoutConstraints)
        }
        else {
            
            baseTextView?.backgroundColor = .gray
            
            chatMessageTextView?.textContainerInset = UIEdgeInsets.init(top: ScreenConstants.proportionalValueForValue(value: 12.0), left: ScreenConstants.proportionalValueForValue(value: 8.0), bottom: ScreenConstants.proportionalValueForValue(value: 8.0), right: ScreenConstants.proportionalValueForValue(value: 12.0))
            
            textColor = .white
            
            baseTextView?.corners = UIRectCorner.bottomRight.union(UIRectCorner.topRight.union(.topLeft))
            NSLayoutConstraint.deactivate(rightLayoutConstraints)
            NSLayoutConstraint.activate(leftLayoutConstraints)
        }
        
        chatMessageTextView?.textColor = textColor
        deliveredStatusLbl?.text = devliveredText
    }
    
    func setUpViews(){
        
        contentView.backgroundColor = .clear
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "ic_user")
        profileImageView.backgroundColor = .gray
        profileImageView.layer.cornerRadius = ScreenConstants.proportionalValueForValue(value: 20.0)
        profileImageView.layer.masksToBounds = true
        contentView.addSubview(profileImageView)
        self.profileImageView = profileImageView
        
        let baseView = CustomCornerView.init(backgroundColor: UIColor.white, radius: ScreenConstants.proportionalValueForValue(value: 10.0), cornerValue: [.topLeft, .topRight, .bottomRight])
        contentView.addSubview(baseView)
        baseTextView = baseView
        
        let chatMessageTextView = UITextView.CommonTextView(backgroundColor: .clear, textColor: UIColor.white, textFont: .setCustomFont(name: .medium, size: .x16))
        chatMessageTextView.setContentCompressionResistancePriority(.required, for: .horizontal)
        chatMessageTextView.setContentHuggingPriority(.required, for: .horizontal)
        chatMessageTextView.isUserInteractionEnabled = false
        chatMessageTextView.isScrollEnabled = false
        chatMessageTextView.bounces = false
        chatMessageTextView.keyboardType = .default
        chatMessageTextView.layer.cornerRadius = ScreenConstants.proportionalValueForValue(value: 10.0)
        chatMessageTextView.layer.masksToBounds = true
        chatMessageTextView.textContainerInset = UIEdgeInsets.init(top: ScreenConstants.proportionalValueForValue(value: 12.0), left: ScreenConstants.proportionalValueForValue(value: 8.0), bottom: ScreenConstants.proportionalValueForValue(value: 8.0), right: ScreenConstants.proportionalValueForValue(value: 12.0))
        baseTextView?.addSubview(chatMessageTextView)
        self.chatMessageTextView = chatMessageTextView
        
        let deliveredStatus = UILabel()
        deliveredStatus.translatesAutoresizingMaskIntoConstraints = false
        deliveredStatus.numberOfLines = 0
        deliveredStatus.backgroundColor = .white
        deliveredStatus.textColor = .black
        deliveredStatus.font = .setCustomFont(name: .bold, size: .x14)
        deliveredStatus.textAlignment = .right
        deliveredStatus.setContentCompressionResistancePriority(.required, for: .vertical)
        deliveredStatus.setContentHuggingPriority(.required, for: .vertical)
        contentView.addSubview(deliveredStatus)
        self.deliveredStatusLbl = deliveredStatus
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        
        //profileImageView
        profileImageView?.leadingAnchor.constraint(equalTo: (profileImageView?.superview?.leadingAnchor)!, constant: 0).isActive = true
        profileImageView?.topAnchor.constraint(equalTo: (profileImageView?.superview?.topAnchor)!, constant: ScreenConstants.proportionalValueForValue(value: 10.0)).isActive = true
        profileImageView?.widthAnchor.constraint(equalToConstant: 0).isActive = true
        profileImageView?.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        //chatMessageTextView
        
        leftLayoutConstraints.append(contentsOf: [(baseTextView?.leadingAnchor.constraint(equalTo: (profileImageView?.trailingAnchor)!, constant: 20))!, (baseTextView?.trailingAnchor.constraint(lessThanOrEqualTo: (baseTextView?.superview?.trailingAnchor)!, constant: -ScreenConstants.proportionalValueForValue(value: 60.0)))!])
        
        rightLayoutConstraints.append(contentsOf: [(baseTextView?.leadingAnchor.constraint(greaterThanOrEqualTo: (profileImageView?.trailingAnchor)!, constant: 60))!, (baseTextView?.trailingAnchor.constraint(equalTo: (baseTextView?.superview?.trailingAnchor)!, constant: -20))!])
        
        baseTextView?.topAnchor.constraint(equalTo: (baseTextView?.superview?.topAnchor)!).isActive = true
        
        //chatMessageTextView
        chatMessageTextView?.leadingAnchor.constraint(equalTo: (chatMessageTextView?.superview?.leadingAnchor)!).isActive = true
        chatMessageTextView?.trailingAnchor.constraint(equalTo: (chatMessageTextView?.superview?.trailingAnchor)!).isActive = true
        chatMessageTextView?.topAnchor.constraint(equalTo: (chatMessageTextView?.superview?.topAnchor)!).isActive = true
        chatMessageTextView?.bottomAnchor.constraint(equalTo: (chatMessageTextView?.superview?.bottomAnchor)!).isActive = true
        
        //deliveredStatusLbl
        deliveredStatusLbl?.topAnchor.constraint(equalTo: (baseTextView?.bottomAnchor)!, constant:10).isActive = true
        deliveredStatusLbl?.trailingAnchor.constraint(equalTo: (deliveredStatusLbl?.superview?.trailingAnchor)!, constant: -ScreenConstants.proportionalValueForValue(value: 16.0)).isActive = true
        deliveredStatusLbl?.bottomAnchor.constraint(equalTo: (deliveredStatusLbl?.superview?.bottomAnchor)!, constant: 0.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
