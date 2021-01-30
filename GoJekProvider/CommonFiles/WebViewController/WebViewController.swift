//
//  WebViewController.swift
//  GoJekProvider
//
//  Created by Rajes on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView : WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    var urlString: String = String.Empty
    var navTitle: String = String.Empty

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.load(request)
        }
        self.title = navTitle
        self.setLeftBarButtonWith(color: .blackColor)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.show()
        self.navigationController?.isNavigationBarHidden = false
        self.hideTabBar()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setWebViewFrame()
    }
    
    func setWebViewFrame() {
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
//MARK:- WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        LoadingIndicator.hide()
    }
}
