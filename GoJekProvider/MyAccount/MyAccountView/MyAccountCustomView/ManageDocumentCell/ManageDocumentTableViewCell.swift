//
//  ManageDocumentTableViewCell.swift
//  GoJekProvider
//
//  Created by CSS on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ManageDocumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var doucmentTitleLabel: UILabel!
    @IBOutlet weak var serviceSelectionImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initalSetup()
    }
    
    private func initalSetup(){
        serviceSelectionImageview.isHidden = true
        doucmentTitleLabel.font = .setCustomFont(name: .light, size: .x16)
        bottomView.backgroundColor = .gray
        outterView.backgroundColor = .boxColor
        serviceSelectionImageview.image = UIImage(named: MyAccountConstant.check)
    }
    
    func setCategoryData(data: CategoryData){
        doucmentTitleLabel.text = data.service_category_name
        serviceSelectionImageview.isHidden = data.providerservicecategory?.count == 0 ? true : false
        setCustomArrow()
    }
    
    func setSubCategoryData(data: SubCategoryData){
        doucmentTitleLabel.text = data.service_subcategory_name
        serviceSelectionImageview.isHidden = data.providerservicesubcategory?.count == 0 ? true : false
        setCustomArrow()
    }
    
    func setCustomArrow() {
        rightArrowImageView.image = UIImage(named: MyAccountConstant.rightArrow)
        if CommonFunction.checkisRTL() {
            rightArrowImageView.transform = rightArrowImageView.transform.rotated(by: .pi)
        }
    }
    
    func setDocumentData(data: DocumentData){
        if data.service_category == nil  && data.servicesub_category == nil{
            doucmentTitleLabel.text = (data.name ?? "")
        }
        else if data.servicesub_category == nil{
            doucmentTitleLabel.text = (data.service_category?.service_category_name ?? "")
        }
        else{
            doucmentTitleLabel.text = (data.service_category?.service_category_name ?? "") + " - " + (data.servicesub_category?.service_subcategory_name ?? "")
        }
        if data.provider_document == nil {
            rightArrowImageView.image = UIImage(named: MyAccountConstant.error)
            rightArrowImageView.imageTintColor(color1: .red)
        } else {
            rightArrowImageView.image = UIImage(named: MyAccountConstant.check)
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
