//
//  PaymentViewController.swift
//  GoJekProvider
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var transactionButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var transactionLineView: UIView!
    @IBOutlet weak var topView: UIView!
    
    var paymentView: PaymentView?
    var transactionTableView = UITableView()
    var totalRecord = 0
    let baseModel = AppManager.share.getUserDetails()
    
    var isWalletSelect: Bool = false {
        didSet {
            UIUpdates()
        }
    }
    
    var transactionList:[TransactionData] = []
    var isUpdate = false
    var offset = 0
    var totalValues = "10"
    var currentPage =  1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
        
        //Get user profile detail
        myAccountPresenter?.getProfileDetail()
        myAccountPresenter?.postAppSettings(param: [Constant.saltkey: APPConstant.saltKeyValue])

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       transactionTableView.tableHeaderView?.frame.size.height = transactionList.count == 0 ? 0 : view.frame.size.width * 0.15
    }
}

//MARK: - LocalMethod

extension PaymentViewController {
    
    func initialLoad() {
        underLineView.isHidden = false
        transactionLineView.isHidden = true
        setNavigationBar()
        self.title = MyAccountConstant.wallet.localized
        self.setLeftBarButtonWith(color: .blackColor)
        self.walletButton.addTarget(self, action: #selector(tapWallet), for: .touchUpInside)
        self.transactionButton.addTarget(self, action: #selector(tapTransaction), for: .touchUpInside)
        self.topView.addSubview(underLineView)
        self.walletButton.setTitle(MyAccountConstant.wallet.localized, for: .normal)
        self.transactionButton.setTitle(MyAccountConstant.transaction.localized, for: .normal)
        self.addPaymentView()
        self.addTransactionView()
        self.isWalletSelect = true
        
        transactionTableView.register(nibName: MyAccountConstant.TransactionTableCell)
        transactionTableView.separatorStyle = .none
        transactionTableView.backgroundColor = .clear
        setHeaderTableBackground()
        view.backgroundColor = .backgroundColor
        
    }
    
    private func setNavigationBar() {
        let rightBarButton = UIBarButtonItem.init(image: UIImage(named: MyAccountConstant.ic_qrcode)?.resizeImage(newWidth: 25), style: .plain, target: self, action: #selector(rightBarButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func rightBarButtonAction() {
        
        showActionSheet(viewController: self,message: MyAccountConstant.qrCodeTitle.localized, buttonOne: MyAccountConstant.qrCodeReceiveAmount.localized, buttonTwo: MyAccountConstant.qrCodeSendAmount.localized, buttonThird: nil)
        onTapAction = { tag in
            if tag == 0 {
                let myQRCodeViewController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.MyQRCodeViewController) as! MyQRCodeViewController
                self.navigationController?.pushViewController(myQRCodeViewController, animated: true)
            }else if tag == 1 {
                let qrCodeScanViewController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.QRCodeScanViewController) as! QRCodeScanViewController
                self.navigationController?.pushViewController(qrCodeScanViewController, animated: true)
            }
        }
    }
    
    private func setHeaderTableBackground() {
        if let headerView = Bundle.main.loadNibNamed(MyAccountConstant.TransactionHeaderView, owner: self, options: [:])?.first as? TransactionHeaderView {
            transactionTableView.tableHeaderView = transactionList.count == 0 ? UIView() : headerView
            transactionTableView.tableHeaderView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        
        if transactionList.count == 0 {
            transactionTableView.tableHeaderView = nil

            transactionTableView.setBackgroundImageAndTitle(imageName: Constant.ic_empty_card, title: MyAccountConstant.noTransaction.localized)
        }else{
            transactionTableView.backgroundView = nil
        }
        
    }
    
    @objc func tapWallet() {
        isWalletSelect = true
        addPaymentView()
    }
    
    @objc func tapTransaction() {
        isWalletSelect = false
        let param: Parameters = [
            MyAccountConstant.POffset:offset.toString(),
            MyAccountConstant.PLimit:totalValues
        ]
        myAccountPresenter?.getTransactionList(param: param,ishideLoader: true)
    }
    
    @objc func addAmountButtonTapped() {
        
        let cashTxt = paymentView?.cashTextField.text

        guard let cashStr = cashTxt, !cashStr.isEmpty else {
            paymentView?.cashTextField.becomeFirstResponder()
            ToastManager.show(title: MyAccountConstant.cardEmptyField.localized, state: .error)
            return
        }
        
        if Int(cashTxt!) == 0 {
            paymentView?.cashTextField.becomeFirstResponder()
            ToastManager.show(title: MyAccountConstant.validAmount, state: .error)
            return
        }
        
        let paymentSelectViewController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.PaymentSelectViewController) as! PaymentSelectViewController
        paymentSelectViewController.walletAmount = cashTxt!
        paymentSelectViewController.isFromAddAmountWallet = true
        navigationController?.pushViewController(paymentSelectViewController, animated: true)
    }
    
    private func UIUpdates() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                if self.isWalletSelect {
                    self.underLineView.isHidden = false
                    self.transactionLineView.isHidden = true
                }else{
                    self.underLineView.isHidden = true
                    self.transactionLineView.isHidden = false
                }
                
                self.paymentView?.frame = CGRect(origin: CGPoint(x: self.isWalletSelect ? 0 : self.contentView.frame.width, y: 0), size: CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height))
                
