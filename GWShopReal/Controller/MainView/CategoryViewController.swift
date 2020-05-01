//
//  CategoryViewController.swift
//  GWShopReal
//
//  Created by PMJs on 1/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categorySearch : String?
    var product : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        loadProduct()
        
        
        
    }
    
    func loadProduct()  {
        
        
        
        let db = Firestore.firestore()
        let productCollection = db.collection(K.productCollection.productCollection)
        
        productCollection.whereField(K.productCollection.productCategory, isEqualTo: categorySearch!).getDocuments { (querySnapshot, error) in
            
            if let e = error {
                print(e.localizedDescription)
            } else {
                print(self.categorySearch!)
                if let snapShotDocument = querySnapshot?.documents {
                    
                    if snapShotDocument.count == 0 {
                        self.activityIndicator.stopAnimating()
                    }
                    for doc in snapShotDocument {
                        let docID = doc.documentID
                        let data = doc.data()
                        
                        if let productNameCell = data[K.productCollection.productName] as? String
                            ,  let productCategoryCell = data[K.productCollection.productCategory] as? String
                            ,  let productDetailCell = data[K.productCollection.productDetail] as? String
                            ,  let productImageURLCell = data[K.productCollection.productImageURL] as? String
                            , let productPriceCell = data[K.productCollection.productPrice] as? String
                            , let productQuantityCell = data[K.productCollection.productQuantity] as? String
                            , let senderFrom = data[K.productCollection.sender] as? String
                            , let storeName = data[K.productCollection.storeName] as? String {
                            
                            let newProduct = Product(productName: productNameCell, productDetail: productDetailCell, productCategory: productCategoryCell, productPrice: productPriceCell, productQuantity: productQuantityCell, productImageURL: productImageURLCell, documentId: docID, sender: senderFrom, storeName: storeName)
                            
                            self.product.append(newProduct)
                            
                            DispatchQueue.main.async {
                                self.categoryTableView.reloadData()
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    
    
}

extension CategoryViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if product.count == 0 {
            self.activityIndicator.stopAnimating()
        }
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productForCell = product[indexPath.row]
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.categoryCellIdentifier) as! categoryCell
        let url = URL(string: productForCell.productImageURL)!
        let resource = ImageResource(downloadURL: url)
        
        cell.productImage.kf.setImage(with: resource) { (result) in
            
            self.activityIndicator.stopAnimating()
        }
        cell.productNameLable.text = productForCell.productName
        cell.productPriceLabel.text = productForCell.productPrice
        cell.storeNameLable.text = productForCell.storeName
        
        return cell
    }
    
}
