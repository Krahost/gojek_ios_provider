//
//  TransactionHeaderView.swift
//  GoJekUser
//
//  Created by Ansar on 08/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TransactionHeaderView: UIView {
    
    @IBOutlet weak var staticTransactionIdLabel: UILabel!
    @IBOutlet weak var staticAmountLabel: UILabel!
    @IBOutlet weak var staticStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
}

extension TransactionHeaderView {
    private func initialLoads() {
        staticTransactionIdLabel.font = .setCustomFont(name: .bold, size: .x14)
        staticAmountLabel.font = .setCustomFont(name: .bold, size: .x14)
        staticStatusLabel.font = .setCustomFont(name: .bold, size: .x14)
        localize()
    }
    
    private func localize() {
        staticStatusLabel.text = MyAccountConstant.status.localized
        staticAmountLabel.text = MyAccountConstant.amount.localized
        staticTransactionIdLabel.text = MyAccountConstant.transactionID.localized
    }
    
}
