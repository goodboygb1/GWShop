//
//  NotificationViewController.swift
//  GWShopReal
//
//  Created by PMJs on 24/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class NotificationViewController: UIViewController {

    var orderForshow : [OrderedProduct] = []            //order show to user
    var cellUserSelect : OrderedProduct?                // cell that user select for sent to next view
    
    
    @IBOutlet weak var orderForShowTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderForShowTableView.delegate = self
        orderForShowTableView.dataSource = self
        // Do any additional setup after loading the view.
        loadOrder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setHidesBackButton(true, animated: animated)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    func loadOrder()  {
        
        let db = Firestore.firestore()
        let orderCollection = db.collection(K.tableName.orderCollection)
        
        if let email = Auth.auth().currentUser?.email {
            orderCollection.whereField(K.order.userName, isEqualTo: email).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapShotDocument = querySnapshot?.documents {
                        for doc in snapShotDocument {
                            let  data = doc.data()
                            let  docID = doc.documentID
                            
                            if let orderID = data[K.order.orderID] as? String,
                                let addressID = data[K.order.addressID] as? String,
                                let datePerchased = data[K.order.dateOfPurchase] as? String,
                                let orderStatus = data[K.order.orderStatus] as? Bool,
                            let paymentID = data[K.order.paymentID] as? String,
                                let total = data[K.order.total] as? Double,
                                let user = data[K.order.userName]  as? String{
                                
                                let newOrder = OrderedProduct(orderID: orderID, addressID: addressID, datePurchased: datePerchased, orderStatus: orderStatus, paymentID: paymentID, total: total, orderDocID: docID, user: user)
                                
                                self.orderForshow.append(newOrder)
                                
                                DispatchQueue.main.async {
                                    self.orderForShowTableView.reloadData()
                                }
                            }
                            
                            
                        }
                    }
                }
            }
        }
    }
    
     

}


extension NotificationViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderForshow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderIncell = orderForshow[indexPath.row]
        let cell = orderForShowTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.showAllOrder) as! ShowAllOrderTableViewCell
        
        cell.orderIDLabel.text = orderIncell.orderID
        
        if orderIncell.orderStatus {
            cell.statusLabel.text = "Distributed"
            cell.showStatusColour.backgroundColor = .green
        } else {
            cell.statusLabel.text = "Wait for distribution"
            cell.showStatusColour.backgroundColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         cellUserSelect = orderForshow[indexPath.row]
        performSegue(withIdentifier: K.segue.showOrderDetailToUser, sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showOrderDetailToUser {
            let destinationVC = segue.destination as! OrderDetailViewController
            destinationVC.orderForQuery = cellUserSelect
        }
    }
    
}
