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
    
    func uploadImage() -> String {
        
        var imageURL = K.other.empty
        guard let imageSelect = self.imageForUpload else {
            print("Image is nil")
            presentAlert(title: "Image Error", message: "Please select image", actiontitle: "Dismiss")
            return K.other.empty
        }
        
        guard let imageData = imageSelect.jpegData(compressionQuality: 0.5) else {
            presentAlert(title: "Image Error", message: "Can't convert Image", actiontitle: "Dismiss")
            return K.other.empty
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://gwshopreal-47f16.appspot.com")
        let storageProductRef = storageRef.child("ProductImage").child("\(Auth.auth().currentUser?.email)+\(Date().timeIntervalSince1970)")
        
        let metaData  = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageProductRef.putData(imageData, metadata: metaData) { (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription)
                self.presentAlert(title: "Error Upload Image", message: error?.localizedDescription ?? "error", actiontitle: "Dismiss")
                return
            }
        }
        
        storageProductRef.downloadURL { (url, error) in
            if let metaImageURL = url?.absoluteString {
                print(metaImageURL)
                imageURL = metaImageURL
            }
        }
        
        
        return imageURL
    }
    
    func presentAlert(title:String,message:String,actiontitle:String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actiontitle, style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
