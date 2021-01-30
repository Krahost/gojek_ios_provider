//
//  WaitingTimeView.swift
//  GoJekProvider
//
//  Created by Sravani on 22/07/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class WaitingTimeView: UIView {

    @IBOutlet weak var waitingTimeLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var outterView: UIView!
    var onClickStopWaitingTime:(()->Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.stopButton.setCornorRadius()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
        setLocalize()
        stopButton.addTarget(self, action: #selector(stopButtonAction(_:)), for: .touchUpInside)
        stopButton.backgroundColor = .taxiColor
        self.outterView.backgroundColor = .boxColor
    }
    
    private func setFont() {
        waitingTimeLabel.font  = UIFont.setCustomFont(name: .bold, size: .x20)
        TimerLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        stopButton.titleLabel?.font = UIFont.setCustomFont(name: .medium, size: .x16)
    }
    
    private func setLocalize() {
        waitingTimeLabel.text = TaxiConstant.waitingTime.localize()
        stopButton.setTitle(TaxiConstant.stop.localize().uppercased(), for: .normal)
    }
    
   @objc func stopButtonAction(_ sender:UIButton) {
        onClickStopWaitingTime?()
    }
    
}
