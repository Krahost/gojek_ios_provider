//
//  ReceiptView.swift
//  GoJekUser
//
//  Created by Ansar on 12/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ReceiptView: UIView {
    
    @IBOutlet weak var sourcelocationview: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationpinImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sourcelocationLabel: UILabel!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var staticReceiptLabel: UILabel!
    @IBOutlet weak var itemDiscountValueLabel: UILabel!
    @IBOutlet weak var staticItemDiscountLabel: UILabel!
    @IBOutlet weak var itemDiscountView: UIView!
    @IBOutlet weak var tollChargeView: UIView!
    @IBOutlet weak var staticTotalLabel: UILabel!
    @IBOutlet weak var staticBaseFareLabel: UILabel!
    @IBOutlet weak var staticTaxFareLabel: UILabel!
    @IBOutlet weak var staticHourlyLabel: UILabel!
    @IBOutlet weak var staticDistanceLabel: UILabel!
    @IBOutlet weak var staticWalletLabel: UILabel!
    @IBOutlet weak var staticDiscountLabel: UILabel!
    @IBOutlet weak var staticTipsLabel: UILabel!
    @IBOutlet weak var staticWaitingLabel: UILabel!
    @IBOutlet weak var staticRoundOffLabel: UILabel!
    @IBOutlet weak var staticExtraChargeLabel: UILabel!
    @IBOutlet weak var staticPackageLabel: UILabel!
    @IBOutlet weak var staticDeliveryChargeLabel: UILabel!
    @IBOutlet weak var staticPayableLabel: UILabel!
    
    @IBOutlet weak var tollChargeLabel: UILabel!
    @IBOutlet weak var staticTollCharge: UILabel!
    @IBOutlet weak var baseFareValueLabel: UILabel!
    @IBOutlet weak var taxFareValueLabel: UILabel!
    @IBOutlet weak var hourlyFareValueLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var walletFareValueLabel: UILabel!
    @IBOutlet weak var discountFareValueLabel: UILabel!
    @IBOutlet weak var tipsFareValueLabel: UILabel!
    @IBOutlet weak var totalFareValueLabel: UILabel!
    @IBOutlet weak var waitingValueLabel: UILabel!
    @IBOutlet weak var roundOffValueLabel: UILabel!
    @IBOutlet weak var extraChargeValueLabel: UILabel!
    @IBOutlet weak var packageValueLabel: UILabel!
    @IBOutlet weak var deliveryChargeValueLabel: UILabel!
    @IBOutlet weak var payableLabel: UILabel!
    
    @IBOutlet weak var receiptOuterView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var baseFareView: UIView!
    @IBOutlet weak var taxFareView: UIView!
    @IBOutlet weak var hourlyFareView: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var roundOffView: UIView!
    @IBOutlet weak var extraChargeView: UIView!
    @IBOutlet weak var packageView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var payableView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var peakChargeView: UIView!
       @IBOutlet weak var peakChargeLbl: UILabel!
       @IBOutlet weak var peakChargeValueLbl: UILabel!
    var onTapClose:(()->Void)?
    var isFlow = false

    override func awakeFromNib() {
        superview?.awakeFromNib()
        initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFlow{
        receiptOuterView.addDashLine(strokeColor: .courierColor, lineWidth: 1)
        }
        else{
        receiptOuterView.addDashLine(strokeColor: .appPrimaryColor, lineWidth: 1)
        }
    }
}

//MARK: - Methods

extension ReceiptView  {
    
    private func initialLoads() {
        self.sourcelocationview.isHidden = true
        self.locationView.isHidden = true
        totalView.backgroundColor = .appPrimaryColor
        totalView.setCornerRadiuswithValue(value: 5)
        closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        setFont()
        localize()
        payableView.backgroundColor = .veryLightGray
        setDarkMode()
    }
    
