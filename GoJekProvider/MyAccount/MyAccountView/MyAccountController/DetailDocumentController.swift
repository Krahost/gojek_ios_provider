//
//  DetailDocumentController.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import PDFKit

class DetailDocumentController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var documentTableView: UITableView!
    
    var documentDetail: DocumentData?
    var ExpiryDate = String.Empty
    var frontimgeData: Data!
    var backimgeData: Data!
    var isBack = false
    var isexpiry = false
    var typeName = String()
    
    var isselectTag = 0
    var frontPdfString = String.Empty
    var backPdfString = String.Empty
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.uploadButton.setCornorRadius()
        }
    }
}

//MARK:- LocalMethod

extension DetailDocumentController {
    
    private func initialLoads(){
        documentTableView.register(nibName: MyAccountConstant.DocumentTableViewCell)
        uploadButton.backgroundColor = .appPrimaryColor
        uploadButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x20)
        if documentDetail?.service_category == nil  && documentDetail?.servicesub_category == nil{
            typeName = (documentDetail?.name ?? "")
            }
        else if documentDetail?.servicesub_category == nil{
            typeName = (documentDetail?.service_category?.service_category_name ?? "")
            }
            else{
            typeName = (documentDetail?.service_category?.service_category_name ?? "") + " - " + (documentDetail?.servicesub_category?.service_subcategory_name ?? "")
            }
        
        
        title = typeName
        uploadButton.setTitle(MyAccountConstant.upload.localized, for: .normal)
        
        setLeftBarButtonWith(color: .blackColor)
        view.backgroundColor = .backgroundColor
        documentTableView.backgroundColor = .backgroundColor
        uploadButton.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
    }
    
    //Validation
    private func validation() -> Bool {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = documentTableView.cellForRow(at: indexPath) as! DocumentTableViewCell
      
        if documentDetail?.file_type == "image" {
            if cell.frontImageView.image?.isEqual(to: UIImage(named: Constant.holderImage) ?? UIImage()) ?? false {
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.frontImage.localized,state: .error)
                return false
                
            }
            if isBack {
                if cell.backImageView.image?.isEqual(to: UIImage(named: Constant.holderImage) ??  UIImage()) ?? false {
                    simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.backImage.localized,state: .error)
                    return false
                }
                
            }
            if isexpiry {
                if cell.expiryValueLabel.text == MyAccountConstant.expiryPlaceholder {
                    simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.expiryDate.localized,state: .error)
                    return false
                }
            }
            
            return true
        }else{
            if frontPdfString == String.Empty {
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.frontPdf.localized,state: .error)
                return false
            }
            if isBack {
                if backPdfString == String.Empty {
                    simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.backPdf.localized,state: .error)
                    return false
                }
            }
            if isexpiry {
                if cell.expiryValueLabel.text == MyAccountConstant.expiryPlaceholder {
                    simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.expiryDate.localized,state: .error)
                    return false
                }
            }
            return true
        }
    }
}

//MARK:- IBAction

extension DetailDocumentController {
    
    @objc func uploadButtonAction(_ sender:UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = documentTableView.cellForRow(at: indexPath) as! DocumentTableViewCell
        if validation() {
            let param:Parameters = [MyAccountConstant.PExpiry: ExpiryDate,
                                    MyAccountConstant.PDcoumentId: (documentDetail?.id!)!
            ]
            
            if documentDetail?.provider_document != nil {
                if  let frontdataImg = cell.frontImageView.image?.jpegData(compressionQuality: 0){
                    self.frontimgeData = frontdataImg
                }
                if isBack, let backdataImg = cell.backImageView.image?.jpegData(compressionQuality: 0) {
                    self.backimgeData = backdataImg
                }
            }else{
                if  let frontdataImg = cell.frontImageView.image?.jpegData(compressionQuality: 0.3){
                    self.frontimgeData = frontdataImg
                }
                if isBack, let backdataImg = cell.backImageView.image?.jpegData(compressionQuality: 0.3) {
                    self.backimgeData = backdataImg
                    
                }
            }
            
            if isBack {
                if frontimgeData != nil && backimgeData != nil {
                    
                    if documentDetail?.file_type == "image" {
                    self.myAccountPresenter?.addDocumentDetail(param: param, uploadData: [MyAccountConstant.PFile0 : frontimgeData,MyAccountConstant.PFile1:backimgeData], isTypePDF: false)
                    }else{
                         self.myAccountPresenter?.addDocumentDetail(param: param, uploadData: [MyAccountConstant.PFile0 : frontimgeData,MyAccountConstant.PFile1:backimgeData], isTypePDF: true)
                    }
                }
            }else {
                if frontimgeData != nil {
                     if documentDetail?.file_type == "image" {
                    self.myAccountPresenter?.addDocumentDetail(param: param, uploadData: [MyAccountConstant.PFile0: frontimgeData], isTypePDF: false)
                     }else{
                         self.myAccountPresenter?.addDocumentDetail(param: param, uploadData: [MyAccountConstant.PFile0: frontimgeData], isTypePDF: true)
                    }
                }
            }
        }
    }
    
