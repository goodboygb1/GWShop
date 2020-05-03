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
    
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var creditCardTableView: UITableView!
    
    @IBAction func selectCreditCardBUtton(_ sender: UIButton) {
        performSegue(withIdentifier: K.segue.summaryToSelectCreditCard, sender: self)
    }
    
    
    var addressSelectedByUser : Address?
    var address : [Address] = []
    var addressDefult : Address? = nil
    var totalPrize : [Double] = []
    var cart : [Cart] = []
    var creditCard : [Card] = []
    var creditCardDefault : Card? = nil
    
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
        
    }
    
    
    @IBOutlet weak var creditCardButton: BEMCheckBox!
    @IBOutlet weak var payAtHomeButton: BEMCheckBox!
    
    @IBAction func payAtHomePress(_ sender: BEMCheckBox) {
         
         //ถ้ากดจ่ายที่บ้านให้ซ่อน credit card tableview
         // uncheck creditcard
        
        creditCardButton.on = false
        creditCardTableView.isHidden = true
    
    }
    
    @IBAction func creditCardPressed(_ sender: BEMCheckBox) {
        //ถ้ากดจ่ายผ่านบัตรใช้โชว์บัตรและโหลดข้อมูลมา
        // vuncheck pay at home
        
        payAtHomeButton.on = false
        creditCardTableView.isHidden = false
        creditCardTableView.reloadData()
    }
    
    @IBAction func selectAddressButton(_ sender: Any) {
        performSegue(withIdentifier: K.segue.summaryToSelectedAddress, sender: self)
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
            let TotalForEachForCell = totalPrize[indexPath.row]
            let cell = productTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.productInSummary) as! ProductTableViewCell
            
            cell.productName.text = productForCell.productName
            cell.priceForEach.text = ("\(productForCell.productPrice) ฿")
            cell.quantity.text = String(productForCell.numberProduct)
            cell.totalPriceForEach.text = String(TotalForEachForCell)
            
            return cell
            
    
            
        } else {
                       let creditCardForCell = creditCardDefault
                       let cell = creditCardTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.creditCardinSummary) as! CreditCardTableViewCell
                
                
                if let cardNameForCell = creditCardForCell?.cardName,
                    let cardNumberForCell = creditCardForCell?.cardNumber {
                    cell.cardHolderName.text = cardNameForCell
                    cell.creditCardNumber.text = cardNumberForCell
                
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
