//
//  RegisterViewController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    var gender : String!
    let db = Firestore.firestore()
    var user: userDetail!
    var datePickerView: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showDatePicker(_ sender: UITextField) {
        
        // show datePicker when tab dateTextField
        
        datePickerView = UIDatePicker()                     // create DatePicker
        datePickerView.datePickerMode = .date               // เอาแค่วันที่
        datePickerView.calendar = Calendar(identifier: .buddhist)       // พ.ศ.
        datePickerView.locale = Locale(identifier: "th")                // ไทย
        
        sender.inputView = datePickerView                   // ตั้ง input = picker แทนคีบอด
        
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        toolbar.barStyle = UIBarStyle.default        // สร้าง toolbar structure
        
        let cancleButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(cancelTapped))         // create cancle button
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)               // space ขั่นกลาง
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        // create done button
        
        toolbar.setItems([cancleButton,flexibleSpace,doneButton], animated: true)
        // set item into toolsbar
        sender.inputAccessoryView = toolbar         // add toolbar into                                                      inputAccessoryView
        
        toolbar.items = [cancleButton, flexibleSpace, doneButton]
        sender.inputAccessoryView = toolbar
    }
    
    @objc func doneTapped(sender : UIBarButtonItem!)  {  // กด done แล้วจะจบ
        let dateFormatter  = DateFormatter()              // set formatter
        dateFormatter.locale = Locale(identifier: "th")   // set location to thailand
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        // set format เวลา
        dateTextField.text = dateFormatter.string(from: datePickerView.date)
        // add date into text field
        dateTextField.resignFirstResponder()              // close textfield
    }
    
    @objc func cancelTapped(sender:UIBarButtonItem!) {   // กด cancle จะไม่ทำอะไรเลย
        dateTextField.resignFirstResponder()
    }
    
    
    
    @IBAction func genderPressed(_ sender: UISegmentedControl) {
        gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)!
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        let userDetailIsNotNil = userDetailIsNotNilFunction()  // เช็ค detail ว่ากรอกครบไหม
        
        if userDetailIsNotNil {                                // ถ้าครบ
            
            if let email = emailTextField.text , let password = passwordTextField.text {
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    
                    if let errorFound = error {                 // ถ้า register ไม่ผ่าน
                        print("Register Failed")
                        print(errorFound.localizedDescription)
                        
                        let firebaseAlert = UIAlertController(title: "Error", message: errorFound.localizedDescription, preferredStyle: .alert)
                        let firebaseAlertAction = UIAlertAction(title: "Dissmiss", style: .destructive) { (UIAlertAction) in
                        }
                        firebaseAlert.addAction(firebaseAlertAction)
                        self.present(firebaseAlert, animated: true)
                    }
                        
                    else {                                                    // ถ้า register ผ่าน
                        print("Register Success")
                        
                        let detailForSendToFirebase : [String : Any] =    // pack                                                           userdetail to                                                   dictionary
                            [
                                K.firstName : self.firstNameTextField.text!,
                                K.surname : self.lastNameTextField.text!,
                                K.gender : self.gender!,
                                K.phoneNumber : self.phoneNumberTextField.text!,
                                K.dateOfBirth : self.dateTextField.text!,
                                K.addressDetail : self.address1TextField.text!,
                                K.province : self.provinceTextField.text!,
                                K.district : self.districtTextField.text!,
                                K.postCode : self.postCodeTextField.text!,
                                K.sender : email
                        ]
                        
                        self.db.collection(K.userDetailCollection).addDocument(data:  detailForSendToFirebase) { (error) in
                            if let e = error {
                                print("error while saveing data to fire store \(e)")
                            } else {
                                print("saving success")
                                self.performSegue(withIdentifier: segue.registerToMain, sender: self)
                                
                            }                             // sent data to firebase
                        }
                        
                    }
                    
                    
                }
                
            }
        }
            
            
        else {    print("Error detail")                             // ถ้ากรอกไม่ครบ
            
            let detailAlert = UIAlertController(title: "Error", message: "Please fill information befor pressed register", preferredStyle: .alert)                      // crete alert
            let detailAction = UIAlertAction(title: "Dissmiss", style: .destructive) { (UIAlertAction) in
                
            }
            
            detailAlert.addAction(detailAction)
            self.present(detailAlert, animated: true)      // show alert to user
            
        }
    }
    
    
    
    
    
    
    func userDetailIsNotNilFunction() -> Bool { // เช็คว่ากรอกครบทุกช่องแล้ว
        if firstNameTextField.text != "" {
            if lastNameTextField.text != "" {
                if phoneNumberTextField.text != "" {
                    if dateTextField.text != "" {
                        if address1TextField.text != "" {
                            if provinceTextField.text != "" {
                                if districtTextField.text != "" {
                                    if postCodeTextField.text != "" {
                                        return true
                                    } else {
                                        return false
                                    }
                                } else {
                                    return false
                                }
                            } else {
                                return false
                            }
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
}





