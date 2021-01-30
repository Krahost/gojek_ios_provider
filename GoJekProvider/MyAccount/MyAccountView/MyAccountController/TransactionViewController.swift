//
//  TransactionViewController.swift
//  GoJekProvider
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet weak var transactionHeaderView: UIView!
    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewDidSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide show tabbar
        hideTabBar()
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

extension TransactionViewController {
    
    private func viewDidSetup() {
        
        //View controller title
        title = MyAccountConstant.transaction.localized
        setLeftBarButtonWith(color: .black)
        //Custom tableview register
        tableView.register(nibName: MyAccountConstant.TransactionTableViewCell)
        tableView.separatorStyle = .none
        
        //Call custom localization
        setCustomLocalization()
        
        //Call custom color
        setCustomColor()
        
        //Call custom font
        setCustomFont()
    }
    
    //Set custom localization
    private func setCustomLocalization() {
        
        transactionIdLabel.text = MyAccountConstant.transactionId.localized
        amountLabel.text = MyAccountConstant.amount.localized
        statusLabel.text = MyAccountConstant.status.localized
    }
    
    //Set custom color
    private func setCustomColor() {
        
        transactionHeaderView.backgroundColor = .veryLightGray
        view.backgroundColor = .backgroundColor
        tableView.backgroundColor = .clear
    }
    
    //Set custom font
    private func setCustomFont() {
        
        transactionIdLabel.font = .setCustomFont(name: .light, size: .x16)
        statusLabel.font = .setCustomFont(name: .light, size: .x16)
        amountLabel.font = .setCustomFont(name: .light, size: .x16)
    }
}

// MARK: - UITableViewDataSource

extension TransactionViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionTableViewCell = tableView.dequeueReusableCell(withIdentifier: MyAccountConstant.TransactionTableViewCell, for: indexPath) as! TransactionTableViewCell
        cell.transactionIdLabel.text = "Tran0001"
        cell.amountLabel.text = "$ 1000"
        cell.statusLabel.text = "pending"
        cell.statusLabel.textColor = .orange
        return cell
    }
    
}

