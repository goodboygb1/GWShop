//
//  MainViewController.swift
//  GWShopReal
//
//  Created by PMJs on 22/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class MainViewController: UIViewController,UITextFieldDelegate {
    
    
    var categorySearch : String?
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
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
        } else if segue.identifier == K.segue.mainToCategoryProduct {
            
            let destinationVC = segue.destination as! CategoryViewController
            destinationVC.categorySearch = self.categorySearch
            
        }
    }
    
    
    @IBAction func manFashion(_ sender: UIButton) {
        categorySearch = K.categoryList.menFashion
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
    }
    
    @IBAction func wormanFashion(_ sender: UIButton) {
        categorySearch = K.categoryList.womenFashion
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func mobile(_ sender: UIButton) {
        categorySearch = K.categoryList.mobile
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func foodSupport(_ sender: Any) {
        categorySearch = K.categoryList.footSup
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func toy(_ sender: UIButton) {
        categorySearch = K.categoryList.toy
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func watchAndGlasses(_ sender: UIButton) {
        categorySearch = K.categoryList.watchAndGlasses
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func indoorAccessory(_ sender: UIButton) {
        categorySearch = K.categoryList.indoorAccessory
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func manShoes(_ sender: UIButton) {
        categorySearch = K.categoryList.menShoes
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func womanShoes(_ sender: UIButton) {
        categorySearch = K.categoryList.womenShoes
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func bag(_ sender: UIButton) {
        categorySearch = K.categoryList.bag
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func cosmetic(_ sender: UIButton) {
        categorySearch = K.categoryList.cosmetic
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func computer(_ sender: UIButton) {
        categorySearch = K.categoryList.computer
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func camera(_ sender: UIButton) {
        categorySearch = K.categoryList.camera
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func jewelry(_ sender: UIButton) {
        categorySearch = K.categoryList.jewelry
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func sport(_ sender: UIButton) {
        categorySearch = K.categoryList.sport
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func foodAndBev(_ sender: UIButton) {
        categorySearch = K.categoryList.foodAndBev
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func indoorEntertainment(_ sender: UIButton) {
        categorySearch = K.categoryList.indoorEntertainment
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func electronic(_ sender: UIButton) {
        categorySearch = K.categoryList.electronic
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func game(_ sender: UIButton) {
        categorySearch = K.categoryList.game
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func pet(_ sender: UIButton) {
        categorySearch = K.categoryList.pet
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    @IBAction func car(_ sender: UIButton) {
        categorySearch = K.categoryList.car
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func stationary(_ sender: UIButton) {
        categorySearch = K.categoryList.stationary
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func ticket(_ sender: UIButton) {
        categorySearch = K.categoryList.ticket
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func others(_ sender: UIButton) {
        categorySearch = K.categoryList.others
        performSegue(withIdentifier: K.segue.mainToCategoryProduct, sender: self)
        
    }
    
    @IBAction func cartPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.mainToCartSegue, sender: self)
    }
    
    
    
}





//MARK: - SearchView

class SearchViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var keywordForQuery : String?   // for query
    var product : [Product] = []    // product attribute array
    var selectRowAtIndex : Int?      // check wether index was click
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self     // set data source
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
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
                        
                        if snapShotDocument.count == 0 {
                            self.activityIndicator.stopAnimating()
                        }
                        
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
    
    @IBAction func cartPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segue.searchToCartSegue, sender: self)
    }

}

//MARK: - SearchView For TableView

extension SearchViewController : UITableViewDataSource,UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return product.count                // number of cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productReturnToCell = product[indexPath.row]        // data in row
        let cell = searchResultTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.searchCell)
            as! searchCell    // cell connect
        
         let url = URL(string: productReturnToCell.productImageURL)!
         let resource = ImageResource(downloadURL: url)
        
        cell.resultNameLabel.text = productReturnToCell.productName
        cell.resultPriceLabel.text  = productReturnToCell.productPrice
        cell.resultImageURL = productReturnToCell.productImageURL
        cell.storeNameLable.text = productReturnToCell.storeName
        cell.resultImage.kf.setImage(with: resource) { (result) in
            switch result {
            case .success(_):
              print("Fetch image successful")
            case .failure(_):
                print("Fetch image error")
            }
            
            self.activityIndicator.stopAnimating()
         }
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
            let destinationVC = segue.destination as! ProductDetail
            destinationVC.productDetail = product[selectRowAtIndex!]
        }
    }
    
    func presentAlert(title:String,message:String,actiontitle:String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actiontitle, style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: - Product detail

class ProductDetail: UIViewController {         // for add product detail
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productDetailLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var promotionTableView: UITableView!
    var productDetail : Product!
    var promotions: [Promotion] = []
    var selectedPromotionDocumentID: [String] = []
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        productNameLabel.text = productDetail.productName
        productDetailLabel.text = productDetail.productDetail
        productPriceLabel.text = productDetail.productPrice
        productQuantityLabel.text = productDetail.productQuantity
        productCategoryLabel.text = productDetail.productCategory
        storeNameLabel.text = productDetail.storeName
        promotionTableView.dataSource = self
        promotionTableView.delegate = self
        loadProductData()
    }
    //ภพ1
    func loadProductData(){
        self.db.collection(K.tableName.hasPromotionTableName).whereField(K.sender, isEqualTo: productDetail.sender).whereField(K.productCollection.productDocID, isEqualTo: self.productDetail.documentId).getDocuments { (querySnapshot, error) in
            if let e = error{
                print("error while checking promotions in product: \(e.localizedDescription)")
            }else{
                if let snapShotDocuments = querySnapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let promotion = data[K.promotion.promotionName] as? String{
                            print(promotion) // got promotionName
                            // search specific promotion data
                            self.db.collection(K.tableName.promotionTableName).whereField(K.sender, isEqualTo: self.productDetail.sender).whereField(K.promotion.promotionName, isEqualTo: promotion).getDocuments { (querySnapshot, error) in
                                    if let e = error{
                                        print("Error while looping in promotionName: \(e.localizedDescription) ")
                                    }else{
                                        if let snapShotDocuments = querySnapshot?.documents{
                                            for doc in snapShotDocuments{
                                                let data = doc.data()
                                                let docID = doc.documentID
                                                if let promotionName = data[K.promotion.promotionName] as? String, let promotionDetail = data[K.promotion.promotionDetail] as? String,
                                                    let discountPercent = data[K.promotion.discountPercent] as? Int, let minimumPrice = data[K.promotion.minimumPrice] as? String,
                                                    let validDate = data[K.promotion.validDate] as? String{
                                                    self.promotions.append(Promotion(promotionName: promotionName, promotionDetail: promotionDetail, minimumPrice: minimumPrice, discountPercent: discountPercent, validDate: validDate, docID: docID))
                                                    //print(self.promotions)
                                                    DispatchQueue.main.async {
                                                        self.promotionTableView.reloadData()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }else {print("rip")}
            }
        }
    }
    
    @IBAction func addCartPressed(_ sender: UIButton) {
        
        if let emailSender = Auth.auth().currentUser?.email{
            db.collection(K.tableName.cartTableName).whereField(K.cartDetail.user, isEqualTo: emailSender).whereField(K.cartDetail.productDocID, isEqualTo: productDetail.documentId).getDocuments { (querySnapshot, error) in
                if let e = error{
                    print("Error while loading cart data: \(e.localizedDescription)")
                }else{
                    if let snapShotdocuments = querySnapshot?.documents{
                        if snapShotdocuments.count == 0{
                            if self.selectedPromotionDocumentID.count == 1{
                                    self.db.collection(K.tableName.cartTableName).addDocument(data: [
                                        K.cartDetail.productDocID: self.productDetail.documentId,
                                        K.cartDetail.user: emailSender,
                                        K.cartDetail.promotionDocID: self.selectedPromotionDocumentID[0],
                                        K.cartDetail.quantity: 1,
                                        K.storeDetail.storeName: self.productDetail.storeName,
                                        K.productCollection.productPrice: self.productDetail.productPrice
                                    ])
                                self.navigationController?.popToRootViewController(animated: true)
                            }else if self.selectedPromotionDocumentID.count == 0{
                                self.db.collection(K.tableName.cartTableName).addDocument(data: [
                                    K.cartDetail.productDocID: self.productDetail.documentId,
                                    K.cartDetail.user: emailSender,
                                    K.cartDetail.promotionDocID: "",
                                    K.cartDetail.quantity: 1,
                                    K.storeDetail.storeName: self.productDetail.storeName,
                                    K.productCollection.productPrice: self.productDetail.productPrice
                                ])
                                self.navigationController?.popToRootViewController(animated: true)
                            }else{
                                print("Please choose only one promotion")
                            }
                        }else{
                            let data = snapShotdocuments[0].data()
                            let docID = snapShotdocuments[0].documentID
                            if let quantiy = data[K.cartDetail.quantity] as? Int{
                                if self.selectedPromotionDocumentID.count == 1{
                                    self.db.collection(K.tableName.cartTableName).document(docID).updateData([
                                        K.cartDetail.quantity: quantiy + 1,
                                        K.cartDetail.promotionDocID: self.selectedPromotionDocumentID[0]
                                    ])
                                    self.navigationController?.popToRootViewController(animated: true)
                                }else if self.selectedPromotionDocumentID.count == 0{
                                    self.db.collection(K.tableName.cartTableName).document(docID).updateData([
                                        K.cartDetail.quantity: quantiy + 1,
                                        K.cartDetail.promotionDocID: ""
                                    ])
                                    self.navigationController?.popToRootViewController(animated: true)
                                }else{
                                    print("Please choose only one promotion")
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    @IBAction func buyPressed(_ sender: UIButton) {
        //print(promotions)
        print(selectedPromotionDocumentID)
    }
}

extension ProductDetail:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let promotion = promotions[indexPath.row]
        let promotionCell = promotionTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.promotionMainIdentifier) as! promotionMainCell
               promotionCell.promotionNameLabel.text = promotion.promotionName
               promotionCell.promotionDetailLabel.text = promotion.promotionDetail
               promotionCell.discountPercentLabel.text = String(promotion.discountPercent)
               promotionCell.minimumPriceLabel.text = promotion.minimumPrice
               promotionCell.validDateLabel.text = promotion.validDate
               
               return promotionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPromotionDocumentID.append(promotions[indexPath.row].docID)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = self.selectedPromotionDocumentID.firstIndex(of: promotions[indexPath.row].docID){
            self.selectedPromotionDocumentID.remove(at: index)
        }
    }

}

class promotionMainCell: UITableViewCell{
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionDetailLabel: UILabel!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var discountPercentLabel: UILabel!
    @IBOutlet weak var validDateLabel: UILabel!
    
}


