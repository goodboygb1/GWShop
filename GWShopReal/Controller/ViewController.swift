//
//  ViewController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = loginButton.frame.size.height/5      //ปุ่มโค้ง
         loginButton.layer.cornerRadius = loginButton.frame.size.height/5
    }
    
    override func viewWillAppear(_ animated: Bool) {               //ซ่อนแถบข้างบนตอนเปิดหน้า
        super.viewWillAppear(animated)
         navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {            //เอาแถบข้างบนกลับมาตอนปิด
        super.viewWillDisappear(animated)
         navigationController?.isNavigationBarHidden = false
    }


}



