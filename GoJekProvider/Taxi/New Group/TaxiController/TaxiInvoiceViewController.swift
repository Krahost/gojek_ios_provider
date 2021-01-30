//
//  TaxiInvoiceViewController.swift
//  GoJekProvider
//
//  Created by apple on 14/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
class TaxiInvoiceViewController: UIViewController {
    
    //Static label
    @IBOutlet weak var bookingIDLabel: UILabel!
    @IBOutlet weak var distanceTravelLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var baseFareLabel: UILabel!
    @IBOutlet weak var distanceFareLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentViaLabel: UILabel!
    @IBOutlet weak var cardCashLabel: UILabel!
    @IBOutlet weak var tollChargeLabel: UILabel!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var walletDeductionView: UIView!
    @IBOutlet weak var distanceFareView: UIView!
    @IBOutlet weak var tipsValueLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tipsView: UIView!
    
    @IBOutlet weak var staticSourceDestinationLabel: UILabel!
    @IBOutlet weak var sourceAddressLabel: UILabel!
    @IBOutlet weak var destinationAddressLabel: UILabel!
    @IBOutlet weak var bookingIDValueLabel: UILabel!
    @IBOutlet weak var distanceTravelValueLabel: UILabel!
    @IBOutlet weak var timeTakenValueLabel: UILabel!
    @IBOutlet weak var baseFareValueLabel: UILabel!
    @IBOutlet weak var distanceFareValueLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var tollChangeAmountLabel: UILabel!
    
    @IBOutlet weak var staticDollarLabel: UILabel!
    @IBOutlet weak var paymentOuterView: UIView!
    @IBOutlet weak var paymentInnerView: UIView!
    @IBOutlet weak var invoiceImageView: UIImageView!
    @IBOutlet weak var totalView:UIView!
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var staticDiscountLabel: UILabel!
    @IBOutlet weak var processDashView: UIView!
    @IBOutlet weak var pickupLocationView: UIView!
    @IBOutlet weak var dropLocationView: UIView!
    @IBOutlet weak var finishView: UIView!
    
    @IBOutlet weak var pickupImageView: UIImageView!
    @IBOutlet weak var dropImageView: UIImageView!
    @IBOutlet weak var finishImageView: UIImageView!
    @IBOutlet weak var paymentTypeImageView: UIImageView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var processView: UIView!
    @IBOutlet weak var billInfoView: UIView!
    @IBOutlet weak var invoiceImageBackgroundView: UIView!
    
    @IBOutlet weak var walletDeductionValueLabel: UILabel!
    @IBOutlet weak var staticWalletDeductionLabel: UILabel!
    @IBOutlet weak var timeTakenView: UIView!
    @IBOutlet weak var tollView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
       
    @IBOutlet weak var waitingChargeView: UIView!
    @IBOutlet weak var waitingChargeLbl: UILabel!
    @IBOutlet weak var waitingChargeValueLbl: UILabel!
       
    @IBOutlet weak var peakChargeView: UIView!
    @IBOutlet weak var peakChargeLbl: UILabel!
    @IBOutlet weak var peakChargeValueLbl: UILabel!
    
    @IBOutlet weak var totalFareView: UIView!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var totalFareValueLabel: UILabel!
    
    
    @IBOutlet weak var subTotalFareView: UIView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalValueLabel: UILabel!
    
    
    var taxiCheckRquestData: TaxiCheckRequestData?
    var onClickConfirm:(()->Void)?
    var currency = ""
    var delegate: InVoiceDelegate?
    private var taxiRatingView: TaxiRatingView?


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title = TaxiConstant.invoice.localized
        // Do any additional setup after loading the view.
        viewDidSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.setCustomDesign()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        hideTabBar()
    }
}

//MARK: - Methods

extension TaxiInvoiceViewController {
    
