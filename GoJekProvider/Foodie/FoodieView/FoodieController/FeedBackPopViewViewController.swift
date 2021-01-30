//
//  FeedBackPopViewViewController.swift
//  Project
//
//  Created by apple on 07/03/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

enum FeedbackRating: Int {
    case Terrible = 1
    case Sad = 2
    case Okey = 3
    case Good = 4
    case Super = 5
}

class FeedBackPopViewViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var feedbacktextView: UITextView!
    @IBOutlet weak var giveFeedbackLabel: UILabel!
    @IBOutlet weak var badLabel: UILabel!
    @IBOutlet weak var okeyLabel: UILabel!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var superBLabel: UILabel!
    @IBOutlet weak var terribleLabel: UILabel!
    @IBOutlet weak var howWasDeliveryLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var superbImageView: UIImageView!
    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var okeyImageView: UIImageView!
    @IBOutlet weak var sadImageView: UIImageView!
    @IBOutlet weak var terribleImageView: UIImageView!
    @IBOutlet weak var feedBackOverView: UIView!
    
    // MARK: - LocalVariable
    
    var Data: OrdersEntity?
    var feedBackRatingStr = String.Empty
    
    var backDelegate: FeedBackViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
}

// MARK: - LocalMethod

extension FeedBackPopViewViewController {
    
    private func viewDidSetup() {
        
        feedBackOverView.layer.cornerRadius = 10
        feedBackOverView.layer.masksToBounds = true
        
        submitButton.setTitle(FoodieConstant.submit.localized, for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .foodieColor
        
        feedbacktextView.tintColor = UIColor.orange.withAlphaComponent(0.5)
        addToolBarTextView(textView: feedbacktextView)
        feedbacktextView.layer.borderColor = UIColor.lightGray.cgColor
        feedbacktextView.layer.borderWidth = 1
        
        //Call custom font method
        setCustomFont()
        
        //Call custom color method
        setCustomColor()
        
        //Call super method
        superBmethod()
        
        //Call localization
        setLocalization()
    }
    
    //Set localization font
    private func setLocalization() {
        okeyLabel.text = Constant.okay.localized
        terribleLabel.text = FoodieConstant.terrible.localized
        badLabel.text = FoodieConstant.bad.localized
        goodLabel.text = FoodieConstant.good.localized
        superBLabel.text = FoodieConstant.superb.localized
        
        feedbackLabel.text = FoodieConstant.feedback.localized
        howWasDeliveryLabel.text = FoodieConstant.howdelivery.localized
        giveFeedbackLabel.text = FoodieConstant.feedbackwords.localized
    }
    
    //Set custom font
    private func setCustomFont() {
        
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
        feedbacktextView.font = .setCustomFont(name: .light, size: .x14)
        giveFeedbackLabel.font = .setCustomFont(name: .medium, size: .x14)
        badLabel.font = .setCustomFont(name: .light, size: .x14)
        okeyLabel.font = .setCustomFont(name: .light, size: .x14)
        goodLabel.font = .setCustomFont(name: .light, size: .x14)
        superBLabel.font = .setCustomFont(name: .light, size: .x14)
        terribleLabel.font = .setCustomFont(name: .light, size: .x14)
        howWasDeliveryLabel.font = .setCustomFont(name: .medium, size: .x14)
        feedbackLabel.font = .setCustomFont(name: .medium, size: .x18)
    }
    
    //Set custom color
    private func setCustomColor() {
        
        badLabel.textColor = .black
        okeyLabel.textColor = .black
        goodLabel.textColor = .black
        superBLabel.textColor = .black
        terribleLabel.textColor = .black
        
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .foodieColor
        feedbacktextView.textColor = .black
        giveFeedbackLabel.textColor = .black
        howWasDeliveryLabel.textColor = .black
        feedbackLabel.textColor = .black
    }
    
    //Add tollbar to text
    func addToolBarTextView(textView: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.orange.withAlphaComponent(0.5)
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([flexButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
    }
}

// MARK: - IBAction

extension FeedBackPopViewViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onSumbitButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.backDelegate?.feedBackNextScreen()
        }
    }
    
