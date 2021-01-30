//
//  ManageDocumentController.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

//Document type

enum DocumentType: String {
    
    case all = "all"
    case transport = "Transport"
    case order = "Order"
    case service = "service"
    case delivery = "Delivery"
}

class ManageDocumentController: UIViewController {
    
    @IBOutlet weak var documentTableView: UITableView!

    var serviceType: ServiceType = .document
    var catgeoryArr: [CategoryData] = []
    var documentArray: [AdminServiceData] = Array()
    var adminServiceId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
           initalLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide show tabbar
        //web service
        if serviceType == .category {
            
            myAccountPresenter?.getCategoryDetail()
        }
        else {
            myAccountPresenter?.getAdminServiceDetail()
        }
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
    }

}

// MARK: - LocalMethod

extension ManageDocumentController {
    
    private func initalLoads(){
        documentTableView.register(nibName: MyAccountConstant.ManageDocumentTableViewCell)
        setColor()
        if serviceType == .category {
            title = MyAccountConstant.serviceDescription.localized
            
        }else{
            title = MyAccountConstant.manageDocument.localized
        }
        setLeftBarButtonWith(color: .blackColor)
    }
    
    private func setColor(){
        view.backgroundColor = .backgroundColor
        documentTableView.backgroundColor = .backgroundColor
    }
}

// MARK: - UITableViewDataSource

extension ManageDocumentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if serviceType == .category {
            return 1
        }else{
            return documentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if serviceType == .category {
            return catgeoryArr.count
        }else{
            let documentDic = documentArray[section]
            return documentDic.documents?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ManageDocumentTableViewCell = documentTableView.dequeueReusableCell(withIdentifier: MyAccountConstant.ManageDocumentTableViewCell, for: indexPath) as! ManageDocumentTableViewCell
        cell.backgroundColor = .backgroundColor
        if serviceType == .category {
            let categoryDict = catgeoryArr[indexPath.row]
            cell.setCategoryData(data: categoryDict)
        }else{
            let documentDict = documentArray[indexPath.section].documents
            cell.setDocumentData(data: (documentDict?[indexPath.row])!)
            if(((documentArray[indexPath.section].documents?.count ?? 0) - 1) == indexPath.row){
                cell.bottomView.isHidden = true
            }
            else{
                cell.bottomView.isHidden = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (tableView == documentTableView) {
//            cell.backgroundColor = .boxColor
//            let radius = 10.0
//            //Top Left Right Corners
//            let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
//            let shapeLayerTop = CAShapeLayer()
//            shapeLayerTop.frame = cell.bounds
//            shapeLayerTop.path = maskPathTop.cgPath
//            
//            //Bottom Left Right Corners
//            let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
//            let shapeLayerBottom = CAShapeLayer()
//            shapeLayerBottom.frame = cell.bounds
//            shapeLayerBottom.path = maskPathBottom.cgPath
//            
//            //All Corners
//            let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
//            let shapeLayerAll = CAShapeLayer()
//            shapeLayerAll.frame = cell.bounds
//            shapeLayerAll.path = maskPathAll.cgPath
//            let count = serviceType == .category ? catgeoryArr.count : documentArray.count
//            if (indexPath.row == 0 && indexPath.row == count-1) {
//                cell.layer.mask = shapeLayerAll
//            }else if (indexPath.row == 0) {
//                cell.layer.mask = shapeLayerTop
//            }else if (indexPath.row == count-1) {
//                cell.layer.mask = shapeLayerBottom
//            }
//        }
    }
}

// MARK: - UITableViewDelegate

extension ManageDocumentController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if serviceType == .category {
            let categoryDict = catgeoryArr[indexPath.row]
            
            let setupServiceController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.SubCategoryController)  as! SubCategoryController
            setupServiceController.serviceType = .subCategory
            setupServiceController.adminServiceId = adminServiceId
            setupServiceController.categoryId = categoryDict.id ?? 0
            setupServiceController.priceChoose = categoryDict.price_choose ?? String.Empty
            setupServiceController.titleName = categoryDict.service_category_name ?? String.Empty
            
            navigationController?.pushViewController(setupServiceController, animated: true)
        } else {
            let documentDict = documentArray[indexPath.section ]
            let setupServiceController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.DetailDocumentController)  as! DetailDocumentController
            setupServiceController.documentDetail = documentDict.documents?[indexPath.row]
            navigationController?.pushViewController(setupServiceController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if serviceType != .category {
            let documentDict = documentArray[section]
            let headerTitle = documentDict.admin_service ?? String.Empty.capitalized + " Documents"
            return headerTitle
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         if serviceType != .category {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - MyAccountPresenterToMyAccountViewProtocol

extension ManageDocumentController: MyAccountPresenterToMyAccountViewProtocol {
    
    func getCategorySuccess(getCategoryEntity: GetCategoryEntity) {
        catgeoryArr = getCategoryEntity.responseData ?? []
        documentTableView.reloadInMainThread()
    }
    
    func getAdminServiceSuccess(getAdminServiceEntity: GetAdminServiceEntity) {
        if let adminSerArray = getAdminServiceEntity.responseData {
            documentTableView.backgroundView = nil
            documentArray.removeAll()
            for item in adminSerArray {
                if item.providerservices != nil || item.admin_service == MyAccountConstant.common{
                    documentArray.append(item)
                }
            }
        }
        else {
            documentTableView.setBackgroundImageAndTitle(imageName: MyAccountConstant.noDocument, title: MyAccountConstant.EmptyDoucment.localized)
        }
        documentTableView.reloadInMainThread()
        
    }
}
