//
//  ReportViewController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 5/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func topFivePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.topFiveProductInMonthSegue, sender: self)
    }
}
