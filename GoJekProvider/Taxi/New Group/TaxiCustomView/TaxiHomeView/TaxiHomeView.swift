//
//  TaxiHomeView.swift
//  GoJekProvider
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TaxiHomeView: UIView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var dropDashView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var processView: UIView!
    @IBOutlet weak var pickupLocationView: UIView!
    @IBOutlet weak var dropLocationView: UIView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var driverRatingView: FloatRatingView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var pickupImageView: UIImageView!
    @IBOutlet weak var dropImageView: UIImageView!
    @IBOutlet weak var finishImageView: UIImageView!
    
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var arrivedButton: UIButton!
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var pickupButton: UIButton!
    
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var pickupLocationTitleLabel: UILabel!
    @IBOutlet weak var pickupLocationDetailLabel: UILabel!
    
    @IBOutlet weak var waitingTimeButton: UIButton!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var slideUpDownView: UIView!
    @IBOutlet weak var pullDownImage: UIImageView!
    @IBOutlet weak var bookSomeTitleLbl: UILabel!
    @IBOutlet weak var someoneName: UILabel!
    @IBOutlet weak var someOneMbl: UILabel!
    @IBOutlet weak var someOneBgVw: UIView!
    @IBOutlet weak var someoneinnerVW: UIView!
    @IBOutlet weak var someoneCallBtn: UIButton!

    
    var isHideView:Bool = false {
        didSet {
            pullDownImage.transform = pullDownImage.transform.rotated(by: .pi/1)
        }
    }
    
    //MARK: - LocalVariable
    var onClickButton: ((String?)->())?
    var test:((CGFloat)->())?
    var onClickHideTaxiHome: ((Bool?)->())?
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.viewDidSetup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        driverRatingView.setFloatRatingView()
        driverRatingView.backgroundColor = .clear
        driverRatingView.isUserInteractionEnabled = false
        slideUpDownView.setOneSideCorner(corners: [.topLeft, .topRight], radius: slideUpDownView.frame.height/2)
        slideUpDownView.layer.shadowOpacity = 0.5
        slideUpDownView.layer.shadowOffset = CGSize.zero
        slideUpDownView.layer.shadowColor = UIColor.lightGray.cgColor
        navigationButton.tintColor = .taxiColor
    }
}

//MARK: - LocalMethod

extension TaxiHomeView {
    
