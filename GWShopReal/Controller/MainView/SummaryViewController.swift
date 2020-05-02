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

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var summaryTableView: UITableView!
    
    var address : [Address] = []
    var addressDefult : Address? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        
        loadAddress()
    }
    
    func loadAddress()  {
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
                                    if index == documentSnapshot.count {
                                        self.addressDefultCheck()
                                    }
                                    DispatchQueue.main.async {
                                        self.summaryTableView.reloadData()
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                    }
            }
        }
    }
    
    func addressDefultCheck() {
        
        for (index,addressDefultCheck) in address.enumerated() {
            if addressDefultCheck.isDefultAddress == true {
                addressDefult = addressDefultCheck
            } else {
                print("Address is not defult")
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

extension SummaryViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let addressForCell = addressDefult
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.summaryProductViewCell) as! SummaryProductViewCell
        
        cell.recieverNameLable.text = "\(addressForCell?.firstName) \(addressForCell?.lastName)"
        cell.revieverPhoneNumberLable.text = addressForCell?.phoneNumber
        cell.addressLable.text = "\(addressForCell?.addressDetail) \(addressForCell?.district) \(addressForCell?.province) \(addressForCell?.postCode)"
        return cell
        
        
    }
    
    
}
