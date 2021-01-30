//
//  AddVehicleController.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class AddVehicleController: UIViewController {
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var truckOrTaxiView: UIView!
    @IBOutlet weak var bikeView: UIView!
    @IBOutlet weak var bikeVehicleLicenseTextField: CustomTextField!
    @IBOutlet weak var vehicleNameTextField: CustomTextField!
    @IBOutlet weak var vehicleColorTextField: CustomTextField!
    @IBOutlet weak var vehicleLicenseTextField: CustomTextField!
    @IBOutlet weak var vehicleMakeTextField: CustomTextField!
    @IBOutlet weak var vehicleYearTextField: CustomTextField!
    @IBOutlet weak var vehicleModelTextField: CustomTextField!
    @IBOutlet weak var carCatgeoryTextField: CustomTextField!
    @IBOutlet weak var rcEyeImageView: UIButton!
    @IBOutlet weak var insuranceViewButton: UIButton!
    
    @IBOutlet weak var wheelChairButton: UIButton!
    @IBOutlet weak var childSeatButton: UIButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var rcBookTitleImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var vehicleScrollView: UIScrollView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var documentUploadLabel: UILabel!
    
    @IBOutlet weak var insuranceImageView: UIImageView!
    @IBOutlet weak var insuranceView: UIView!
    @IBOutlet weak var rcBookView: UIView!
    @IBOutlet weak var rcBookLabel: UILabel!
    @IBOutlet weak var rcBookImageView: UIImageView!
    @IBOutlet weak var insuranceTitleImageView: UIImageView!
    @IBOutlet weak var insuranceLabel: UILabel!
    
    var serviceType:ServiceType = .category
    var adminServiceId = ""
    var transportArr:[Servicelist] = []
    var vehicleId = 0
    var carCategoryArr:[String] = []
    var isrcBookImg = false
    var isInsuranceImg = false
    var categoryId = 0
    var providerService:TransportProviderservice?
    var childSeatValue = 0
    var wheelSeatValue = 0
    var courierService : ServiceList?
    var isEdit = false
    
    var isChildSeat:Bool = false {
        didSet {
            childSeatValue = isChildSeat ? 0 : 1
            childSeatButton.setImage(UIImage(named: isChildSeat ? Constant.sqaureEmpty : Constant.squareFill), for: .normal)
        }
    }
    
    var isWheelSeat:Bool = false {
        didSet {
            wheelSeatValue = isWheelSeat ? 0: 1
            wheelChairButton.setImage(UIImage(named: isWheelSeat ? Constant.sqaureEmpty : Constant.squareFill), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        hideTabBar()
        checkEdit()
        navigationController?.isNavigationBarHidden = false
        
    }
    
    func checkEdit(){
            if (isEdit == true){
                bikeVehicleLicenseTextField.isUserInteractionEnabled = true
                vehicleNameTextField.isUserInteractionEnabled = true
                vehicleColorTextField.isUserInteractionEnabled = true
                vehicleLicenseTextField.isUserInteractionEnabled = true
                vehicleMakeTextField.isUserInteractionEnabled = true
                vehicleYearTextField.isUserInteractionEnabled = true
                vehicleModelTextField.isUserInteractionEnabled = true
                carCatgeoryTextField.isUserInteractionEnabled = true
                wheelChairButton.isUserInteractionEnabled = true
                childSeatButton.isUserInteractionEnabled = true
                rcEyeImageView.isUserInteractionEnabled = true
                insuranceViewButton.isUserInteractionEnabled = true
                insuranceTitleImageView.isUserInteractionEnabled = true
                rcBookTitleImageView.isUserInteractionEnabled = true
                submitButton.isHidden = false
                self.navigationController?.navigationBar.tintColor = .blackColor
                self.navigationItem.rightBarButtonItem = nil
                self.navigationController?.navigationBar.isHidden = false
            }
            else{
                bikeVehicleLicenseTextField.isUserInteractionEnabled = false
                vehicleNameTextField.isUserInteractionEnabled = false
                vehicleColorTextField.isUserInteractionEnabled = false
                vehicleLicenseTextField.isUserInteractionEnabled = false
                vehicleMakeTextField.isUserInteractionEnabled = false
                vehicleYearTextField.isUserInteractionEnabled = false
                vehicleModelTextField.isUserInteractionEnabled = false
                carCatgeoryTextField.isUserInteractionEnabled = false
                wheelChairButton.isUserInteractionEnabled = false
                childSeatButton.isUserInteractionEnabled = false
                rcEyeImageView.isUserInteractionEnabled = false
                insuranceViewButton.isUserInteractionEnabled = false
                insuranceTitleImageView.isUserInteractionEnabled = false
                rcBookTitleImageView.isUserInteractionEnabled = false
                submitButton.isHidden = true
                let rightBarButton = UIBarButtonItem.init(title: MyAccountConstant.edit, style: .plain, target: self, action: #selector(editClicked))
                self.navigationController?.navigationBar.tintColor = .blackColor
                self.navigationItem.rightBarButtonItem = rightBarButton
                self.navigationController?.navigationBar.isHidden = false
           }
    }
    
    @objc func editClicked(){
        let alert = UIAlertController(title: MyAccountConstant.editInformation, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: MyAccountConstant.cancel, style: UIAlertAction.Style.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: MyAccountConstant.ok, style: UIAlertAction.Style.default, handler: { action in
            self.isEdit = true
            self.checkEdit()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension AddVehicleController {
    private func initialLoads(){
        title = MyAccountConstant.AddVehicle.localized
        setLeftBarButtonWith(color: .blackColor)
        setDarkMode()
        setFont()
        vehicleScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomView.bounds.height, right: 0)
        customLocalize()
        submitButton.backgroundColor = .appPrimaryColor
        submitButton.setTitleColor(.white, for: .normal)
        rcBookImageView.image = UIImage(named: MyAccountConstant.file)
        rcBookImageView.imageTintColor(color1: UIColor.appPrimaryColor.withAlphaComponent(0.5))
        insuranceImageView.image = UIImage(named: MyAccountConstant.file)
        insuranceImageView.imageTintColor(color1: UIColor.appPrimaryColor.withAlphaComponent(0.5))
        dropDownImageView.image = UIImage(named: MyAccountConstant.dropDown)
        dropDownImageView.setImageColor(color: .blackColor)
        rcEyeImageView.setImage(UIImage(named: MyAccountConstant.eyeImage), for: .normal)
        insuranceViewButton.setImage(UIImage(named: MyAccountConstant.eyeImage), for: .normal)
        
        submitButton.setTitle(Constant.save.localized, for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
        rcBookTitleImageView.isUserInteractionEnabled = true
        let rcBookgesture = UITapGestureRecognizer(target: self, action: #selector(rcBooktapImage(_:)))
        rcBookTitleImageView.addGestureRecognizer(rcBookgesture)
        insuranceTitleImageView.isUserInteractionEnabled = true
        let insurancegesture = UITapGestureRecognizer(target: self, action: #selector(insurancetapImage(_:)))
        insuranceTitleImageView.addGestureRecognizer(insurancegesture)
        
        if serviceType == .transport ||  serviceType == .delivery {
            truckOrTaxiView.isHidden = false
            bikeView.isHidden = true
        }else if serviceType == .order {
            truckOrTaxiView.isHidden = true
            bikeView.isHidden = false
        }
        
        childSeatButton.setTitleColor(.blackColor, for: .normal)
        wheelChairButton.setTitleColor(.blackColor, for: .normal)
        wheelChairButton.tintColor = .appPrimaryColor
        childSeatButton.tintColor = .appPrimaryColor
        rcBookLabel.textColor = .appPrimaryColor
        insuranceLabel.textColor = .appPrimaryColor
        insuranceView.addDashedBorder(strokeColor: .appPrimaryColor, lineWidth: 1, isBottomOnly: false)
        rcBookView.addDashedBorder(strokeColor: .appPrimaryColor, lineWidth: 1, isBottomOnly: false)
        wheelChairButton.addTarget(self, action: #selector(tapwheelChairAction), for: .touchUpInside)
        childSeatButton.addTarget(self, action: #selector(tapChildSeatAction), for: .touchUpInside)
        rcEyeImageView.addTarget(self, action: #selector(tapRcImageViewAction), for: .touchUpInside)
        insuranceViewButton.addTarget(self, action: #selector(tapInsuranceImageViewAction), for: .touchUpInside)
        
        //UIupdate
        DispatchQueue.main.async {
            self.submitButton.setCornerRadius()
            self.topView.setCornerRadiuswithValue(value: 5)
            self.insuranceView.setCornerRadiuswithValue(value: 8)
            self.rcBookView.setCornerRadiuswithValue(value: 8)
        }
        rcEyeImageView.isHidden = true
        insuranceViewButton.isHidden = true
        for transport in transportArr {
            carCategoryArr.append(transport.vehicle_name ?? String.Empty)
        }
        
        isChildSeat = true
        isWheelSeat = true
        
        if providerService != nil {
            vehicleColorTextField.text = providerService?.providervehicle?.vehicle_color
            vehicleYearTextField.text = providerService?.providervehicle?.vehicle_year?.toString()
            vehicleLicenseTextField.text = providerService?.providervehicle?.vehicle_no
            vehicleNameTextField.text = providerService?.providervehicle?.vehicle_make
            vehicleModelTextField.text = providerService?.providervehicle?.vehicle_model
            vehicleMakeTextField.text = providerService?.providervehicle?.vehicle_make
            bikeVehicleLicenseTextField.text = providerService?.providervehicle?.vehicle_no
            rcEyeImageView.isHidden = false
            insuranceViewButton.isHidden = false
            
            if let rcImg = providerService?.providervehicle?.picture {
                if let url = URL(string:  rcImg){
                    rcBookTitleImageView.sd_setImage(with: url)
                }
            }
            
            if let insuranceImg = providerService?.providervehicle?.picture1 {
                if let url = URL(string:  insuranceImg){
                    insuranceTitleImageView.sd_setImage(with: url)
                    
                }
            }
            
            isrcBookImg = true
            isInsuranceImg = true
            print(serviceType)
            
            for service in transportArr {
                if serviceType == .transport{
                    if service.id == providerService?.ride_delivery_id {
                        let carCategory = service.vehicle_name ?? String.Empty
                        carCatgeoryTextField.text = carCategory
                        self.vehicleId = service.id ?? 0
                        if (service.capacity ?? 0) > 3 {
                            childView.isHidden = false
                            childSeatValue = providerService?.providervehicle?.child_seat ?? 0
                            wheelSeatValue = providerService?.providervehicle?.wheel_chair ?? 0
                            if wheelSeatValue == 1{
                                isWheelSeat = false
                            }else{
                                isWheelSeat = true
                                
                            }
                            if childSeatValue == 1{
                                isChildSeat = false
                            }else{
                                isChildSeat = true
                                
                            }
                        }else{
                            childView.isHidden = true
                            
                        }
                        return

                    }
                }else if serviceType == .delivery {
                    childView.isHidden = true

                        if service.id == providerService?.delivery_vehicle_id {
                            let carCategory = service.vehicle_name ?? String.Empty
                            carCatgeoryTextField.text = carCategory
                            return

                        }

                    }
                    
            }
        }else {
            if serviceType == .delivery {
            childView.isHidden = true
            }
        }
 
    }
    
    func setDarkMode(){
        self.view.backgroundColor = .backgroundColor
        self.vehicleScrollView.backgroundColor = .backgroundColor
        self.topView.backgroundColor = .boxColor
        self.rcBookView.backgroundColor = .boxColor
        self.insuranceView.backgroundColor = .boxColor
        self.childView.backgroundColor = .clear
        self.childSeatButton.backgroundColor = .clear
        self.wheelChairButton.backgroundColor = .clear

    }
    
    @objc func insurancetapImage(_ sender: UITapGestureRecognizer) {
        showImage { [weak self] (image) in
            guard let self = self else {
                return
            }
            self.insuranceTitleImageView.image = image
            self.isInsuranceImg = true
        }
    }
    
    @objc func tapInsuranceImageViewAction(_ sender: UIButton){
        let showImageViewController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ShowImageViewController)  as! ShowImageViewController
        showImageViewController.modalTransitionStyle = .crossDissolve
        showImageViewController.modalPresentationStyle = .overCurrentContext
        showImageViewController.showImageView.image = insuranceTitleImageView.image
        present(showImageViewController, animated: true, completion: nil)
    }
    
    @objc func tapwheelChairAction(_ sender: UIButton){
        isWheelSeat = !isWheelSeat
        
    }
    
    @objc func tapChildSeatAction(_ sender: UIButton){
        isChildSeat = !isChildSeat
    }
    
    @objc func submitButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if validation() {
            var param:Parameters
            if serviceType == .transport || serviceType == .delivery {
                
                param = [MyAccountConstant.PVehicleId: vehicleId,
                         MyAccountConstant.PVehicleYear: vehicleYearTextField.text ?? String.Empty,
                         MyAccountConstant.PVehicleMake: vehicleMakeTextField.text ?? String.Empty,
                         MyAccountConstant.PVehicleModel:vehicleModelTextField.text ?? String.Empty,
                         MyAccountConstant.PVehicleNo: vehicleLicenseTextField.text ?? String.Empty,
                         MyAccountConstant.PVehcileColor:vehicleColorTextField.text ?? String.Empty,
                         MyAccountConstant.PAdminServiceId:adminServiceId,
                         MyAccountConstant.PCategoryId:categoryId
                ]
                if childSeatValue == 1 {
                    param[MyAccountConstant.Pchild_seat] = childSeatValue
                    
                }
                if wheelSeatValue == 1 {
                    param[MyAccountConstant.Pwheel_chair] = wheelSeatValue
                    
                }
            }else{
                param = [MyAccountConstant.PVehicleMake:vehicleNameTextField.text ?? String.Empty,
                         MyAccountConstant.PVehicleNo: bikeVehicleLicenseTextField.text ?? String.Empty,
                         MyAccountConstant.PAdminServiceId:adminServiceId,
                         MyAccountConstant.PCategoryId:categoryId
                ]
                
                
            }
            //Image data
            var rcbookimgeData:Data!
            if  let dataImg = rcBookTitleImageView.image?.jpegData(compressionQuality: 0.5) {
                rcbookimgeData = dataImg
            }
            
            //Image data
            var insuranceImgeData:Data!
            if  let dataImg = insuranceTitleImageView.image?.jpegData(compressionQuality: 0.5) {
                insuranceImgeData = dataImg
            }
            
            
            if providerService != nil {
                param[MyAccountConstant.PId] = providerService?.providervehicle?.id
                myAccountPresenter?.EditVehicleDetail(param: param, imageData: [MyAccountConstant.PPicture:rcbookimgeData,MyAccountConstant.PPicture1:insuranceImgeData])
                
            }else{
                
                myAccountPresenter?.AddVehicleDetail(param: param, imageData: [MyAccountConstant.PPicture:rcbookimgeData,MyAccountConstant.PPicture1:insuranceImgeData])
                
            }
        }
    }
    
    
    @objc func rcBooktapImage(_ sender: UITapGestureRecognizer) {
        showImage { [weak self] (image) in
            guard let self = self else {
                return
            }
            self.rcBookTitleImageView.image = image
            self.isrcBookImg = true
        }
    }
    
    @objc func tapRcImageViewAction(_ sender: UIButton){
        let showImageViewController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ShowImageViewController)  as! ShowImageViewController
        showImageViewController.modalTransitionStyle = .crossDissolve
        showImageViewController.modalPresentationStyle = .overCurrentContext
        showImageViewController.showImageView.image = rcBookTitleImageView.image
        present(showImageViewController, animated: true, completion: nil)
    }
    
    
    //Validation
    private func validation() -> Bool {
        if serviceType == .order {
            guard let vehicleNameStr = vehicleNameTextField.text?.trim(), !vehicleNameStr.isEmpty else {
                vehicleNameTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VvehicleName.localized,state: .error)
                return false
            }
            guard let vehicleLicenseStr = bikeVehicleLicenseTextField.text?.trim(), !vehicleLicenseStr.isEmpty else {
                bikeVehicleLicenseTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VvehicleLicensePlate.localized,state: .error)
                return false
            }
        }else{
            guard let carCategoryStr = carCatgeoryTextField.text?.trim(), !carCategoryStr.isEmpty else {
                carCatgeoryTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VcarCategory.localized,state: .error)
                return false
            }
            guard let vehicleModelStr = vehicleModelTextField.text?.trim(), !vehicleModelStr.isEmpty else {
                vehicleModelTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VvehicleModel.localized,state: .error)
                return false
            }
            guard let vehicleYearStr = vehicleYearTextField.text?.trim(), !vehicleYearStr.isEmpty else {
                vehicleYearTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VvehicleYear.localized,state: .error)
                return false
            }
            guard let vehiclecolorStr = vehicleColorTextField.text?.trim(), !vehiclecolorStr.isEmpty else {
                vehicleColorTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VvehicleColor.localized,state: .error)
                return false
            }
            guard let vehicleLicenseStr = vehicleLicenseTextField.text?.trim(), !vehicleLicenseStr.isEmpty else {
                vehicleLicenseTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VvehicleLicensePlate.localized,state: .error)
                return false
            }
            guard let vehicleMakeStr = vehicleMakeTextField.text?.trim(), !vehicleMakeStr.isEmpty else {
                vehicleMakeTextField.becomeFirstResponder()
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.VvehicleMake.localized,state: .error)
                return false
            }
        }
        
        if rcBookTitleImageView.image == nil {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.rcBookImageUpload.localized,state: .error)
            return false
        }else if rcBookTitleImageView.image?.isEqual(to: UIImage(named: Constant.holderImage) ?? UIImage()) ?? false {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.rcBookImageUpload.localized,state: .error)
            return false
        }else if insuranceTitleImageView.image == nil {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.InsuranceImageUpload.localized,state: .error)
            return false
        }else if insuranceTitleImageView.image?.isEqual(to: UIImage(named: Constant.holderImage) ?? UIImage()) ?? false {
            simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.InsuranceImageUpload.localized,state: .error)
            return false
        }
        
        return true
    }
    
    
    private func customLocalize(){
        vehicleNameTextField.placeholder = MyAccountConstant.vehicleName.localized
        bikeVehicleLicenseTextField.placeholder = MyAccountConstant.vehicleLicensePlate.localized
        vehicleColorTextField.placeholder = MyAccountConstant.vehicleColor.localized
        vehicleLicenseTextField.placeholder = MyAccountConstant.vehicleLicensePlate.localized
        vehicleMakeTextField.placeholder = MyAccountConstant.vehicleMake.localized
        vehicleYearTextField.placeholder = MyAccountConstant.vehicleYear.localized
        vehicleModelTextField.placeholder = MyAccountConstant.vehicleModel.localized
        carCatgeoryTextField.placeholder = MyAccountConstant.carCategory.localized
        
        submitButton.setTitle(MyAccountConstant.submit.localized, for: .normal)
        documentUploadLabel.text = MyAccountConstant.documentUpload.localized
        
        rcBookLabel.text = MyAccountConstant.rcBook.localized
        insuranceLabel.text = MyAccountConstant.Insurance.localized
        childSeatButton.setTitle(MyAccountConstant.childSeat.localized, for: .normal)
        wheelChairButton.setTitle(MyAccountConstant.wheelChair.localized, for: .normal)
        
    }
    
    private func setFont(){
        childSeatButton.titleLabel?.font = .setCustomFont(name: .light, size: FontSize.x16)
        wheelChairButton.titleLabel?.font = .setCustomFont(name: .light, size: FontSize.x16)
        vehicleNameTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        bikeVehicleLicenseTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        vehicleColorTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        vehicleLicenseTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        vehicleMakeTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        vehicleYearTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        vehicleModelTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        carCatgeoryTextField.font = .setCustomFont(name: .light, size: FontSize.x16)
        
        submitButton.titleLabel?.font = .setCustomFont(name: .bold, size: FontSize.x16)
        documentUploadLabel.font = .setCustomFont(name: .light, size: FontSize.x16)
        
        rcBookLabel.font = .setCustomFont(name: .light, size: FontSize.x14)
        insuranceLabel.font = .setCustomFont(name: .light, size: FontSize.x14)
    }
    
    
}
//MARK: - Textfield delegate
extension AddVehicleController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case carCatgeoryTextField:
            
            PickerManager.shared.showPicker(pickerData: carCategoryArr, selectedData: nil) { [weak self] (data) in
                guard let self = self else {
                    return
                }
                if self.serviceType == .transport {
                    
                    for transport in self.transportArr {
                        
                        if data == transport.vehicle_name {
                            self.carCatgeoryTextField.text = data
                            self.vehicleId = transport.id ?? 0
                            if (transport.capacity ?? 0) > 3 {
                                self.childView.isHidden = false
                            }else{
                                self.childView.isHidden = true
                                
                            }
                            self.isChildSeat = true
                            self.isWheelSeat = true
                            return
                        }
                    }
                }else if self.serviceType == .delivery {
                    for transport in self.transportArr {
                        
                        if data == transport.vehicle_name {
                            self.carCatgeoryTextField.text = data
                            self.vehicleId = transport.id ?? 0
                            return
                        }
                    }
                }
            }
            return false
        default:
            break
        }
        return true
    }
}
//MARK: - MyAccountPresenterToMyAccountViewProtocol

extension AddVehicleController: MyAccountPresenterToMyAccountViewProtocol {
    func getAddVehicleSuccess(getAddVehicleEntity: AddVehicleEntity) {
        simpleAlert(view: self, title: String.Empty, message: getAddVehicleEntity.message ?? MyAccountConstant.AddVehicle.localized, state: .success)
        for controller in navigationController!.viewControllers as Array {
            if controller.isKind(of: ManageServiceController.self) {
                _ =  navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    func getEditVehicleSuccess(editVehicleEntity: AddVehicleEntity) {
        simpleAlert(view: self, title: String.Empty, message: editVehicleEntity.message ?? MyAccountConstant.editVechile.localized, state: .success)
        
        for controller in navigationController!.viewControllers as Array {
            if controller.isKind(of: ManageServiceController.self) {
                _ =  navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
}
