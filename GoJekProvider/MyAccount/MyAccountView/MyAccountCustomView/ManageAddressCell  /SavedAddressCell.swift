//
//  SavedAddressCell.swift
//  GoJekProvider
//
//  Created by Ansar on 25/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class SavedAddressCell: UITableViewCell {
    
    @IBOutlet weak var addressTypeLabel:UILabel!
    @IBOutlet weak var addressDetailLabel:UILabel!
    @IBOutlet weak var addressTypeImageView:UIImageView!
    @IBOutlet weak var deleteButton:UIButton!
    @IBOutlet weak var editBbutton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
//MARK: - Method

extension SavedAddressCell {
    private func initialLoads() {
        addressTypeLabel.textColor = .black
        addressDetailLabel.textColor = .lightGray
        deleteButton.textColor(color: .blue)
        editBbutton.textColor(color: .blue)
        editBbutton.setTitle(MyAccountConstant.edit.localized, for: .normal)
        deleteButton.setTitle(MyAccountConstant.delete.localized, for: .normal)
    }
}
