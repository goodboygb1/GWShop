//
//  ProfileController.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 23/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func showAddressPressed(_ sender: UIButton) {
    }
    @IBAction func showCardPressed(_ sender: UIButton) {
    }
    @IBAction func logOutPressed(_ sender: UIButton) {
    }
    @IBAction func cartPressed(_ sender: UIButton) {
    }
    
    // bottom menu tab
    @IBAction func homeButtonPressed(_ sender: UIButton) {
    }
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToEditProfile", sender: self)
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
