//
//  PaymentSelectViewController.swift
//  GoJekProvider
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class PaymentSelectViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LocalVariable
    var paymentTypeArr: [Payments] = []
    var cardFooterView: CardView?
    var isFromAddAmountWallet: Bool = false
    var walletAmount: String = String.Empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()
        //Get card status
        myAccountPresenter?.postAppSettings(param: [Constant.saltkey: APPConstant.saltKeyValue])
    }
}

// MARK: - LocalMethod

extension PaymentSelectViewController {
    
    private func initialSetup() {
        
        self.title = isFromAddAmountWallet == true ? MyAccountConstant.choosePayment.localized : MyAccountConstant.payment.localized
        
        // Do any additional setup after loading the view.
        let baseConfig = AppManager.share.getBaseDetails()
        let paymetArray = baseConfig?.appsetting?.payments ?? []
        for paymentDic in paymetArray {
            if paymentDic.name?.uppercased() != Constant.card.uppercased() {
                paymentTypeArr.append(paymentDic)
            }
        }
        
        view.backgroundColor = .backgroundColor
        setLeftBarButtonWith(color: .blackColor)
        
        tableView.register(nibName: MyAccountConstant.PaymentTypeTableViewCell)
        tableView.register(nibName: MyAccountConstant.CardView)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
    }
}

// MARK: - UITableViewDataSource

extension PaymentSelectViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: MyAccountConstant.PaymentTypeTableViewCell, for: indexPath) as! PaymentTypeTableViewCell
        
        let paymentDic = paymentTypeArr[indexPath.row]
        cell.setPaymentValue(payment: paymentDic)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
        header?.backgroundColor = .clear
        header?.textLabel?.font = .setCustomFont(name: .medium, size: .x18)
        header?.textLabel?.textColor = .blackColor
        header?.textLabel?.text = MyAccountConstant.availablePayment.localized
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if paymentTypeArr.contains(where: { ($0.name)?.uppercased()  == Constant.cash.uppercased() }) {
            return cardFooterView
        }
        return nil
    }
}

//MARK: - UITableViewDelegate

extension PaymentSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cardFooterView?.frame.height ?? 0
    }
}

// MARK: - MyAccountPresenterToMyAccountViewProtocol

extension PaymentSelectViewController: MyAccountPresenterToMyAccountViewProtocol {
    
    func getCardResponse(getCardResponse: CardEntityResponse) {
        
        print(getCardResponse)
        cardFooterView?.isDeleteCancelShow = true
        cardFooterView?.cardsList = getCardResponse
        cardFooterView?.paymentCardCollectionView.reloadInMainThread()
    }
    
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse) {
        
        myAccountPresenter?.getCard()
    }
    
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity) {
        
        simpleAlert(view: self, title: String.Empty, message: walletSuccessResponse.responseData?.message?.localized ?? MyAccountConstant.AddAmountSuccess.localized, state: .success)
        navigationController?.popViewController(animated: true)
    }
    
    func postAppSettingsResponse(baseEntity: BaseEntity) {
        
        //Get Card detail
        myAccountPresenter?.getCard()
        paymentTypeArr.removeAll()
        
        AppConfigurationManager.shared.baseConfigModel = baseEntity
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        
        let paymetArray = baseEntity.responseData?.appsetting?.payments ?? []
        var tempPaymentArray: [Payments] = []
        for paymentDic in paymetArray {
            if paymentDic.status == "1" {
                paymentTypeArr.append(paymentDic)
                tempPaymentArray.append(paymentDic)
            }
        }
        
        if isFromAddAmountWallet == true, let index = paymentTypeArr.firstIndex(where: { $0.name?.uppercased() ==  Constant.cash.uppercased()}) {
            paymentTypeArr.remove(at: index)
        }
        
        if let _ = paymentTypeArr.firstIndex(where: { $0.name?.uppercased() ==  Constant.card.uppercased()}) {
            if let index = paymentTypeArr.firstIndex(where: { $0.name?.uppercased() ==  Constant.card.uppercased()}) {
                paymentTypeArr.remove(at: index)
            }
            if self.cardFooterView == nil, let cardFooterView = Bundle.main.loadNibNamed(MyAccountConstant.CardView, owner: self, options: [:])?.first as? CardView {
                cardFooterView.frame = CGRect(x: 16, y: paymentTypeArr.count>0 ? 0 : 100, width: view.frame.width-32, height: cardFooterView.frame.height)
                cardFooterView.backgroundColor = .backgroundColor
                cardFooterView.delegate = self
                self.cardFooterView = cardFooterView
                self.view.addSubview(cardFooterView)
            }
        }
        
        if tempPaymentArray.count == 0 {
            tableView.setBackgroundImageAndTitle(imageName: Constant.ic_empty_card, title: MyAccountConstant.noPaymentType)
        }
        else {
            tableView.backgroundView = nil
        }
        tableView.reloadInMainThread()
    }
}

// MARK: - CardViewDelegate

extension PaymentSelectViewController: CardViewDelegate {
    
    func deleteButtonClick() {
        
        simpleAlert(view: self, title: XuberConstant.deleteCard.localized, message: String.Empty, buttonOneTitle: Constant.SYes.localized, buttonTwoTitle: Constant.SNo.localized)
        onTapAlert = { [weak self] (tag) in
            guard let self = self else {
                return
            }
            if tag == 1 {
                self.myAccountPresenter?.deleteCard(cardID: self.cardFooterView?.selectedCardId ?? 0 )
            }
        }
    }
    
    func addAmountToWallet() {
        
        if isFromAddAmountWallet == true {
            guard cardFooterView?.selectedCardId != 0 else {
                simpleAlert(view: self, title: String.Empty.localized, message: MyAccountConstant.cardSelection.localized, state: .error)
                return
            }
            
            let param: Parameters = [MyAccountConstant.PAmount: walletAmount,
                                     MyAccountConstant.PCardId: cardFooterView?.selectedCard_token ?? String.Empty,
                                     MyAccountConstant.PUsertype: userType.Provider.rawValue,
                                     MyAccountConstant.PpaymentMode: Constant.card]
            myAccountPresenter?.addMoneyToWallet(param: param)
        }
    }
    
    func addNewCardButtonClick() {
        
        let addCardViewController = storyboard?.instantiateViewController(withIdentifier: MyAccountConstant.AddCardViewController) as! AddCardViewController
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
}



