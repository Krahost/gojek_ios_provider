//
//  BankDetailCell.swift
//  GoJekProvider
//
//  Created by CSS on 10/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

protocol BankDetailCellDelegate: class {
    
    func didSelectTextField(index: Int,textFieldStr: String)
}

class BankDetailCell: UITableViewCell {

    //MARk: - IBOutlet

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customTextField: UITextField!
    
    weak var delegate: BankDetailCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customTextField.font = .setCustomFont(name: .light, size: .x14)
        titleLabel.font = .setCustomFont(name: .medium, size: .x16)
        
        titleLabel.textColor = .gray
        customView.backgroundColor = .boxColor
        contentView.backgroundColor = .backgroundColor
        customView.addShadow(radius: 8.0, color: .lightGray)
        
        customTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARk: - UITextFieldDelegate

extension BankDetailCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.tag)
        delegate?.didSelectTextField(index: textField.tag,textFieldStr: textField.text ?? String.Empty)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.endEditing(true)
        return true
    }
}
