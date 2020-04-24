//
//  LoginController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
       
        if let email = emailTextField.text , let password = passwordTextField.text { //                                                                         ร้างตัวแปรได้
            
            if emailTextField.text != "" && passwordTextField.text != "" {      // ถ้ากรอกครบ
                
                Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                    
                    if let errorFound = error {
                        print(errorFound.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: segue.loginToMain, sender: self)
                    }
                    
                }
            } else {                                        // user กรอก เมลหรือพาสไม่ครบ
                
                let passwordAlert = UIAlertController(title:"Error", message: "Please Fill email or password", preferredStyle: .alert)        // create alertview
                
                let alertAction = UIAlertAction(title: "Dismiss", style: .destructive) { (UIAlertAction) in                              // create action button
                    self.passwordTextField.becomeFirstResponder()
                }
                passwordAlert.addAction(alertAction)                // add action
                
                self.present(passwordAlert, animated: true)
                
                
               
            }
        }
        
    }
    
   
}


