//
//  BankDetailController.swift
//  GoJekProvider
//
//  Created by CSS on 10/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class BankDetailController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bankDetailTableView: UITableView!
    
    var bankDetailArr:[BankResponseData] = []
    var bankformIdArr:NSMutableArray = []
    var keyvalueArr:NSMutableArray = []
    var idvalueArr:NSMutableArray = []
    
    var bankNub: String = String.Empty
    var iseditBank = false
    
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

// MARK: - LocalMethod

extension BankDetailController {
    
    private func initalLoads() {
        bankDetailTableView.register(nibName: MyAccountConstant.BankDetailCell)
        submitButton.titleLabel?.font =  .setCustomFont(name: .bold, size: .x20)
        setLeftBarButtonWith(color: .blackColor)
        title = MyAccountConstant.bankDetails.localized
        submitButton.setCornorRadius()
        myAccountPresenter?.getBankTemplateList()
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        view.backgroundColor = .backgroundColor
        submitButton.setTitle(MyAccountConstant.submit.localized, for: .normal)
        submitButton.setTitleColor(.white, for:  .normal)
        submitButton.backgroundColor = .appPrimaryColor
        bankformIdArr.removeAllObjects()
        keyvalueArr.removeAllObjects()
        
    }
    
    
    @objc func submitButtonAction() {
        if validation() {
            var parameter:Parameters = [
                MyAccountConstant.PBankFormId:bankformIdArr,
                MyAccountConstant.PKeyValue:keyvalueArr
            ]
            if bankDetailArr[0].bankdetails != nil {
                parameter[MyAccountConstant.PId] = idvalueArr
                myAccountPresenter?.editBankDetailList(param: parameter)
                
            }else{
                myAccountPresenter?.addBankDetailList(param: parameter)
                
            }
        }
    }
    
    //Validation Method
    private func validation() -> Bool {
        for index in 0..<bankDetailArr.count {
//            let cell:BankDetailCell = bankDetailTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! BankDetailCell
            let text = keyvalueArr[index] as! String
            if(text ==  ""){
                print(text + "Empty")
                simpleAlert(view: self, title: String.Empty, message: "Please Enter " + bankDetailArr[index].label!.lowercased(),state: .error)
                
                return false
            }
            if text.count < bankDetailArr[index].min ?? 0 || text.count > bankDetailArr[index].max ?? 0 {
                print("Lenght")
                simpleAlert(view: self, title: String.Empty, message: "Please Enter Valid " + bankDetailArr[index].label!.lowercased(),state: .error)
                
                return false
            }
        }
        return true
    }
}

// MARK: - UITableViewDataSource

extension BankDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bankDetailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BankDetailCell = tableView.dequeueReusableCell(withIdentifier: MyAccountConstant.BankDetailCell, for: indexPath) as! BankDetailCell
        
        if bankDetailArr.count > 0 {
          
            if CommonFunction.checkisRTL() {
                cell.customTextField.textAlignment = .right
            }else {
                cell.customTextField.textAlignment = .left
            }
            
            let bankDict = bankDetailArr[indexPath.row]
            cell.delegate = self
            cell.titleLabel.text = bankDict.label?.uppercased()
            cell.customTextField.tag = indexPath.row
               
            cell.customTextField.text = "\(keyvalueArr[indexPath.row])"
            if bankDict.type == banktypKeyboardeMode.varChar.rawValue {
                cell.customTextField.keyboardType = .default
                
            }else if bankDict.type == banktypKeyboardeMode.int.rawValue  {
                cell.customTextField.keyboardType = .numberPad
                
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BankDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - MyAccountPresenterToMyAccountViewProtocol

extension BankDetailController: MyAccountPresenterToMyAccountViewProtocol {
    
    func getBankTemplateList(bankTemplateEntity: BankTemplateEntity) {
        bankDetailArr = bankTemplateEntity.responseData ?? []
        if bankDetailArr.count == 0 {
            bankDetailTableView.setBackgroundImageAndTitle(imageName: MyAccountConstant.noDocument, title: MyAccountConstant.bankDetailsEmpty.localized)
            submitButton.isHidden = true
        }else{
            submitButton.isHidden = false
            bankDetailTableView.backgroundView = nil
        }
        
        for i in 0..<bankDetailArr.count {
            keyvalueArr.add(bankDetailArr[i].bankdetails?.keyvalue ?? String.Empty)
            bankformIdArr.add(bankDetailArr[i].id?.toString() ?? String.Empty)
            idvalueArr.add(bankDetailArr[i].bankdetails?.id?.toString() ?? String.Empty)
            
            if bankDetailArr[i].bankdetails != nil {
                self.iseditBank = true
            }
        }
        
        print(bankDetailArr)
        
        bankDetailTableView.reloadData()
    }
    
    func editBankDetailList(editBankEntity: LogoutEntity) {
        simpleAlert(view: self, title: String.Empty, message: editBankEntity.message ?? MyAccountConstant.bankSucess.localized,state: .success)
        navigationController?.popViewController(animated: true)
    }
    
    func addBankDetailList(addBankEntity: LogoutEntity) {
        simpleAlert(view: self, title: String.Empty, message: addBankEntity.message ?? MyAccountConstant.bankSucess.localized,state: .success)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - BankDetailCellDelegate

extension BankDetailController: BankDetailCellDelegate {
    
    func didSelectTextField(index: Int,textFieldStr: String) {
        let bankdict = bankDetailArr[index]
        
        if bankdict.bankdetails != nil {
            bankformIdArr.replaceObject(at: index, with: bankdict.id ?? String.Empty)
            keyvalueArr.replaceObject(at: index, with: textFieldStr)
            idvalueArr.replaceObject(at: index, with: bankdict.bankdetails?.id?.toString() ?? String.Empty)
        } else {
            bankformIdArr.replaceObject(at: index, with: bankdict.id ?? String.Empty)
            keyvalueArr.replaceObject(at: index, with: textFieldStr)
            idvalueArr.replaceObject(at: index, with: bankdict.bankdetails?.id?.toString() ?? String.Empty)
            
        }
    }
}
