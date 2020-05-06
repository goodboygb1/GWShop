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
    var datePickerView: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showDatePicker(_ sender: UITextField) {
           
           // show datePicker when tab dateTextField
           
           datePickerView = UIDatePicker()                     // create DatePicker
           datePickerView.datePickerMode = .date               // เอาแค่วันที่
           datePickerView.calendar = Calendar(identifier: .buddhist)       // พ.ศ.
           datePickerView.locale = Locale(identifier: "th")                // ไทย
           
           sender.inputView = datePickerView                   // ตั้ง input = picker แทนคีบอด
           
           let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
           toolbar.barStyle = UIBarStyle.default        // สร้าง toolbar structure
           
           let cancleButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(cancelTapped))         // create cancle button
           
           let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)               // space ขั่นกลาง
           
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
           // create done button
           
           toolbar.setItems([cancleButton,flexibleSpace,doneButton], animated: true)
           // set item into toolsbar
           sender.inputAccessoryView = toolbar         // add toolbar into                                                      inputAccessoryView
           
           toolbar.items = [cancleButton, flexibleSpace, doneButton]
           sender.inputAccessoryView = toolbar
       }
       
       @objc func doneTapped(sender : UIBarButtonItem!)  {  // กด done แล้วจะจบ
           let dateFormatter  = DateFormatter()              // set formatter
           dateFormatter.locale = Locale(identifier: "th")   // set location to thailand
           dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
           // set format เวลา
           validDateTextField.text = dateFormatter.string(from: datePickerView.date)
           // add date into text field
           validDateTextField.resignFirstResponder()              // close textfield
       }
       
       @objc func cancelTapped(sender:UIBarButtonItem!) {   // กด cancle จะไม่ทำอะไรเลย
           validDateTextField.resignFirstResponder()
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
                    self.db.collection(K.tableName.hasPromotionTableName).addDocument(data: [
                            K.productCollection.productDocID: productDoc,
                            K.promotion.promotionName: self.promotionNameTextField.text!,
                            K.sender: emailSender
                           ])
                    }
                print("Successfully added new hasPromotion document")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