    //Set custom design
    private func viewDidSetup() {
        cancelButton.setTitle(Constant.cancel.localized.uppercased(), for: .normal)
        arrivedButton.setTitle(Constant.arrived.localized.uppercased(), for: .normal)
        dropButton.setTitle(TaxiConstant.tapWhenDrop.localized.uppercased(), for: .normal)
        pickupButton.setTitle(TaxiConstant.pickup.localized.uppercased(), for: .normal)
        navigationButton.setImage(UIImage.init(named: TaxiConstant.navigationImage), for: .normal)
        pickupImageView.image = UIImage.init(named: TaxiConstant.pickupImage)
        dropImageView.image = UIImage.init(named: TaxiConstant.dropImage)
        finishImageView.image = UIImage.init(named: TaxiConstant.finishImage)
        arrivedButton.addTarget(self, action: #selector(arriveButtonAction(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        dropButton.addTarget(self, action: #selector(dropButtonAction(_:)), for: .touchUpInside)
        pickupButton.addTarget(self, action: #selector(pickupButtonAction(_:)), for: .touchUpInside)
        navigationButton.addTarget(self, action: #selector(navigationButtonAction(_:)), for: .touchUpInside)
        waitingTimeButton.addTarget(self, action: #selector(waitingTimeButtonAction(_:)), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapSlideUpDown))
        slideUpDownView.addGestureRecognizer(gesture)
        pullDownImage.image = UIImage(named: TaxiConstant.ic_pull_down)
        //Call local method
        setCustomDesign()
        setCustomFont()
        setCustomColor()
         bookSomeTitleLbl.text = TaxiConstant.booksomeone.localized
        waitingTimeButton.setTitle(TaxiConstant.waitingTime.localized, for: .normal)
        waitingTimeButton.setTitleColor(.black, for: .normal)
        waitingTimeButton.backgroundColor = .white
        waitingTimeLabel.textColor = .lightGray
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        slideUpDownView.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        slideUpDownView.addGestureRecognizer(swipeDown)
        setDarkMode()
    }
    
    
    func setDarkMode(){
        outterView.backgroundColor = .backgroundColor
        slideUpDownView.backgroundColor = .backgroundColor
        pullDownImage.setImageColor(color: .blackColor)
        profileView.backgroundColor = .boxColor
        someOneBgVw.backgroundColor = .boxColor
        locationView.backgroundColor = .boxColor
        processView.backgroundColor = .boxColor

    }
    
    //set custom design
    private func setCustomDesign() {
        DispatchQueue.main.async {
//            if CommonFunction.checkisRTL() {
//                self.profileView.setOneSideCorner(corners: .topRight, radius: self.userImageView.frame.width/2)
//            }
//            else {
//                self.profileView.setOneSideCorner(corners: .topLeft, radius: self.userImageView.frame.width/2)
//            }
            self.cancelButton.setCornerRadiuswithValue(value: 5.0)
            self.arrivedButton.setCornerRadiuswithValue(value: 5.0)
            self.dropButton.setCornerRadiuswithValue(value: 5.0)
            self.pickupButton.setCornerRadiuswithValue(value: 5.0)
            self.processView.setCornerRadiuswithValue(value: 5.0)
            self.profileView.setCornerRadiuswithValue(value: 5.0)
            self.navigationButton.setCornerRadiuswithValue(value: 5.0)
            self.waitingTimeButton.setCornorRadius()
            
            self.userImageView.layer.borderWidth = 5.0
            self.userImageView.setCornerRadius()
        }
    }
    
    //Set custom font
    private func setCustomFont() {
        driverName.font = .setCustomFont(name: .bold, size: .x16)
        pickupLocationTitleLabel.font = .setCustomFont(name: .bold, size: .x14)
        pickupLocationDetailLabel.font = .setCustomFont(name: .light, size: .x14)
        cancelButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        arrivedButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        dropButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        pickupButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x16)
        waitingTimeButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x14)
        waitingTimeLabel.font = .setCustomFont(name: .light, size: .x16)
        bookSomeTitleLbl.font = .setCustomFont(name: .bold, size: .x16)
        someOneMbl.font = .setCustomFont(name: .light, size: .x14)
        someoneName.font = .setCustomFont(name: .light, size: .x14)
    }
    
    //Set custom font
    private func setCustomColor() {
        driverName.textColor = .taxiColor
        pickupLocationDetailLabel.textColor = .lightGray
        processView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        profileView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        pickupLocationTitleLabel.superview?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        pickupLocationView.backgroundColor = .boxColor
        dropLocationView.backgroundColor = .boxColor
        finishView.backgroundColor = .boxColor
        cancelButton.backgroundColor = .taxiColor
        arrivedButton.backgroundColor = .taxiColor
        dropButton.backgroundColor = .taxiColor
        pickupButton.backgroundColor = .taxiColor
        cancelButton.textColor(color: .white)
        arrivedButton.textColor(color: .white)
        dropButton.textColor(color: .white)
        pickupButton.textColor(color: .white)
        navigationButton.backgroundColor = .white
        pickupImageView.setImageColor(color: .black)
        dropImageView.setImageColor(color: .black)
        finishImageView.setImageColor(color: .black)
        userImageView.layer.borderColor = UIColor.whiteColor.cgColor
        someoneinnerVW.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        someoneinnerVW.setCornerRadiuswithValue(value: 5)
    }
}

//MARK: - IBAction

extension TaxiHomeView {
    @objc func arriveButtonAction(_ sender: UIButton) {
        onClickButton?(TravelState.arrived.rawValue)
    }
    
    @objc func cancelButtonAction(_ sender: UIButton) {
        onClickButton?(TravelState.cancelled.rawValue)
    }
    
    @objc func dropButtonAction(_ sender: UIButton) {
        onClickButton?(TravelState.droped.rawValue)
    }
    
    @objc func pickupButtonAction(_ sender: UIButton) {
        onClickButton?(TravelState.pickedup.rawValue)
    }
    
    @objc func navigationButtonAction(_ sender: UIButton) {
        onClickButton?(TaxiConstant.GoogleMap)
    }
    
    @objc func waitingTimeButtonAction(_ sender: UIButton) {
        onClickButton?(TaxiConstant.time)
    }
    
    @objc func tapSlideUpDown() {
        isHideView = !isHideView
        
        hideViews(isHide: isHideView)
    }
    
    @objc  func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .up {
            isHideView = false
            hideViews(isHide: false)
        }
        else if gesture.direction == .down {
            isHideView = true
            hideViews(isHide: true)
        }
    }
    
    private func hideViews(isHide: Bool) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.locationView.isHidden = isHide
            self.processView.isHidden = isHide
        })
        onClickHideTaxiHome?(isHide)
    }
}


