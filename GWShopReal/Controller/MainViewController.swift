//
//  MainViewController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        searchTextField.delegate = self
        super.viewDidLoad()
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height/10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setHidesBackButton(true, animated: animated)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let searchKeyword = searchTextField.text
        
        performSegue(withIdentifier: K.segue.mainToSearchDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        <#code#>
    }
    
 }


class SearchViewController: UIViewController {
    
    
}