    private func setDarkMode(){
          self.receiptOuterView.backgroundColor = .boxColor
          self.baseFareView.backgroundColor = .boxColor
          self.taxFareView.backgroundColor = .boxColor
          self.hourlyFareView.backgroundColor = .boxColor
          self.distanceView.backgroundColor = .boxColor
          self.walletView.backgroundColor = .boxColor
          self.discountView.backgroundColor = .boxColor
          self.tipsView.backgroundColor = .boxColor
          self.waitingView.backgroundColor = .boxColor
          self.roundOffView.backgroundColor = .boxColor
          self.extraChargeView.backgroundColor = .boxColor
          self.peakChargeView.backgroundColor = .boxColor
          self.payableView.backgroundColor = .boxColor
          self.closeView.backgroundColor = .boxColor
        self.packageView.backgroundColor = .boxColor
        self.deliveryView.backgroundColor = .boxColor
        self.itemDiscountView.backgroundColor = .boxColor
        self.tollChargeView.backgroundColor = .boxColor

      }
    
    @objc func tapClose() {
        onTapClose?()
    }
    
    private func localize()  {
        staticReceiptLabel.text  = OrdersConstant.receipt.localized
        staticTaxFareLabel.text  = OrdersConstant.taxFare.localized
        staticHourlyLabel.text  = OrdersConstant.hourFare.localized
        staticWalletLabel.text  = OrdersConstant.wallet.localized
        staticDiscountLabel.text  = OrdersConstant.discountApplied.localized
        staticTipsLabel.text  = OrdersConstant.tips.localized
        staticDistanceLabel.text = OrdersConstant.distanceFare.localized
            peakChargeLbl.text =  OrdersConstant.peakCharge.localized
        
        staticWaitingLabel.text = OrdersConstant.waiting.localized
        staticRoundOffLabel.text = OrdersConstant.roundOff.localized
        staticExtraChargeLabel.text = OrdersConstant.extraCharge.localized
        staticPackageLabel.text = OrdersConstant.packageCharge.localized
        staticDeliveryChargeLabel.text = OrdersConstant.deliveryCharge.localized
        staticTollCharge.text = OrdersConstant.tollCharge.localized
        staticItemDiscountLabel.text = OrdersConstant.itemDiscount.localized
        staticPayableLabel.text = OrdersConstant.total.localized
    }
    
    private func setFont() {
        itemDiscountValueLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticItemDiscountLabel.font = .setCustomFont(name: .medium, size: .x14)
        tollChargeLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticTollCharge.font = .setCustomFont(name: .medium, size: .x14)
        staticReceiptLabel.font  = .setCustomFont(name: .bold, size: .x14)
        staticBaseFareLabel.font  = .setCustomFont(name: .medium, size: .x14)
        staticTaxFareLabel.font  = .setCustomFont(name: .medium, size: .x14)
        staticHourlyLabel.font  = .setCustomFont(name: .medium, size: .x14)
        staticWalletLabel.font  = .setCustomFont(name: .medium, size: .x14)
        staticDiscountLabel.font  = .setCustomFont(name: .medium, size: .x14)
        staticTotalLabel.font  = .setCustomFont(name: .medium, size: .x14)
        staticTipsLabel.font  = .setCustomFont(name: .medium, size: .x14)
        staticDistanceLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticWaitingLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticRoundOffLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticExtraChargeLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticPackageLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticDeliveryChargeLabel.font = .setCustomFont(name: .medium, size: .x14)
        staticPayableLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        locationLabel.font  = .setCustomFont(name: .medium, size: .x14)
        sourcelocationLabel.font  = .setCustomFont(name: .medium, size: .x14)
        baseFareValueLabel.font  = .setCustomFont(name: .bold, size: .x14)
        taxFareValueLabel.font  = .setCustomFont(name: .bold, size: .x14)
        hourlyFareValueLabel.font  = .setCustomFont(name: .bold, size: .x14)
        walletFareValueLabel.font  = .setCustomFont(name: .bold, size: .x14)
        discountFareValueLabel.font  = .setCustomFont(name: .bold, size: .x14)
        walletFareValueLabel.font  = .setCustomFont(name: .bold, size: .x14)
        tipsFareValueLabel.font  = .setCustomFont(name: .bold, size: .x14)
        tollChargeLabel.font = .setCustomFont(name: .bold, size: .x14)
        distanceValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        waitingValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        roundOffValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        totalFareValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        extraChargeValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        packageValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        deliveryChargeValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        payableLabel.font = UIFont.setCustomFont(name: .bold, size: .x14)
        peakChargeLbl.font = UIFont.setCustomFont(name: .medium, size: .x14)
        peakChargeValueLbl.font  = UIFont.setCustomFont(name: .bold, size: .x14)

      
    }
    
