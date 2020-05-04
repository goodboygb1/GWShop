//
//  SummaryViewController.swift
//  GWShopReal
//
//  Created by PMJs on 2/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import BEMCheckBox

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var creditCardTableView: UITableView!
    
    
    @IBAction func selectCreditCardBUtton(_ sender: UIButton) {
        performSegue(withIdentifier: K.segue.summaryToSelectCreditCard, sender: self)
    }
    
    
    var addressSelectedByUser : Address?
    var address : [Address] = []
    var addressDefult : Address? = nil
    var totalPrize : [String: Double] = [:]
    var cart : [Cart] = []
    var creditCard : [Card] = []
    var creditCardDefault : Card? = nil
    var totalMoney : Double = 0
    var paymentMethod : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.delegate = self
        addressTableView.dataSource = self
        productTableView.dataSource = self
        productTableView.delegate = self
        creditCardTableView.delegate = self
        creditCardTableView.dataSource = self
        
        loadAddress()
        loadCardData()
        creditCardButton.on = true
        print(totalPrize, cart)
        totalMoney = totalPrize.values.reduce(0, +) + 50
        totalMoenyLabel.text = "฿\(totalMoney) "
        
        activityIndicator.hidesWhenStopped = true
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    @IBOutlet weak var totalMoenyLabel: UILabel!
    @IBOutlet weak var creditCardButton: BEMCheckBox!
    @IBOutlet weak var payAtHomeButton: BEMCheckBox!
    
    @IBAction func payAtHomePress(_ sender: BEMCheckBox) {
        
        //ถ้ากดจ่ายที่บ้านให้ซ่อน credit card tableview
        // uncheck creditcard
        
        creditCardButton.on = false
        creditCardTableView.isHidden = true
        paymentMethod = "COD"
        
    }
    
    @IBAction func creditCardPressed(_ sender: BEMCheckBox) {
        //ถ้ากดจ่ายผ่านบัตรใช้โชว์บัตรและโหลดข้อมูลมา
        // vuncheck pay at home
        
        payAtHomeButton.on = false
        creditCardTableView.isHidden = false
        creditCardTableView.reloadData()
        paymentMethod = "Credit Card"
    }
    
    
    @IBAction func selectAddress(_ sender: UIButton) {
        performSegue(withIdentifier: K.segue.summaryToSelectedAddress, sender: self)
        
    }
    
    
    
    @IBAction func sendOrderPress(_ sender: UIButton) {
        
        findNumberOfVendor()
        if orderSepByVendor.count != 0 {
            sendDataToFirebase()
            activityIndicator.startAnimating()
            
            
            
            
            
            
        } else {
            print("order is empty")
            presentAlert(title: "Empty Cart", message: "Please add something to cart", actiontitle: "Dismiss")
        }
        
        
        
    }
    
    func sendDataToFirebase()  {
        let db = Firestore.firestore()
        let orderCollection = db.collection(K.tableName.orderCollection)
        let paymentID = (Auth.auth().currentUser?.email)!+String(Date().timeIntervalSince1970)
        // paymentID
        
        for orderUpload in orderSepByVendor {
            // upload orderCollection
            orderCollection.addDocument(data: [ K.order.orderID : orderUpload.orderID ,
                                                K.order.vendorName : orderUpload.productInOrder[0].storeName,
                                                K.order.userName : Auth.auth().currentUser?.email,
                                                K.order.paymentID : paymentID,
                                                K.order.phoneNumber : addressDefult?.phoneNumber,
                                                K.order.addressID : addressDefult?.docID,
            ]) { (error) in
                
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    // upload order detail collection
                    
                    let orderDetailCollection = db.collection(K.orderDetailCollection.orderDetailCollection)
                    var totalPrizeEachProductIndex = 0
                    for productInOrder in orderUpload.productInOrder {
                        
                        orderDetailCollection.addDocument(data: [ K.orderDetailCollection.orderID : orderUpload.orderID,
                        K.orderDetailCollection.productID : productInOrder.productDocumentID,
                        K.orderDetailCollection.quantity : productInOrder.numberProduct,
                        K.orderDetailCollection.priceInProduct: self.totalPrize[productInOrder.productDocumentID]!
                        ]) { (error) in
                            totalPrizeEachProductIndex = totalPrizeEachProductIndex + 1
                            self.activityIndicator.stopAnimating() 
                            let alert = UIAlertController(title: "Success", message: "Order success, Wating for amazing time" , preferredStyle:.alert)
                            let action = UIAlertAction(title: "Dismiss", style: .default) { (UIAlertAction) in
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            alert.addAction(action)
                            self.present(alert,animated: true,completion: nil)
                            }
                        
                        let productDetailCollection = db.collection(K.productCollection.productCollection)
                        productDetailCollection.document(productInOrder.productDocumentID).getDocument { (documentSnapshot, error) in
                            if let e = error{
                                print("Error while updating quantity data: \(e.localizedDescription)")
                            }else{
                                if let data = documentSnapshot?.data(){
                                    if let quantity = data[K.productCollection.productQuantity] as? String{
                                        let intQuantity = Int(quantity)
                                        productDetailCollection.document(productInOrder.productDocumentID).updateData([
                                            K.productCollection.productQuantity: String( intQuantity! - productInOrder.numberProduct)
                                        ])
                                    }
                                }
                                
                            }
                        }
                    
                    }
                }
            }
            
            
            
            
            
        }
        // for upload payment collection
        let paymentCollection = db.collection(K.paymentCollection.paymentCollection)
        paymentCollection.addDocument(data: [ K.paymentCollection.paymentID : paymentID,
                                              K.paymentCollection.paymentMethod : paymentMethod,
                                              K.paymentCollection.cardNumber : creditCardDefault?.cardNumber ?? "",
                                              K.paymentCollection.dateOfPurchase : getCurrentDateTime(),
                                              K.paymentCollection.totalPrice : totalMoney
        ])
        
        
    }
    
    var orderSepByVendor : [order] = []          // order array
    
    func findNumberOfVendor()  {                        // หาว่าใน cart นั้นมีแม่ค้ากี่คน
        
        for productForCheck in cart {                   // เอาตัวนึงยึดหาอีกตัวนึง
            
            var productSepByVender : [Cart] = []        // product in order array
            
            for productForAppend in cart {
                // ตัวไหนแม่ค้าเดียวกันให้เอาใส่ array
                
                if productForCheck.storeName == productForAppend.storeName {
                    productSepByVender.append(productForAppend)
                }
            }
            // vendor is not exist before
            if !(isVenderExistAlready(For: productForCheck.storeName)) {
                
                let orderIDFor = randomString(length: 10) + String(Date().timeIntervalSince1970)
                
                let newOrder = order(orderID: orderIDFor, productInOrder: productSepByVender)
                
                orderSepByVendor.append(newOrder)
            }
        }
    }
    
   
    
    func isVenderExistAlready(For vendorName : String) -> Bool {
        
        // check wether vender already exist or not?
        if orderSepByVendor.count != 0 {
            for order in orderSepByVendor {
                
                if order.productInOrder[0].storeName == vendorName {
                    return true
                } else {
                    return false
                }
                
            }
        }
        return false
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.summaryToSelectedAddress {
            
            let destinationVC = segue.destination as! SelectedAddressViewController
            destinationVC.delegate = self
            destinationVC.addressForSelect = address
            
        } else if segue.identifier == K.segue.summaryToSelectCreditCard {
            
            let destinationVC = segue.destination as! SelectCreditCardViewController
            destinationVC.delegate = self
            destinationVC.creditCard = creditCard
        }
    }
    
    
    
    func loadAddress()  {
        
        address = []
        let db = Firestore.firestore()
        let addressCollection = db.collection(K.tableName.addressTableName)
        
        if let email = Auth.auth().currentUser?.email{
            addressCollection
                .whereField(K.sender, isEqualTo: email )
                .getDocuments { (querySnapShot, error) in
                    
                    if error != nil {
                        self.presentAlert(title: "Error", message: "While Loading Address", actiontitle: "Dismiss")
                    } else {
                        
                        if let documentSnapshot = querySnapShot?.documents {
                            
                            for (index,doc) in documentSnapshot.enumerated() {
                                
                                let docID = doc.documentID
                                let data = doc.data()
                                
                                if   let firstName = data[K.firstName] as? String
                                    ,let surname = data[K.surname] as? String
                                    ,let phoneNumber = data[K.phoneNumber] as? String
                                    ,let defaultAddress = data[K.defaultAddress] as? Bool
                                    ,let distrinc = data[K.district] as? String
                                    ,let postCode = data[K.postCode] as? String
                                    ,let addressDetail = data[K.addressDetail] as? String
                                    ,let province = data[K.province] as? String {
                                    
                                    let newAddress = Address(firstName: firstName, lastName: surname, phoneNumber: phoneNumber, addressDetail: addressDetail, district: distrinc, province: province, postCode: postCode, docID: docID, isDefultAddress: defaultAddress)
                                    
                                    self.address.append(newAddress)
                                    
                                    if index == (documentSnapshot.count-1){
                                        self.addressDefultCheck()
                                        DispatchQueue.main.async {
                                            self.addressTableView.reloadData()
                                        }
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                    }
            }
        }
    }
    
    func loadCardData() {
        
        creditCard = []
        if let emailSender = Auth.auth().currentUser?.email{
            let db = Firestore.firestore()
            db.collection(K.tableName.cardDetailTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error in show card page: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        
                        if snapShotDocuments.count != 0 {
                            print("card is not empty")
                        } else {
                            print("card is empty")
                        }
                        
                        for (index,doc) in snapShotDocuments.enumerated() {
                            
                            let data = doc.data()
                            let docID = doc.documentID
                            if let cardName = data[K.cardDetail.cardName] as? String
                                , let cardNumber = data[K.cardDetail.cardNumber] as? String
                                , let expiredDate = data[K.cardDetail.expiredDate] as? String
                                ,let cvv = data[K.cardDetail.cvvNumber] as? String
                                ,let isDefultCard = data[K.cardDetail.isDefultCard] as? Bool
                            {
                                self.creditCard.append(Card(cardNumber: cardNumber, cardName: cardName, expiredDate: expiredDate, cvv: cvv, docID: docID, isDefultCard: isDefultCard))
                                
                                print("index = \(index)")
                                
                                if index == (snapShotDocuments.count-1) {
                                    self.cardDefaultCheck()
                                    DispatchQueue.main.async {
                                        self.creditCardTableView.reloadData()
                                    }
                                }
                                
                                
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func addressDefultCheck() {     // for check which address is default
        
        for (_,addressDefultCheck) in address.enumerated() {
            if addressDefultCheck.isDefultAddress == true {
                addressDefult = addressDefultCheck
                
            } else {
                print("Address is not defult")
            }
        }
    }
    
    func cardDefaultCheck()  {
        for (_,creditCardDefultCheck) in creditCard.enumerated() {
            if creditCardDefultCheck.isDefultCard == true {
                creditCardDefault = creditCardDefultCheck
                
            } else {
                print("card is not defult")
            }
        }
    }
    
    
    func presentAlert(title:String,message:String,actiontitle:String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actiontitle, style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
           let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
           return String((0..<length).map{ _ in letters.randomElement()! })
       }
    
    
    func getCurrentDateTime() -> String {
       
        let currentDateTime = Date()            // get current time
            
        let formatter = DateFormatter()         // set format and style
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let dateAndTimeString = formatter.string(from: currentDateTime)
                                                // get date from object
        return dateAndTimeString
    }
}

func showOnly4LastDigit(cardNumber : String) -> String {
    
    var card4LastDigit : String = ""
    
    for (index,cardDigit) in cardNumber.enumerated() {
        
        if index+1 <= cardNumber.count-4 {
            card4LastDigit.append("X")
        } else {
            card4LastDigit.append("\(cardDigit)")
        }
    }
    print(card4LastDigit)
    return card4LastDigit
}






//MARK: - extension for tableView

extension SummaryViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addressTableView {
            return 1
        } else if tableView == productTableView {
            return cart.count
        } else {
            
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == addressTableView {
            print("reload addres table")
            
            let addressForCell = addressDefult
            let cell = addressTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.summaryProductViewCell) as! SummaryAddressViewCell
            
            if let firstNameCell = addressForCell?.firstName
                ,let lastNameCell = addressForCell?.lastName
                ,let phoneNumberCell = addressForCell?.phoneNumber
                ,let detailCell = addressForCell?.addressDetail
                ,let districtCell = addressForCell?.district
                ,let provinceCell = addressForCell?.province
                ,let postCodeCell = addressForCell?.postCode
            {
                cell.recieverNameLable.text = "\(firstNameCell) \(lastNameCell)"
                cell.revieverPhoneNumberLable.text = phoneNumberCell
                cell.addressLable.text = "\(detailCell) \(provinceCell)"
                cell.districtAndPostCodeLabel.text = "\(districtCell) \(postCodeCell)"
            }
            
            return cell
            
        } else
            if tableView == productTableView
            {
                
                print("reload product table")
                let productForCell = cart[indexPath.row]
                //let TotalForEachForCell = totalPrize.values[indexPath.row]
                let TotalForEachForCell = totalPrize[cart[indexPath.row].productDocumentID]
                let cell = productTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.productInSummary) as! ProductTableViewCell
                
                cell.productName.text = productForCell.productName
                cell.priceForEach.text = ("\(productForCell.productPrice) ฿")
                cell.quantity.text = String(productForCell.numberProduct)
                cell.totalPriceForEach.text = String(TotalForEachForCell!)
                
                return cell
                
                
                
            } else {
                let creditCardForCell = creditCardDefault
                let cell = creditCardTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.creditCardinSummary) as! CreditCardTableViewCell
                
                
                if let cardNameForCell = creditCardForCell?.cardName,
                    let cardNumberForCell = creditCardForCell?.cardNumber {
                    cell.cardHolderName.text = cardNameForCell
                    cell.creditCardNumber.text = showOnly4LastDigit(cardNumber: cardNumberForCell)
                    
                }
                
                
                return cell
        }
        
    }
    
}

//MARK: - extension for send back data

extension SummaryViewController : changeAddressDelegate,changeCreditCardDelegate {
    func changeCreditCard(From: Card) {
        creditCardDefault = From
        creditCardTableView.reloadData()
    }
    
    func changeAddress(From: Address) {
        addressDefult = From
        addressTableView.reloadData()
    }
   
    
    
    
}
