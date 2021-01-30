//
//  ManageAddressController.swift
//  GoJekProvider
//
//  Created by Ansar on 25/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ManageAddressController: UIViewController {
    
    @IBOutlet weak var addressTableView:UITableView!
    @IBOutlet weak var addNewAddressButton:UIButton!
    
    var addressTypeArr = ["Home", "Work", "Other"]
    var addressStr = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
    var imageArr = ["ic_address_home", "ic_work", "ic_location"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addNewAddressButton.setCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        hideTabBar()
    }

}

//MARK: - Methods

extension ManageAddressController {
    private func initialLoads() {
        
        title = MyAccountConstant.manageAddress.localized
        setLeftBarButtonWith(color: .black)
        
        view.backgroundColor = .veryLightGray
        addNewAddressButton.backgroundColor = .appPrimaryColor
        addNewAddressButton.setTitleColor(.white, for: .normal)
        addressTableView.register(UINib(nibName: MyAccountConstant.SavedAddressCell, bundle: nil), forCellReuseIdentifier: MyAccountConstant.SavedAddressCell)
        addNewAddressButton.setTitle(MyAccountConstant.addNewAddress.localized, for: .normal)
    }
}

//MARK: - Table view Delegate and Datasource

extension ManageAddressController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: addressTableView.frame.width, height: 40))
        label.font = .boldSystemFont(ofSize: 17)
        label.backgroundColor = .clear
        label.text = MyAccountConstant.savedLocation.localized
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SavedAddressCell = addressTableView.dequeueReusableCell(withIdentifier: MyAccountConstant.SavedAddressCell, for: indexPath) as! SavedAddressCell
        cell.addressTypeImageView.image = UIImage(named: imageArr[indexPath.row])
        cell.addressTypeLabel.text = addressTypeArr[indexPath.row]
        cell.addressDetailLabel.text = indexPath.row == 1 ? "Test" : addressStr
        cell.addressTypeImageView.imageTintColor(color1: .lightGray)
        return cell
    }
}

extension ManageAddressController:UITableViewDelegate {
    
}