    func setValues(values: PaymentData,calculator: String) {
        deliveryView.isHidden = true
        packageView.isHidden = true
        itemDiscountView.isHidden = true
        peakChargeView.isHidden = true
        self.hourlyFareView.isHidden = true
        self.distanceView.isHidden = true
        self.staticBaseFareLabel.text = values.base_fare_text ?? OrdersConstant.baseFare.localized
        // baseFareLabel.text = values.payment?.base_fare_text
        staticHourlyLabel.text = values.time_fare_text ?? OrdersConstant.hourFare.localized
        staticDistanceLabel.text = values.distance_fare_text ?? OrdersConstant.distanceFare.localized
        staticWaitingLabel.text = values.waiting_fare_text ?? OrdersConstant.waitingFare.localized
        staticDiscountLabel.text = values.discount_fare_text ?? OrdersConstant.discountApplied.localized
        let paymentMode = PaymentType(rawValue: values.payment_mode ?? "CASH") ?? .CASH
        baseFareValueLabel.text = values.fixed?.setCurrency()
        
        taxFareValueLabel.text = (values.tax ?? 0)?.setCurrency()
        
        if calculator == invoiceCalculator.min.rawValue {
            if  let timeFare = values.minute, timeFare>0{
                self.hourlyFareValueLabel.text = (values.minute ?? 0)?.setCurrency()
                self.hourlyFareView.isHidden = false
            }
        }
        else if calculator == invoiceCalculator.hour.rawValue {
            if  let timeFare = values.hour, timeFare>0{
                self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
                self.hourlyFareView.isHidden = false
            }
        }
        else if calculator == invoiceCalculator.distancemin.rawValue {
            
            if  let timeFare = values.minute, timeFare>0{
                self.hourlyFareValueLabel.text = (values.minute ?? 0)?.setCurrency()
                self.hourlyFareView.isHidden = false
            }
            if  let distanceFare = values.distance, distanceFare>0{
                self.distanceValueLabel.text = (values.distance ?? 0)?.setCurrency()
                self.distanceView.isHidden = false
            }
            
        }        // distance with hour base
        else if calculator == invoiceCalculator.distancehour.rawValue {
            if  let timeFare = values.hour, timeFare>0{
                self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
                self.hourlyFareView.isHidden = false
            }
            if  let distanceFare = values.distance, distanceFare>0{
                self.distanceValueLabel.text = (values.distance ?? 0)?.setCurrency()
                self.distanceView.isHidden = false
            }
            
        }
        
        
        walletFareValueLabel.text = values.wallet?.setCurrency()
        walletView.isHidden = (values.wallet ?? 0) == 0
        
        discountFareValueLabel.text = "-" + (values.discount?.setCurrency() ?? "")
        discountView.isHidden = (values.discount ?? 0) == 0
        
        tipsFareValueLabel.text = values.tips?.setCurrency()
        tipsView.isHidden = (values.tips ?? 0) == 0
        
        waitingValueLabel.text = values.waiting_amount?.setCurrency()
        waitingView.isHidden = (values.waiting_amount ?? 0) == 0
        
        roundOffValueLabel.text = values.round_of?.setCurrency()
        roundOffView.isHidden = (values.round_of ?? 0) == 0
        
        extraChargeValueLabel.text = values.extra_charges?.setCurrency()
        extraChargeView.isHidden = (values.extra_charges ?? 0) == 0
        
        tollChargeLabel.text = values.toll_charge?.setCurrency()
        tollChargeView.isHidden = (values.toll_charge ?? 0) == 0
        
        let payableAmt = Double((values.tips ?? 0.0)+(values.total ?? 0.0))
        payableLabel.text = payableAmt.setCurrency()
        
        if paymentMode == .CASH && paymentMode == .WALLET {
            let totalAmt = Double((values.tips ?? 0.0)+(values.cash ?? 0.0))
            self.totalFareValueLabel.text = totalAmt.setCurrency()
            
        }
        else {
            let totalAmt = Double((values.tips ?? 0.0)+(values.card ?? 0.0))
            self.totalFareValueLabel.text = totalAmt.setCurrency()
        }
        staticTotalLabel.text  = OrdersConstant.payableAmount.localized
        if let peakFare = values.peak_amount, peakFare>0 {
            peakChargeValueLbl.text = peakFare.setCurrency()
            peakChargeView.isHidden = false
        }else{
            peakChargeView.isHidden = true
        }
        
    }
    
