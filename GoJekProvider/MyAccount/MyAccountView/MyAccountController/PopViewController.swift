//
//  PopViewController.swift
//  GoJekProvider
//
//  Created by Sudar vizhi on 17/08/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {
    
    @IBOutlet weak var contentLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentLabel.font = UIFont.setCustomFont(name: .medium, size: .x16)
        contentLabel.text = MyAccountConstant.waitingApproval
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
