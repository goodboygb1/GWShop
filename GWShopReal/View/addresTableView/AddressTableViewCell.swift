//
//  AddressTableViewCell.swift
//  GWShopReal
//
//  Created by Thakorn Krittayakunakorn on 27/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var addressDetailTextField: UILabel!
    @IBOutlet weak var districtTextField: UILabel!
    @IBOutlet weak var provinceTextField: UILabel!
    @IBOutlet weak var postCodeTextField: UILabel!
    @IBOutlet weak var phoneNumberTextField: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
