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
        currentTimeArray[2] = String(Int(currentTimeArray[2])! + 543)
        topFiveTableView.dataSource = self
        topFiveTableView.delegate = self
        
        loadTopFiveData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.sortSoldProduct()
            self.topFiveTableView.reloadData()
        }
    }
    
    @IBAction func pressed(_ sender: UIButton) {
        print(topProduct)
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
                              if self.currentTimeArray[1] == orderDateArray[1] && self.currentTimeArray[2] == orderDateArray[3]{   // if current month is month when product ordered
    
                                  self.db.collection(K.orderDetailCollection.orderDetailCollection).whereField(K.orderDetailCollection.orderID, isEqualTo: orderID).getDocuments { (queryData, error) in
                                      if let e = error{
                                          print(e.localizedDescription)
                                      }else{
                                          print(1)
                                          if let snapShot = queryData?.documents{
                                              for document in snapShot{
                                                  let data = document.data()
                                                  if let productID = data[K.orderDetailCollection.productID] as? String,let quantity = data[K.orderDetailCollection.quantity] as? Int{
                                                  //print(productID,quantity)
                                                  self.db.collection(K.productCollection.productCollection).document(productID).getDocument { (documentSnapshot, error) in
                                                      if let e = error{
                                                          print(e.localizedDescription)
                                                      }else{
                                                          print("got doc porductID")
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

    func sortSoldProduct(){
        topProduct.sort(by: {$0.sold > $1.sold})
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
    
}

extension TopFiveProductController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = topProduct[indexPath.row]
        let productCell = topFiveTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.TopProductIdentifier) as! TopFiveCell
        productCell.productIDLabel.text = product.productID
        productCell.productNameLabel.text = product.productName
        productCell.numberSoldLabel.text = String(product.sold)
        productCell.storeNameLabel.text = product.storeName
        
        return productCell
    }
    
    
}

class TopFiveCell: UITableViewCell{
    @IBOutlet weak var productIDLabel: UILabel!
    @IBOutlet weak var storeNameLabel :UILabel!
    @IBOutlet weak var productNameLabel :UILabel!
    @IBOutlet weak var numberSoldLabel :UILabel!

}
