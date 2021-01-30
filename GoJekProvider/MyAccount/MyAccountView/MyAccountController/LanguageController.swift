//
//  LanguageController.swift
//  GoJekProvider
//
//  Created by CSS on 04/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class LanguageController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    
    //MARK: - LocalVariable
    
    var languageArr:[Languages] = []
    var selectlanguage = String.Empty
    var profileDetail: ProfileData?
    
    private var selectedLanguage: Language = .english {
        didSet {
            LocalizeManager.share.setLocalization(language: selectedLanguage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalLoads()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        languageTableView.setCornerRadiuswithValue(value: 8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBar()  // Hidetabbar
        navigationController?.isNavigationBarHidden = false
    }
}

//MARK: - LocalMethod

extension LanguageController {
    
    private func initalLoads(){
        
        localizable() 
        localization()
        setCustomColor()
        DispatchQueue.main.async { 
            self.languageTableView.setCornerRadiuswithValue(value: 8)
            self.saveButton.setCornorRadius()
            
        }
        saveButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x14)
        selectLanguageLabel.font = .setCustomFont(name: .light, size: .x16)
        
        myAccountPresenter?.getProfileDetail()
        languageTableView.register(nibName: MyAccountConstant.LanguageTableViewCell)
        
        let baseDetail = AppManager.share.getBaseDetails()
        languageArr = baseDetail?.appsetting?.languages ?? []
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        setDarkMode()
    }
    
    private func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.languageTableView.backgroundColor = .backgroundColor
    }
    
    private func  localization() {
        
        title = MyAccountConstant.language.localized
        selectLanguageLabel.text = MyAccountConstant.selectLanguage.localized
        saveButton.setTitle(MyAccountConstant.save.localized, for: .normal)
        
    }
    
    private func setCustomColor() {
        
        setLeftBarButtonWith(color: .blackColor)
        saveButton.backgroundColor = .appPrimaryColor
        saveButton.tintColor = .white
        view.backgroundColor = .veryLightGray
        languageTableView.backgroundColor = .veryLightGray
    }
    
    @objc func saveButtonAction(_ sender:UIButton) {
        let param: Parameters = [MyAccountConstant.PLanguage: selectlanguage]
        //  switchLanguagePage()
        myAccountPresenter?.updateLanguageDetail(param: param)
    }
}

//MARK: - UITableViewDataSource

extension LanguageController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LanguageTableViewCell = languageTableView.dequeueReusableCell(withIdentifier: MyAccountConstant.LanguageTableViewCell, for: indexPath) as! LanguageTableViewCell
        
        let languagedict = languageArr[indexPath.row]
        cell.languageNameLabel.text = languagedict.name?.localized
        if selectlanguage == languagedict.key {
            cell.languageNameLabel.textColor = .blackColor
            cell.radioImageView.image = UIImage(named: MyAccountConstant.circleFullImage)
        }
        else {
            cell.languageNameLabel.textColor = .lightGray
            cell.radioImageView.image = UIImage(named: MyAccountConstant.circleImage)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate

extension LanguageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = languageTableView.cellForRow(at: indexPath) as! LanguageTableViewCell
        let languagedict = languageArr[indexPath.row]
        let language = Language.allCases[indexPath.row]
        selectedLanguage = language
        if cell.radioImageView.image?.isEqual(to: UIImage(named: MyAccountConstant.circleImage) ?? UIImage()) ?? false {
            selectlanguage = languagedict.key ?? String.Empty
            cell.radioImageView.image = UIImage(named: MyAccountConstant.circleFullImage)
        }
        else {
            cell.radioImageView.image = UIImage(named: MyAccountConstant.circleImage)
        }
        languageTableView.reloadData()
        
    }
}

//MARK: - MyAccountPresenterToMyAccountViewProtocol

extension LanguageController: MyAccountPresenterToMyAccountViewProtocol {
    
    func updateLanguageServiceSuccess(updateLanguageEntity: LogoutEntity) {
        
        
        UserDefaults.standard.set(selectedLanguage.rawValue, forKey: MyAccountConstant.Language)
        
        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.Language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
        }
        else {
            LocalizeManager.share.setLocalization(language: .english)
        }
        simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.languageSuccess.localized,state: .success)
        
        localization()
        switchLanguagePage()
        
    }
    
    func viewProfileDetail(profileEntity: ProfileEntity) {
        
        profileDetail =  profileEntity.responseData
        selectlanguage = profileDetail?.language ?? String.Empty
        
        languageTableView.reloadData()
        localization()
    }
    
    private func switchLanguagePage() {
        
        navigationController?.isNavigationBarHidden = true // For Changing backbutton direction on RTL Changes
        let settingVc = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier:MyAccountConstant.LanguageController)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [UIView.AnimationOptions.curveEaseInOut,  (self.selectedLanguage == .arabic ? UIView.AnimationOptions.transitionFlipFromLeft : UIView.AnimationOptions.transitionFlipFromRight)], animations: {
            self.navigationController?.pushViewController(settingVc, animated: true)
            self.navigationController?.isNavigationBarHidden = false
        })
        
        if Int.removeNil(navigationController?.viewControllers.count) > 2 {
            navigationController?.viewControllers.remove(at: 1)
        }
    }
    
    func switchViewControllers(isArabic arabic : Bool){
        if arabic {
            UIView.appearance().semanticContentAttribute = arabic ? .forceRightToLeft : .forceLeftToRight
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let settingVc = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier:MyAccountConstant.LanguageController)
            appDelegate?.window?.rootViewController = settingVc
        }
    }
    
    private func localizable() {
        
        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.Language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
            selectedLanguage = language
        }else {
            LocalizeManager.share.setLocalization(language: .english)
            selectlanguage = "en"
        }
        
    }
    
}
