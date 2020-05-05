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
        tabBarController?.tabBar.isHidden = false
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.setHidesBackButton(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
        
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
            db.collection(K.tableName.storeDetailTableName)/*.whereField(K.sender, isEqualTo: emailSender)*/.getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error in hadStore Function: \(e.localizedDescription)")
                }else {
                    if let snapShotData = querySnapshot?.documents{
                        for doc in snapShotData{
                            let data = doc.data()
                            if let dataSender = data[K.sender] as? String{
                                if dataSender == emailSender{
                                    self.performSegue(withIdentifier: K.segue.meToMainStore, sender: self)
                                    break
                                }
                                else if dataSender != emailSender{
                                    self.performSegue(withIdentifier: K.segue.meToCreateStore, sender: self)
                                    break
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
                            if let firstName = data[K.firstName] as? String
                                , let lastName = data[K.surname] as? String
                                , let phoneNumber = data[K.phoneNumber] as? String
                                , let addressDetail = data[K.addressDetail] as? String
                                , let district = data[K.district] as? String
                                , let province = data[K.province] as? String
                                , let postCode = data[K.postCode] as? String
                                ,let defaultAddress = data[K.defaultAddress] as? Bool
                            {
                                let newAddress = Address(firstName: firstName,lastName: lastName, phoneNumber: phoneNumber, addressDetail: addressDetail, district: district, province: province, postCode: postCode,docID: doc_id, isDefultAddress: defaultAddress)
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
        loadAddressData()
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

class EditProfileController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var newProfileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    
    var db = Firestore.firestore()
    var gender: String!
    var imageForUpload : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
    }
    
    @IBAction func selectImageButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Select Image", message: "Please select source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("camera not avaliable")
            }
        }
        
        let libAction = UIAlertAction(title: "Photo Library", style: .default) { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("album not avaliable")
            }
        }
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libAction)
        actionSheet.addAction(cancleAction)
        
        self.present(actionSheet,animated: true,completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageForUser = info[.originalImage] as! UIImage
        imageForUpload = imageForUser
        
        newProfileImageView.image = imageForUser
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func genderChoosed(_ sender: UISegmentedControl) {
        gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
    }
    
    func presentAlert(title:String,message:String,actiontitle:String)  {
        
        // for show alert to user
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actiontitle, style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        
    }
    
    func uploadImage()  {
        
       
        guard let imageSelect = self.imageForUpload else {     //add image for upload
            print("Image is nil")
            presentAlert(title: "Image Error", message: "Please select image", actiontitle: "Dismiss")
            return
        }
        
        guard let imageData = imageSelect.jpegData(compressionQuality: 0.5) else {
            // convert image to jpeg
            
            presentAlert(title: "Image Error", message: "Can't convert Image", actiontitle: "Dismiss")
            return
        }
        
        let storageRef = Storage.storage().reference(forURL:    "gs://gwshopreal-47f16.appspot.com")               // add link to upload
        
        let storageProductRef = storageRef.child("ProfileImage").child("\(Auth.auth().currentUser?.email)+\(Date().timeIntervalSince1970)")          // path for upload
        
        let metaData  = StorageMetadata()                      // set meta data
        metaData.contentType = "image/jpg"
        
        storageProductRef.putData(imageData, metadata: metaData) { (storageMetaData, error) in                                          // upload file
            
            if let errorFromPut = error {                      // upload failed
                self.presentAlert(title: "Error Upload Image", message: error?.localizedDescription ?? "error", actiontitle: "Dismiss")
                print(errorFromPut.localizedDescription)
                
            } else {                                           // upload success
                print("put success")
                
                storageProductRef.downloadURL { (url, error) in     // download URL
                    
                    if let metaImageURL = url?.absoluteString {     // change URL TO String
                        
                        
                       self.uploadDataToFireBase(imageURL: metaImageURL)                           // update others                                                  information
                        // add picture first
                        // picture use long time
                        
                    } else {
                        print("error from download URL")          // can't donwload URL
                       
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    
    func uploadDataToFireBase(imageURL : String )  {
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
                                K.phoneNumber: self.phoneNumberTextField.text!,
                                K.imageURL : imageURL
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
    
    
    
    
    
    
    let db = Firestore.firestore()
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
                        K.sender: sender,
                        K.defaultAddress : false
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
    
    func loadCardData() {
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
                            if let cardName = data[K.cardDetail.cardName] as? String
                                , let cardNumber = data[K.cardDetail.cardNumber] as? String
                                , let expiredDate = data[K.cardDetail.expiredDate] as? String
                                ,let cvv = data[K.cardDetail.cvvNumber] as? String
                                ,let isDefultCard = data[K.cardDetail.isDefultCard] as? Bool
                            {
                                self.cards.append(Card(cardNumber: cardNumber, cardName: cardName, expiredDate: expiredDate, cvv: cvv, docID: docID, isDefultCard: isDefultCard))
                                
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
        loadCardData()
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
                    K.cardDetail.isDefultCard : false,
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
                    K.dateField: Date().timeIntervalSince1970,
                    K.defaultAddress: true
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
                        self.performSegue(withIdentifier: K.segue.createStoreToMainStoreSegue, sender: self)
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
    var moneyTotal: Double = 0.0
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
                                    self.moneyTotal = money
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
                                if let accountName = data[K.bankAccount.accountName] as? String,let accountNumber = data[K.bankAccount.accountNumber] as? String,let bankName = data[K.bankAccount.bankName] as? String{
                                    self.bankAccounts.append(BankAccount(bankAccontName: accountName, bankAccountNumber: accountNumber, bankName: bankName, docID: docID))
                                    
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
    
    @IBAction func addAccountPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.storeDetialToEditAccountSegue, sender: self)
    }
    @IBAction func editStorePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.storeDetailToEditStoreDetailSegue, sender: self)
    }
    @IBAction func withDrawPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.storeDetailToWithdrawPageSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.storeDetialToEditAccountSegue{
            let destinationVC = segue.destination as! EditAccountController
            destinationVC.storeName = storeNameLabel.text
        }else if segue.identifier == K.segue.storeDetailToWithdrawPageSegue{
            let destinationVC = segue.destination as! WithDrawController
            destinationVC.moneyTotal = moneyTotal
            destinationVC.storeName = storeNameLabel.text
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
        accountCell.documentIDLabel.text = account.docID
        
        if account.bankName == "KTB"{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "ktb-logo")
        }else if account.bankName == "KBANK"{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "kbank-logo")
        }else if account.bankName == "SCB"{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "SCB-logo")
        }else{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "logo-krungsri")
        }
        
        return accountCell
    }
    
    
}
class BankAccountCell : UITableViewCell{
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankImageView: UIImageView!
    @IBOutlet weak var documentIDLabel: UILabel!
    
}

class EditAccountController:UIViewController{
    @IBOutlet weak var bankNameSegment: UISegmentedControl!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var storeNameLabel: UILabel!
    var bankName: String!
    var storeName: String!
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        storeNameLabel.text = storeName
        bankName = bankNameSegment.titleForSegment(at: bankNameSegment.selectedSegmentIndex)
    }
    
    @IBAction func bankNameChoosed(_ sender: UISegmentedControl) {
        bankName = bankNameSegment.titleForSegment(at: bankNameSegment.selectedSegmentIndex)
    }
    
    func NewAccountNotNil() -> Bool{
        if bankName != ""{
            if accountNumberTextField.text != ""{
                if accountNumberTextField.text != ""{
                    return true
                }else { return false }
            }else { return false }
        }else { return false }
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if NewAccountNotNil(){
            if let emailSender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.bankAccountTableName).addDocument(data: [
                    K.sender: emailSender,
                    K.bankAccount.accountName: accountNameTextField.text!,
                    K.bankAccount.accountNumber: accountNumberTextField.text!,
                    K.bankAccount.bankName: bankName!,
                    K.storeDetail.storeName: storeName!
                ]) { (error) in
                    if let e = error{
                        print("Error while saving bank account to database: \(e)")
                    }else{
                        print("Successfully saved bank account")
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }else{
            print("Some text fields haven't filled in")
        }
    }
}

class  EditStoreDetailController: UIViewController {
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var storeDistrictTextField: UITextField!
    @IBOutlet weak var storeProvinceTextField: UITextField!
    @IBOutlet weak var postCodeTextField: UITextField!
    
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateImagePressed(_ sender: UIButton) {
    }
    @IBAction func submitPressed(_ sender: UIButton) {
        if NewStoreDetailNotNil(){
            if let emailSender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.storeDetailTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                    if let e = error{
                        print("Error while get store detail: \(e.localizedDescription)")
                    }else{
                        if let snapShotDocuments = querySnapshot?.documents{
                            snapShotDocuments.first?.reference.updateData([
                                K.sender: emailSender,
                                K.storeDetail.storeName: self.storeNameTextField.text!,
                                K.phoneNumber: self.phoneNumberTextField.text!,
                                K.storeDetail.addressDetail: self.storeDistrictTextField.text!,
                                K.storeDetail.district: self.storeProvinceTextField.text!,
                                K.storeDetail.province: self.storeProvinceTextField.text!,
                                K.storeDetail.postCode: self.postCodeTextField.text!,
                                K.dateField: Date().timeIntervalSince1970
                                ], completion: { (error) in
                                    if let e = error{
                                        print("Error while updating store detail: \(e.localizedDescription)")
                                    }else{
                                        print("Successfully updated store detail")
                                    }
                            })
                        }
                        
                    }
                }
                self.dismiss(animated: true, completion: nil)
            }else {
                print("Some text fields did not have any text inside")
            }
        }
        
    }
    
    func NewStoreDetailNotNil()-> Bool{
        if storeNameTextField.text != ""{
            if phoneNumberTextField.text != ""{
                if addressTextField.text != ""{
                    if storeDistrictTextField.text != ""{
                        if storeProvinceTextField.text != ""{
                            if postCodeTextField.text != ""{
                                return true
                            }else { return false }
                        }else { return false }
                    }else { return false }
                }else { return false }
            }else { return false }
        }else { return false }
    }
    
}

