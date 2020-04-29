//
//  MeViewController.swift
//  GWShopReal
//
//  Created by PMJs on 24/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase


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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setHidesBackButton(true, animated: animated)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.setHidesBackButton(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileData()
    }
    
    func loadProfileData(){
        if let emailSender = Auth.auth().currentUser?.email!{
            db.collection(K.userDetailCollection).whereField(K.sender, isEqualTo: emailSender)
                .getDocuments { (querySnapshot, error) in
                if let e = error{
                    
                    let queryAlart = UIAlertController(title:"Error", message: "Please Fill email or password", preferredStyle: .alert)  // create alertview
                    
                    let alertAction = UIAlertAction(title: "Load profile error", style: .destructive) { (UIAlertAction) in           // create action button
                       
                    }
                    queryAlart.addAction(alertAction)                // add action
                    
                    self.present(queryAlart, animated: true)
                    
                    print("Load profile form database error: \(e.localizedDescription)")
                    
                } else {
                    if let snapShotDocuments = querySnapshot?.documents{
                        let data = snapShotDocuments[0].data()
                        if let email = data[K.sender] as? String,
                           let firstName = data[K.firstName] as? String,
                           let lastName = data[K.surname] as? String,
                           let gender = data[K.gender] as? String,
                           let dob = data[K.dateOfBirth] as? String,
                           let phoneNumber = data[K.phoneNumber] as? String {
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
        if let emailSender = Auth.auth().currentUser?.email{
            db.collection(K.tableName.storeDetailTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error in hadStore Function: \(e.localizedDescription)")
                }else{
                    if let snapShotData = querySnapshot?.documents{
                        for doc in snapShotData{
                            let data = doc.data()
                            if let dataSender = data[K.sender] as? String{
                                if dataSender == emailSender{
                                    self.performSegue(withIdentifier: K.segue.profileToStoreDetailSegue, sender: self)
                                }
                                else if dataSender != emailSender{
                                    self.performSegue(withIdentifier: K.segue.profileToNewVendorSegue, sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func showAddressPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.goToShowAddressSegue, sender: self)
    }
    @IBAction func showCardPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.profileToShowCardSegue, sender: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do{ print("logged out")
            try Auth.auth().signOut()
            performSegue(withIdentifier: K.segue.logoutToMainSegue, sender: self)
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.goToShowAddressSegue{
            let destinationVC = segue.destination as! ShowAddressViewController
            destinationVC.name = headerNameLabel.text
        }else if segue.identifier == K.segue.profileToShowCardSegue{
            let destinationVC = segue.destination as! ShowCardViewController
            destinationVC.name = headerNameLabel.text
        }
    }
}

class ShowAddressViewController:UIViewController{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTableView: UITableView!
    
    var name: String?
    var addresses: [Address] = []
    var db = Firestore.firestore()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name!
        addressTableView.dataSource = self
        //addressTableView.register(UINib(nibName: K.identifierForTableView.nibNameAddress, bundle: nil), forCellReuseIdentifier: K.identifierForTableView.identifierAddress)
        loadAddressData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func addAddressPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.goToEditAddressSegue, sender: self)
    }
    
    func loadAddressData(){
        if let emailSender = Auth.auth().currentUser?.email{
            db.collection(K.tableName.addressTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                self.addresses = []
                if let e = error{
                    print("error while loading name in show address page: \(e.localizedDescription)")
                }else{
                    if let snapShotDocument = querySnapshot?.documents{
                        for doc in snapShotDocument{
                            let data = doc.data()
                            let doc_id = doc.documentID
                            if let firstName = data[K.firstName] as? String, let lastName = data[K.surname] as? String, let phoneNumber = data[K.phoneNumber] as? String
                                , let addressDetail = data[K.addressDetail] as? String, let district = data[K.district] as? String
                                , let province = data[K.province] as? String, let postCode = data[K.postCode] as? String{
                                let newAddress = Address(firstName: firstName,lastName: lastName, phoneNumber: phoneNumber, addressDetail: addressDetail, district: district, province: province, postCode: postCode,docID: doc_id)
                                self.addresses.append(newAddress)
                                
                                DispatchQueue.main.async {
                                    self.addressTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        print("Successfully address loaded to array")
    }

}
extension ShowAddressViewController: AddressDelegate{
    func didPressDelete(documentID: String) {
        db.collection(K.tableName.addressTableName).document(documentID).delete()
    }
    
}

extension ShowAddressViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let address = addresses[indexPath.row]
        let addressCell = addressTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierAddress) as! AddressCell
        addressCell.firstNameLabel.text = address.firstName
        addressCell.lastNameLabel.text = address.lastName
        addressCell.phoneLabel.text = address.phoneNumber
        addressCell.addressDetailLabel.text = address.addressDetail
        addressCell.districtLabel.text = address.district
        addressCell.provinceLabel.text = address.province
        addressCell.postCodeLabel.text = address.postCode
        addressCell.documentIDLabel.text = address.docID
        addressCell.delegate = self
        return addressCell
    }
}

protocol AddressDelegate {
    func didPressDelete(documentID: String)
    // firstName: String,lastName: String,phoneNumber: String,addressDetail: String,district: String,province: String,postCode: String
}
class AddressCell: UITableViewCell {
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    var delegate: AddressDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate?.didPressDelete(documentID: documentIDLabel.text!)
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
                        print("got document")
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
        self.dismiss(animated: false, completion: nil)
        }else {
            print("Some text fields did not have any text inside")
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
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
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
                                   K.phoneNumber : phoneNumber,
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
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }else {
            print("Some text fields did not have any text inside")
        }
    }
    
    func newAddressNotNil() -> Bool{
        if phoneNumberTextField.text != ""{
            if firstNameTextField.text != ""{
                if lastNameTextField.text != ""{
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

class ShowCardViewController: UIViewController{
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var cardTableView: UITableView!
    
    var name: String?
    var cards: [Card] = []
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        headerNameLabel.text = name!
        cardTableView.dataSource = self
        loadCardData()
    }
    
    func loadCardData(){
        if let emailSender = Auth.auth().currentUser?.email{
            self.cards = []
            db.collection(K.tableName.cardDetailTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error in show card page: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        for doc in snapShotDocuments{
                            let data = doc.data()
                            let docID = doc.documentID
                            if let cardName = data[K.cardDetail.cardName] as? String, let cardNumber = data[K.cardDetail.cardNumber] as? String, let expiredDate = data[K.cardDetail.expiredDate] as? String
                                ,let cvv = data[K.cardDetail.cvvNumber] as? String{
                                self.cards.append(Card(cardNumber: cardNumber, cardName: cardName, expiredDate: expiredDate, cvv: cvv, docID: docID))
                                
                                DispatchQueue.main.async {
                                    self.cardTableView.reloadData()
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func addCardPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.segue.showCardToEditCardSegue, sender: self)
    }
    
}
extension ShowCardViewController: CardViewCellDelegate{
    func didPressDelete(docID: String) {
        db.collection(K.tableName.cardDetailTableName).document(docID).delete()
    }
    
    
}

extension ShowCardViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = cards[indexPath.row]
        let cardCell = cardTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierCard) as! CardViewCell
        cardCell.cardNameLabel.text = card.cardName
        cardCell.cardNumberLabel.text = card.cardNumber
        cardCell.expiredDateLabel.text = card.expiredDate
        cardCell.documentIDLabel.text = card.docID
        cardCell.delegate = self
        return cardCell
    }
    
}
protocol CardViewCellDelegate {
    func didPressDelete(docID: String)
}

class CardViewCell: UITableViewCell{
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expiredDateLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    var delegate: CardViewCellDelegate?
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate?.didPressDelete(docID: documentIDLabel.text!)
    }
}

class EditCardController:UIViewController {
    @IBOutlet weak var cardFirstNameTextField: UITextField!
    @IBOutlet weak var cardLastNameTextField: UITextField!
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
            let cardName = "\(cardFirstNameTextField.text!) \(cardLastNameTextField.text!)"
            let cardNumber = cardNumberTextField.text!
            let expiredDate = "\(expiredMonthTextField.text!)/\(expiredYearTextField.text!)"
            let cvv = cvvTextField.text!
            if let emailSender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.cardDetailTableName).addDocument(data: [
                    K.cardDetail.cardName: cardName,
                    K.cardDetail.cardNumber: cardNumber,
                    K.cardDetail.expiredDate: expiredDate,
                    K.cardDetail.cvvNumber: cvv,
                    K.sender: emailSender,
                    K.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error{
                        print("Add card error: \(e.localizedDescription)")
                    }else{
                        print("Successfully added new card")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }else{
            print("Some text fields did not have any text inside")
        }
    }
    
    func cardNotNil() -> Bool{
        if cardLastNameTextField.text != ""{
            if cardFirstNameTextField.text != ""{
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
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    var db = Firestore.firestore()
    var bankName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        bankName = bankNameSegment.titleForSegment(at: bankNameSegment.selectedSegmentIndex)
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
                    K.storeDetail.addressDetail: storeAddress,
                    K.storeDetail.district: storeDistrict,
                    K.storeDetail.province: storeProvince,
                    K.storeDetail.postCode: storePostCode,
                    K.storeDetail.moneyTotal: 0,
                    K.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error{
                        print("Create new store error: \(e.localizedDescription)")
                    }else{
                        print("Successfully added new store in this user")
                    }
                }
                db.collection(K.tableName.bankAccountTableName).addDocument(data: [
                    K.bankAccount.accountName: self.accountNameTextField.text!,
                    K.bankAccount.accountNumber: self.accountNumberTextField.text!,
                    K.storeDetail.storeName: storeName,
                    K.bankAccount.bankName: self.bankName!,
                    K.sender: sender
                ]) { (error) in
                    if let e = error{
                        print("Error in create new vendor page: \(e.localizedDescription)")
                    }else{
                        print("Successfully added new store in database")
                        self.performSegue(withIdentifier: K.segue.newVendorToStoreDetailSegue, sender: self)
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
    }
    
}

class StoreDetailController :UIViewController{
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storePhoneNumberLabel: UILabel!
    @IBOutlet weak var moneyTotalLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDistrictLabel: UILabel!
    @IBOutlet weak var storeProvinceLabel: UILabel!
    @IBOutlet weak var storePostCodeLabel: UILabel!
    
    @IBOutlet weak var storeBankAccountTableView: UITableView!
    var db = Firestore.firestore()
    var bankAccounts: [BankAccount] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        storeBankAccountTableView.dataSource = self
        loadStoreData()
    }
   
    
    func loadStoreData(){
        if let emailSender = Auth.auth().currentUser?.email{
            self.bankAccounts = []
            db.collection(K.tableName.storeDetailTableName).whereField(K.sender
                , isEqualTo:  emailSender) .getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error while loading store data: \(e.localizedDescription)")
                }else{
                    if let snapShotDocument = querySnapshot?.documents{
                        let data = snapShotDocument[0].data()
                        if let storeName = data[K.storeDetail.storeName] as? String,let storePhone = data[K.phoneNumber] as? String,let money = data[K.storeDetail.moneyTotal] as? Double,let storeAddress = data[K.storeDetail.addressDetail] as? String,let storeDistrict = data[K.storeDetail.district] as? String,let storeProvince = data[K.storeDetail.province] as? String,let storePostCode = data[K.storeDetail.postCode] as? String{
                            DispatchQueue.main.async {
                                self.storeNameLabel.text = storeName
                                self.storePhoneNumberLabel.text = storePhone
                                self.moneyTotalLabel.text = String(format: "%.2f", money)
                                self.storeAddressLabel.text = storeAddress
                                self.storeDistrictLabel.text = storeDistrict
                                self.storeProvinceLabel.text = storeProvince
                                self.storePostCodeLabel.text = storePostCode
                            }
                            
                        }
                    }
                }
            }
            db.collection(K.tableName.bankAccountTableName).whereField(K.sender
                , isEqualTo:  emailSender).getDocuments { (querySnapshot, error) in
                    if let e = error{
                        print("Error while loading bank account: \(e.localizedDescription)")
                    }else{
                        if let snapShotDocuments = querySnapshot?.documents{
                            for doc in snapShotDocuments{
                                let data = doc.data()
                                let docID = doc.documentID
                                if let accountName = data[K.bankAccount.accountName] as? String,let accountNumber = data[K.bankAccount.accountNumber] as? String,let bankName = data[K.bankAccount.bankName] as? String,let sender = data[K.sender] as? String{
                                    self.bankAccounts.append(BankAccount(bankAccontName: accountName, bankAccountNumber: accountNumber, bankName: bankName, sender: sender, docID: docID))
                                    
                                    DispatchQueue.main.async {
                                        self.storeBankAccountTableView.reloadData()
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
}

extension StoreDetailController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = bankAccounts[indexPath.row]
        let accountCell = storeBankAccountTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierBankAccount) as! BankAccountCell
        accountCell.accountNameLabel.text = account.bankAccontName
        accountCell.accountNumberLabel.text = account.bankAccountNumber
        accountCell.bankNameLabel.text = account.bankName
        
        return accountCell
    }
    
    
}
class BankAccountCell : UITableViewCell{
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankImageView: UIImageView!
    
}


