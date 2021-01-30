//
//  ViewControllerExtension.swift
//  GoJekProvider
//
//  Created by Ansar on 25/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import AVKit

private var imageCompletion: ((UIImage?)->())?
private var backBarButtonAction: (()->Void)?

/** ACTION SHEET
 Simple two actionsheet button
 Button One Patameter Int: 1
 Button Two Patameter Int: 2
 */
var onTapAction: ((Int)->Void)?

/** ALERT
 Simple single alert button
 Button One Patameter Int: 1
 
 Simple two alert button
 Button One Patameter Int: 1
 Button two Patameter Int: 2
 */
var onTapAlert: ((Int)->Void)?

extension UIViewController {
    
    //MARK:- Show Image Selection Action Sheet
    func showImage(isRemoveNeed: String? = nil,with completion : @escaping ((UIImage?)->())){  //isRemoveNeed - used to remove photo in profile

        showActionSheet(viewController: self,message: Constant.choosePicture.localized, buttonOne: Constant.openCamera.localized, buttonTwo: Constant.openGalley.localized,buttonThird: isRemoveNeed == nil ? nil : Constant.removePhoto.localized)
        imageCompletion = completion
        onTapAction = { tag in
            if tag == 0 {
                self.checkCameraPermission(source: .camera)
            }else if tag == 1 {
                self.checkCameraPermission(source: .photoLibrary)
            }else {
                let imageView = UIImageView()
                imageView.image = UIImage(named: Constant.userPlaceholderImage)
                imageCompletion?(imageView.image)
            }
        }
    }
    
    private func checkCameraPermission(source : UIImagePickerController.SourceType) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch (cameraAuthorizationStatus){
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.chooseImage(with: source)
                    }else {
                        ToastManager.show(title: Constant.cameraPermission.localized, state: .warning)
                    }
                }
            }
        case .restricted, .denied:
            ToastManager.show(title: Constant.cameraPermission.localized, state: .warning)
        case .authorized:
            self.chooseImage(with: source)
        default:
            ToastManager.show(title: Constant.cameraPermission.localized, state: .warning)
        }
    }
    
    func showOpenCamera(with completion : @escaping ((UIImage?)->())){
        imageCompletion = completion
        self.checkCameraPermission(source: .camera)
    }
    
    func addshadow(){
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.7
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    func showDimView(view: UIView) {
        let dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimView.addSubview(view)
        self.view.addSubview(dimView)
    }
    
    public func setNavigationTitle() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackColor, NSAttributedString.Key.font: UIFont.setCustomFont(name: .bold, size: .x20)]
    }
    
    // MARK:- Show Image Picker
    
    private func chooseImage(with source : UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func disableTabBar() {
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    
    public func enableTabBar() {
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    //Hide tabbar in view controller
    public func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1

    }
    
    //Hide show in view controller
    public func showTabBar() {
        
        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.Language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
        }
        else {
            LocalizeManager.share.setLocalization(language: .english)
        }
        
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0

        guard let items = self.tabBarController?.tabBar.items else { return }
        
        DispatchQueue.main.async {
            
            items[0].title = HomeConstant.THome.localized
            items[1].title = OrdersConstant.history.localized
            items[2].title = NotificationConstant.TNotification.localized
            items[3].title = MyAccountConstant.account.localized
            if CommonFunction.checkisRTL() {
                
                self.tabBarController?.tabBar.semanticContentAttribute = .forceRightToLeft
                
            }else {
                self.tabBarController?.tabBar.semanticContentAttribute = .forceLeftToRight
                
            }
        }
    }
}

//MARK:- UIAlertView

extension UIViewController {
    
    //Simple Alert view
    func simpleAlert(view: UIViewController, title: String, message: String,state: ToastType){
        ToastManager.show(title: message , state: state)
    }
    
    //Simple Alert view with button one
    func simpleAlert(view: UIViewController, title: String, message: String, buttonTitle: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        //okButton Action
        let okButton = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("OnTap")
            onTapAlert?(1)
        }
        alert.addAction(okButton)
        view.present(alert, animated: true, completion: nil)
    }
    func push(id: String)  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: id)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //Simple Alert view with two button
    func simpleAlert(view: UIViewController, title: String, message: String, buttonOneTitle: String, buttonTwoTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //Button One Action
        let buttonOne = UIAlertAction(title: buttonOneTitle, style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("OnTap")
            onTapAlert?(1)
        }
        alert.addAction(buttonOne)
        
        //Button Two Action
        let buttonTwo = UIAlertAction(title: buttonTwoTitle, style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("OnTap")
            onTapAlert?(2)
        }
        alert.addAction(buttonTwo)
        
        view.present(alert, animated: true, completion: nil)
    }
}

//MARK:- UINavigationbar

extension UIViewController {
    
    //Left navigation button
    func setLeftBarButtonWith(color leftButtonImageColor: UIColor) {
        self.setNavigationTitle()
        if CommonFunction.checkisRTL() {
            let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: Constant.back)?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(leftBarButtonAction))
            self.navigationController?.navigationBar.tintColor = leftButtonImageColor
            self.navigationItem.leftBarButtonItem = leftBarButton
            self.navigationController?.navigationBar.isHidden = false
        }else {
            let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: Constant.back), style: .plain, target: self, action: #selector(leftBarButtonAction))
            self.navigationController?.navigationBar.tintColor = leftButtonImageColor
            self.navigationItem.leftBarButtonItem = leftBarButton
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    //Left navigation bar button action
    @objc func leftBarButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- ActionSheet

extension UIViewController {
    
    //Actionsheet with two button dynamic
    func showActionSheet(viewController: UIViewController,message: String? =  nil, buttonOne: String, buttonTwo: String? = nil, buttonThird: String? = nil) {
        
        let actionSheetController = UIAlertController(title: nil, message:message, preferredStyle: .actionSheet)
        
        //Cancel Button
        let cancelButtonAction = UIAlertAction(title: Constant.cancel.localized, style: .cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelButtonAction)
        
        //Button One
        let buttonOneAction = UIAlertAction(title: buttonOne, style: .default) { action -> Void in
            onTapAction?(0)
        }
        actionSheetController.addAction(buttonOneAction)
        if (buttonTwo != nil) {
            //Button Two
            let buttonTwoAction = UIAlertAction(title: buttonTwo, style: .default) { action -> Void in
                onTapAction?(1)
            }
            actionSheetController.addAction(buttonTwoAction)
        }
        
        if (buttonThird != nil) {
            //Button Two
            let buttonThirdAction = UIAlertAction(title: buttonThird, style: .destructive) { action -> Void in
                onTapAction?(2)
            }
            
            actionSheetController.addAction(buttonThirdAction)
        }
        viewController.present(actionSheetController, animated: true, completion: nil)
    }
}


//MARK:- UIImagePickerControllerDelegate

extension UIViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                imageCompletion?(image)
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UINavigationControllerDelegate

extension UIViewController: UINavigationControllerDelegate {
    
}
