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
    
    
    @IBOutlet weak var dayForShowLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var dateSplitArray : [String] = []                                // รับมาจาก date picker
    var dataForCheck : [ShowAllProductSellInOneDay] = []              // raw data ไม่ได้แยกวัน
    var dataForPutIncell : [ShowAllProductSellInOneDay] = []             // data แบบแยกวัน
    var totalInOneDay : Double = 0.0                                  // for show total in one day
    var dateBelow : String = ""                                       // วันแบบตัดเวลา
    
    
    @IBOutlet weak var showAllSaleTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllSaleTableView.delegate = self
        showAllSaleTableView.dataSource = self
        loadData()
    }
    
    func loadData() {                                   // query from firebase
        
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
                                                                                
                                                                                // query for find order
                                let orderCollection = db.collection(K.tableName.orderCollection)
                                orderCollection
                                    .whereField(K.order.vendorName, isEqualTo: vendorName).getDocuments { (snapShotQuery2, error) in
                                        if let e = error {
                                            print("error can't find order")
                                        } else {
                                           
                                            if let snapshotDocument2 = snapShotQuery2?.documents {
                                                print("order number = \(snapshotDocument2.count)")
                                                
                                                for (index,doc2) in snapshotDocument2.enumerated() {
                                                    let data = doc2.data()
                                                    if let day = data[K.order.dateOfPurchase] as? String
                                                        ,let total = data[K.order.total] as? Double {
                                                        let newShowAllProduct = ShowAllProductSellInOneDay(day: day, totalPrice: total)
                                                        self.dataForCheck.append(newShowAllProduct)
                                                        
                                                        // last index check วันที่
                                                        if index == (snapshotDocument2.count-1) {
                                                            self.findOrderThatSameAsTheDayThatUserWant()
                                                            DispatchQueue.main.async {
                                                                self.showAllSaleTableView.reloadData()
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
                
                // function here
                
                
            }
        }
        
    }
    
    func findOrderThatSameAsTheDayThatUserWant()  {
                                                                    // find order same as the day user choose
        
        for data in dataForCheck {
            if data.day.contains(dateSplitArray[0]) {               // same day
                if data.day.contains(dateSplitArray[1]) {           // same month
                    if data.day.contains(dateSplitArray[2]) {       // same year
                        
                        dateBelow = "\(dateSplitArray[0]) \(dateSplitArray[1]) \(dateSplitArray[2])"
                        // set day to show
                        
                        dataForPutIncell.append(data)               // add order into array for show
                        totalInOneDay += data.totalPrice            // find total ที่ขายได้
                        print(dateBelow)
                        print(totalInOneDay)
                    }
                }
            }
        }
        
        dayForShowLabel.text = dateBelow                            // show day to user
        totalLabel.text = String(totalInOneDay)                     // show total to user
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
