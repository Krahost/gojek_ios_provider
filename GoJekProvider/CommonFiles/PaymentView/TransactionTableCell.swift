//
//  TransactionTableCell.swift
//  GoJekUser
//
//  Created by Ansar on 08/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TransactionTableCell: UITableViewCell {
    
    enum TransactionType: String {
        case C
        case D
        case none
        
        var code: String {
            switch self {
            case .C: return "Credited"
            case .D: return "Debited"
            case .none: return String.Empty
            }
        }
    }

    @IBOutlet weak var transactionIDLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setValues(values: Transactions) {
                
        transactionIDLabel.text = values.transaction_desc
        amountLabel.text = values.amount?.setCurrency()
        if let type = TransactionType(rawValue: values.type ?? String.Empty) {
            if TransactionType.C.rawValue == values.type {
                statusLabel.textColor = .green
            }else{
                statusLabel.textColor = .red

            }
            statusLabel.text = type.code
        }
    }
    
}

extension TransactionTableCell {
    private func initialLoads() {
        transactionIDLabel.font = .setCustomFont(name: .medium, size: .x14)
        amountLabel.font = .setCustomFont(name: .medium, size: .x14)
        statusLabel.font = .setCustomFont(name: .medium, size: .x14)
        transactionIDLabel.textColor = .blackColor
        self.contentView.backgroundColor = .boxColor
    }
}
