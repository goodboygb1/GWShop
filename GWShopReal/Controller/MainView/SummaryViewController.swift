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
    
    var addressSelectedByUser : Address?
    var address : [Address] = []
    var addressDefult : Address? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAddress()
        
    }
    
    @IBAction func selectAddressButton(_ sender: Any) {
        performSegue(withIdentifier: K.segue.summaryToSelectedAddress, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.summaryToSelectedAddress {
            let destinationVC = segue.destination as! SelectedAddressViewController
            destinationVC.delegate = self
            destinationVC.addressForSelect = address
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
                                        print("check defult berfor reload table")
                                        self.addressDefultCheck()
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
    }
    
    func addressDefultCheck() {
        
        for (index,addressDefultCheck) in address.enumerated() {
            if addressDefultCheck.isDefultAddress == true {
                addressDefult = addressDefultCheck
                print("Address default is \(addressDefultCheck.firstName)")
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

//MARK: - extension for tableView

extension SummaryViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let addressForCell = addressDefult
        let cell = summaryTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.summaryProductViewCell) as! SummaryProductViewCell
        
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
        
    }
    
}

//MARK: - extension for send back data

extension SummaryViewController : changeAddressDelegate {
    func changeAddress(From: Address) {
        addressDefult = From
        summaryTableView.reloadData()
    }
    
    
}
