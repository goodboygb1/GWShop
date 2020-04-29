//
//  AddProductController.swift
//  GWShopReal
//
//  Created by PMJs on 29/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class AddProductController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageLable.layer.cornerRadius = addImageLable.frame.size.height/5
        addProductLabel.layer.cornerRadius = addProductLabel.frame.size.height/5
        imagePicker.delegate = self
    }
    
    let imagePicker = UIImagePickerController()
    
    
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