    @objc func tapfrontViewPdf() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = documentTableView.cellForRow(at: indexPath) as! DocumentTableViewCell
        if documentDetail?.file_type == "image" {
            let showImageViewController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ShowImageViewController)  as! ShowImageViewController
            showImageViewController.modalTransitionStyle = .crossDissolve
            showImageViewController.modalPresentationStyle = .overCurrentContext
            showImageViewController.showImageView.image = cell.frontImageView.image
            present(showImageViewController, animated: true, completion: nil)
        }else{
            let vc = PdfViewController()
            vc.urlString = frontPdfString
            vc.navTitle = MyAccountConstant.pdfViewer.localized
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tapbackViewPdf() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = documentTableView.cellForRow(at: indexPath) as! DocumentTableViewCell
        if documentDetail?.file_type == "image" {
            let showImageViewController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ShowImageViewController)  as! ShowImageViewController
            showImageViewController.modalTransitionStyle = .crossDissolve
            showImageViewController.modalPresentationStyle = .overCurrentContext
            showImageViewController.showImageView.image = cell.backImageView.image
            present(showImageViewController, animated: true, completion: nil)
            
        }else{
            let vc = PdfViewController()
            vc.urlString = backPdfString
            vc.navTitle = MyAccountConstant.pdfViewer.localized
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tapImage(_ sender: UITapGestureRecognizer) {
        print("Gesture")
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = documentTableView.cellForRow(at: indexPath) as! DocumentTableViewCell
        
        if documentDetail?.file_type == "image" {
            showImage { (image) in
                if sender.view?.tag == 0 {
                    cell.frontImageView.image = image
                    cell.frontViewButton.isHidden = false
                }else{
                    cell.backImageView.image = image
                    cell.backViewButton.isHidden = false
                }
            }
        }else{
            showPdfDocument()
            isselectTag = sender.view?.tag ?? 0
        }
    }
}

//MARK:- UITableViewDataSource

