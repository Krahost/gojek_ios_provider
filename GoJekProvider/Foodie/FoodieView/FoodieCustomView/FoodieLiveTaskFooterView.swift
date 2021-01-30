//
//  FoodieLiveTaskFooterView.swift
//  GoJekProvider
//
//  Created by Ansar on 04/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class FoodieLiveTaskFooterView: UIView {
    
    //Static label
    @IBOutlet weak var staticItemTotalLabel: UILabel!
    @IBOutlet weak var staticTaxLabel: UILabel!
    @IBOutlet weak var staticDeliveryChargeLabel: UILabel!
    @IBOutlet weak var staticWalletLabel: UILabel!
    @IBOutlet weak var staticTotalLabel: UILabel!
    @IBOutlet weak var staticShopPackageLabel: UILabel!
    @IBOutlet weak var staticDiscountLabel: UILabel!
    @IBOutlet weak var shopPackageLabel: UILabel!
    @IBOutlet weak var staticCouponLabel: UILabel!
    
    //Dynamic label
    @IBOutlet weak var itemTotalValueLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var deliveryChargeValueLabel: UILabel!
    @IBOutlet weak var walletValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var discountValueLabel: UILabel!
    @IBOutlet weak var couponValueLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var couponView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
        setCustomLocalize()
        self.backgroundColor = .backgroundColor
    }
    
    override func layoutSubviews() {
        topView.addSingleLineDash(color: .lightGray, width: 1)
    }

}

extension FoodieLiveTaskFooterView {
    
    private func setCustomLocalize() {
        staticItemTotalLabel.text = FoodieConstant.itemTotal.localized
        staticTaxLabel.text = FoodieConstant.serviceTax.localized
        staticDeliveryChargeLabel.text = FoodieConstant.deliveryCharge.localized
        staticWalletLabel.text = FoodieConstant.wallet.localized
        staticTotalLabel.text = FoodieConstant.total.localized
        staticShopPackageLabel.text =  FoodieConstant.storePackage.localized
        staticDiscountLabel.text =  FoodieConstant.discount.localized
        staticCouponLabel.text =  FoodieConstant.counpon.localized
        
        staticItemTotalLabel.textColor = .lightGray
        staticTaxLabel.textColor = .lightGray
        staticDeliveryChargeLabel.textColor = .lightGray
        staticWalletLabel.textColor = .lightGray
        staticTotalLabel.textColor = .foodieColor
        staticShopPackageLabel.textColor = .lightGray
        staticDiscountLabel.textColor = .lightGray
        shopPackageLabel.textColor = .lightGray
        staticCouponLabel.textColor = .lightGray
        
        //Dynamic label
        itemTotalValueLabel.textColor = .lightGray
        taxValueLabel.textColor = .lightGray
        deliveryChargeValueLabel.textColor = .lightGray
        walletValueLabel.textColor = .lightGray
        totalValueLabel.textColor = .foodieColor
        discountValueLabel.textColor = .lightGray
        couponValueLabel.textColor = .lightGray
        
        if CommonFunction.checkisRTL() {
            
            itemTotalValueLabel.textAlignment = .left
            taxValueLabel.textAlignment = .left
            deliveryChargeValueLabel.textAlignment = .left
            walletValueLabel.textAlignment = .left
            totalValueLabel.textAlignment = .left
            discountValueLabel.textAlignment = .left
            couponValueLabel.textAlignment = .left
            shopPackageLabel.textAlignment = .left
            
        }else {
            itemTotalValueLabel.textAlignment = .right
            taxValueLabel.textAlignment = .right
            deliveryChargeValueLabel.textAlignment = .right
            walletValueLabel.textAlignment = .right
            totalValueLabel.textAlignment = .right
            discountValueLabel.textAlignment = .right
            couponValueLabel.textAlignment = .right
            shopPackageLabel.textAlignment = .right
        }
    }
    
    private func setCustomFont() {
        shopPackageLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticShopPackageLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticItemTotalLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticTaxLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticDeliveryChargeLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticWalletLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticTotalLabel.font = .setCustomFont(name: .medium, size: .x16)
        staticDiscountLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticCouponLabel.font = .setCustomFont(name: .medium, size: .x14)
        
        itemTotalValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        taxValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        deliveryChargeValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        walletValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        totalValueLabel.font = .setCustomFont(name: .medium, size: .x16)
        discountValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        couponValueLabel.font = .setCustomFont(name: .medium, size: .x14)
    }
    
    func setValues(values: Order_invoice) {
        
        shopPackageLabel.text = (values.store_package_amount ?? 0).setCurrency()
        
        taxValueLabel.text = (values.tax_amount ?? 0)?.setCurrency()
        
        itemTotalValueLabel.text = (values.item_price ?? 0)?.setCurrency()
        
        deliveryChargeValueLabel.text = (values.delivery_amount ?? 0)?.setCurrency()
        
        totalValueLabel.text = (values.payable ?? 0)?.setCurrency()
        
        walletValueLabel.text = (values.wallet_amount ?? 0)?.setCurrency()
        walletView.isHidden = (values.wallet_amount ?? 0) == 0
        
        couponValueLabel.text = "- " + ((values.promocode_amount)?.setCurrency() ?? String.Empty)
        couponView.isHidden = (values.promocode_amount ?? 0) == 0
        
        discountValueLabel.text = "- " + ((values.discount)?.setCurrency() ?? String.Empty)
        discountView.isHidden = (values.discount ?? 0) == 0
    }
}
