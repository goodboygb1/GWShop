//
//  EditProfileController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 23/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var newFirstNameTextField: UITextField!
    @IBOutlet weak var newLastNameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var newDateTextField: UITextField!
    @IBOutlet weak var newPhoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // make rounded profile image 
        /*image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true*/
    }
    @IBAction func updateProfileImagePressed(_ sender: UIButton) {
    }
    @IBAction func submitProfilePressed(_ sender: UIButton) { // go back to profile page
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
