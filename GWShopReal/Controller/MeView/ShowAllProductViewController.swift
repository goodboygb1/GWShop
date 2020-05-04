//
//  ShowAllProductViewController.swift
//  GWShopReal
//
//  Created by PMJs on 5/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class ShowAllProductViewController: UIViewController {
    
    
    var dateSplitArray : [String] = []
    var dataForCheck : [ShowAllProductSellInOneDay] = []
    var dataForPutIncell : [ShowAllProductSellInOneDay] = []
    
    
    @IBOutlet weak var showAllSaleTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllSaleTableView.delegate = self
        showAllSaleTableView.dataSource = self
        loadData()
    }
    
    func loadData() {
        
      
        
        let db = Firestore.firestore()
        let vendorCollection = db.collection(K.tableName.storeDetailTableName)
        
        if let email = Auth.auth().currentUser?.email {     // query for find vendor name from email
            vendorCollection.whereField(K.sender, isEqualTo: email).getDocuments { (querySnapShot, error) in
                if let e = error {
                    print("error form query vendorName \(e.localizedDescription)")
                } else {
                    if let snapShotDocument = querySnapShot?.documents {
                        print("vendor count = \(snapShotDocument.count)")
                        for doc in snapShotDocument {
                            let data = doc.data()
                            if let vendorName = data[K.storeDetail.storeName]
                            {
                                print("vender name from query = \(vendorName)")
                                
                                let orderCollection = db.collection(K.tableName.orderCollection)
                                orderCollection
                                    .whereField(K.sender, isEqualTo: email).getDocuments { (snapShotQuery2, error) in
                                        if let e = error {
                                            print("error can't find order")
                                        } else {
                                            if let snapshotDocument2 = snapShotQuery2?.documents {
                                                for doc2 in snapshotDocument2 {
                                                    let data = doc2.data()
                                                    if let day = data[K.order.dateOfPurchase] as? String
                                                        ,let total = data[K.order.total] as? Double {
                                                        let newShowAllProduct = ShowAllProductSellInOneDay(day: day, totalPrice: total)
                                                        self.dataForCheck.append(newShowAllProduct)
                                                    }
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                
                // function here
                self.findOrderThatSameAsTheDayThatUserWant()
                
            }
        }
        
    }
    
    func findOrderThatSameAsTheDayThatUserWant()  {
                                                                    // find order same as the day user choose
        for data in dataForCheck {
            if data.day.contains(dateSplitArray[0]) {
                if data.day.contains(dateSplitArray[1]) {
                    if data.day.contains(dateSplitArray[2]) {
                        print(data.day)
                        print(data.totalPrice)
                        dataForPutIncell.append(data)
                    }
                }
            }
        }
    }
}

extension ShowAllProductViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForCheck.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataForCell = dataForCheck[indexPath.row]
        let cell = showAllSaleTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.ShowAllProductSellInOneDay) as! ShowAllProductSellInOneDayTableViewCell
        
        cell.day.text = dataForCell.day
        cell.saleLabel.text = String(dataForCell.totalPrice)
        
        return cell
    }
    
    
}
