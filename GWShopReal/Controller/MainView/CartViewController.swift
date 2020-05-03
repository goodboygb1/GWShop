//
//  CartViewController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 1/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
class CartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var db = Firestore.firestore()
    var carts: [Cart] = []
    var totalPrice: [Double] = []
    var NetPrice: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        loadCartData()
        loadTotalPrice()
    }
    
    func loadCartData() {
        if let emailSender = Auth.auth().currentUser?.email{
            self.carts = []
            db.collection(K.tableName.cartTableName).whereField(K.cartDetail.user, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("error while loading cart data in cart page: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        for cart in snapShotDocuments{
                            let data = cart.data()
                            let docID = cart.documentID
                            if let storeName = data[K.storeDetail.storeName] as? String, let productPrice = data[K.productCollection.productPrice] as? String,let number = data[K.cartDetail.quantity] as? Int,let productDocID = data[K.cartDetail.productDocID] as? String{
                                self.db.collection(K.productCollection.productCollection).document(productDocID).getDocument { (documentSnapshot, error) in
                                    if let e = error{
                                        print("error while loading product name: \(e.localizedDescription)")
                                    }else{
                                        let data = documentSnapshot?.data()
                                        if let productName = data![K.productCollection.productName] as? String{
                                            self.carts.append(Cart(storeName: storeName, productName: productName, productPrice: productPrice, numberProduct: number, documentID: docID))
                                            DispatchQueue.main.async {
                                                self.cartTableView.reloadData()
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    } // if let snapshot = query
                }
            }
        }
        
    }
    
    func loadTotalPrice(){
        self.totalPrice = []
        if let emailSender = Auth.auth().currentUser?.email{
            db.collection(K.tableName.cartTableName).whereField(K.cartDetail.user, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("error while loading cart data on calculateTotalPrice.swift: \(e.localizedDescription)")
                }else{
                    if let snapShotDocuments = querySnapshot?.documents{
                        for doc in snapShotDocuments{
                            let data = doc.data()
                            if let quantity = data[K.cartDetail.quantity] as? Int, let price = data[K.productCollection.productPrice] as? String,let promotionDocID = data[K.cartDetail.promotionDocID] as? String{
                                let priceInDoubleFormat = Double(price)
                                let totalPricePerProduct = Double(quantity) * priceInDoubleFormat!
                                if promotionDocID == ""{
                                    self.totalPrice.append(totalPricePerProduct)
                                }else{
                                    self.db.collection(K.tableName.promotionTableName).document(promotionDocID).getDocument { (documentSnapshot, error) in
                                        let data = documentSnapshot?.data()
                                        if let minimumPrice = data![K.promotion.minimumPrice] as? String, let discountPercent = data![K.promotion.discountPercent] as? Int{
                                            let minimumPriceInDoubleFormat = Double(minimumPrice)
                                            if minimumPriceInDoubleFormat! > totalPricePerProduct{
                                                self.totalPrice.append(totalPricePerProduct)
                                            }else{
                                                self.totalPrice.append(totalPricePerProduct - (totalPricePerProduct * (Double(discountPercent) / 100)))
                                            }
                                        }
                                        self.totalPriceLabel.text = String(format: "%.2f", self.totalPrice.reduce(0, +))
                                    }
                                }
                                self.totalPriceLabel.text = String(format: "%.2f", self.totalPrice.reduce(0, +))
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func checkOutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.segue.cartToSummary, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.cartToSummary {
            let destinationVC = segue.destination as! SummaryViewController
                destinationVC.totalPrize = totalPrice 
                destinationVC.cart = carts
            print(carts[0].productName)
                   print(totalPrice[0])
                   
                   print(carts[1].productName)
                   print(totalPrice[1])
        }
    }
}



extension CartViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = carts[indexPath.row]
        let cartCell = cartTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.cartViewIdentifier) as! CartTableViewCell
        cartCell.shopNameLabel.text = cart.storeName
        cartCell.productNameLabel.text = cart.productName
        cartCell.priceLabel.text = cart.productPrice
        cartCell.numberLabel.text = String(cart.numberProduct)
        cartCell.cartDocumentIDLabel.text = cart.documentID
        cartCell.numberStepper.value = Double(cart.numberProduct)
        cartCell.delegate = self
        return cartCell
    }

}

extension CartViewController:CartCellDelegate{
    func didDeletePressed(cartDocID: String) {
        db.collection(K.tableName.cartTableName).document(cartDocID).delete()
        loadCartData()
        loadTotalPrice()
    }
    func didStepperPressed(cartDocID: String,number: Int){
        db.collection(K.tableName.cartTableName).document(cartDocID).updateData([
            K.cartDetail.quantity: number
        ])
        loadCartData()
        loadTotalPrice()
    }
}

protocol CartCellDelegate {
    func didDeletePressed(cartDocID: String)
    func didStepperPressed(cartDocID: String,number: Int)
}
class CartTableViewCell:UITableViewCell{
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var cartDocumentIDLabel: UILabel!

    @IBOutlet weak var numberStepper: UIStepper!
    
    var delegate: CartCellDelegate?
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate?.didDeletePressed(cartDocID: cartDocumentIDLabel.text!)
    }
    @IBAction func stepperPressed(_ sender: UIStepper) {
        numberLabel.text = String(format: "%.0f", numberStepper.value)
        delegate?.didStepperPressed(cartDocID: cartDocumentIDLabel.text!, number: Int(numberStepper.value))
    }
}