extension DetailDocumentController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DocumentTableViewCell = tableView.dequeueReusableCell(withIdentifier: MyAccountConstant.DocumentTableViewCell, for: indexPath) as! DocumentTableViewCell
        cell.delegate = self
        cell.frontImageLabel.attributeString(string: (typeName) + MyAccountConstant.front.localized, range: NSRange(location: (typeName).count, length: MyAccountConstant.front.localized.count), color: .lightGray)
        
        
        cell.backImageLabel.attributeString(string: (typeName) + MyAccountConstant.back.localized, range: NSRange(location: (typeName).count, length: MyAccountConstant.back.localized.count), color: .lightGray)
        
        if documentDetail?.provider_document != nil {
            let dateStr = documentDetail?.provider_document?.expires_at ?? String.Empty
            let dateString = AppUtils.shared.dateToString(dateStr: dateStr, dateFormatTo: DateFormat.yyyy_mm_dd_HH_MM_ss, dateFormatReturn: DateFormat.ddmmyyyy)
            cell.expiryValueLabel.text = dateString
            
            ExpiryDate = cell.expiryValueLabel.text ?? MyAccountConstant.expiryPlaceholder
            if documentDetail?.file_type == "image" {
                
                if (documentDetail?.provider_document?.url?.count ?? 0) == 2 {
                    if let url = URL(string:  (documentDetail?.provider_document?.url?[0].url ?? String.Empty)){
                        cell.frontImageView.sd_setImage(with: url)
                        
                    }
                    if let url = URL(string:  (documentDetail?.provider_document?.url?[1].url ?? String.Empty)){
                        cell.backImageView.sd_setImage(with: url)
                        
                    }
                    
                    if  let dataImg = cell.frontImageView.image?.jpegData(compressionQuality: 0.3) {
                        frontimgeData = dataImg
                    }
                    
                    if  let dataImg = cell.backImageView.image?.jpegData(compressionQuality: 0.3) {
                        backimgeData = dataImg
                    }
                    cell.frontViewButton.isHidden = false
                    cell.backViewButton.isHidden = false
                    
                }else {
                    if let url = URL(string:  documentDetail?.provider_document?.url?[0].url ?? String.Empty){
                        cell.frontImageView.sd_setImage(with: url)
                    }
                    cell.frontViewButton.isHidden = false
                    cell.backViewButton.isHidden = true
                }
                cell.backpdfImage.isHidden = true
                cell.FrontpdfImage.isHidden = true
                
            }else{
                cell.frontViewButton.isHidden = true
                cell.backViewButton.isHidden = true
                if (documentDetail?.provider_document?.url?.count ?? 0) == 2 {
                    cell.frontViewButton.isHidden = false
                    cell.backViewButton.isHidden = false
                    cell.frontImageView.image = nil
                    cell.backImageView.image = nil
                    cell.frontImageView.backgroundColor = .white
                    cell.backImageView.backgroundColor = .white
                    frontPdfString = documentDetail?.provider_document?.url?[0].url ?? String.Empty
                    frontimgeData = frontPdfString.data(using: .utf8)
                    let FrontPdffileUrl = URL(string: frontPdfString)
                    do {
                        backimgeData = try Data(contentsOf: FrontPdffileUrl!)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    cell.backpdfImage.isHidden = false
                    cell.FrontpdfImage.isHidden = false
                    backPdfString = documentDetail?.provider_document?.url?[1].url ?? String.Empty
                    let BackPdffileUrl = URL(string: backPdfString)
                    
                    do {
                        backimgeData = try Data(contentsOf: BackPdffileUrl!)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                }else{
                    cell.frontImageView.image = nil
                    cell.backpdfImage.isHidden = true
                    cell.FrontpdfImage.isHidden = false
                    cell.frontImageView.backgroundColor = .white
                    frontPdfString = documentDetail?.provider_document?.url?[0].url ?? String.Empty
                    let FrontPdffileUrl = URL(string: frontPdfString)
                    
                    do {
                        frontimgeData = try Data(contentsOf: FrontPdffileUrl!)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    cell.frontViewButton.isHidden = false
                }
            }
        }else{
            cell.expiryValueLabel.text = MyAccountConstant.expiryPlaceholder
            cell.frontImageView.image = nil
            cell.backImageView.image = nil
            cell.frontViewButton.isHidden = true
            cell.backViewButton.isHidden = true
        }
        
        if documentDetail?.is_backside == "1" {
            isBack = true
            cell.backView.isHidden = false
        }else{
            isBack = false
            cell.backView.isHidden = true
            
        }
        
        if documentDetail?.is_expire == 1 {
            isexpiry = true
            cell.expiryView.isHidden = false
        }else{
            isexpiry = false
            cell.expiryView.isHidden = true
        }
        let frontGesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        cell.frontImageView.addGestureRecognizer(frontGesture)
        cell.frontImageView.tag = 0
        
        let backgesture = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
        cell.backImageView.addGestureRecognizer(backgesture)
        cell.backImageView.tag = 1
        cell.frontViewButton.addTarget(self, action: #selector(tapfrontViewPdf), for: .touchUpInside)
        cell.frontViewButton.tag = indexPath.row
        cell.backViewButton.addTarget(self, action: #selector(tapbackViewPdf), for: .touchUpInside)
        cell.backViewButton.tag = indexPath.row
        return cell
    }
}

//MARK:- UITableViewDelegate

extension DetailDocumentController: UITableViewDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

//MARK:- MyAccountPresenterToMyAccountViewProtocol

extension DetailDocumentController: MyAccountPresenterToMyAccountViewProtocol {
    
    func updateAddDocumentSuccess(documentEntity: SuccessEntity) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- DocumentTableViewCellDelegate

extension DetailDocumentController: DocumentTableViewCellDelegate,UITextFieldDelegate {
    
    func onExpiryTap(expiryStr: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.ddmmyyyy
        if let date = dateFormatter.date(from: expiryStr) {
            if date < Date() {
                print("Before now")
                simpleAlert(view: self, title: String.Empty, message: MyAccountConstant.validExpiryDate.localized,state: .error)
            } else {
                print("After now")
                ExpiryDate = expiryStr
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = documentTableView.cellForRow(at: indexPath) as! DocumentTableViewCell
                cell.expiryValueLabel.text = ExpiryDate
            }
        }
        
    }
    
  
}

//MARK:- UIDocumentPickerDelegate

extension DetailDocumentController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = documentTableView.cellForRow(at: indexPath) as! DocumentTableViewCell
        if isselectTag == 0 {
            cell.frontPdfLabel.text = myURL.lastPathComponent
            cell.frontImageView.backgroundColor = .white
            cell.FrontpdfImage.isHidden = false
            cell.frontImageView.image = nil
            frontPdfString = myURL.lastPathComponent
            do {
                frontimgeData = try Data(contentsOf: myURL)
            } catch {
                print("Unable to load data: \(error)")
            }
            cell.frontViewButton.isHidden = true
        }
        else{
            cell.backpdfImage.isHidden = false
            
            cell.backPdfLabel.text = myURL.lastPathComponent
            cell.backImageView.image = nil
            cell.backImageView.backgroundColor = .white
            backPdfString = myURL.lastPathComponent
            cell.backViewButton.isHidden = true
            do {
                backimgeData = try Data(contentsOf: myURL)
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showPdfDocument(){
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true, completion: nil)
    }
}
