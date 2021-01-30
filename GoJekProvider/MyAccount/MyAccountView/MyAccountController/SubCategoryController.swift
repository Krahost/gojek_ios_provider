//
//  SubCategoryController.swift
//  GoJekProvider
//
//  Created by CSS on 06/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class SubCategoryController: UIViewController {
    
    @IBOutlet weak var subCategoruTableView: UITableView!
    
    var subCatgeoryArr:[SubCategoryData] = []
    var serviceType:ServiceType = .category
    var adminServiceId = ""
    var categoryId = 0
    var titleName = String.Empty
    var priceChoose = String.Empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //web service
        let param:Parameters = [MyAccountConstant.PServiceCategoryId: categoryId]
        myAccountPresenter?.getSubCategoryDetail(param: param)
        
        //Hide show tabbar
        hideTabBar()
        navigationController?.isNavigationBarHidden = false
        
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

// MARK: - LocalMethod

extension SubCategoryController {
    
    private func initalLoads(){
        subCategoruTableView.register(nibName: MyAccountConstant.ManageDocumentTableViewCell)
        setColor()
        title = titleName
        setLeftBarButtonWith(color: .blackColor)
    }
    
    private func setColor(){
        view.backgroundColor = .backgroundColor
        subCategoruTableView.backgroundColor = .backgroundColor
    }
}

// MARK: - UITableViewDataSource

extension SubCategoryController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subCatgeoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ManageDocumentTableViewCell = subCategoruTableView.dequeueReusableCell(withIdentifier: MyAccountConstant.ManageDocumentTableViewCell, for: indexPath) as! ManageDocumentTableViewCell
        
        let subCategoryDict = subCatgeoryArr[indexPath.row]
        cell.setSubCategoryData(data: subCategoryDict)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (tableView == subCategoruTableView)
        {
            cell.backgroundColor = .boxColor
            let radius = 10.0
            //Top Left Right Corners
            let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerTop = CAShapeLayer()
            shapeLayerTop.frame = cell.bounds
            shapeLayerTop.path = maskPathTop.cgPath
            
            //Bottom Left Right Corners
            let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerBottom = CAShapeLayer()
            shapeLayerBottom.frame = cell.bounds
            shapeLayerBottom.path = maskPathBottom.cgPath
            
            //All Corners
            let maskPathAll = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayerAll = CAShapeLayer()
            shapeLayerAll.frame = cell.bounds
            shapeLayerAll.path = maskPathAll.cgPath
            let count = subCatgeoryArr.count
            if (indexPath.row == 0 && indexPath.row == count-1)
            {
                cell.layer.mask = shapeLayerAll
            }
            else if (indexPath.row == 0)
            {
                cell.layer.mask = shapeLayerTop
            }
            else if (indexPath.row == count-1)
            {
                cell.layer.mask = shapeLayerBottom
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension SubCategoryController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subCategoryDict = subCatgeoryArr[indexPath.row]
        
        let setupServiceController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.SetupServiceController)  as! SetupServiceController
        setupServiceController.serviceType = .service
        setupServiceController.adminServiceId = adminServiceId
        setupServiceController.categoryId = categoryId
        setupServiceController.subCategoryId = subCategoryDict.id ?? 0
        setupServiceController.priceChoose = priceChoose
        navigationController?.pushViewController(setupServiceController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - MyAccountPresenterToMyAccountViewProtocol

extension SubCategoryController: MyAccountPresenterToMyAccountViewProtocol {
    
    func getSubCategorySuccess(getSubCategoryEntity: GetSubCategoryEntity) {
        
        if let subCatArray = getSubCategoryEntity.responseData {
            subCategoruTableView.backgroundView = nil
            subCatgeoryArr.removeAll()
            for categoryDetail in subCatArray {
                if categoryDetail.service_subcategory_status == 1 {
                    subCatgeoryArr.append(categoryDetail)
                }
            }
        }
        else {
            subCategoruTableView.setBackgroundImageAndTitle(imageName: MyAccountConstant.noService, title: MyAccountConstant.EmptyService.localized)
        }
        subCategoruTableView.reloadData()
    }
}
