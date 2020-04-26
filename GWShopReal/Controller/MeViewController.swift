//
//  MeViewController.swift
//  GWShopReal
//
//  Created by PMJs on 24/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
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
    @IBOutlet weak var headerNameLabel: UILabel!
    
    var db = Firestore.firestore()
    var user: [userDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileData()
    }
    
    func loadProfileData(){
        if let emailSender = Auth.auth().currentUser?.email!{
            db.collection(K.userDetailCollection).whereField(K.sender, isEqualTo: emailSender)
                .getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Load profile form database error: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        let data = snapShotDocuments[0].data()
                        if let email = data[K.sender] as? String, let firstName = data[K.firstName] as? String , let lastName = data[K.surname] as? String
                            ,let gender = data[K.gender] as? String, let dob = data[K.dateOfBirth] as? String, let phoneNumber = data[K.phoneNumber] as? String{
                            DispatchQueue.main.async {
                                self.headerNameLabel.text = "\(firstName) \(lastName)"
                                self.emailLabel.text = email
                                self.firstNameLabel.text = firstName
                                self.lastNameLabel.text = lastName
                                self.genderLabel.text = gender
                                self.dateOfBirthLabel.text = dob
                                self.phoneNumberLabel.text = phoneNumber
                            }
                         }
                    }
                }
            }
        }
        
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.goToEditProfileSegue, sender: self)
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
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}

class EditProfileController: UIViewController{
    @IBOutlet weak var newProfileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var db = Firestore.firestore()
    var gender: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
    }
    @IBAction func genderChoosed(_ sender: UISegmentedControl) {
        gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if newProfileNotNil(){
            if let emailSender = Auth.auth().currentUser?.email{
                db.collection(K.userDetailCollection).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                    if let e = error{
                        print("Error in update profile page: \(e.localizedDescription)")
                    }else{
                        if let snapShotData = querySnapshot?.documents{
                            snapShotData.first?.reference.updateData([
                                K.firstName: self.firstNameTextField.text!,
                                K.surname:  self.lastNameTextField.text!,
                                K.gender: self.gender!,
                                K.dateOfBirth: self.dateOfBirthTextField.text!,
                                K.phoneNumber: self.phoneNumberTextField.text!
                                ], completion: { (error) in
                                    if let e = error{
                                        print("Error while updating data: \(e.localizedDescription)")
                                    }else{
                                        print("Successfully updated new profile")
                                    }
                            })
                        }
                    }
                }
            }
            
        }
        
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
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if newAddressNotNil() {
            let firstName = firstNameTextField.text!
            let lastName = lastNameTextField.text!
            let phoneNumber = phoneNumberTextField.text!
            let address = addressTextField.text!
            let district = districtTextField.text!
            let province = provinceTextField.text!
            let postCode = postCodeTextField.text!
            if let sender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.addressTableName) // still no addressID in this collection
                .addDocument(data:  [
                                   K.firstName: firstName,
                                   K.surname: lastName,
                                   K.phoneNumber: phoneNumber,
                                   K.addressDetail: address,
                                   K.district: district,
                                   K.province: province,
                                   K.postCode: postCode,
                                   K.dateField: Date().timeIntervalSince1970,
                                   K.sender: sender
                ]) { (error) in
                    if let e = error{
                        print("Add new Address error: \(e.localizedDescription)")
                    }
                    else{
                        print("Successfully added new address")
                    }
                }
            }
        }else {
            print("Some text fields did not have any text inside")
        }
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
    
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func submitPressed(_ sender: UIButton) {
        if cardNotNil(){
            let cardName = cardNameTextField.text!
            let cardNumber = cardNumberTextField.text!
            let expiredDate = "\(expiredMonthTextField.text!)/\(expiredYearTextField.text!)"
            let cvv = cvvTextField!
            if let sender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.cardDetailTableName).addDocument(data: [
                    K.cardDetail.cardName: cardName,
                    K.cardDetail.cardNumber: cardNumber,
                    K.cardDetail.expiredDate: expiredDate,
                    K.cardDetail.cvvNumber: cvv,
                    K.sender: sender,
                    K.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error{
                        print("Add card error: \(e.localizedDescription)")
                    }else{
                        print("Successfully added new card")
                    }
                }
            }
        }else{
            print("Some text fields did not have any text inside")
        }
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
    
    var db = Firestore.firestore()
    var bankName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bankNameChoosed(_ sender: UISegmentedControl) {
        bankName = bankNameSegment.titleForSegment(at: bankNameSegment.selectedSegmentIndex)
    }
    @IBAction func submitPressed(_ sender: UIButton) { // add addressID in collection
        if storeDetailNotNil(){
            let storeName = storeNameTextField.text!
            let storePhoneNumber = storePhoneTextField.text!
            let storeAddress = storeAddressTextField.text!
            let storeDistrict = storeDistrictTextField.text!
            let storeProvince = storeProvinceTextField.text!
            let storePostCode = storePostCodeTextField.text!
            if let sender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.storeDetailTableName).addDocument(data: [
                    K.storeDetail.storeName: storeName,
                    K.sender: sender,
                    K.phoneNumber: storePhoneNumber,
                    K.storeDetail.moneyTotal: 0,
                    K.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error{
                        print("Create new store error: \(e.localizedDescription)")
                    }else{
                        print("Successfully added new store in this user")
                    }
                }
            }
            
        }else {
            print("Some text fields did not have any text inside")
        }
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

class AddProductController:UIViewController{
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productCategoryTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var numberOfProductTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func removeImagePressed(_ sender: UIButton) {
           }
    @IBAction func confirmPressed(_ sender: UIButton) {
       
    }
}
