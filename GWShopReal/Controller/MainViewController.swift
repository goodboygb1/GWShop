//
//  MainViewController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height/10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setHidesBackButton(true, animated: animated)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
    }
    
   

   
    
   
    

}
