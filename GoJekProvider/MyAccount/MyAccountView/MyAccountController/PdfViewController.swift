//
//  PdfViewController.swift
//  GoJekProvider
//
//  Created by CSS on 24/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import PDFKit


class PdfViewController: UIViewController {
     let pdfView = PDFView()
    
    var urlString: String = String.Empty
    var navTitle: String = String.Empty

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        title = navTitle
        setLeftBarButtonWith(color: .black)
        pdfView.autoScales = false
        if let url = URL(string: urlString){
            if let document = PDFDocument(url: url) {
                pdfView.document = document
            }
        }
    }
}
