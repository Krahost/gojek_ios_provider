//
//  SetupServiceTableViewCell.swift
//  GoJekProvider
//
//  Created by CSS on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

// MARK: - SetupServiceTableViewCellDelegate

protocol SetupServiceTableViewCellDelegate: class {
    
    func onEditTap(tag: Int,serviceId: Int)
}

class SetupServiceTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var overView: UIView!
    
    // MARK: - LocalVariable

    weak var delegate: SetupServiceTableViewCellDelegate?
    var serviceData: XuberServiceData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalLoads()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - LocalMethod

extension SetupServiceTableViewCell {
    
    private func initalLoads(){
        editButton.setImage(UIImage(named: Constant.edit)?.withRenderingMode(.alwaysTemplate), for: .normal)
        editButton.tintColor = .lightGray
        priceLabel.textColor = .gray
        serviceNameLabel.font = .setCustomFont(name: .light, size: .x16)
        priceLabel.font = .setCustomFont(name: .light, size: .x14)
        
        checkImageView.image = UIImage(named: Constant.sqaureEmpty)
        checkImageView.imageTintColor(color1: .appPrimaryColor)
        overView.adddropshadow(radius: 5)
        overView.backgroundColor = .boxColor
        contentView.backgroundColor = .backgroundColor
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        
    }
    
    func setServiceData(data: XuberServiceData) {
        
        serviceData = data
        serviceNameLabel.text = data.service_name
    }
    
    @objc func editButtonAction(_ sender: UIButton) {
        delegate?.onEditTap(tag: sender.tag, serviceId: serviceData?.id ?? 0)
    }
}
