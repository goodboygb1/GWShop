//
//  MainViewController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        
        searchTextField.delegate = self                  // set textfield delegate
        super.viewDidLoad()
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height/10
        // set curve button search
    }
    
    override func viewWillAppear(_ animated: Bool) {     // hide navigation bar
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.setHidesBackButton(true, animated: animated)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if searchTextField.text != ""{              // if user fill product name
            
            performSegue(withIdentifier: K.segue.mainToSearchDetail, sender: self)
            return true                             // end edit and go to query
            
        } else {
            searchTextField.placeholder = "กรุณากรอกชื่อสินค้าก่อนค้นหา"
            return false                             // tell use to fill
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.segue.mainToSearchDetail {
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.keywordForQuery =
                searchTextField.text                    // sent word for query to next view
        }
    }
    
}

//MARK: - SearchView

class SearchViewController: UIViewController {
    
    var keywordForQuery : String?   // for query
    var product : [Product] = []    // product attribute array
    var selectRowAtIndex : Int?      // check wether index was click
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self     // set data source
        loadProduct()
    }
    
    func loadProduct()  {                 // load product attribute from firebase
        
        let db = Firestore.firestore()
        let productCollect = db.collection(K.productCollection.productCollection)
        let keywordFinal = keywordForQuery!             // force unwrapping
        let keywordArray = [keywordFinal]               // pack into array for query
        
        if keywordFinal != "" {        // if key for query is not empty
            productCollect.order(by: "productName").start(at: keywordArray).getDocuments { (querySnapshot, error) in
                
                self.product = []          // reset array
                
                if let e = error {         // error
                    print("error while loading product \(e.localizedDescription)")
                } else {                   // not error
                    
                    if let snapShotDocument = querySnapshot?.documents {
                        // have data or not
                        print("no error and have data")
                        
                        for doc in snapShotDocument {
                            let data = doc.data()
                            let docID = doc.documentID
                            
                            
                            if let productNameCell = data[K.productCollection.productName] as? String
                                ,  let productCategoryCell = data[K.productCollection.productCategory] as? String
                                ,  let productDetailCell = data[K.productCollection.productDetail] as? String
                                ,  let productImageURLCell = data[K.productCollection.productImageURL] as? String
                                , let productPriceCell = data[K.productCollection.productPrice] as? String
                                , let productQuantity = data[K.productCollection.productQuantity] as? String
                                , let senderFrom = data[K.productCollection.sender] as? String
                                , let storeName = data[K.productCollection.storeName] as? String
                            {
                                
                                //  collect data from firebase
                                
                                print("all data wasn't empty")
                                print("\(storeName)")
                                let newProduct = Product(productName: productNameCell, productDetail: productDetailCell, productCategory: productCategoryCell, productPrice: productPriceCell, productQuantity: productQuantity, productImageURL: productImageURLCell, documentId: docID, sender: senderFrom, storeName: storeName)
                                // new product object
                                
                                self.product.append(newProduct)
                                for n in self.product {
                                    print("append value = \(n.productName)")
                                }
                                
                                // add to array for tableviewCell
                                
                                DispatchQueue.main.async {
                                    self.searchResultTableView.reloadData()
                                    // very important !!!!! for reload
                                    // because download from data base was very long
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

//MARK: - SearchView For TableView

extension SearchViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count                // number of cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productReturnToCell = product[indexPath.row]        // data in row
        let cell = searchResultTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.searchCell) as! searchCell    // cell connect
        
        cell.resultNameLabel.text = productReturnToCell.productName
        cell.resultPriceLabel.text  = productReturnToCell.productPrice
        cell.resultImageURL = productReturnToCell.productImageURL
        cell.resultProductID = productReturnToCell.documentId
        cell.senderLabel.text = productReturnToCell.storeName
        cell.senderName = productReturnToCell.sender
        
        // 1. create data 2. create cell 3. add data to cell 4. return cell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if user click any row
        
        selectRowAtIndex = indexPath.row
        performSegue(withIdentifier: K.segue.searchToProductDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.searchToProductDetail {
            var destinationVC = segue.destination as! ProductDetail
            destinationVC.productDetail = product[selectRowAtIndex!]
        }
    }
}


//MARK: - Product detail

class ProductDetail: UIViewController {         // for add product detail
    
    var productDetail : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productDetail?.sender)
    }
}