    private func viewDidSetup() {
        
        confirmButton.addTarget(self, action: #selector(confirmPaymentButtonAction(_:)), for: .touchUpInside)
        invoiceImageView.image = UIImage.init(named: TaxiConstant.invoiceImage)
        pickupImageView.image = UIImage.init(named: TaxiConstant.pickupImage)?.imageTintColor(color: .black)
        dropImageView.image = UIImage.init(named: TaxiConstant.dropImage)?.imageTintColor(color: .black)
        finishImageView.image = UIImage.init(named: TaxiConstant.finishImage)?.imageTintColor(color: .black)
        staticDollarLabel.adjustsFontSizeToFitWidth = true
        DispatchQueue.main.async {
            self.updateInvoiceViewDetail()
        }
        //NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(invoiceDetailUpdate), name: Notification.Name("InvoiceDetailUpdate"), object: nil)
        setCustomColor()
        setCustomFont()
        setCustomLocalization()
        setDarkMode()
    }
    
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.profileView.backgroundColor = .boxColor
        self.addressView.backgroundColor = .boxColor
        self.processView.backgroundColor = .boxColor
        self.billInfoView.backgroundColor = .boxColor
        self.paymentOuterView.backgroundColor = .boxColor

    }
    
    @objc func invoiceDetailUpdate(notification: Notification) {
        let detail = notification.userInfo
        taxiCheckRquestData = detail?["data"] as? TaxiCheckRequestData
        DispatchQueue.main.async {
            self.updateInvoiceViewDetail()
        }
    }
    
    private func setCustomDesign() {
        
        if CommonFunction.checkisRTL() {
            paymentOuterView.setOneSideCorner(corners: .topRight, radius: paymentInnerView.frame.width/2)
        }else {
            paymentOuterView.setOneSideCorner(corners: .topLeft, radius: paymentInnerView.frame.width/2)
        }
        paymentInnerView.setCornerRadius()
        staticDollarLabel.setCornerRadius()
        invoiceImageView.setCornerRadius()
        addressView.setCornerRadiuswithValue(value: 5.0)
        processView.setCornerRadiuswithValue(value: 5.0)
        billInfoView.setCornerRadiuswithValue(value: 5.0)
        paymentOuterView.setCornerRadiuswithValue(value: 5.0)
        confirmButton.setCornerRadiuswithValue(value: 5.0)
        invoiceImageBackgroundView.setCornerRadius()
    }
    
