//
//  TopFiveProductController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 4/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
class TopFiveProductController: UIViewController {
    
    @IBOutlet weak var topFiveTableView: UITableView!
    var db = Firestore.firestore()
    var currentTime: String!
    var currentTimeArray: [String]!
    var topProduct: [TopFiveProduct] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTime = getCurrentDateTime()
        currentTimeArray = currentTime.components(separatedBy: " ")
    }
    
    func loadTopFiveData() {
        db.collection(K.tableName.orderCollection).getDocuments { (querySnapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            }else{
                if let snapShotDocuments = querySnapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let date = data[K.order.dateOfPurchase] as? String,let storeName = data[K.order.vendorName] as? String,let orderID = data[K.order.orderID] as? String{
                            let orderDateArray = date.components(separatedBy: " ")
                            if self.currentTimeArray[1] == orderDateArray[1]{   // if current month is month when product ordered
                                    
                                self.db.collection(K.orderDetailCollection.orderDetailCollection).whereField(K.orderDetailCollection.orderID, isEqualTo: orderID).getDocuments { (queryData, error) in
                                    if let e = error{
                                        print(e.localizedDescription)
                                    }else{
                                        // check each order detail if that product exists in topProduct Array
                                        if let productID = data[K.orderDetailCollection.productID] as? String,let quantity = data[K.orderDetailCollection.quantity] as? Int{
                                            
                                            self.db.collection(K.productCollection.productCollection).document(productID).getDocument { (documentSnapshot, error) in
                                                if let e = error{
                                                    print(e.localizedDescription)
                                                }else{
                                                    if let data = documentSnapshot?.data(){
                                                        if let productName = data[K.productCollection.productName] as? String{
                                                            if self.topProduct.count == 0{
                                                                self.topProduct.append(TopFiveProduct(productID: productID, productName: productName, storeName: storeName, sold: quantity))
                                                            }else{
                                                                var found = false
                                                                for index in 0..<self.topProduct.count{
                                                                    if self.topProduct[index].productID == productID{
                                                                        found = true
                                                                        self.topProduct[index].AddSold(number: quantity)
                                                                        break
                                                                    }
                                                                }
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                    if found == false{
                                                                        self.topProduct.append(TopFiveProduct(productID: productID, productName: productName, storeName: storeName, sold: quantity))
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
        
        let dateAndTimeString = formatter.string(from: currentDateTime)
        // get date from object
        return dateAndTimeString
    }
    
    


class TopFiveCell: UITableViewCell{
    @IBOutlet weak var productIDLabel: UILabel!
    @IBOutlet weak var storeNameLabel :UILabel!
    @IBOutlet weak var productNameLabel :UILabel!
    @IBOutlet weak var numberSoldLabel :UILabel!

}
