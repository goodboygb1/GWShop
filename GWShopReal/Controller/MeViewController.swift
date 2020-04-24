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

class ProfileController:UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToEditProfile", sender: self)
    }
    @IBAction func shopCartPressed(_ sender: UIButton) {
    }
    @IBAction func storePressed(_ sender: UIButton) {
    }
    
    @IBAction func showAddressPressed(_ sender: UIButton) {
    }
    @IBAction func showCardPressed(_ sender: UIButton) {
    }
    @IBAction func logOutPressed(_ sender: UIButton) {
    }
    
}

class EditProfileController: UIViewController{
    @IBOutlet weak var newProfileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var gender: String!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func genderChoosed(_ sender: UISegmentedControl) {
        gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
    }
    
    func newProfileNotNil() -> Bool{
        if firstNameTextField.text != ""{
            if lastNameTextField.text != ""{
                if gender != ""{
                    if dateOfBirthTextField.text != ""{
                        if phoneNumberTextField.text != ""{
                            return true
                        }else { return false }
                    }else { return false }
                }else { return false }
            }else { return false }
        }else { return false }
    }
    
}

class EditAddressController:UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
    }
    
    func newAddressNotNil() -> Bool{
        if firstNameTextField.text != ""{
            if lastNameTextField.text != ""{
                if phoneNumberTextField.text != ""{
                    if addressTextField.text != ""{
                        if districtTextField.text != ""{
                            if provinceTextField.text != ""{
                                if postCodeTextField.text != ""{
                                    return true
                                }else { return false }
                            }else { return false }
                        }else { return false }
                    }else { return false }
                }else { return false }
            }else { return false }
        }else { return false }
    }
    
}

class EditCardController:UIViewController {
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expiredMonthTextField: UITextField!
    @IBOutlet weak var expiredYearTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func submitPressed(_ sender: UIButton) {
    }
    
    func cardNotNil() -> Bool{
        if cardNameTextField.text != ""{
            if cardNumberTextField.text != ""{
                if expiredMonthTextField.text != ""{
                    if expiredYearTextField.text != ""{
                        if cvvTextField.text != ""{
                            return true
                        }else { return false }
                    }else { return false }
                }else { return false }
            }else { return false }
        }else { return false }
    }
}

class NewVendorController: UIViewController{
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var storePhoneTextField: UITextField!
    @IBOutlet weak var storeAddressTextField: UITextField!
    @IBOutlet weak var storeDistrictTextField: UITextField!
    @IBOutlet weak var storeProvinceTextField: UITextField!
    @IBOutlet weak var storePostCodeTextField: UITextField!
    
    @IBOutlet weak var bankNameSegment: UISegmentedControl!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var idCardTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    var bankName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bankNameChoosed(_ sender: UISegmentedControl) {
        bankName = bankNameSegment.titleForSegment(at: bankNameSegment.selectedSegmentIndex)
    }
    @IBAction func submitPressed(_ sender: UIButton) {
    }
    
    func storeDetailNotNil()-> Bool{
        if storeNameTextField.text != ""{
            if storePhoneTextField.text != ""{
                if storeAddressTextField.text != ""{
                    if storeDistrictTextField.text != ""{
                        if storeProvinceTextField.text != ""{
                            if storePostCodeTextField.text != ""{
                                if bankName != ""{
                                    if accountNameTextField.text != ""{
                                        if idCardTextField.text != ""{
                                            if accountNumberTextField.text != ""{
                                                return true
                                            }else { return false }
                                        }else { return false }
                                    }else { return false }
                                }else { return false }
                            }else { return false }
                        }else { return false }
                    }else { return false }
                }else { return false }
            }else { return false }
        }else { return false }
    }
    
}