    func setFoodieValues(values: Order_invoice) {
         peakChargeView.isHidden = true
        self.itemDiscountValueLabel.text = "-" + (values.discount?.setCurrency() ?? "")
        self.itemDiscountView.isHidden = (values.discount ?? 0) == 0
      //static let itemTotal = "Item Total"
        staticBaseFareLabel.text  = OrdersConstant.itemTotal.localized
        staticTaxFareLabel.text  = OrdersConstant.taxAmount.localized
        self.baseFareValueLabel.text = values.item_price?.setCurrency()
        self.baseFareView.isHidden  = (values.item_price ?? 0) == 0
        payableView.isHidden = true
        taxFareValueLabel.text = (values.tax_amount ?? 0)?.setCurrency()
        taxFareView.isHidden = (values.tax_amount ?? 0) == 0
        
        walletFareValueLabel.text = (values.wallet_amount ?? 0)?.setCurrency()
        walletView.isHidden = (values.wallet_amount ?? 0) == 0
        
        discountFareValueLabel.text = "-"+((values.promocode_amount ?? 0)?.setCurrency() ?? "")
        discountView.isHidden = (values.promocode_amount ?? 0) == 0
        
        packageValueLabel.text = (values.store_package_amount ?? 0)?.setCurrency()
        packageView.isHidden = (values.store_package_amount ?? 0) == 0
        
        deliveryChargeValueLabel.text = (values.delivery_amount ?? 0)?.setCurrency()
        deliveryView.isHidden = (values.delivery_amount ?? 0) == 0
        

        self.totalFareValueLabel.text = values.cash?.setCurrency()
        staticTotalLabel.text  = OrdersConstant.total.localized

        tipsView.isHidden = true
        waitingView.isHidden = true
        extraChargeView.isHidden = true
        roundOffView.isHidden = true
        tollChargeView.isHidden = true
        roundOffValueLabel.isHidden = true
        hourlyFareView.isHidden = true
        distanceView.isHidden = true
    }
    
    
    func setCourierVaue(values: CourierOrderDetailData, index : Int)
    {
        if (values.deliveries?.count ?? 0) > 1{
            self.sourcelocationview.isHidden = false
            self.locationView.isHidden = false
        }
        else{
            self.sourcelocationview.isHidden = true
            self.locationView.isHidden = true
        }
        self.itemDiscountValueLabel.text = "-" + (Double(values.deliveries?[index].payment?.discount ??  0).setCurrency())
        self.locationLabel.text = values.deliveries?[index].d_address ?? ""
        self.sourcelocationLabel.text = values.s_address ?? ""
        self.itemDiscountView.isHidden =  (Double(values.deliveries?[index].payment?.discount ?? 0) ?? 0.0) == 0.0
        staticBaseFareLabel.text  = OrdersConstant.baseFare.localized
        taxFareValueLabel.text = Double(values.deliveries?[index].payment?.tax ?? 0).setCurrency()
        taxFareView.isHidden = Double(values.deliveries?[index].payment?.tax ?? 0) == 0
        staticHourlyLabel.text = OrdersConstant.weightFare.localized
        baseFareValueLabel.text = Double(values.deliveries?[index].payment?.fixed ?? 0).setCurrency()
        hourlyFareValueLabel.text = Double(values.deliveries?[index].payment?.weight ?? 0).setCurrency()
        hourlyFareView.isHidden = Double(values.deliveries?[index].payment?.weight ?? 0) == 0
//        walletFareValueLabel.text = Double(values.wallet ?? 0).setCurrency()
//        walletView.isHidden  == 0
        //commission
        staticWaitingLabel.text = OrdersConstant.commission.localized
        waitingValueLabel.text = Double(values.deliveries?[index].payment?.commision ?? 0).setCurrency()
        
        distanceValueLabel.text = Double(values.deliveries?[index].payment?.distance ?? 0).setCurrency()
        distanceView.isHidden = Double(values.deliveries?[index].payment?.distance ?? 0) == 0

        waitingView.isHidden = Double(values.deliveries?[index].payment?.commision ?? 0) == 0

//        roundOffValueLabel.text = Double(values.round_of ?? 0).setCurrency()
//        roundOffView.isHidden = (values.round_of ?? 0) == 0
        
        let payableAmt = Double(values.deliveries?[index].payment?.total ?? 0)
        payableLabel.text = payableAmt.setCurrency()
        
        self.totalFareValueLabel.text = Double(values.deliveries?[index].payment?.total ?? 0).rounded().setCurrency()
              staticTotalLabel.text  = OrdersConstant.total.localized
        walletView.isHidden = true
        tipsView.isHidden = true
        extraChargeView.isHidden = true
        tollChargeView.isHidden = true
        deliveryView.isHidden = true
        packageView.isHidden = true
        roundOffView.isHidden = true
        discountView.isHidden = true
         peakChargeView.isHidden = true
    }
    
