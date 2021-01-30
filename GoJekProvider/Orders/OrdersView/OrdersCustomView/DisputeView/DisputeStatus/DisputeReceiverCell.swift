//
//  DisputeReceiverCell.swift
//  TranxitUser
//
//  Created by Ansar on 19/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class DisputeReceiverCell: UITableViewCell {

    //MARK: - IBOutlet
    
    @IBOutlet var imgProfile:UIImageView!
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblContent:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initialLoad() {
        lblName.font = .setCustomFont(name: .medium, size: .x16)
        lblContent.font = .setCustomFont(name: .medium, size: .x14)
        imgProfile.image = UIImage(named: Constant.userPlaceholderImage)
        imgProfile.setBorder(width: 1, color: .black)
        DispatchQueue.main.async {
            self.imgProfile.setCornerRadius()
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
           self.contentView.backgroundColor = .boxColor
       }
    
    func setValues(adminComment: String) {
        lblName.text = HomeConstant.admin
        lblContent.text = adminComment
        imgProfile.image = UIImage(named: OrdersConstant.appLogo)
    }
}