    private func setCustomFont() {
        tipsLabel.font = .setCustomFont(name: .light, size: .x14)
        tipsValueLabel.font = .setCustomFont(name: .light, size: .x14)
        walletDeductionValueLabel.font = .setCustomFont(name: .light, size: .x14)
        staticWalletDeductionLabel.font = .setCustomFont(name: .light, size: .x14)
        sourceAddressLabel.font = .setCustomFont(name: .light, size: .x14)
        destinationAddressLabel.font = .setCustomFont(name: .light, size: .x14)
        staticSourceDestinationLabel.font = .setCustomFont(name: .bold, size: .x16)
        staticDiscountLabel.font = .setCustomFont(name: .light, size: .x14)
        discountLabel.font = .setCustomFont(name: .light, size: .x14)
        bookingIDLabel.font = .setCustomFont(name: .light, size: .x14)
        bookingIDValueLabel.font = .setCustomFont(name: .light, size: .x14)
        distanceFareLabel.font = .setCustomFont(name: .light, size: .x14)
        distanceFareValueLabel.font = .setCustomFont(name: .light, size: .x14)
        timeTakenLabel.font = .setCustomFont(name: .light, size: .x14)
        timeTakenValueLabel.font = .setCustomFont(name: .light, size: .x14)
        baseFareLabel.font = .setCustomFont(name: .light, size: .x14)
        baseFareValueLabel.font = .setCustomFont(name: .light, size: .x14)
        distanceTravelLabel.font = .setCustomFont(name: .light, size: .x14)
        distanceTravelValueLabel.font = .setCustomFont(name: .light, size: .x14)
        taxLabel.font = .setCustomFont(name: .light, size: .x14)
        taxValueLabel.font = .setCustomFont(name: .light, size: .x14)
        tollChargeLabel.font = .setCustomFont(name: .light, size: .x14)
        tollChangeAmountLabel.font = .setCustomFont(name: .light, size: .x14)
        staticDollarLabel.font = .setCustomFont(name: .medium, size: .x12)
        totalLabel.font = .setCustomFont(name: .bold, size: .x16)
        totalValueLabel.font = .setCustomFont(name: .bold, size: .x16)
        subTotalLabel.font = .setCustomFont(name: .bold, size: .x14)
        subTotalValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        totalFareLabel.font = .setCustomFont(name: .bold, size: .x14)
        totalFareValueLabel.font = .setCustomFont(name: .bold, size: .x14)
        waitingChargeLbl.font = .setCustomFont(name: .light, size: .x14)
        peakChargeLbl.font = .setCustomFont(name: .light, size: .x14)
        waitingChargeValueLbl.font = .setCustomFont(name: .light, size: .x14)
        peakChargeValueLbl.font = .setCustomFont(name: .light, size: .x14)
        confirmButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x18)
    }
    
    //Set custom color
    private func setCustomColor() {
        totalView.backgroundColor = .white
        totalLabel.textColor = .black
        totalValueLabel.textColor = .black
        confirmButton.backgroundColor = .taxiColor
        confirmButton.textColor(color: .white)
        paymentInnerView.backgroundColor = .taxiColor
        staticDollarLabel.backgroundColor = .taxiColor
        view.backgroundColor = UIColor.veryLightGray
        profileView.backgroundColor = .clear
        addressView.backgroundColor = .white
        processView.backgroundColor = .white
        billInfoView.backgroundColor = .white
        paymentOuterView.backgroundColor = .white
        pickupLocationView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
        dropLocationView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
        finishView.backgroundColor = UIColor.taxiColor.withAlphaComponent(0.5)
        pickupImageView.setImageColor(color: .taxiColor)
        dropImageView.setImageColor(color: .taxiColor)
        finishImageView.setImageColor(color: .taxiColor)
        pickupLocationView.setBorderWith(color: .taxiColor, width: 1.5)
        dropLocationView.setBorderWith(color: .taxiColor, width: 1.5)
        finishView.setBorderWith(color: .taxiColor, width: 1.5)
        processDashView.addSingleLineDash(color: .taxiColor, width: 2)
        totalFareLabel.textColor = .blackColor
        totalFareValueLabel.textColor = .blackColor
        subTotalLabel.textColor = .blackColor
        subTotalValueLabel.textColor = .blackColor
    }
    
    //Set custom localization
    private func setCustomLocalization() {
        staticWalletDeductionLabel.text = TaxiConstant.walletDeduction.localized
        staticDiscountLabel.text = TaxiConstant.discount.localized
        staticSourceDestinationLabel.text = TaxiConstant.sourceDestination.localized
        bookingIDLabel.text = TaxiConstant.bookingId.localized
        distanceTravelLabel.text = TaxiConstant.distanceTravel.localized
        timeTakenLabel.text = TaxiConstant.timeTaken.localized
        baseFareLabel.text = TaxiConstant.baseFare.localized
        distanceFareLabel.text = TaxiConstant.distanceFare.localized
        taxLabel.text = TaxiConstant.tax.localized
        totalLabel.text = TaxiConstant.totalbill.localized
        paymentViaLabel.text = TaxiConstant.paymentVia.localized
        tollChargeLabel.text = TaxiConstant.tollCharge.localized
        tipsLabel.text = TaxiConstant.tips.localized
        totalFareLabel.text =  TaxiConstant.totalfare.localized
        subTotalLabel.text =  TaxiConstant.subtotal.localized
        waitingChargeLbl.text = TaxiConstant.waitingFare.localized
        peakChargeLbl.text =  TaxiConstant.peakCharge.localized

        
        if CommonFunction.checkisRTL() {
            bookingIDValueLabel.textAlignment = .left
            baseFareValueLabel.textAlignment = .left
            taxValueLabel.textAlignment = .left
            totalValueLabel.textAlignment = .left
            cardCashLabel.textAlignment = .left
            distanceFareValueLabel.textAlignment = .left
            walletDeductionValueLabel.textAlignment = .left
            discountLabel.textAlignment = .left
            timeTakenValueLabel.textAlignment = .left
            distanceTravelValueLabel.textAlignment = .left
            tipsValueLabel.textAlignment = .left
            
        }else {
            bookingIDValueLabel.textAlignment = .right
            baseFareValueLabel.textAlignment = .right
            taxValueLabel.textAlignment = .right
            totalValueLabel.textAlignment = .right
            cardCashLabel.textAlignment = .right
            distanceFareValueLabel.textAlignment = .right
            walletDeductionValueLabel.textAlignment = .right
            discountLabel.textAlignment = .right
            timeTakenValueLabel.textAlignment = .right
            distanceTravelValueLabel.textAlignment = .right
            tipsValueLabel.textAlignment = .right
        }
    }
    
    private func updateInvoiceViewDetail() {
        
        let requestDetail = taxiCheckRquestData?.request
        let paymentDetail = taxiCheckRquestData?.request?.payment
        let providerDetail = taxiCheckRquestData?.providerDetails
        
        currency = providerDetail?.currencySymbol ?? String.Empty
        
        timeTakenView.isHidden = true
        waitingChargeView.isHidden = true
        peakChargeView.isHidden = true
        distanceFareView.isHidden = true
        
        
        baseFareLabel.text = taxiCheckRquestData?.request?.payment?.base_fare_text
        distanceFareLabel.text = taxiCheckRquestData?.request?.payment?.distance_fare_text
        timeTakenLabel.text = taxiCheckRquestData?.request?.payment?.time_fare_text
        
        waitingChargeLbl.text = taxiCheckRquestData?.request?.payment?.waiting_fare_text ?? TaxiConstant.waitingFare.localized
        staticDiscountLabel.text = taxiCheckRquestData?.request?.payment?.discount_fare_text ?? TaxiConstant.discount.localized
        
        //Validate value
        
        tipsValueLabel.text = requestDetail?.payment?.tips?.setCurrency()
        tipsView.isHidden = requestDetail?.payment?.tips == 0.0
        tollView.isHidden = (requestDetail?.payment?.tollCharge ?? 0) == 0
        bookingIDValueLabel.text = requestDetail?.bookingId ?? String.Empty
        distanceTravelValueLabel.text = "\(requestDetail?.total_distance ?? 0) \(requestDetail?.unit ?? String.Empty)"
        sourceAddressLabel.text = requestDetail?.sAddress ?? String.Empty
        destinationAddressLabel.text = requestDetail?.dAddress ?? String.Empty
        cardCashLabel.text = requestDetail?.paymentMode?.uppercased() ?? Constant.cash.localized.uppercased()
        
        let currencySymbol = providerDetail?.currencySymbol ?? String.Empty
        //Validate waiting fare grater then 0
        //        if let waitingFare = paymentDetail?.waitingAmount, waitingFare>0 {
        //            timeTakenValueLabel.text = self.setCurrency(amount: waitingFare, currency: currencySymbol)
        //            timeTakenView.isHidden = false
        //        }
        if requestDetail?.calculator == invoiceCalculator.min.rawValue {
            if let timeFare = taxiCheckRquestData?.request?.payment?.minute, timeFare>0 {
                timeTakenValueLabel.text = setCurrency(amount: Double(taxiCheckRquestData?.request?.payment?.minute ?? 0), currency: currencySymbol)
                timeTakenView.isHidden = false
            }
        }else if requestDetail?.calculator == invoiceCalculator.hour.rawValue {
            if let timeFare = taxiCheckRquestData?.request?.payment?.hour, timeFare>0 {
                timeTakenValueLabel.text = setCurrency(amount: taxiCheckRquestData?.request?.payment?.hour ?? 0, currency: currencySymbol)
                timeTakenView.isHidden = false
            }
        }  else if requestDetail?.calculator == invoiceCalculator.distancemin.rawValue {
            
            if let timeFare = taxiCheckRquestData?.request?.payment?.minute, timeFare>0 {
                timeTakenValueLabel.text = setCurrency(amount: Double(taxiCheckRquestData?.request?.payment?.minute ?? 0), currency: currencySymbol)
                timeTakenView.isHidden = false
            }
            if let distance = taxiCheckRquestData?.request?.payment?.distance , distance>0 {
                distanceFareView.isHidden = false
                distanceFareValueLabel.text = setCurrency(amount: taxiCheckRquestData?.request?.payment?.distance ?? 0, currency: currencySymbol)
            }
            
        }        // distance with hour base
        else if requestDetail?.calculator == invoiceCalculator.distancehour.rawValue {
            if let timeFare = taxiCheckRquestData?.request?.payment?.hour, timeFare>0 {
                timeTakenValueLabel.text = setCurrency(amount: Double(taxiCheckRquestData?.request?.payment?.hour ?? 0), currency: currencySymbol)
                timeTakenView.isHidden = false
            }
            if let distance = taxiCheckRquestData?.request?.total_distance , distance>0 {
                distanceFareView.isHidden = false
                distanceFareValueLabel.text = setCurrency(amount: taxiCheckRquestData?.request?.total_distance ?? 0, currency: currencySymbol)
            }
            
        }
        if let waitingFare = paymentDetail?.waitingAmount, waitingFare>0 {
            waitingChargeValueLbl.text = setCurrency(amount: paymentDetail?.waitingAmount ?? 0, currency: currencySymbol)
            waitingChargeView.isHidden = false
        }
        if let peakFare = paymentDetail?.peakAmount, peakFare>0 {
            peakChargeValueLbl.text = setCurrency(amount: paymentDetail?.peakAmount ?? 0, currency: currencySymbol)
            peakChargeView.isHidden = false
        }
        
        if let totalFare = paymentDetail?.total_fare, totalFare>0 {
            totalFareValueLabel.text = setCurrency(amount: paymentDetail?.total_fare ?? 0, currency: currencySymbol)
            totalFareView.isHidden = false
        }else{
            totalFareView.isHidden = true
        }
        if let subFare = paymentDetail?.sub_total, subFare>0 {
            subTotalValueLabel.text = setCurrency(amount: paymentDetail?.sub_total ?? 0, currency: currencySymbol)
            subTotalFareView.isHidden = false
        }else{
            subTotalFareView.isHidden = true
            
        }
        
        
        baseFareValueLabel.text = self.setCurrency(amount: paymentDetail?.fixed ?? 0.0, currency: currencySymbol)
        taxValueLabel.text = self.setCurrency(amount: paymentDetail?.tax ?? 0.0, currency: currencySymbol)
        discountLabel.text = "-" + self.setCurrency(amount:paymentDetail?.discount ?? 0.0, currency: currencySymbol)
        cardCashLabel.text = requestDetail?.paymentMode?.uppercased() ?? Constant.cash.localized.uppercased()
        walletDeductionValueLabel.text = "-" + self.setCurrency(amount:paymentDetail?.wallet ?? 0.0, currency: currencySymbol)
        discountView.isHidden = paymentDetail?.discount == 0.0
        walletDeductionValueLabel.text = "-" + setCurrency(amount:paymentDetail?.wallet ?? 0.0, currency: currencySymbol)
        walletDeductionView.isHidden = paymentDetail?.wallet == 0.0
        
        if let tollCharge = paymentDetail?.tollCharge, tollCharge>0 {
            
            tollChangeAmountLabel.text = self.setCurrency(amount: tollCharge, currency: currencySymbol)
            tollView.isHidden = false
        }
        
        if taxiCheckRquestData?.request?.useWallet == 1 {
            confirmButton.setTitle(Constant.SDone.localized.uppercased(), for: .normal)
            paymentTypeImageView.image = UIImage.init(named: TaxiConstant.walletImage)
        }else {
            if taxiCheckRquestData?.request?.paymentMode == Constant.cash.uppercased() {
                confirmButton.setTitle(Constant.confirmPayment.localized.uppercased(), for: .normal)
                paymentTypeImageView.image = UIImage.init(named: Constant.ic_money)
            }else {
                confirmButton.setTitle(Constant.SDone.localized.uppercased(), for: .normal)
                paymentTypeImageView.image = UIImage.init(named: Constant.ic_creditCard)
            }
        }
        
        if ((requestDetail?.payment?.tips) != 0.0) {
            let totalAmt = Double((paymentDetail?.payable ?? 0.0)+(requestDetail?.payment?.tips ?? 0.0))
            totalValueLabel.text = self.setCurrency(amount: totalAmt, currency: currencySymbol)
        }else {
            totalValueLabel.text = self.setCurrency(amount: paymentDetail?.payable ?? 0.0, currency: currencySymbol)
        }
        staticDollarLabel.text = self.setCurrency(amount: paymentDetail?.payable ?? 0.0, currency: currencySymbol)
    }
    
    @objc func confirmPaymentButtonAction(_ sender: UIButton) {
            //onClickConfirm?()
            if self.taxiCheckRquestData?.request?.paymentMode == Constant.cash.uppercased() {
    //            self.updateTaxiStatus(with: TravelState.completed.rawValue)
                //Update payment done completed
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.removeObserver(self, name: Notification.Name("InvoiceDetailUpdate"), object: nil)
                delegate?.showCash()
             
            }else{
                if self.taxiCheckRquestData?.request?.useWallet == 1 {
                    let requestDetail = self.taxiCheckRquestData?.request
                    let param: Parameters = [TaxiConstant.id: requestDetail?.id ?? 0]
                    self.taxiPresenter?.paymentRequest(param: param)
                }else {
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("InvoiceDetailUpdate"), object: nil)

                    delegate?.showRating()
                   // self.showTaxiRatingView()
                }
            }
        }
        
        
        
        private func setCurrency(amount:Double,currency:String) -> String  {
            return currency+amount.roundOff(2)
        }
    }

    extension TaxiInvoiceViewController: TaxiPresenterToTaxiViewProtocol{
        //Update taxi request status
          private func updateTaxiStatus(with status: String) {
              
          }
        func providerRatingResponse(taxiEntity: TaxiEntity) {
              
              if let _ = taxiRatingView {
                  taxiRatingView =  nil
              }
    //          xmapView?.clearAll()
              BackGroundRequestManager.share.resetBackGroudTask()
              ToastManager.show(title: Constant.RatingToast, state: .success)
              taxiCheckRquestData = taxiEntity.responseData
              navigationController?.popViewController(animated: true)
            
          }
        func updateRequestResponse(taxiEntity: TaxiEntity) {
            
            let requestDetail = self.taxiCheckRquestData?.request
                       let param: Parameters = [TaxiConstant.id: requestDetail?.id ?? 0]
            self.taxiPresenter?.paymentRequest(param: param)
              
           }
         func paymentRequestResponse(taxiEntity: PaidEntity) {
              // self.showTaxiRatingView()
            delegate?.Confirm()
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.removeObserver(self, name: Notification.Name("InvoiceDetailUpdate"), object: nil)



           }
    }


