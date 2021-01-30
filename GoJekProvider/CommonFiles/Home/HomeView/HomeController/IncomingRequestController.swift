//
//  IncomingRequestController.swift
//  GoJekProvider
//
//  Created by Rajes on 07/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

protocol IncomingRequestDelegate: class {
    
    func acceptButtonAction(_ sender: UIButton)
    func rejectButtonAction(_ sender: UIButton)
    func finishButtonAction()
}

class IncomingRequestController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var requestTitleLabel: UILabel!
    @IBOutlet weak var locationPlaceHolderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var serviceDetailsLabel: UILabel!
    
    @IBOutlet weak var rejectButton:UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var deliveryView: UIView!
    
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelWeightValue: UILabel!
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: Progressview!
    
    //MARK: - LocalVariable
    weak var delegate: IncomingRequestDelegate?
    var checkResponseDetail: CheckResponseData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defalutSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AudioManager.share.startPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AudioManager.share.stopSound()
    }
}

//MARK: - LocalMethod

extension IncomingRequestController {
    
    func defalutSetup() {
        
        containerView.setCornerRadiuswithValue(value: 5)
        progressView.delegate = self
        progressView.timeLeftValue = Double(checkResponseDetail?.requests?.first?.timeLeftToRespond ?? 60)
        view.isOpaque = false
        
        let requestDetail = checkResponseDetail?.requests?.first?.request
        
        progressView.timeLeftValue = Double(checkResponseDetail?.requests?.first?.timeLeftToRespond ?? 60)
        let status = ActiveStatus(rawValue: checkResponseDetail?.serviceStatus ?? String.Empty) ?? .none
        if status == .transport {
            
            deliveryView.isHidden = true
            serviceDetailsLabel.text = (requestDetail?.rideType?.ride_name ?? String.Empty) + " - " + (requestDetail?.rideDetail?.vehicle_name ?? String.Empty)
            locationLabel.text = requestDetail?.sAddress ?? String.Empty
        }
        else if status == .order {
             deliveryView.isHidden = true
            let orderDetail = requestDetail?.pickup
            serviceDetailsLabel.text = (orderDetail?.storeType?.name ?? String.Empty) + " - " + (orderDetail?.storeType?.category ?? String.Empty)
            locationLabel.text = (requestDetail?.pickup?.store_location ?? String.Empty) 
        }
        else if status == .service {
             deliveryView.isHidden = true
            let serviceDetail = requestDetail?.service
            serviceDetailsLabel.text = (serviceDetail?.service_category?.service_category_name ?? String.Empty) + " - " + (serviceDetail?.ServiceSubCategory?.service_subcategory_name ?? String.Empty)
            locationLabel.text = requestDetail?.sAddress ?? String.Empty
        }else if status == .delivery {
            
            
            deliveryView.isHidden = false
           serviceDetailsLabel.text = requestDetail?.admin_service
           locationLabel.text = requestDetail?.sAddress ?? String.Empty
           labelWeightValue.text = "\(requestDetail?.weight ?? 0) KG"
            
        }
        
        DispatchQueue.main.async {
            self.rejectButton.setCornorRadius()
            self.acceptButton.setCornorRadius()
        }
        
        setCustomColor()
        setCustomFont()
        setCustomLocalization()
        containerView.backgroundColor = .boxColor
    }
    
    private func setCustomColor() {
        
        locationLabel.textColor = .lightGray
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        serviceDetailsLabel.textColor = .lightGray
        labelWeightValue.textColor = .lightGray
        rejectButton.setTitleColor(.white, for: .normal)
        rejectButton.backgroundColor = .foodieColor
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = .xuberColor
    }
    
    private func setCustomFont() {
        
        serviceDetailsLabel.font = .setCustomFont(name: .medium, size: .x12)
        locationPlaceHolderLabel.font = .setCustomFont(name: .medium, size: .x16)
        requestTitleLabel.font = .setCustomFont(name: .medium, size: .x16)
        locationLabel.font = .setCustomFont(name: .medium, size: .x12)
        serviceTypeLabel.font = .setCustomFont(name: .medium, size: .x16)
        labelWeightValue.font = .setCustomFont(name: .medium, size: .x12)
        labelWeight.font = .setCustomFont(name: .medium, size: .x16)
        rejectButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        acceptButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
    }
    
    private func setCustomLocalization() {
        
        requestTitleLabel.text = Constant.incomingRequest.localized
        locationPlaceHolderLabel.text = Constant.location.localized
        labelWeight.text = Constant.weight.localized
        serviceTypeLabel.text = Constant.serviceType.localized
        rejectButton.setTitle(Constant.Reject.localized, for: .normal)
        acceptButton.setTitle(Constant.Accept.localized, for: .normal)
    }
}

//MARK: - IBAction

extension IncomingRequestController {
    
    @IBAction func rejectAction(_ sender: UIButton) {
        
        progressView.removeTimer()
        delegate?.rejectButtonAction(sender)
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        
        progressView.removeTimer()
        delegate?.acceptButtonAction(sender)
    }
}

//MARK: - ProgressViewDelegate

extension IncomingRequestController: ProgressViewDelegate {
    
    func finishedProgress() {
        delegate?.finishButtonAction()
      //  dismiss(animated: true, completion: nil)
    }
}