                self.transactionTableView.frame = CGRect(origin: CGPoint(x: !self.isWalletSelect ? 10 : self.contentView.frame.width, y: 0), size: CGSize(width: self.contentView.frame.width-20, height: self.contentView.frame.height))
        
            })
        }

        self.transactionLineView.backgroundColor = .appPrimaryColor
        self.underLineView.backgroundColor = .appPrimaryColor
        self.walletButton.setTitleColor(isWalletSelect ? .appPrimaryColor : .lightGray, for: .normal)
        self.transactionButton.setTitleColor(isWalletSelect ? .lightGray : .appPrimaryColor, for: .normal)
    }
    
    private func addPaymentView() {
        if paymentView == nil, let paymentView = Bundle.main.loadNibNamed(MyAccountConstant.paymentView, owner: self, options: [:])?.first as? PaymentView {
            
            paymentView.frame = CGRect(origin: CGPoint(x: isWalletSelect ? 0 : view.frame.width, y: 0), size: CGSize(width: view.frame.width, height: contentView.frame.height))
            self.paymentView = paymentView
            self.paymentView?.addAmountButton.addTarget(self, action: #selector(addAmountButtonTapped), for: .touchUpInside)
            self.contentView.addSubview(paymentView)
        }
    }
    
    private func addTransactionView() {
        transactionTableView.frame = CGRect(origin: CGPoint(x: !isWalletSelect ? 10 : view.frame.width, y: 0), size: CGSize(width: contentView.frame.width, height: contentView.frame.height))
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.addSubview(transactionTableView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK:- UITableViewDataSource

extension PaymentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subTransActionList = self.transactionList[section]
        let subArray = subTransActionList.transactions
    
        guard let arrayCount = subArray?.count else {
            return 0
        }
        return arrayCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionTableCell = transactionTableView.dequeueReusableCell(withIdentifier: MyAccountConstant.TransactionTableCell, for: indexPath) as! TransactionTableCell
        
        let subTransActionList = self.transactionList[indexPath.section]
        let subArray = subTransActionList.transactions
        if subArray != nil {
          cell.setValues(values: subArray![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastCell = (transactionList.count) - 3
            if indexPath.section == lastCell {
                if currentPage < totalRecord {
                    isUpdate = true
                    currentPage =  currentPage + 1
                    offset = offset + 10
                    let param:Parameters = [
                        MyAccountConstant.POffset:currentPage.toString(),
                        MyAccountConstant.PLimit:totalValues
                    ]
                    myAccountPresenter?.getTransactionList(param:param ,ishideLoader: false)
                }
            }
        }
}

//MARK:- UITableViewDelegate

extension PaymentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
        headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        let headerLbl = UILabel()
        headerLbl.frame = CGRect(x: 15, y: 5, width: tableView.frame.width - (2 * 15), height: 20)
        headerLbl.text = transactionList[section].transaction_alias

        headerLbl.textColor = UIColor.black
        headerLbl.textAlignment = .left
        headerView.addSubview(headerLbl)
        return headerView
    }
}

//MARK:- MyAccountPresenterToMyAccountViewProtocol

extension PaymentViewController: MyAccountPresenterToMyAccountViewProtocol {
    
    func getTransactionList(transactionEntity: TransactionEntity) {
        
        if isUpdate  {
            if (transactionEntity.responseData?.data?.count ?? 0) > 0
            {
                for i in 0..<(transactionEntity.responseData?.data?.count ?? 0)
                {
                    let dict = transactionEntity.responseData?.data?[i]
                    
                    transactionList.append(dict!)
                    
                    print("Test = \(transactionList.append(dict!))")
                }
            }
        }
        else {
            transactionList = transactionEntity.responseData?.data ?? []
        }
        totalRecord  = transactionEntity.responseData?.total_records ?? 0
        
        transactionTableView.reloadInMainThread()
        setHeaderTableBackground()
    }
    
    func viewProfileDetail(profileEntity: ProfileEntity) {
        if let userDetails = profileEntity.responseData {
            DispatchQueue.main.async {
                let wallet = Constant.wallet.localized
                var walletBalance = userDetails.wallet_balance?.setCurrency()
                walletBalance = "(\(walletBalance ?? String.Empty))"
                self.paymentView?.walletLabel.attributeString(string: wallet+(walletBalance ?? String.Empty), range: NSRange(location: wallet.count, length: walletBalance?.count ?? 0), color: .lightGray)
                self.paymentView?.walletTotalAmtLabel.text = userDetails.wallet_balance?.setCurrency()
                self.paymentView?.cashTextField.text = String.Empty
            }
            AppManager.share.setUserDetails(details: userDetails)
        }
    }
    
    private func postAppsettingsResponse(baseEntity: BaseEntity) {
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        let baseModel = AppConfigurationManager.shared.baseConfigModel
        let paymetArray = baseModel?.responseData?.appsetting?.payments ?? []
        for paymentDic in paymetArray {
            if paymentDic.status == "0" {
                paymentView?.walletOuterView?.isHidden = true
                paymentView?.addAmountButton.isHidden = true
            }else{
                paymentView?.walletOuterView?.isHidden = false
                paymentView?.addAmountButton.isHidden = false
            }
        }
    }
}
