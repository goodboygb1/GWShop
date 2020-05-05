//
//  OrderDetailViewController.swift
//  GWShopReal
//
//  Created by PMJs on 5/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class OrderDetailViewController: UIViewController {
    
    var orderForQuery : OrderedProduct?     //รับมาจากหน้าที่แล้ว
    var orderDetailForShow : [OrderedProductDetail] = []                // cart for show
    
    @IBOutlet weak var orderDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orderIDForQuery = orderForQuery?.orderID
        orderDetailTableView.delegate = self
        orderDetailTableView.dataSource = self
        loadOrder(from: orderIDForQuery!)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tabBarController?.navigationItem.setHidesBackButton(false, animated: animated)
           tabBarController?.navigationController?.setNavigationBarHidden(false, animated: animated)
           
           
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func loadOrder(from orderIDForQuery : String)  {
        
        let db = Firestore.firestore()
        let orderDetailCollection = db.collection(K.orderDetailCollection.orderDetailCollection)
        
        orderDetailCollection
            .whereField(K.orderDetailCollection.orderID, isEqualTo: orderIDForQuery)
            .getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapShotDocument = querySnapshot?.documents {
                   
                    for doc in snapShotDocument {
                        let  data = doc.data()
                        
                        if  let totalPricePerProduct = data[K.orderDetailCollection.priceInProduct] as? Double,
                            let productID = data[K.orderDetailCollection.productID] as? String,
                            let totalQuantityForEachProduct = data[K.orderDetailCollection.quantity] as? Int {
                            
                           print("productID = \(productID)")
                            let productCollection = db.collection(K.productCollection.productCollection)
                            
                            productCollection
                                .document(productID)
                                .getDocument { (queryShapShot2,error2) in
                                    if let e2 = error2 {
                                        print(e2.localizedDescription)
                                    } else {
                                        if let data2 = queryShapShot2?.data() {
                                           
                                            if let imageURL = data2[K.productCollection.productImageURL] as? String
                                                    ,let productName = data2[K.productCollection.productName] as? String
                                                {
                                                    
                                                    let newOrderDetail = OrderedProductDetail(quantity: totalQuantityForEachProduct, productID: productID, productName: productName, imageURL: imageURL, totalPrice: totalPricePerProduct)
                                                    
                                                    self.orderDetailForShow.append(newOrderDetail)
                                                    // create object cart
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
        
        
    }


extension OrderDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderDetailForShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderDetailForCell = orderDetailForShow[indexPath.row]
        let cell = orderDetailTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.orderDetailForCustomer) as! OrderDetailTableViewCell
        let url = URL(string: orderDetailForCell.imageURL)!
        let resource = ImageResource(downloadURL: url)
        
        cell.productName.text = orderDetailForCell.productName
        cell.totalPriceLabel.text = String(orderDetailForCell.totalPrice)
        cell.productImage.kf.setImage(with: resource)
        cell.quantityLabel.text = String(orderDetailForCell.quantity)
        return cell
        
    }
    
    
}
