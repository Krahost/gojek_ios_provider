//
//  ReasonView.swift
//  User
//
//  Created by CSS on 26/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class DisputeLostItemView: UIView, UIScrollViewDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var tableview : UITableView!
    @IBOutlet private weak var scrollView : UIScrollView!
    @IBOutlet private weak var labelTitle : UILabel!
    @IBOutlet private weak var buttonSubmit : UIButton!
    
    //MARK: - LocalVariable
    
    var textView: UITextView?
    
    private var datasource: [String] = []
    private var selectedIndexPath = IndexPath(row: -1, section: -1)
    private var isShowTextView = false {
        didSet {
            tableview.tableFooterView = isShowTextView ? getTextView() : nil
        }
    }
    
    var onClickClose: ((Bool)->Void)?
    var didSelectReason: ((String)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }
}

// MARK:- LocalMethods

extension DisputeLostItemView {
    
    private func initialLoad() {
        labelTitle.text = OrdersConstant.dispute.localized
        tableview.dataSource = self
        tableview.delegate = self
        isShowTextView = false
        tableview.register(nibName: OrdersConstant.DisputeCell)
        buttonSubmit.backgroundColor = .appPrimaryColor
        buttonSubmit.setTitle(Constant.submit.localized, for: .normal)
        buttonSubmit.setCornorRadius()
        buttonSubmit.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        setCustomFont()
        self.backgroundColor = .boxColor
        tableview.backgroundColor = .boxColor
    }
    
    //Creating Dynamic Text View
    private func getTextView()->UIView{
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        textView = UITextView(frame: CGRect(x: 16, y: 8, width: view.frame.width-60, height: 84))
        textView?.enablesReturnKeyAutomatically = true
        textView?.delegate = self
        textView?.layer.borderWidth = 1
        textView?.layer.cornerRadius = 10
        textView?.layer.borderColor = UIColor.lightGray.cgColor
        textView?.backgroundColor = .veryLightGray
        textView?.textColor = .lightGray
        textView?.text = Constant.writingSomething.localized
        textView?.font = .setCustomFont(name: .light, size: .x14)
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
        view.addSubview(textView!)
        return view
    }
    
    func set(value: [DisputeListData]?) {
        for dispute in value ?? [] {
            datasource.append(dispute.dispute_name ?? String.Empty)
        }
        datasource.append(OrdersConstant.others)
        tableview.reloadInMainThread()
    }
    
    func setCustomFont() {
        labelTitle.font = .setCustomFont(name: .bold, size: .x18)
        buttonSubmit.titleLabel?.font = .setCustomFont(name: .bold, size: .x16)
    }
}

// MARK:- IBAction

extension DisputeLostItemView {
    
    @objc private func tapSubmit() {
        
        if selectedIndexPath.row < 0 {
            ToastManager.show(title: OrdersConstant.selectDispute.localized, state: .error)
            return
        }
        
        if selectedIndexPath.row == datasource.count-1 && textView?.text == Constant.writingSomething.localized{
            ToastManager.show(title: OrdersConstant.enterComment.localized, state: .error)
            return
        }
        if self.selectedIndexPath.row == datasource.count-1 {
            guard let text = textView?.text, text != OrdersConstant.enterComment.localized, !text.isEmpty else {
                textView?.becomeFirstResponder()
                ToastManager.show(title: OrdersConstant.enterComment.localized, state: .error)
                return
            }
        }
        
        if selectedIndexPath.row == datasource.count-1  {
            didSelectReason?(textView?.text ?? String.Empty)
        } else {
            didSelectReason?(datasource[selectedIndexPath.row])
        }
    }
}

// MARK:- UITableViewDataSource

extension DisputeLostItemView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableview.dequeueReusableCell(withIdentifier: OrdersConstant.DisputeCell, for: indexPath) as? DisputeCell, datasource.count > indexPath.row {
            tableCell.selectionStyle = .none
            tableCell.lblTitle.text = datasource[indexPath.row].localized
            tableCell.isSelect = selectedIndexPath == indexPath
            return tableCell
        }
        return UITableViewCell()
    }
}

// MARK:- UITableViewDelegate

extension DisputeLostItemView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        var cell = tableView.cellForRow(at: selectedIndexPath) as? DisputeCell
        selectedIndexPath = indexPath
        cell = tableView.cellForRow(at: selectedIndexPath) as? DisputeCell
        cell?.isSelect = selectedIndexPath == indexPath
        
        if (indexPath.row == (datasource.count-1)) {
            isShowTextView = !isShowTextView ? true : false
        } else {
            isShowTextView = false
        }
        tableview.reloadInMainThread()
    }
}

// MARK:- UITextViewDelegate

extension DisputeLostItemView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constant.writingSomething.localized {
            self.textView?.text = String.Empty
            self.textView?.textColor = .black
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == String.Empty {
            self.textView?.text = Constant.writingSomething.localized
            self.textView?.textColor = .lightGray
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
