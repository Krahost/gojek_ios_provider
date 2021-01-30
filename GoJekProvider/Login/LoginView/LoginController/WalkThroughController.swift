//
//  WalkThroughController.swift
//  GoJekProvider
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class WalkThroughController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var walkThroughCollectionView: UICollectionView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomLineLabel: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var siginUpContainerView: UIView!
    
    var lottieFileArray: [AnimationModel]!
    
    //MARK:- Local Variable
    //Get current page index
    var currentPage = 0 {
        didSet {
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    view.setCornerRadius()
                    if view.tag == self.currentPage {
                        view.backgroundColor = .appPrimaryColor
                    }else{
                        view.backgroundColor = .veryLightGray
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
        
        //LottieViewManager.playWithFrame(fileName: "onboard_lottie", sourceView: animationView)
        lottieFileArray = [AnimationModel]()
        lottieFileArray.append(AnimationModel(title: LoginConstant.titleOne, description: LoginConstant.descriptionOne, fileName: LoginConstant.imageOne))
        lottieFileArray.append(AnimationModel(title: LoginConstant.titleTwo, description: LoginConstant.descriptionTwo, fileName: LoginConstant.imageTwo))
        lottieFileArray.append(AnimationModel(title: LoginConstant.titleThree, description: LoginConstant.descriptionThree, fileName: LoginConstant.imageThre))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first {
            let touchLocation = theTouch.location(in: self.view)
            let x = touchLocation.x
            let y = touchLocation.y
            if y > siginUpContainerView.frame.origin.y { return }
            let val = (x/self.view.frame.size.width)
            DispatchQueue.main.async {
                LottieViewManager.lottieView.currentProgress = val
            }
        }
    }
}

//MARK: - Local Methods

extension WalkThroughController {
    
    //View initial loads
    private func initialLoads() {
        if let _ = AppConfigurationManager.shared.baseConfigModel {
            
        } else {
             loginPresenter?.getBaseURL(param: [Constant.saltkey: APPConstant.saltKeyValue])
        }
      
        //Set custom font
        signInButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        signUpButton.titleLabel?.font = .setCustomFont(name: .medium, size: .x18)
        
        //Set custom color
        signInButton.textColor(color: .blackColor)
        signUpButton.textColor(color: .white)
        signUpButton.backgroundColor = .appPrimaryColor
        bottomLineLabel.backgroundColor = .veryLightGray
        
        // Add action to button
        signInButton.addTarget(self, action: #selector(tapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(tapSignUp), for: .touchUpInside)
        signInButton.setTitle(LoginConstant.signIn.localized, for: .normal)
        signUpButton.setTitle(LoginConstant.signUp.localized, for: .normal)
        currentPage = 0
        
        //Tableview cell nib setup
        walkThroughCollectionView.register(nibName: LoginConstant.WalkThroughCell)
        
        DispatchQueue.main.async {
            self.signInButton.setCornerRadius()
            self.signUpButton.setCornerRadius()
        }
        setDarkMode()
    }
    
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.walkThroughCollectionView.backgroundColor = .backgroundColor
    }
}

//MARK: - ButtonAction

extension WalkThroughController {
    
    //sign in button action
    @objc func tapSignIn() {
        
        let loginViewcontroller =  LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignInController)
        navigationController?.pushViewController(loginViewcontroller, animated: true)
    }
    
    //Sign up button action
    @objc func tapSignUp() {
        let signUpController = LoginRouter.loginStoryboard.instantiateViewController(withIdentifier: LoginConstant.SignUpController)
        navigationController?.pushViewController(signUpController, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension WalkThroughController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WalkThroughCell = walkThroughCollectionView.dequeueReusableCell(withReuseIdentifier: LoginConstant.WalkThroughCell, for: indexPath) as! WalkThroughCell
       // cell.setValues(image: "ic_app_logo", heading: LoginConstant.rateService, content: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu")
        cell.playAnimation(animationDetails: lottieFileArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
    }
    
    private func checkAlreadyLogin() -> Bool {
        let fetchData = try! DataBaseManager.shared.context.fetch(LoginData.fetchRequest()) as? [LoginData]
        if (fetchData?.count ?? 0) <= 0 {
            return false
        }
        AppManager.share.accessToken = fetchData?.first?.access_token
        print("Access Token \(fetchData?.first?.access_token ?? .Empty)" )
        return (fetchData?.count ?? 0) > 0
    }
}

//MARK: - UICollectionViewDelegate

extension WalkThroughController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension WalkThroughController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: walkThroughCollectionView.frame.width, height: walkThroughCollectionView.frame.height)
    }
}

//MARK: - UIScrollViewDelegate

extension WalkThroughController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        self.currentPage = currentPage
    }
}

//MARK: - LoginPresenterToLoginViewProtocol

extension WalkThroughController: LoginPresenterToLoginViewProtocol {
    func getBaseURLResponse(baseEntity: BaseEntity) {
        
        AppConfigurationManager.shared.baseConfigModel = baseEntity
        AppConfigurationManager.shared.setBasicConfig(data: baseEntity)
        AppManager.share.setBaseDetails(details: baseEntity.responseData!)

        if checkAlreadyLogin() {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            appDelegate.window?.rootViewController = TabBarController().listTabBarController()
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}

