//
//  CourierInvoiceView.swift
//  GoJekProvider
//
//  Created by Chan Basha on 05/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class CourierInvoiceView: UIView {

    @IBOutlet weak var labelInvoice: UILabel!
    
    @IBOutlet weak var labelBookingID: UILabel!
    
    @IBOutlet weak var labelBookingIDValue: UILabel!
    
    @IBOutlet weak var labelTotal: UILabel!
    
    @IBOutlet weak var labelTotalValue: UILabel!
    
    @IBOutlet weak var labelAmountToBePaid: UILabel!
    
    @IBOutlet weak var labelAmountToBepaidValue: UILabel!
    
    
    @IBOutlet weak var imagePayment: UIImageView!
    
    
    @IBOutlet weak var labelPaymentType: UILabel!
    
    
    @IBOutlet weak var buttonChangePayment: UIButton!
    
    @IBOutlet weak var buttonConfirmPayment: UIButton!
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var imageBGView: UIView!
    
    @IBOutlet weak var labelDistanceTravelled: UILabel!
    @IBOutlet weak var labelDistanceValue: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var labelTimeValue: UILabel!
    
    @IBOutlet weak var labelBaseFare: UILabel!
    
    @IBOutlet weak var labelBaseFareValue: UILabel!
    
    @IBOutlet weak var labelDistanceFare: UILabel!
    
    @IBOutlet weak var labelDistanceFlowValue: UILabel!
    
    @IBOutlet weak var labelTax: UILabel!
    
    @IBOutlet weak var labelTaxValue: UILabel!
    
    @IBOutlet weak var labelCoupon: UILabel!
    @IBOutlet weak var labelCouponValue: UILabel!

    @IBOutlet weak var amountBGView: UIView!
    @IBOutlet weak var timeTakenView: UIStackView!
    @IBOutlet weak var distanceFareView: UIStackView!
    @IBOutlet weak var taxView: UIStackView!
    @IBOutlet weak var couponView: UIStackView!
    @IBOutlet weak var distanceTravelledView: UIStackView!

    
    
    var onClickConfirm:(()->Void)?
    
    var requestData : CourierCheckRequestData?
    
    override func awakeFromNib() {
        initialLoads()
    }
    override func layoutSubviews() {
        amountBGView.setCornerRadiuswithValue(value: 8)
        imageBGView.setCornerRadius()
        BGView.setCornerRadiuswithValue(value: 6)
        buttonConfirmPayment.setCornerRadiuswithValue(value: 4)
    }
    
    private func initialLoads(){
        setFont()
        setConstant()
        setDesign()
        setDesign()
        self.buttonConfirmPayment.addTarget(self, action: #selector(confirmPayment(sender:)), for: .touchUpInside)
        self.backgroundColor = .backgroundColor
        self.BGView.backgroundColor = .boxColor

    }
    
    func setValues(values:CourierCheckRequestData?, isSender : Bool){
        if isSender {
            let currencySymbol = values?.request?.currency ?? String.Empty
            labelCouponValue.text = "\(currencySymbol) \(values?.request?.payment?.discount ?? 0)"
            couponView.isHidden = values?.request?.delivery?.payment?.discount == 0.0
            labelBookingIDValue.text = values?.request?.bookingId
            labelTotalValue.text = "\(currencySymbol) \(values?.request?.payment?.total ?? 0)"
            labelAmountToBepaidValue.text =  "\(currencySymbol) \(values?.request?.payment?.total?.rounded() ?? 0)"
            labelTaxValue.text = "\(currencySymbol) \(values?.request?.payment?.tax ?? 0)"
            labelBaseFareValue.text = "\(currencySymbol) \(values?.request?.payment?.fixed ?? 0)"
            labelDistanceFlowValue.text = "\(currencySymbol) \(values?.request?.payment?.weight ?? 0)"
            labelDistanceValue.text = "\(currencySymbol) \(values?.request?.payment?.distance ?? 0)"
            distanceFareView.isHidden = ((values?.request?.payment?.weight ?? 0) == 0)

            
            //Commission
            labelTime.text = CourierConstant.commission.localized
            labelTimeValue.text =  "\(currencySymbol) \(values?.request?.payment?.commision ?? 0)"
            timeTakenView.isHidden = ((values?.request?.payment?.commision ?? 0) == 0)
            
            if values?.request?.payment?.paymentMode == "CARD"{
                buttonConfirmPayment.setTitle(CourierConstant.waitingForPayment.localized, for: .normal)
                buttonConfirmPayment.isUserInteractionEnabled = false

            }else{
                buttonConfirmPayment.isUserInteractionEnabled = true

                buttonConfirmPayment.setTitle(CourierConstant.confirmPayment, for: .normal)
            }


                   //Validate waiting fare grater then 0
    //               if let waitingFare = values?.request?.waitingAmount, waitingFare>0 {
    //                   labelTimeValue.text = self.setCurrency(amount: waitingFare, currency: currencySymbol)
    //                   timeTakenView.isHidden = true
    //               }
            if values?.request?.paymentMode == PaymentType.CASH.rawValue {
                
                imagePayment.image = #imageLiteral(resourceName: "money")
                labelPaymentType.text = PaymentType.CASH.rawValue
                
            }else{
                imagePayment.image = #imageLiteral(resourceName: "ic_credit_card")
                labelPaymentType.text = PaymentType.CARD.rawValue
            }
        }
        else{
        
        let currencySymbol = values?.request?.currency ?? String.Empty
        labelCouponValue.text = "\(currencySymbol) \(values?.request?.delivery?.payment?.discount ?? 0)"
        couponView.isHidden = values?.request?.delivery?.payment?.discount == 0.0
        labelBookingIDValue.text = values?.request?.bookingId
        labelTotalValue.text = "\(currencySymbol) \(values?.request?.delivery?.payment?.total ?? 0)"
        labelAmountToBepaidValue.text =  "\(currencySymbol) \(values?.request?.delivery?.payment?.total?.rounded() ?? 0)"
        labelTaxValue.text = "\(currencySymbol) \(values?.request?.delivery?.payment?.tax ?? 0)"
        labelBaseFareValue.text = "\(currencySymbol) \(values?.request?.delivery?.payment?.fixed ?? 0)"
        labelDistanceFlowValue.text = "\(currencySymbol) \(values?.request?.delivery?.payment?.weight ?? 0)"
        labelDistanceValue.text = "\(currencySymbol) \(values?.request?.delivery?.payment?.distance ?? 0)"
        distanceFareView.isHidden = ((values?.request?.payment?.weight ?? 0) == 0)

        //Commission
        labelTime.text = CourierConstant.commission.localized
        labelTimeValue.text =  "\(currencySymbol) \(values?.request?.delivery?.payment?.commision ?? 0)"
        timeTakenView.isHidden = ((values?.request?.delivery?.payment?.commision ?? 0) == 0)
        
        if values?.request?.payment?.paymentMode == "CARD"{
            buttonConfirmPayment.setTitle(CourierConstant.waitingForPayment.localized, for: .normal)
            buttonConfirmPayment.isUserInteractionEnabled = false

        }else{
            buttonConfirmPayment.isUserInteractionEnabled = true

            buttonConfirmPayment.setTitle(CourierConstant.confirmPayment, for: .normal)
        }


               //Validate waiting fare grater then 0
//               if let waitingFare = values?.request?.waitingAmount, waitingFare>0 {
//                   labelTimeValue.text = self.setCurrency(amount: waitingFare, currency: currencySymbol)
//                   timeTakenView.isHidden = true
//               }
        if values?.request?.paymentMode == PaymentType.CASH.rawValue {
            
            imagePayment.image = #imageLiteral(resourceName: "money")
            labelPaymentType.text = PaymentType.CASH.rawValue
            
        }else{
            imagePayment.image = #imageLiteral(resourceName: "ic_credit_card")
            labelPaymentType.text = PaymentType.CARD.rawValue
        }
        }
    }
    
    private func setFont(){

        labelInvoice.font = .setCustomFont(name: .bold, size: .x18)
        labelBookingID.font = .setCustomFont(name: .light, size: .x14)
        labelBookingIDValue.font = .setCustomFont(name: .light, size: .x14)
        labelTotal.font = .setCustomFont(name: .light, size: .x14)
        labelTotalValue.font = .setCustomFont(name: .light, size: .x14)
        labelAmountToBePaid.font = .setCustomFont(name: .light, size: .x14)
        labelAmountToBepaidValue.font = .setCustomFont(name: .light, size: .x14)
        buttonConfirmPayment.titleLabel?.font = .setCustomFont(name: .light, size: .x18)
        labelPaymentType.font = .setCustomFont(name: .light, size: .x14)
        
        labelDistanceFare.font = .setCustomFont(name: .light, size: .x14)
        labelDistanceValue.font = .setCustomFont(name: .light, size: .x14)
        labelTime.font = .setCustomFont(name: .light, size: .x14)
        labelTimeValue.font = .setCustomFont(name: .light, size: .x14)
        labelBaseFare.font = .setCustomFont(name: .light, size: .x14)
        labelBaseFareValue.font = .setCustomFont(name: .light, size: .x14)
        labelDistanceTravelled.font = .setCustomFont(name: .light, size: .x14)
        labelCouponValue.font = .setCustomFont(name: .light, size: .x14)
        labelDistanceFlowValue.font = .setCustomFont(name: .light, size: .x14)
        labelTax.font = .setCustomFont(name: .light, size: .x14)
        labelTaxValue.font = .setCustomFont(name: .light, size: .x14)
        labelCoupon.font = .setCustomFont(name: .light, size: .x14)
    }
    
    private func setConstant(){
        labelInvoice.text = CourierConstant.invoice.localized
        labelAmountToBePaid.text = CourierConstant.amountToBePaid.localized
        labelTotal.text = CourierConstant.total.localized
        labelBookingID.text = CourierConstant.bookingID.localized
        buttonConfirmPayment.setTitle(CourierConstant.confirmPayment, for: .normal)
        labelBaseFare.text = CourierConstant.baseFare.localized
        labelTax.text = CourierConstant.tax.localized
        labelDistanceTravelled.text = CourierConstant.distanceTravelled.localized
        labelDistanceFare.text = CourierConstant.weight.localized
        labelCoupon.text = CourierConstant.couponCode.localized
    }
    
    private func setDesign(){
        buttonConfirmPayment.backgroundColor = .courierColor
        buttonConfirmPayment.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func confirmPayment(sender:UIButton){
       onClickConfirm?()
        
    }
   
}

