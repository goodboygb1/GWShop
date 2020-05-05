//
//  AddProductInPromotionController.swift
//  GWShopReal
//
//  Created by PMJs on 30/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class AddProductInPromotionController: UIViewController {
    
    
    @IBOutlet weak var productInPromotionTableView: UITableView!
    var product : [Product] = []
    var productDocumentID: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        productInPromotionTableView.dataSource = self
        loadProduct()
    }
    
    func loadProduct()  {
        
        let db = Firestore.firestore()
        let productCollect = db.collection(K.productCollection.productCollection)
        if let emailSender = Auth.auth().currentUser?.email {
            productCollect.whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                
                self.product = []
                
                if let e = error {
                    print("error while loading product \(e.localizedDescription)")
                } else {
                    if let snapShotDocument = querySnapshot?.documents {
                        for doc in snapShotDocument {
                            let data = doc.data()
                            let docID = doc.documentID
                            
                            if let productNameCell = data[K.productCollection.productName] as? String
                                ,  let productCategoryCell = data[K.productCollection.productCategory] as? String
                                ,  let productDetailCell = data[K.productCollection.productDetail] as? String
                                ,  let productImageURLCell = data[K.productCollection.productImageURL] as? String
                                , let productPriceCell = data[K.productCollection.productPrice] as? String
                                , let productQuantity = data[K.productCollection.productQuantity] as? String
                                , let senderFrom = data[K.sender] as? String
                                , let storeName = data[K.productCollection.storeName] as? String
                                
                                
                                
                            {
                                
                                let newProduct = Product(productName: productNameCell, productDetail: productDetailCell, productCategory: productCategoryCell, productPrice: productPriceCell, productQuantity: productQuantity, productImageURL: productImageURLCell, documentId: docID, sender: senderFrom, storeName: storeName )
                                print("Storename = \(storeName)")
                                self.product.append(newProduct)
                                print("add success")
                                DispatchQueue.main.async {
                                    self.productInPromotionTableView.reloadData()
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }

    
    @IBAction func nextPressed(_ sender: UIButton) {
        if productDocumentID.count == 0{
            print("Please select at least one item")
        }else{
            self.performSegue(withIdentifier: K.segue.addProductPromotionToAddPromotionSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.addProductPromotionToAddPromotionSegue{
            let destinationVC = segue.destination as! AddPromotionInProductController
            destinationVC.productDocumentID = productDocumentID
        }
    }
 }


extension AddProductInPromotionController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(product.count)
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productReturnToCell = product[indexPath.row]
        let cell = productInPromotionTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.addProductInAddPromotionCell) as! addProductInAddPromotionCell
        
        cell.productNameLable.text = productReturnToCell.productName
        cell.priceLabel.text  = productReturnToCell.productPrice
        cell.productImageURL = productReturnToCell.productImageURL
        productInPromotionTableView.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.productDocumentID.append(product[indexPath.row].documentId)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = productDocumentID.firstIndex(of: product[indexPath.row].documentId){
            self.productDocumentID.remove(at: index)
        }
    }
    
}
