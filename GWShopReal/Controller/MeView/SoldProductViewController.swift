//
//  SoldProductViewController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 5/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class SoldProductViewController: UIViewController {
    @IBOutlet weak var soldProductTableView: UITableView!
    var currentTime: String!
    var currentTimeArray: [String]!
    var db = Firestore.firestore()
    var soldProducts: [TopFiveProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTime = getCurrentDateTime()
        currentTimeArray = currentTime.components(separatedBy: " ")
        currentTimeArray[2] = String(Int(currentTimeArray[2])! + 543)
        soldProductTableView.dataSource = self
        soldProductTableView.delegate = self
        loadSoldProductData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.sortSoldProduct()
            self.soldProductTableView.reloadData()
        }
    }
    
    func loadSoldProductData(){
        if let emailSender = Auth.auth().currentUser?.email{
            db.collection(K.tableName.storeDetailTableName).whereField(K.sender, isEqualTo:  emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    if let snapShotDoc = querySnapshot?.documents{
                        let data = snapShotDoc[0].data()
                        if let storeName = data[K.storeDetail.storeName] as? String{ // got storeName
                            self.db.collection(K.tableName.orderCollection).whereField(K.order.vendorName, isEqualTo: storeName).getDocuments { (queryData, error) in
                                if let e = error{
                                    print(e.localizedDescription)
                                }else{
                                    if let snapShots = queryData?.documents{
                                        for doc in snapShots{
                                            let data = doc.data()
                                            if let orderID = data[K.order.orderID] as? String,let orderDate = data[K.order.dateOfPurchase] as? String{
                                                let orderDateArray = orderDate.components(separatedBy: " ")
                                                if self.currentTimeArray[1] == orderDateArray[1] && self.currentTimeArray[2] == orderDateArray[3]{
                                                    
                                                    self.db.collection(K.orderDetailCollection.orderDetailCollection).whereField(K.orderDetailCollection.orderID, isEqualTo: orderID).getDocuments { (query, error) in
                                                        if let e = error{
                                                            print(e.localizedDescription)
                                                        }else{
                                                            if let snapDocument = query?.documents{
                                                                for doc in snapDocument{
                                                                    let data = doc.data()
                                                                    if let productID = data[K.orderDetailCollection.productID] as? String,let quantity = data[K.orderDetailCollection.quantity] as? Int{
                                                                        self.db.collection(K.productCollection.productCollection).document(productID).getDocument { (documentSnapshot, error) in
                                                                        if let e = error{
                                                                            print(e.localizedDescription)
                                                                        }else{
                                                                            print("got doc porductID")
                                                                            if let data = documentSnapshot?.data(){
                                                                                if let productName = data[K.productCollection.productName] as? String{
                                                                                    if self.soldProducts.count == 0{
                                                                                        self.soldProducts.append(TopFiveProduct(productID: productID, productName: productName, storeName: storeName, sold: quantity))
                                                                                    }else{
                                                                                        var found = false
                                                                                        for index in 0..<self.soldProducts.count{
                                                                                            if self.soldProducts[index].productID == productID{
                                                                                                found = true
                                                                                                self.soldProducts[index].AddSold(number: quantity)
                                                                                                break
                                                                                            }
                                                                                        }
                                                                                            if found == false{
                                                                                                self.soldProducts.append(TopFiveProduct(productID: productID, productName: productName, storeName: storeName, sold: quantity))
                                                                                            }
                                                                                            
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCurrentDateTime() -> String {
        
        let currentDateTime = Date()            // get current time
        
        let formatter = DateFormatter()         // set format and style
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        formatter.dateFormat = "d MMMM yyyy"
        let dateAndTimeString = formatter.string(from: currentDateTime)
        // get date from object
        return dateAndTimeString
    }
    func sortSoldProduct(){
        soldProducts.sort(by: {$0.sold > $1.sold})
    }
}

extension SoldProductViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soldProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let soldProduct = soldProducts[indexPath.row]
        let productCell = self.soldProductTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.SoldProductIdentifier) as! soldProductCell
        productCell.productIDLabel.text = soldProduct.productID
        productCell.productNameLabel.text = soldProduct.productName
        productCell.storeNameLabel.text = soldProduct.storeName
        productCell.numberSoldLabel.text = String(soldProduct.sold)
        
        return productCell
    }
    
    
}

class soldProductCell:UITableViewCell{
    @IBOutlet weak var productIDLabel :UILabel!
    @IBOutlet weak var productNameLabel :UILabel!
    @IBOutlet weak var storeNameLabel :UILabel!
    @IBOutlet weak var numberSoldLabel :UILabel!
    
}
