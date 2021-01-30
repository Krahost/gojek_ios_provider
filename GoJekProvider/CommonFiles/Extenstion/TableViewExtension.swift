//
//  TableViewExtension.swift
//  GoJekProvider
//
//  Created by apple on 27/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(nibName: String) {
        let Nib = UINib(nibName: nibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: nibName)
    }
    
    func reloadInMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func setBackgroundImageAndTitle(imageName:String?,title:String,tintColor: UIColor) {
        let emptyDataView = EmptyDataView(frame: self.bounds)
        if let image  = imageName  {
            emptyDataView.imageView.image = UIImage(named: image)?.imageTintColor(color: tintColor)
        }
        emptyDataView.labelTitle.text = title
        self.backgroundView = emptyDataView
        
    }
    
    func  setBackgroundImageAndTitle(imageName:String,title:String) {
        let emptyDataView = EmptyDataView(frame: self.bounds)
        emptyDataView.imageView.image = UIImage(named: imageName)
        emptyDataView.labelTitle.text = title
        self.backgroundView = emptyDataView
        
    }
}

