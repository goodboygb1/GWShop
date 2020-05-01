//
//  AddProductController.swift
//  GWShopReal
//
//  Created by PMJs on 29/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddProductController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var storeName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageLable.layer.cornerRadius = addImageLable.frame.size.height/5
        addProductLabel.layer.cornerRadius = addProductLabel.frame.size.height/5
        imagePicker.delegate = self
        picker.delegate = self
        picker.dataSource = self
        productCategoryTextField.inputView = picker
    }
    
    let picker = UIPickerView()
    let imagePicker = UIImagePickerController()
    let categoryTitle = ["เสื้อผ้าแฟชั่นผู้หญิง","เสื้อผ้าแฟชั่นผู้ชาย"]
    var imageForUpload : UIImage? = nil
    var updateStatus : Bool = false
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var addImageLable: UIButton!
    
    @IBAction func addImageButton(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Select photo Source", message: "From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibAction = UIAlertAction(title: "Photo Library", style: .default) { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .default) { (action:UIAlertAction) in
            
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibAction)
        actionSheet.addAction(cancleAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageChoosen = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageForUpload = imageChoosen
        productImageView.image = imageChoosen
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDetailTextField: UITextField!
    @IBOutlet weak var productCategoryTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productQuantityTextField: UITextField!
    @IBOutlet weak var addProductLabel: UIButton!
    
    @IBAction func addProductButton(_ sender: UIButton) {
        uploadImage()
    }
    
    
    
    func userProductIsNotNilFunction() -> Bool { // เช็คว่ากรอกครบทุกช่องแล้ว
        if productNameTextField.text != "" {
            if productDetailTextField.text != "" {
                if productCategoryTextField.text != "" {
                    if productPriceTextField.text != "" {
                        if productQuantityTextField.text != "" {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

extension AddProductController : UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryTitle.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        productCategoryTextField.text = categoryTitle[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryTitle[row]
    }
    
    
}

extension AddProductController {
    
    func uploadImage()  {
        
        guard let imageSelect = self.imageForUpload else {     //add image for upload
            print("Image is nil")
            presentAlert(title: "Image Error", message: "Please select image", actiontitle: "Dismiss")
            return
        }
        
        guard let imageData = imageSelect.jpegData(compressionQuality: 0.5) else {
                                                               // convert image to jpeg
            
            presentAlert(title: "Image Error", message: "Can't convert Image", actiontitle: "Dismiss")
            return 
        }
        
        let storageRef = Storage.storage().reference(forURL:    "gs://gwshopreal-47f16.appspot.com")               // add link to upload
        
        let storageProductRef = storageRef.child("ProductImage").child("\(Auth.auth().currentUser?.email)+\(Date().timeIntervalSince1970)")          // path for upload
        
        let metaData  = StorageMetadata()                      // set meta data
        metaData.contentType = "image/jpg"
        
        storageProductRef.putData(imageData, metadata: metaData) { (storageMetaData, error) in                                          // upload file
            
            if let errorFromPut = error {                      // upload failed
                self.presentAlert(title: "Error Upload Image", message: error?.localizedDescription ?? "error", actiontitle: "Dismiss")
                print(errorFromPut.localizedDescription)
                
            } else {                                           // upload success
                print("put success")
                
                storageProductRef.downloadURL { (url, error) in     // download URL
                    
                    if let metaImageURL = url?.absoluteString {     // change URL TO String
                                                                       
                        
                        self.updateStatus = self.uploadDataToFirebase(imageURL: metaImageURL)                           // update others                                                  information
                                                                   // add picture first
                                                                   // picture use long time
                        
                    } else {
                        print("error from download URL")          // can't donwload URL
                        print(error?.localizedDescription)
                        
                    }
                    
                }
            }
        }
                                               
    }
    
    func presentAlert(title:String,message:String,actiontitle:String)  {
                                            
                                                            // for show alert to user
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actiontitle, style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadDataToFirebase(imageURL:String) -> Bool {    // for upload data to firebase
        
       
        let userProductIsNotnil = userProductIsNotNilFunction()        // เช็คกรอกครบไหม
        let db = Firestore.firestore()
        let productCollection = db.collection(K.productCollection.productCollection)
        let venderCollection = db.collection(K.tableName.storeDetailTableName)
       
        if let emailSender = Auth.auth().currentUser?.email{
           
            venderCollection.whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("error can't find storeName")
                } else {
                    if let snapSnotQuery = querySnapshot?.documents {
                        for doc in snapSnotQuery {
                            let data = doc.data()
                            if let nameOfStore = data[K.storeDetail.storeName] as? String
                            {
                                self.storeName = nameOfStore
                                
                               
                            }
                        }
                    }
                }
                
                if userProductIsNotnil && (imageURL != K.other.empty) {
                               let emailSender = Auth.auth().currentUser?.email!
                               print("insirting data")
                                
                    productCollection.addDocument(data: [ K.productCollection.productName:self.productNameTextField.text!,
                                                          K.productCollection.productDetail:self.productDetailTextField.text!,
                                                          K.productCollection.productCategory:self.productCategoryTextField.text!,
                                                          K.productCollection.productPrice:self.productPriceTextField.text!,
                                                          K.productCollection.productQuantity:self.productQuantityTextField.text!,
                                                                     K.productCollection.productImageURL:imageURL,
                                                                     K.sender: emailSender!,
                                                                     K.productCollection.storeName : self.storeName ?? "empty"
                                   
                               ]) { (error) in
                                   if let e = error{
                                       print("error from add product: \(e.localizedDescription)")
                                     self.updateStatus = false
                                       self.presentAlert(title: "Error", message: "Product wasn't added", actiontitle: "Dismiss")
                                   } else {
                                        
                                       self.updateStatus = true
                                       self.presentAlert(title: "Success", message: "Product was added", actiontitle: "Dismiss")
                                   }
                               }
                               
                           }
                       
            }
        }
            
       
        
        return updateStatus
    }
}
