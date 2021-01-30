//
//  MyAccountController.swift
//  GoJekProvider
//
//  Created by Ansar on 22/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class MyAccountController: UIViewController {
    
    @IBOutlet weak var accountCollectionView: UICollectionView!
    
    var accountImageArr = [MyAccountConstant.icProfileImage,
                           MyAccountConstant.manageServiceImage,
                           MyAccountConstant.manageDocumentImage,
                           MyAccountConstant.bankicon,
                           MyAccountConstant.paymentImage,
                           MyAccountConstant.walletSmall,
                           MyAccountConstant.earningsImage,
                           MyAccountConstant.privacyPolicyImage,
                           MyAccountConstant.supportImage,
                           MyAccountConstant.languageImage]
    
    var accountNameArr = [MyAccountConstant.profile,
    MyAccountConstant.manageService,
    MyAccountConstant.manageDocument,
    MyAccountConstant.bankDetails,
    MyAccountConstant.payment,
    MyAccountConstant.wallet,
    MyAccountConstant.Earning,
    MyAccountConstant.privacyPolicy,
    MyAccountConstant.support,
    MyAccountConstant.language]
    
    private var selectedLanguage: Language = .english {
        didSet {
            LocalizeManager.share.setLocalization(language: selectedLanguage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show tabbar
       showTabBar()
        navigationController?.isNavigationBarHidden = false
        setLocalization()
        setupLanaguage()
       // accountCollectionView.reloadData()

    }
    
}

//MARK: - Methods

extension MyAccountController {
    private func initialLoads() {
        title = MyAccountConstant.account.localized
        setNavigationTitle()
        view.backgroundColor = .veryLightGray
        accountCollectionView.register(nibName: MyAccountConstant.AccountCollectionViewCell)
       
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        if (baseConfig?.responseData?.appsetting?.referral ?? 0) == 1 {
            accountImageArr.insert(MyAccountConstant.referFriend, at: 7)
            accountNameArr.insert(MyAccountConstant.inviteReferral, at: 7)
        }
        addshadow()
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.accountCollectionView.backgroundColor = .backgroundColor
    }
    
    private func setupLanaguage(){

        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.Language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
           // self.selectedLanguage = language
        }
        else {
            LocalizeManager.share.setLocalization(language: .english)
        }

        if self.selectedLanguage == .arabic {
            let logoutBarButtonItem = UIBarButtonItem(image: UIImage(named: MyAccountConstant.Logout)?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(tapMore))
            logoutBarButtonItem.tintColor = .blackColor
            self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        }else {
            let logoutBarButtonItem = UIBarButtonItem(image: UIImage(named: MyAccountConstant.Logout), style: .plain, target: self, action: #selector(tapMore))
            logoutBarButtonItem.tintColor = .blackColor
            self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        }
        accountCollectionView.reloadData()
    }
    
    @objc private func tapMore() {
        showActionSheet(viewController: self,message: MyAccountConstant.logoutMsg.localized, buttonOne: MyAccountConstant.logout.localized)
        onTapAction = { [weak self] tag in
            guard let self = self else {
                return
            }
            self.myAccountPresenter?.getLogoutDetail()
        }
        
    }
    
    private func setLocalization() {
        title = MyAccountConstant.account.localized
    }
    
    private func pushPrivacyPolicy() {
        let vc = WebViewController()
        if let privacyUrl = AppConfigurationManager.shared.baseConfigModel.responseData?.appsetting?.cmspage?.privacypolicy {
            vc.urlString = privacyUrl
        }
        vc.navTitle = MyAccountConstant.privacyPolicy.localized
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension MyAccountController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountNameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AccountCollectionViewCell = accountCollectionView.dequeueReusableCell(withReuseIdentifier: MyAccountConstant.AccountCollectionViewCell, for: indexPath) as! AccountCollectionViewCell
        cell.setValues(name: accountNameArr[indexPath.row], imageString: accountImageArr[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension MyAccountController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let baseConfig = AppConfigurationManager.shared.baseConfigModel
        let isReferralEnable = (baseConfig?.responseData?.appsetting?.referral ?? 0) == 1
        switch indexPath.row {
        case 0:
            let myProfileController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.MyProfileController)
            navigationController?.pushViewController(myProfileController, animated: true)
        case 1:
            push(id: MyAccountConstant.ManageServiceController)
        case 2:
            push(id: MyAccountConstant.ManageDocumentController)
        case 3:
            push(id: MyAccountConstant.BankDetailController)
        case 4:
            push(id: MyAccountConstant.PaymentSelectViewController)
        case 5:
            push(id: MyAccountConstant.PaymentViewController)
        case 6:
            push(id: MyAccountConstant.EarningsController)
        case 7:
            if isReferralEnable {
                push(id: MyAccountConstant.InviteController)
            }else{
                pushPrivacyPolicy()
            }
        case 8:
            if isReferralEnable {
                 pushPrivacyPolicy()
            }else{
                push(id: MyAccountConstant.SupportController)
            }
        case 9:
            if isReferralEnable {
                push(id: MyAccountConstant.SupportController)
            }else{
                push(id: MyAccountConstant.LanguageController)
            }
        case 10:
            push(id: MyAccountConstant.LanguageController)
        default:
            break
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MyAccountController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let width:CGFloat = (accountCollectionView.frame.size.width - space) / 2.0
        let height:CGFloat = (accountCollectionView.frame.size.width - space) / 2.3
        return CGSize(width: width, height: height)
    }
}

//MARK: - MyAccountPresenterToMyAccountViewProtocol

extension MyAccountController: MyAccountPresenterToMyAccountViewProtocol {
    func getLogoutServiceSuccess(getLogoutServiceEntity: LogoutEntity) {    
        //Delete data from coredata
        BackGroundRequestManager.share.stopBackGroundRequest()

        AppManager.share.accessToken = ""
        AppConfigurationManager.shared.baseConfigModel = nil
        DataBaseManager.shared.delete(entityName: CoreDataEntity.loginData.rawValue)
        XSocketIOManager.sharedInstance.closeSocketConnection()
        BackGroundRequestManager.share.stopBackGroundRequest()
        //Navigate to walkthrough view controller
        let walkThrough = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.WalkThroughController)
        CommonFunction.changeRootController(controller: walkThrough)
    }
    
}
