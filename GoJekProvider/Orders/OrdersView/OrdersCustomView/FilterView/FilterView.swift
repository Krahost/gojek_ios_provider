//
//  FilterView.swift
//  MySample
//
//  Created by CSS01 on 20/02/19.
//  Copyright © 2019 CSS01. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    //Outlets
    @IBOutlet weak var filterTitleLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tripButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!
    
    var selectedType: Int = 0 { // 1 - Trip 2 - Order 3 - Service
        didSet {
            let tripColor: UIColor = selectedType == 1 ? .appPrimaryColor : .lightGray
            let orderColor: UIColor = selectedType == 2 ? .appPrimaryColor : .lightGray
            let serviceColor: UIColor = selectedType == 3 ? .appPrimaryColor : .lightGray
            let deliveryColor : UIColor = selectedType == 4 ? .appPrimaryColor : .lightGray
            
            tripButton.backgroundColor = tripColor.withAlphaComponent(0.1)
            orderButton.backgroundColor = orderColor.withAlphaComponent(0.1)
            serviceButton.backgroundColor = serviceColor.withAlphaComponent(0.1)
            deliveryButton.backgroundColor = deliveryColor.withAlphaComponent(0.1)
            
            tripButton.setTitleColor(selectedType == 1 ? .appPrimaryColor : .blackColor, for: .normal)
            orderButton.setTitleColor(selectedType == 2 ? .appPrimaryColor : .blackColor, for: .normal)
            serviceButton.setTitleColor(selectedType == 3 ? .appPrimaryColor : .blackColor, for: .normal)
            deliveryButton.setTitleColor(selectedType == 4 ? .appPrimaryColor : .blackColor, for: .normal)
        }
    }
    
    var onTapServices: ((String)->Void)?
    
    //ViewLifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialLoads()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        DispatchQueue.main.async {
            self.applyButton.setCornerRadius()
            self.tripButton.setCornerRadius()
            self.orderButton.setCornerRadius()
            self.serviceButton.setCornerRadius()
            self.deliveryButton.setCornorRadius()
        }
    }
}

//MARK: LocalMethod

extension FilterView {
    
    private func initialLoads() {
        
        selectedType = 1
        tripButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)
        orderButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)
        serviceButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)
        deliveryButton.addTarget(self, action: #selector(tapServiceType(_:)), for: .touchUpInside)
        
        tripButton.titleLabel?.adjustsFontSizeToFitWidth = true
        orderButton.titleLabel?.adjustsFontSizeToFitWidth = true
        serviceButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deliveryButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        resetButton.addTarget(self, action: #selector(tapReset), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(tapApply), for: .touchUpInside)
        
        setCustomFont()
        setCustomColor()
        setCustomLocalization()
        setDarkMode()
    }
    
    func setDarkMode(){
        self.backgroundColor = .boxColor
    }
    
    private func setCustomFont() {
        
        filterTitleLabel.font = .setCustomFont(name: .bold, size: .x18)
        resetButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        applyButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        tripButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        orderButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        deliveryButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)

        serviceButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    private func setCustomColor() {
        
        applyButton.backgroundColor = .appPrimaryColor
        resetButton.textColor(color: .appPrimaryColor)
    }
    
    private func setCustomLocalization() {
        
        filterTitleLabel.text = OrdersConstant.filterBy.localized
        resetButton.setTitle(OrdersConstant.reset.localized, for: .normal)
        applyButton.setTitle(OrdersConstant.apply.localized, for: .normal)
        tripButton.setTitle(ServiceTypes.trips.rawValue.localized, for: .normal)
        orderButton.setTitle(ServiceTypes.orders.rawValue.localized, for: .normal)
        serviceButton.setTitle(ServiceTypes.service.rawValue.localized, for: .normal)
        deliveryButton.setTitle(ServiceTypes.delivery.rawValue.localized, for: .normal)

    }
}

//MARK: - IBAction

extension FilterView {
    
    @objc func tapServiceType(_ sender: UIButton) {
        selectedType = sender.tag
    }
    
    @objc func tapReset() {
        selectedType = -1
    }
    
    @objc func tapApply() {
        
        if selectedType < 0 {
            ToastManager.show(title: OrdersConstant.selectType.localized, state: .error)
            return
        }
        let selectedService = ServiceTypes.allCases[selectedType-1].rawValue
        if let currentService = ServiceTypes(rawValue: selectedService) {
            onTapServices!(currentService.currentType)
        }
    }
}