    func setCourierFlowValues(values: CourierCheckRequestData, index: Int, isOverAll : Bool) {
        staticReceiptLabel.text = CourierConstant.fareDetails.localized
        deliveryView.isHidden = true
        packageView.isHidden = true
        itemDiscountView.isHidden = true
        tipsView.isHidden = true
        peakChargeView.isHidden = true

        totalView.backgroundColor = .courierColor
        isFlow = true
        let data = values.request?.delivery

        let paymentMode = PaymentType(rawValue: data?.paymentMode ?? "CASH") ?? .CASH
        self.baseFareValueLabel.text = Double(data?.payment?.fixed ?? 0).setCurrency()
        staticBaseFareLabel.text  = OrdersConstant.baseFare.localized
        self.taxFareValueLabel.text = Double(data?.payment?.tax ?? 0).setCurrency()
        staticWaitingLabel.text = OrdersConstant.weightFare.localized
       // self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
        hourlyFareView.isHidden = true
        self.distanceValueLabel.text = Double(data?.payment?.distance ?? 0).setCurrency()
        self.distanceView.isHidden = (data?.payment?.distance ?? 0) == 0

        //        self.walletFareValueLabel.text = values.wallet?.setCurrency()
        //        self.walletView.isHidden = (values.wallet ?? 0) == 0
        self.walletView.isHidden = true
        self.discountFareValueLabel.text = "-" + (Double(data?.payment?.discount ?? 0).setCurrency() ?? "")
        self.discountView.isHidden = (data?.payment?.discount ?? 0) == 0
        staticHourlyLabel.text = OrdersConstant.commission.localized
        hourlyFareValueLabel.text = Double(data?.payment?.commision ?? 0).setCurrency()
        hourlyFareView.isHidden = Double(data?.payment?.commision ?? 0) == 0
//        self.recieverNameLabel.text = data?.name ?? ""
//        self.receiverMobileLabel.text = data?.mobile ?? ""
//        self.deliveryTypeLabel.text = data?.payment?package_type?.package_name ?? ""
        //        self.tipsFareValueLabel.text = values.tips?.setCurrency()
        //        self.tipsView.isHidden = (values.tips ?? 0) == 0
        
        self.waitingValueLabel.text = Double(data?.payment?.weight ?? 0).setCurrency()
        self.waitingView.isHidden = (data?.payment?.weight ?? 0) == 0
        //        self.roundOffValueLabel.text = values.round_of?.setCurrency()
        //        self.roundOffView.isHidden = (values.round_of ?? 0) == 0
        self.roundOffView.isHidden = true
        
        //        self.extraChargeLabel.text = values.extra_charges?.setCurrency()
        //        self.extraChargeView.isHidden = (values.extra_charges ?? 0) == 0
        self.extraChargeView.isHidden = true
        
        //        self.tollChargeValueLabel.text = values.toll_charge?.setCurrency()
        //        self.tollChargeView.isHidden = (values.toll_charge ?? 0) == 0
        
//        self.CommissionLabel.text = (data?.payment?.commision ?? 0).setCurrency()
//        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0
//        self.commissionView.isHidden = (values.deliveries?[index].payment?.commision ?? 0) == 0

//        self.lengthLabel.text = "\(values.data?.first?.deliveries?[index].length ?? 0)" + "" + OrderConstant.cm.localized
//        self.lengthView.isHidden = (values.data?.first?.deliveries?[index].length ?? 0) == 0
//
//        self.heightLabel.text = "\(values.data?.first?.deliveries?[index].height ?? 0)" + "" + OrderConstant.cm.localized
//        self.heightView.isHidden = (values.data?.first?.deliveries?[index].height ?? 0) == 0
//
//        self.breadthLabel.text = "\(values.data?.first?.deliveries?[index].breadth ?? 0)" + "" + OrderConstant.cm.localized
//        self.breadthView.isHidden = (values.data?.first?.deliveries?[index].breadth ?? 0) == 0
//
//        self.weightLabel.text = "\(values.data?.first?.deliveries?[index].weight ?? 0)" + "" + OrderConstant.kg.localized
//        self.weightView.isHidden = (values.data?.first?.deliveries?[index].weight ?? 0) == 0
        
        self.tollChargeView.isHidden = true
        
        let payableAmt = Double((data?.payment?.total ?? 0.0))
        payableLabel.text = payableAmt.setCurrency()
        
        if paymentMode == .CASH {
            
            let totalAmt = Double((data?.payment?.total ?? 0.0)).rounded()
            self.totalFareValueLabel.text = totalAmt.setCurrency()
        }else {
                let totalAmt = Double((data?.payment?.total ?? 0.0))
                self.totalFareValueLabel.text = totalAmt.setCurrency()
        }
//        lengthView.isHidden = true
//        heightView.isHidden = true
//        breadthView.isHidden = true
//        weightView.isHidden = true
        staticTotalLabel.text  = OrdersConstant.payableAmount.localized
        
        if isOverAll{
            let data = values.request
            let paymentMode = PaymentType(rawValue: data?.paymentMode ?? "CASH") ?? .CASH
            self.baseFareValueLabel.text = Double(data?.payment?.fixed ?? 0).setCurrency()
            staticBaseFareLabel.text  = OrdersConstant.baseFare.localized
            self.taxFareValueLabel.text = Double(data?.payment?.tax ?? 0).setCurrency()
            staticWaitingLabel.text = OrdersConstant.weightFare.localized
           // self.hourlyFareValueLabel.text = (values.hour ?? 0)?.setCurrency()
            hourlyFareView.isHidden = true
            self.distanceValueLabel.text = Double(data?.payment?.distance ?? 0).setCurrency()
            self.distanceView.isHidden = (data?.payment?.distance ?? 0) == 0

            //        self.walletFareValueLabel.text = values.wallet?.setCurrency()
            //        self.walletView.isHidden = (values.wallet ?? 0) == 0
            self.walletView.isHidden = true
            self.discountFareValueLabel.text = "-" + (Double(data?.payment?.discount ?? 0).setCurrency() ?? "")
            self.discountView.isHidden = (data?.payment?.discount ?? 0) == 0
            
            staticHourlyLabel.text = OrdersConstant.commission.localized
            hourlyFareValueLabel.text = Double(data?.payment?.commision ?? 0).setCurrency()
            hourlyFareView.isHidden = Double(data?.payment?.commision ?? 0) == 0
    //        self.recieverNameLabel.text = data?.name ?? ""
    //        self.receiverMobileLabel.text = data?.mobile ?? ""
    //        self.deliveryTypeLabel.text = data?.payment?package_type?.package_name ?? ""
            //        self.tipsFareValueLabel.text = values.tips?.setCurrency()
            //        self.tipsView.isHidden = (values.tips ?? 0) == 0
            
            self.waitingValueLabel.text = Double(data?.payment?.weight ?? 0).setCurrency()
            self.waitingView.isHidden = (data?.payment?.weight ?? 0) == 0
            
            self.tollChargeView.isHidden = true
            
            let payableAmt = Double((data?.payment?.total ?? 0.0))
            payableLabel.text = payableAmt.setCurrency()
            
            if paymentMode == .CASH {
                
                let totalAmt = Double((data?.payment?.total ?? 0.0)).rounded()
                self.totalFareValueLabel.text = totalAmt.setCurrency()
            }else {
                let totalAmt = Double((data?.payment?.total ?? 0.0))
                    self.totalFareValueLabel.text = totalAmt.setCurrency()
            }
        }
        
    }
}
