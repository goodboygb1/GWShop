//
//  MeViewController.swift
//  GWShopReal
//
//  Created by PMJs on 24/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       tabBarController?.navigationItem.setHidesBackButton(true, animated: animated)
       tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
       navigationController?.setNavigationBarHidden(true, animated: animated)
      
   }

    
    
}
