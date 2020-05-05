//
//  SendProductViewController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 4/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
class SendProductViewController: UIViewController,updateCell {
   
    

    @IBOutlet weak var orderProductTableView: UITableView!
    
    var db = Firestore.firestore()
    var orderedProducts: [OrderedProduct] = []
    var selectedOrder: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderProductTableView.dataSource = self
        orderProductTableView.delegate = self
        loadOrderData()
    }
    
    func loadOrderData(){
        if let emailSender = Auth.auth().currentUser?.email{
            db.collection(K.tableName.storeDetailTableName).whereField(K.sender, isEqualTo: emailSender).getDocuments { (query, error) in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    if let snapShotDocs = query?.documents{
                        let data = snapShotDocs[0].data()
                        if let storeName = data[K.storeDetail.storeName] as? String{
                            self.db.collection(K.tableName.orderCollection).whereField(K.order.vendorName, isEqualTo: storeName).getDocuments { (querySnapshot, error) in
                                if let e = error{
                                    print(e.localizedDescription)
                                }else{
                                    if let snapShotDocuments = querySnapshot?.documents{
                                        for doc in snapShotDocuments{
                                            let data = doc.data()
                                            let docID = doc.documentID
                                            if let orderID = data[K.order.orderID] as? String,let addressID = data[K.order.addressID] as? String, let dateOfPurchase = data[K.order.dateOfPurchase] as? String, let status = data[K.order.orderStatus] as? Bool, let paymentID = data[K.order.paymentID] as? String, let total = data["total"] as? Double,let user = data[K.order.userName] as? String{
                                                self.orderedProducts.append(OrderedProduct(orderID: orderID, addressID: addressID, datePurchased: dateOfPurchase, orderStatus: status, paymentID: paymentID, total: total, orderDocID: docID,user: user))
                                                
                                                DispatchQueue.main.async {
                                                    self.orderProductTableView.reloadData()
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
protocol updateCell {
    func updateCell()
}
extension SendProductViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedProducts.count
    }
    func updateCell() {
           loadOrderData()
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = orderedProducts[indexPath.row]
        let orderCell = self.orderProductTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.orderInSendProduct) as! orderProductTableViewCell
        orderCell.orderIDLabel.text = order.orderID
        if order.orderStatus == true{
            orderCell.statusImageView.backgroundColor = #colorLiteral(red: 0, green: 0.6659262776, blue: 0.419370234, alpha: 1)
            orderCell.statusLabel.text = "Distributed"
        }
        
        return orderCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOrder = indexPath.row
        self.performSegue(withIdentifier: K.segue.listOrderToOrderDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.listOrderToOrderDetail{
            let destinationVC = segue.destination as! ShowOrderDetailViewController
            destinationVC.orderedProduct = self.orderedProducts[selectedOrder]
            destinationVC.delegate = self
        }
    }
    
    
}
class orderProductTableViewCell: UITableViewCell{
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
}

class ShowOrderDetailViewController:UIViewController{
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var dateOfPurchasedLabel: UILabel!
    @IBOutlet weak var distributeButton: UIButton!
    
    var orderedProduct: OrderedProduct!
    var orderedProductDetail: [OrderedProductDetail] = []
    var delegate : updateCell?
    
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDetailTableView.dataSource = self
        orderDetailTableView.delegate = self
        if orderedProduct.orderStatus == true{
            distributeButton.isHidden = true
        }
        loadEachData()
    }
    
    func loadEachData(){
        orderedProductDetail = []
        let dateArray = orderedProduct.datePurchased.components(separatedBy: " ")
        dateOfPurchasedLabel.text = "\(dateArray[0]) \(dateArray[1]) \(dateArray[3])"
        db.collection(K.tableName.addressTableName).document(orderedProduct.addressID).getDocument { (documents, error) in
            if let e = error{
                print(e.localizedDescription)
            }else{
                if let data = documents?.data(){
                    if let firstName = data[K.firstName] as? String, let lastName = data[K.surname] as? String, let phoneNumber = data[K.phoneNumber] as? String,
                        let addressDetail = data[K.addressDetail] as? String, let district = data[K.district] as? String,let province = data[K.province] as? String,
                        let postCode = data[K.postCode] as? String{
                        self.nameLabel.text = "\(firstName) \(lastName)"
                        self.phoneNumberLabel.text = phoneNumber
                        self.addressDetailLabel.text = addressDetail
                        self.districtLabel.text = district
                        self.provinceLabel.text = province
                        self.postCodeLabel.text = postCode
                    }
                }
            }
        }
            
        db.collection(K.orderDetailCollection.orderDetailCollection).whereField(K.orderDetailCollection.orderID, isEqualTo:  orderedProduct.orderID).getDocuments { (querySnapshot, error) in
            if let e = error{
                print(e.localizedDescription)
            }else{
                if let snapShotDocuments = querySnapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let productDocID = data[K.orderDetailCollection.productID] as? String,let quantity = data[K.orderDetailCollection.quantity] as? Int,let totalPrice = data[K.orderDetailCollection.priceInProduct] as? Double{
                            self.db.collection(K.productCollection.productCollection).document(productDocID).getDocument { (document, error) in
                                if let e = error{
                                    print(e.localizedDescription)
                                }else{
                                    if let data = document?.data(){
                                        if let productName = data[K.productCollection.productName] as? String,let imageURL = data[K.productCollection.productImageURL] as? String{
                                            self.orderedProductDetail.append(OrderedProductDetail(quantity: quantity, productID: productDocID, productName: productName,imageURL: imageURL, totalPrice: totalPrice))
                                            
                                            DispatchQueue.main.async {
                                                self.orderDetailTableView.reloadData()
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
    
    @IBAction func distributedPressed(_ sender: UIButton) {
        db.collection(K.tableName.orderCollection).document(orderedProduct.orderDocID).updateData([
            K.order.orderStatus: true
        ]) { (error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.delegate?.updateCell()
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
extension ShowOrderDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedProductDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eachProduct = orderedProductDetail[indexPath.row]
        let productCell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.orderDetailIdentifier) as! OrderDetailCell
        productCell.productNameLabel.text = eachProduct.productName
        productCell.productQuantitiesLabel.text = String(eachProduct.quantity)
        productCell.productTotalPriceLabel.text = String(eachProduct.totalPrice)
        return productCell
    }
    
    
}

class OrderDetailCell: UITableViewCell{
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productQuantitiesLabel: UILabel!
    @IBOutlet weak var productTotalPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
}
