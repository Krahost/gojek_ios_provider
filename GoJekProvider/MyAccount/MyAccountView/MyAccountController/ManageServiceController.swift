//
//  ManageServiceController.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ManageServiceController: UIViewController {
    
    @IBOutlet weak var serviceTableview: UITableView!
    
    var adminServiceList: [AdminServiceData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
extension ManageServiceController {
    private func initalLoads(){
        serviceTableview.register(nibName: MyAccountConstant.ManageServiceTableViewCell)
        setColor()
        title = MyAccountConstant.manageService.localized
        setLeftBarButtonWith(color: .blackColor)
        addshadow()
        
        //web service
        myAccountPresenter?.getAdminServiceDetail()
    }
    
    private func setColor(){
        view.backgroundColor = .backgroundColor
        serviceTableview.backgroundColor = .backgroundColor
    }
}

// Tableview Delegate and DataSource
extension ManageServiceController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return adminServiceList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ManageServiceTableViewCell = serviceTableview.dequeueReusableCell(withIdentifier: MyAccountConstant.ManageServiceTableViewCell, for: indexPath) as! ManageServiceTableViewCell
        let adminServicedict = adminServiceList[indexPath.row]
        cell.setAdminServiceData(data: adminServicedict)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adminServicedict = adminServiceList[indexPath.row]
        
        if adminServicedict.admin_service == ServiceType.transport.rawValue {
            let setupVehicleController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.SetupVehicleController)  as! SetupVehicleController
            setupVehicleController.serviceType = .transport
            setupVehicleController.adminServiceId = adminServicedict.admin_service ?? ""
            self.navigationController?.pushViewController(setupVehicleController, animated: true)
        }
        else if adminServicedict.admin_service == ServiceType.order.rawValue {
            let setupVehicleController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.SetupVehicleController)  as! SetupVehicleController
            setupVehicleController.serviceType = .order
            setupVehicleController.adminServiceId = adminServicedict.admin_service ?? ""
            self.navigationController?.pushViewController(setupVehicleController, animated: true)
        }
        else if adminServicedict.admin_service == ServiceType.service.rawValue {
            
            let setupServiceController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.ManageDocumentController)  as! ManageDocumentController
            setupServiceController.serviceType = .category
            
            setupServiceController.adminServiceId = adminServicedict.admin_service ?? ""
            self.navigationController?.pushViewController(setupServiceController, animated: true)
        }else if adminServicedict.admin_service == ServiceType.delivery.rawValue {
            
            let setupServiceController = MyAccountRouter.myAccountStoryboard.instantiateViewController(withIdentifier: MyAccountConstant.SetupVehicleController)  as! SetupVehicleController
            setupServiceController.serviceType = .delivery
                       
            setupServiceController.adminServiceId = adminServicedict.admin_service ?? ""
            self.navigationController?.pushViewController(setupServiceController, animated: true)
            
        }
    }
}

extension ManageServiceController: MyAccountPresenterToMyAccountViewProtocol {
    func getAdminServiceSuccess(getAdminServiceEntity: GetAdminServiceEntity) {
        if let adminSerArray = getAdminServiceEntity.responseData {
            serviceTableview.backgroundView = nil
            adminServiceList.removeAll()
            for adminDetail in adminSerArray {
                
                if adminDetail.admin_service == "WALLET" {
                    
                }else{
                if adminDetail.status == 1 {
                    self.adminServiceList.append(adminDetail)
                }
                    
            }
            }
        }
        else {
            self.serviceTableview.setBackgroundImageAndTitle(imageName: MyAccountConstant.noService, title: MyAccountConstant.emptyService.localized)
        }
        self.serviceTableview.reloadInMainThread()
        
    }
}