    @IBAction func onTerribleAction(_ sender: Any) {
        terribleImageView.tintColor = .foodieColor
        terribleImageView.image = terribleImageView.image!.withRenderingMode(.alwaysTemplate)
        
        sadImageView.image = sadImageView.image!.withRenderingMode(.alwaysOriginal)
        okeyImageView.image = okeyImageView.image!.withRenderingMode(.alwaysOriginal)
        goodImageView.image = goodImageView.image!.withRenderingMode(.alwaysOriginal)
        superbImageView.image = superbImageView.image!.withRenderingMode(.alwaysOriginal)
        
        sadImageView.backgroundColor = .white
        okeyImageView.backgroundColor = .white
        goodImageView.backgroundColor = .white
        superbImageView.backgroundColor = .white
        
        feedBackRatingStr = String(FeedbackRating.Terrible.rawValue)
    }
    
    @IBAction func onSadAction(_ sender: Any) {
        
        sadImageView.tintColor = .foodieColor
        sadImageView.image = sadImageView.image!.withRenderingMode(.alwaysTemplate)
        
        terribleImageView.image = terribleImageView.image!.withRenderingMode(.alwaysOriginal)
        okeyImageView.image = okeyImageView.image!.withRenderingMode(.alwaysOriginal)
        goodImageView.image = goodImageView.image!.withRenderingMode(.alwaysOriginal)
        superbImageView.image = superbImageView.image!.withRenderingMode(.alwaysOriginal)
        
        terribleImageView.backgroundColor = .white
        okeyImageView.backgroundColor = .white
        goodImageView.backgroundColor = .white
        superbImageView.backgroundColor = .white
        
        feedBackRatingStr = String(FeedbackRating.Sad.rawValue)
    }
    
    @IBAction func onOkeyAction(_ sender: Any) {
        okeyImageView.tintColor = .foodieColor
        okeyImageView.image = okeyImageView.image!.withRenderingMode(.alwaysTemplate)
        
        terribleImageView.image = terribleImageView.image!.withRenderingMode(.alwaysOriginal)
        sadImageView.image = sadImageView.image!.withRenderingMode(.alwaysOriginal)
        goodImageView.image = goodImageView.image!.withRenderingMode(.alwaysOriginal)
        superbImageView.image = superbImageView.image!.withRenderingMode(.alwaysOriginal)
        
        terribleImageView.backgroundColor = .white
        sadImageView.backgroundColor = .white
        goodImageView.backgroundColor = .white
        superbImageView.backgroundColor = .white
        
        feedBackRatingStr = String(FeedbackRating.Okey.rawValue)
    }
    
    @IBAction func onGoodAction(_ sender: Any) {
        
        goodImageView.tintColor = .foodieColor
        goodImageView.image = goodImageView.image!.withRenderingMode(.alwaysTemplate)
        
        terribleImageView.image = terribleImageView.image!.withRenderingMode(.alwaysOriginal)
        sadImageView.image = sadImageView.image!.withRenderingMode(.alwaysOriginal)
        superbImageView.image = superbImageView.image!.withRenderingMode(.alwaysOriginal)
        okeyImageView.image = okeyImageView.image!.withRenderingMode(.alwaysOriginal)
        
        terribleImageView.backgroundColor = .white
        sadImageView.backgroundColor = .white
        okeyImageView.backgroundColor = .white
        superbImageView.backgroundColor = .white
        
        feedBackRatingStr = String(FeedbackRating.Good.rawValue)
    }
    
    @IBAction func onSuperBAction(_ sender: Any) {
        superBmethod()
    }
    
    private func superBmethod() {
        superbImageView.tintColor = .foodieColor
        superbImageView.image = superbImageView.image!.withRenderingMode(.alwaysTemplate)
        
        terribleImageView.image = terribleImageView.image!.withRenderingMode(.alwaysOriginal)
        sadImageView.image = sadImageView.image!.withRenderingMode(.alwaysOriginal)
        goodImageView.image = goodImageView.image!.withRenderingMode(.alwaysOriginal)
        okeyImageView.image = okeyImageView.image!.withRenderingMode(.alwaysOriginal)
        
        terribleImageView.backgroundColor = .white
        sadImageView.backgroundColor = .white
        okeyImageView.backgroundColor = .white
        goodImageView.backgroundColor = .white
        
        feedBackRatingStr = String(FeedbackRating.Super.rawValue)
    }
}
