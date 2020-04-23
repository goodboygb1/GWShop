//
//  RegisterViewController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController{

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var address1Field: UITextField!
    @IBOutlet weak var address2Field: UITextField!
    @IBOutlet weak var districtField: UITextField!
    @IBOutlet weak var ProvinceField: UITextField!
    @IBOutlet weak var postCode: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    var user: userDetail!
    var datePickerView: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func showDatePicker(_ sender: UITextField) {
        datePickerView = UIDatePicker()
        sender.inputView = datePickerView
        
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        toolBar.barStyle = UIBarStyle.default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        
        toolBar.items = [cancelButton, flexibleSpace, doneButton]
        sender.inputAccessoryView = toolBar
    }
    
    @objc func doneTapped(sender:UIBarButtonItem!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateField.text = dateFormatter.string(from: datePickerView.date)
        dateField.resignFirstResponder()
    }
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    
    @objc func cancelTapped(sender:UIBarButtonItem!) {
        dateField.resignFirstResponder()
    }
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
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
