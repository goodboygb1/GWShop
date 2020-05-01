//
//  AddPromotionInProductController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 1/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
class AddPromotionInProductController: UIViewController {
    @IBOutlet weak var promotionNameTextField: UITextField!
    @IBOutlet weak var promotionDetailTextField: UITextField!
    @IBOutlet weak var discountPercentTextField: UITextField!
    @IBOutlet weak var minimumPriceTextField: UITextField!
    @IBOutlet var validDateTextField: UITextField!
    
    var productDocumentID: [String]!
    var discount: Double!
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func NewPromotionNotNil()-> Bool{
        discount = Double(discountPercentTextField.text!)
        if promotionNameTextField.text != ""{
            if promotionDetailTextField.text != ""{
                if minimumPriceTextField.text != ""{
                    if discountPercentTextField.text != ""{
                        if discount <= 100 && discount > 0{
                            if validDateTextField.text != ""{
                                return true
                            }else { return false }
                        }else { print("Discount is not valid")
                            return false }
                    }else { return false }
                }else { return false }
            }else { return false }
        }else { return false }
    }
    
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if NewPromotionNotNil(){
            if let emailSender = Auth.auth().currentUser?.email{
                db.collection(K.tableName.promotionTableName).addDocument(data: [
                    K.promotion.promotionName: promotionNameTextField.text!,
                    K.promotion.promotionDetail: promotionDetailTextField.text!,
                    K.promotion.minimumPrice: minimumPriceTextField.text!,
                    K.promotion.discountPercent: discount!,
                    K.promotion.validDate: validDateTextField.text!,
                    K.sender: emailSender
                ])
                print("Successfully added promotion")
                for productDoc in productDocumentID{
                    db.collection(K.productCollection.productCollection).document(productDoc).getDocument { (documentSnapshot, error) in
                        if let e = error{
                            print("Error while loading product Name: \(e.localizedDescription)")
                        }else{
                            if let data = documentSnapshot?.data(){
                                if let productName = data[K.productCollection.productName]{
                                    self.db.collection(K.tableName.hasPromotionTableName).addDocument(data: [
                                        K.productCollection.productName: productName,
                                        K.promotion.promotionName: self.promotionNameTextField.text!,
                                        K.sender: emailSender
                                       ])
                                }
                            }
                        }
                    }
                }
                print("Successfully added new hasPromotion document")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