class WithDrawController: UIViewController {
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var bankAccountTableView: UITableView!
    var storeName: String!
    var moneyTotal: Double!
    var diffMoney: Double = 0.0
    var db = Firestore.firestore()
    var withdrawAccount: String = ""
    var accounts:[BankAccount] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        bankAccountTableView.delegate = self
        bankAccountTableView.dataSource = self
        loadAccountData()
    }
    
    func loadAccountData(){
        if let emailSender = Auth.auth().currentUser?.email{
            self.accounts = []
            db.collection(K.tableName.bankAccountTableName).whereField(K.sender, isEqualTo:  emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error while loading bank account for withdraw: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        for doc in snapShotDocuments{
                            let data = doc.data()
                            let docID = doc.documentID
                            if let accountName = data[K.bankAccount.accountName] as? String, let accountNumber = data[K.bankAccount.accountNumber] as? String,let bankName = data[K.bankAccount.bankName] as? String{
                                self.accounts.append(BankAccount(bankAccontName: accountName, bankAccountNumber: accountNumber, bankName: bankName, docID: docID))
                                
                                DispatchQueue.main.async {
                                    self.bankAccountTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func withdrawPressed(_ sender: UIButton) {
        if withdrawNotNil(){
            let withdrawMoney = Double(moneyTextField.text!)
            diffMoney = moneyTotal - withdrawMoney!
            if diffMoney > 0{
                if let emailSender = Auth.auth().currentUser?.email{
                    db.collection(K.tableName.storeDetailTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                        if let e = error{
                            print("Error while withdrawing money: \(e.localizedDescription)")
                        }else{
                            if let snapShotDocument = querySnapshot?.documents{
                                snapShotDocument.first?.reference.updateData([
                                    K.storeDetail.moneyTotal: self.diffMoney
                                ])
                                print("Successfully withdrawn")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                    db.collection(K.tableName.transactionTableName).addDocument(data: [
                        K.transaction.amountMoney: withdrawMoney!,
                        K.storeDetail.storeName: storeName!,
                        K.sender: emailSender,
                        K.dateField: Date(),
                        K.transaction.isApprove: false
                    ]) { (error) in
                        if let e = error{
                            print("Error while adding transaction data: \(e)")
                        }else{
                            print("Successfully add transaction data")
                        }
                    }
                }
            }else{
                /*let alert = UIAlertController(title: "Can't withdraw", message: "Your money is not enough", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))*/
                print("Your money is not enough")
            }
        }else{
            /*let alert = UIAlertController(title: "Can't withdraw", message: "Please select account for withdrawing money or type amount of money", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))*/
            print("Please select account for withdrawing money or type amount of money")
        }
    }
    
    func withdrawNotNil()-> Bool{
        if withdrawAccount != ""{
            if moneyTextField.text != ""{
                return true
            }else { return false}
        }else { return false }
    }
}

extension WithDrawController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        let accountCell = bankAccountTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierBankAccountWithDraw) as! AccountCellInWithdrawCell
        accountCell.accountNameLabel.text = account.bankAccontName
        accountCell.accountNumberLabel.text = account.bankAccountNumber
        accountCell.bankNameLabel.text = account.bankName
        accountCell.documentIDLabel.text = account.docID
        
        if account.bankName == "KTB"{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "ktb-logo")
        }else if account.bankName == "KBANK"{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "kbank-logo")
        }else if account.bankName == "SCB"{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "SCB-logo")
        }else{
            accountCell.bankImageView.image = #imageLiteral(resourceName: "logo-krungsri")
        }
        return accountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        withdrawAccount = accounts[indexPath.row].bankAccountNumber
    }
}

protocol AccountCellWithdrawDelegate {
    func didSelectAccount(docID: String)
}

class AccountCellInWithdrawCell:UITableViewCell{
    @IBOutlet weak var bankImageView: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    
}


class StoreMainController: UIViewController{
    
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var moneyTotalLabel: UILabel!
    @IBOutlet weak var storeMainTableView: UITableView!
    @IBOutlet weak var searchProductTextField: UITextField!
    
    var db = Firestore.firestore()
    var products: [Product] = []
    var documentIDSelected: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        storeMainTableView.dataSource = self
        storeMainTableView.delegate = self
        loadData()
    }
    
    func loadData(){
        if let emailSender = Auth.auth().currentUser?.email{
            self.products = []
            db.collection(K.tableName.storeDetailTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error load data store data: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        let data = snapShotDocuments[0].data()
                        if let storeName = data[K.storeDetail.storeName] as? String, let moneyTotal = data[K.storeDetail.moneyTotal] as? Double{
                            self.storeNameLabel.text = storeName
                            self.moneyTotalLabel.text = String(format: "%.2f", moneyTotal)
                        }
                        print("Successfully loaded store Detail")
                    }
                }
            }
            
            db.collection(K.productCollection.productCollection).whereField(K.sender, isEqualTo:  emailSender).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("Error while loading product data: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        for doc in snapShotDocuments{
                            let data = doc.data()
                            let docID = doc.documentID
                            if let productName = data[K.productCollection.productName] as? String,let productDetail = data[K.productCollection.productDetail] as? String
                                ,let productCategory = data[K.productCollection.productCategory] as? String,let productPrice = data[K.productCollection.productPrice] as?  String,let productQuantity = data[K.productCollection.productQuantity] as? String,let ImageURL = data[K.productCollection.productImageURL] as? String,
                                let senderFrom = data[K.productCollection.sender] as? String
                                , let storeName = data[K.productCollection.storeName] as? String
                            {
                                self.products.append(Product(productName: productName, productDetail: productDetail, productCategory: productCategory, productPrice: productPrice, productQuantity: productQuantity, productImageURL: ImageURL, documentId: docID, sender:senderFrom, storeName: storeName))
                                DispatchQueue.main.async {
                                    self.storeMainTableView.reloadData()
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func showStoreDetailPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.mainStoreToStoreDetailSegue, sender: self)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        if searchProductTextField.text != ""{
            self.products = []
            if let emailSender = Auth.auth().currentUser?.email{
                db.collection(K.productCollection.productCollection).whereField(K.sender, isEqualTo: emailSender) .getDocuments { (querySnapshot, error) in
                    if let e = error{
                        print("\(e.localizedDescription)")
                    }else{
                        if let snapShotDocuments = querySnapshot?.documents{
                            for doc in snapShotDocuments{
                                let data = doc.data()
                                let docID = doc.documentID
                                if let product = data[K.productCollection.productName] as? String{
                                    let range = NSRange(location: 0, length: product.utf16.count)
                                    do{     let lowerCaseProduct = product.lowercased()
                                        let lowerCaseSearchText = self.searchProductTextField.text!.lowercased()
                                        let regex = try! NSRegularExpression(pattern: lowerCaseSearchText, options: [])
                                        if regex.firstMatch(in: lowerCaseProduct, options: [], range: range) != nil{
                                            print("\(product) Found")
                                            if let productName = data[K.productCollection.productName] as? String,let productDetail = data[K.productCollection.productDetail] as? String
                                                ,let productCategory = data[K.productCollection.productCategory] as? String,let productPrice = data[K.productCollection.productPrice] as?  String,let productQuantity = data[K.productCollection.productQuantity] as? String,let ImageURL = data[K.productCollection.productImageURL] as? String{
                                                self.products.append(Product(productName: productName, productDetail: productDetail, productCategory: productCategory, productPrice: productPrice, productQuantity: productQuantity, productImageURL: ImageURL, documentId: docID,sender: emailSender,storeName: self.storeNameLabel.text!))
                                                
                                                DispatchQueue.main.async {
                                                    self.storeMainTableView.reloadData()
                                                    self.searchProductTextField.text = ""
                                                }
                                            }
                                        }else{
                                            print("\(product) not found")
                                        }
                                    }catch{
                                        print("error while regex")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else{  print("Empty search field")
            searchProductTextField.placeholder = "Type product name"
            loadData()
        }
        
    }
    
    @IBAction func addProductPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.segue.mainStoreToAddProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.storeMainToProductDetailSegue{
            let destinationVC = segue.destination as! ProductDetailController
            destinationVC.productDocumentID = documentIDSelected
            destinationVC.storeName = storeNameLabel.text
        }
    }
}

extension StoreMainController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        let productCell = storeMainTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierProductInStoreMain) as! ProductCell
        productCell.productNameLabel.text = product.productName
        productCell.productPriceLabel.text = product.productPrice
        
        return productCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        documentIDSelected = products[indexPath.row].documentId
        self.performSegue(withIdentifier: K.segue.storeMainToProductDetailSegue, sender: self)
    }
    
}

class ProductCell: UITableViewCell{
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    
}

class ProductDetailController: UIViewController{
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRemainingLabel: UILabel!
    @IBOutlet weak var productCategorylabel: UILabel!
    @IBOutlet weak var productDetailLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var promotionTableView: UITableView!
    var storeName: String!
    var productDocumentID: String!
    var promotions: [Promotion] = []
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        storeNameLabel.text = storeName
        promotionTableView.dataSource = self
        loadAllProductDetail()
    }
    
    func loadAllProductDetail(){
        if let emailSender = Auth.auth().currentUser?.email{
            self.promotions = []
            db.collection(K.productCollection.productCollection).document(productDocumentID).getDocument { (documentSnapshot, error) in
                if let e = error{
                    print("Error while loading product data with docID: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = documentSnapshot{
                        if let data = snapShotDocuments.data(){
                            if let productName = data[K.productCollection.productName] as? String, let productPrice = data[K.productCollection.productPrice] as? String, let productQuantity = data[K.productCollection.productQuantity] as? String, let productCategory = data[K.productCollection.productCategory] as? String,let productDetail = data[K.productCollection.productDetail] as? String{
                                self.productNameLabel.text = productName
                                self.productPriceLabel.text = productPrice
                                self.productRemainingLabel.text = productQuantity
                                self.productCategorylabel.text = productCategory
                                self.productDetailLabel.text = productDetail
                                print(self.productNameLabel.text!)              // got productName
                                // search for promotion in that productName (hasPromotion)
                                self.db.collection(K.tableName.hasPromotionTableName).whereField(K.sender, isEqualTo: emailSender).whereField(K.productCollection.productDocID  , isEqualTo: self.productDocumentID!).getDocuments { (querySnapshot, error) in
                                    if let e = error{
                                        print("error while checking promotions in product: \(e.localizedDescription)")
                                    }else{
                                        if let snapShotDocuments = querySnapshot?.documents{
                                            for doc in snapShotDocuments{
                                                let data = doc.data()
                                                if let promotion = data[K.promotion.promotionName] as? String{
                                                    print(promotion) // got promotionName
                                                    // search specific promotion data
                                                    self.db.collection(K.tableName.promotionTableName).whereField(K.sender, isEqualTo: emailSender).whereField(K.promotion.promotionName, isEqualTo: promotion).getDocuments { (querySnapshot, error) in
                                                        if let e = error{
                                                            print("Error while looping in promotionName: \(e.localizedDescription) ")
                                                        }else{
                                                            if let snapShotDocuments = querySnapshot?.documents{
                                                                for doc in snapShotDocuments{
                                                                    let data = doc.data()
                                                                    let docID = doc.documentID
                                                                    if let promotionName = data[K.promotion.promotionName] as? String, let promotionDetail = data[K.promotion.promotionDetail] as? String,
                                                                        let discountPercent = data[K.promotion.discountPercent] as? Int, let minimumPrice = data[K.promotion.minimumPrice] as? String,
                                                                        let validDate = data[K.promotion.validDate] as? String{
                                                                        self.promotions.append(Promotion(promotionName: promotionName, promotionDetail: promotionDetail, minimumPrice: minimumPrice, discountPercent: discountPercent, validDate: validDate, docID: docID))
                                                                        print(self.promotions)
                                                                        DispatchQueue.main.async {
                                                                            self.promotionTableView.reloadData()
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }else {print("rip")}
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func editProductPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.productDetailToEditProductSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.productDetailToEditProductSegue{
            let destinationVC = segue.destination as! EditProductController
            destinationVC.productDocumentID = productDocumentID
            destinationVC.promotions = promotions
            destinationVC.productName = self.productNameLabel.text
        }
    }
}

extension ProductDetailController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let promotion = promotions[indexPath.row]
        let promotionCell = promotionTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierPromotionInProductDetailCell) as! promotionInProductDetailCell
        promotionCell.promotionNameLabel.text = promotion.promotionName
        promotionCell.promotionDetailLabel.text = promotion.promotionDetail
        promotionCell.discountLabel.text = String(promotion.discountPercent)
        promotionCell.minimumPriceLabel.text = promotion.minimumPrice
        promotionCell.validDateLabel.text = promotion.validDate
        
        return promotionCell
    }
    
    
}

class promotionInProductDetailCell:UITableViewCell{
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionDetailLabel: UILabel!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var validDateLabel: UILabel!
    
}
class EditProductController: UIViewController{
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productCategoryTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productQuantityTextField: UITextField!
    @IBOutlet weak var productDetailTextField: UITextField!
    
    @IBOutlet weak var promotionInEditProductTableView: UITableView!
    var promotions: [Promotion]!
    var productName: String!
    var updatedProductName: String!
    var productDocumentID: String!
    var promotionName: [String] = []
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promotionInEditProductTableView.dataSource = self
        promotionInEditProductTableView.delegate = self
        loadPromotionData()
    }
    
    func loadPromotionData(){
        DispatchQueue.main.async {
            self.promotionInEditProductTableView.reloadData()
        }
    }
    
    func updateNotNil() -> Bool{
        if productNameTextField.text != ""{
            if productCategoryTextField.text != ""{
                if productPriceTextField.text != ""{
                    if productQuantityTextField.text != ""{
                        if productDetailTextField.text != ""{
                            return true
                        }else { return false }
                    }else { return false }
                }else { return false }
            }else { return false }
        }else { return false }
    }
    
    @IBAction func submitPressed(_ sender: UIButton){
        if updateNotNil(){
            if let emailSender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.hasPromotionTableName).whereField(K.sender, isEqualTo: emailSender).whereField(K.productCollection.productDocID, isEqualTo: productDocumentID!).getDocuments { (querySnapshot, error) in
                    if let e = error{
                        print("error while updating hasPromotion data: \(e.localizedDescription)")
                    }else{
                        if let snapShotDocuments = querySnapshot?.documents{
                            for doc in snapShotDocuments{
                                let docID = doc.documentID
                                self.db.collection(K.tableName.hasPromotionTableName).document(docID).delete()
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1){
                            self.db.collection(K.productCollection.productCollection).document(self.productDocumentID).updateData([
                                K.productCollection.productName: self.productNameTextField.text!,
                                K.productCollection.productDetail: self.productDetailTextField.text!,
                                K.productCollection.productPrice: self.productPriceTextField.text!,
                                K.productCollection.productQuantity: self.productQuantityTextField.text!,
                                K.productCollection.productCategory: self.productCategoryTextField.text!
                            ])
                            self.updatedProductName = self.productNameTextField.text!
                            for selectedPromotion in self.promotionName{
                                self.db.collection(K.tableName.hasPromotionTableName).addDocument(data: [
                                    K.productCollection.productDocID: self.productDocumentID!,
                                    K.promotion.promotionName: selectedPromotion,
                                    K.sender: emailSender
                                ])
                            }
                        }
                        
                    }
                }
                
            }
            print("Updated product successfully")
            self.dismiss(animated: true, completion: nil)
        }else{
            print("Some text fields is empty or promotion has not selected")
        }
    }
    
}

extension EditProductController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let promotion = promotions[indexPath.row]
        let promotionCell = promotionInEditProductTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.identifierpromotionInEditProduct) as! promotionCell
        promotionCell.promotionNameLabel.text = promotion.promotionName
        promotionCell.promotionDetailLabel.text = promotion.promotionDetail
        promotionCell.discountLabel.text = String(promotion.discountPercent)
        promotionCell.minimumPriceLabel.text = promotion.minimumPrice
        promotionCell.validDateLabel.text = promotion.validDate
        
        return promotionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.promotionName.append(promotions[indexPath.row].promotionName)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = promotionName.firstIndex(of: promotions[indexPath.row].promotionName){
            promotionName.remove(at: index)
        }
    }
}

class promotionCell:UITableViewCell{
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionDetailLabel: UILabel!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var validDateLabel: UILabel!
}
