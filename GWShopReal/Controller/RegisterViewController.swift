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
    @IBOutlet weak var malePressed: UIButton!
    @IBOutlet weak var femalePressed: UIButton!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
    var user  = Constant()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func genderPressed(_ sender: UIButton) {
        malePressed.isSelected = false
        femalePressed.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if emailText.text != "" && passwordText != "" && firstName.text != "" && lastName.text != "" && dateField != "" && monthField != "" && yearField != "" && phoneNumber != "" && address1Field != "" && address2Field != "" && districtField != "" && ProvinceField != "" && postCode != "" && (malePressed.isSelected || femalePressed){
            
            user.name = firstName.text
            user.surname = lastName.text
            user.phoneNumber = phoneNumber.text
            user.dateOfBirth = String(dateField.text + "/\(monthField.text)/\(yearField.text)" )
            user.addressDetail = String(address1Field.text + " \(address2Field)")
            user.province = ProvinceField.text
            user.district = districtField.text
            user.postCode = Int(postCode.text)
            
            if malePressed {
                user.gender = "M"
            }else{
                user.gender = "F"
            }
        }
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
