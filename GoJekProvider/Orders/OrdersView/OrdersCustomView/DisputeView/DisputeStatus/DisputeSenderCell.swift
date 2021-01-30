//
//  DisputeSenderCell.swift
//  TranxitUser
//
//  Created by Ansar on 19/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage

class DisputeSenderCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblContent:UILabel!
    @IBOutlet weak var viewStatus:UIView!
    @IBOutlet weak var lblStatus:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initialLoad() {
        lblName.font = .setCustomFont(name: .bold, size: .x16)
        lblContent.font = .setCustomFont(name: .bold, size: .x14)
        lblStatus.font = .setCustomFont(name: .bold, size: .x14)
        imgProfile.setBorder(width: 1, color: .black)
        DispatchQueue.main.async {
            self.imgProfile.setCornerRadius()
            self.viewStatus.setCornerRadius()
        }
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.contentView.backgroundColor = .boxColor
    }
    
    func setValues(detail: ProfileData?, lostItem: Dispute?) {
        
        self.imgProfile.sd_setImage(with: URL(string:  detail?.picture ?? String.Empty), placeholderImage:#imageLiteral(resourceName: "ImagePlaceHolder"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                       if (error != nil) {
                           // Failed to load image
                           self.imgProfile.image = UIImage(named: Constant.profile)
                       } else {
                           // Successful in loading image
                           self.imgProfile.image = image
                       }
                   })
        lblName.text = OrdersConstant.you.localized
        lblContent.text = lostItem?.dispute_name
        lblStatus.text = lostItem?.status?.uppercased()
        if let status = DisputeStatus(rawValue: lostItem?.status ?? String.Empty)  {
            viewStatus.backgroundColor  = status.disputeColor.withAlphaComponent(0.3)
            lblStatus.textColor = status.disputeColor
        }
    }
}
